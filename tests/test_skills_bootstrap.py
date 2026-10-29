import json
import os
import subprocess
from pathlib import Path

import pytest
from faker import Faker

REPOSITORY = Path(__file__).resolve().parents[1]
ENVIRONMENT = dict(os.environ)


def test_install_given_skills_dry_run_should_leave_home_untouched(
    faker: Faker,
    tmp_path: Path,
) -> None:
    home = tmp_path / faker.slug()
    home.mkdir()
    environment = ENVIRONMENT | {"HOME": str(home)}
    result = subprocess.run(
        [str(REPOSITORY / "install"), "--skills-only", "--dry-run"],
        env=environment,
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    assert list(home.iterdir()) == []
    assert "install.skills.conf.yaml" in result.stdout
    assert "~/dev/my-skills" in result.stdout


def test_install_given_full_dry_run_should_leave_home_untouched(
    faker: Faker,
    tmp_path: Path,
) -> None:
    home = tmp_path / faker.slug()
    home.mkdir()
    result = subprocess.run(
        [str(REPOSITORY / "install"), "--dry-run"],
        env=ENVIRONMENT | {"HOME": str(home)},
        text=True,
        capture_output=True,
    )
    assert result.returncode == 0, result.stdout + result.stderr
    assert list(home.iterdir()) == []
    assert "install.conf.yaml" in result.stdout
    assert "install.skills.conf.yaml" in result.stdout
    assert "~/dev/my-skills" in result.stdout


NODE_BINARY = subprocess.check_output(["node", "-p", "process.execPath"], text=True).strip()
REAL_GIT = subprocess.check_output(["which", "git"], text=True).strip()


@pytest.fixture
def skills_bootstrap(
    faker: Faker,
    tmp_path: Path,
) -> tuple[Path, Path, dict[str, str]]:
    import shutil

    home = tmp_path / faker.slug()
    private = tmp_path / faker.slug()
    fixture = tmp_path / faker.slug()
    binaries = tmp_path / faker.slug()
    for directory in [home, private, fixture, binaries]:
        directory.mkdir()
    (fixture / ".installer").mkdir()
    for filename in ["install", "install.skills.conf.yaml"]:
        shutil.copy2(REPOSITORY / filename, fixture / filename)
    (fixture / "dotbot").symlink_to(REPOSITORY / "dotbot", target_is_directory=True)
    (fixture / ".installer/utils.sh").write_text("log_done() { :; }\n")
    (fixture / ".installer/git.sh").write_text('configure_git() { echo git >> "$HOME/events"; }\n')
    (fixture / ".installer/install_mac.sh").write_text('install_packages() { echo packages >> "$HOME/events"; }\n')
    (fixture / "install.conf.yaml").write_text('''- shell:
    - command: echo links >> "$HOME/events"
''')
    (private / "install.ts").write_text('''import fs from 'node:fs';
import os from 'node:os';
if(process.env.TEST_SKILLS_FAIL)process.exit(1);
fs.appendFileSync(os.homedir()+'/events','skills\\n');
''')
    environment = ENVIRONMENT | {
        "HOME": str(home),
        "PATH": str(binaries) + os.pathsep + str(Path(NODE_BINARY).parent) + os.pathsep + ENVIRONMENT["PATH"],
        "GIT_CONFIG_GLOBAL": os.devnull,
        "GIT_CONFIG_NOSYSTEM": "1",
    }
    for command in [
        [REAL_GIT, "init", str(private)],
        [REAL_GIT, "-C", str(private), "add", "."],
        [REAL_GIT, "-C", str(private), "-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid", "-c", "commit.gpgsign=false", "-c", "core.hooksPath=/dev/null", "commit", "-m", "test(skills): create local installation fixture"],
    ]:
        subprocess.run(command, env=environment, check=True, capture_output=True)
    commit = subprocess.check_output([REAL_GIT, "-C", str(private), "rev-parse", "HEAD"], text=True).strip()
    lock = fixture / "skills.lock.json"
    lock.write_text(json.dumps({"repository": str(private), "commit": commit, "runner": "tsx@4.23.15"}))
    scripts = {
        "git": '#!/bin/sh\ncase "$*" in *"submodule update"*) exit 0;; esac\nexec "' + REAL_GIT + '" "$@"\n',
        "uname": '#!/bin/sh\necho Darwin\n',
        "npm": '#!/bin/sh\ncase "$*" in *"tsx "*) while [ "$1" != "tsx" ]; do shift; done; shift; exec "' + NODE_BINARY + '" "$@";; esac\nexit 0\n',
        "npx": '#!/bin/sh\nshift 2\nexec "' + NODE_BINARY + '" "$@"\n',
        "uv": '#!/bin/sh\nexit 0\n',
        "nvim": '#!/bin/sh\necho nvim >> "$HOME/events"\n',
        "gem": '#!/bin/sh\nexit 0\n',
    }
    for name, script in scripts.items():
        executable = binaries / name
        executable.write_text(script)
        executable.chmod(0o755)
    return home, fixture, environment


def test_install_given_local_repository_should_run_both_modes_and_fail_when_repository_is_unavailable(
    faker: Faker,
    tmp_path: Path,
    skills_bootstrap: tuple[Path, Path, dict[str, str]],
) -> None:
    home, fixture, environment = skills_bootstrap
    lock = fixture / "skills.lock.json"
    for parameters, expected in [
        (["--skills-only"], ["skills"]),
        ([], ["packages", "links", "git", "skills", "nvim"]),
    ]:
        (home / "events").unlink(missing_ok=True)
        result = subprocess.run([str(fixture / "install"), *parameters], env=environment, text=True, capture_output=True)
        assert result.returncode == 0, result.stdout + result.stderr
        assert (home / "events").read_text().splitlines() == expected
        alias = home / "dev/my-skills"
        checkout = home / ".local/share/kornicameister/skills"
        assert alias.is_symlink()
        assert alias.readlink() == checkout
        alias.unlink()
    (home / "events").unlink()
    skill_failure = subprocess.run([str(fixture / "install")], env=environment | {"TEST_SKILLS_FAIL": faker.word()}, text=True, capture_output=True)
    assert skill_failure.returncode != 0
    assert (home / "events").read_text().splitlines() == ["packages", "links", "git"]
    lock.write_text(json.dumps({"repository": str(tmp_path / faker.slug()), "commit": faker.sha1(), "runner": "tsx@4.23.15"}))
    (home / "events").unlink()
    failed = subprocess.run([str(fixture / "install"), "--skills-only"], env=environment, text=True, capture_output=True)
    assert failed.returncode != 0
    assert not (home / "events").exists()


@pytest.mark.parametrize("conflict_kind", ["directory", "file", "foreign", "dangling"])
def test_install_given_alias_conflict_should_preserve_existing_path_and_skip_checkout(
    faker: Faker,
    conflict_kind: str,
    skills_bootstrap: tuple[Path, Path, dict[str, str]],
) -> None:
    home, fixture, environment = skills_bootstrap
    alias = home / "dev/my-skills"
    alias.parent.mkdir()
    content = faker.paragraph()
    foreign = home / faker.slug()
    match conflict_kind:
        case "directory":
            alias.mkdir()
            (alias / "keep").write_text(content)
        case "file":
            alias.write_text(content)
        case "foreign" | "dangling":
            if conflict_kind == "foreign":
                foreign.mkdir()
                (foreign / "keep").write_text(content)
            alias.symlink_to(foreign)
    result = subprocess.run(
        [str(fixture / "install"), "--skills-only"],
        env=environment,
        text=True,
        capture_output=True,
    )
    assert result.returncode != 0
    assert "Development alias conflicts" in result.stderr
    assert not (home / ".local").exists()
    assert not (home / "events").exists()
    match conflict_kind:
        case "directory":
            assert (alias / "keep").read_text() == content
        case "file":
            assert alias.read_text() == content
        case "foreign" | "dangling":
            assert alias.readlink() == foreign
            if conflict_kind == "foreign":
                assert (foreign / "keep").read_text() == content


@pytest.mark.parametrize("relative", [False, True])
def test_install_given_correct_alias_should_preserve_link_and_share_git_state(
    faker: Faker,
    relative: bool,
    skills_bootstrap: tuple[Path, Path, dict[str, str]],
) -> None:
    home, fixture, environment = skills_bootstrap
    alias = home / "dev/my-skills"
    checkout = home / ".local/share/kornicameister/skills"
    alias.parent.mkdir()
    target = Path("../.local/share/kornicameister/skills") if relative else checkout
    alias.symlink_to(target)
    original = alias.lstat()
    command = [str(fixture / "install"), "--skills-only"]
    for _ in range(2):
        result = subprocess.run(command, env=environment, text=True, capture_output=True)
        assert result.returncode == 0, result.stdout + result.stderr
        assert alias.readlink() == target
        assert alias.lstat().st_ino == original.st_ino
        assert alias.lstat().st_mtime_ns == original.st_mtime_ns
        assert (alias / ".git").samefile(checkout / ".git")
    changed = alias / "install.ts"
    changed.write_text(changed.read_text() + f"\n// {faker.sentence()}\n")
    assert changed.read_bytes() == (checkout / "install.ts").read_bytes()
    status = subprocess.check_output([REAL_GIT, "-C", str(checkout), "status", "--porcelain"], text=True)
    assert " M install.ts" in status
    blocked = subprocess.run(command, env=environment, text=True, capture_output=True)
    assert blocked.returncode != 0
    assert "Private checkout has local changes" in blocked.stderr


def test_install_given_checkout_failure_should_not_create_alias_or_development_directory(
    faker: Faker,
    skills_bootstrap: tuple[Path, Path, dict[str, str]],
) -> None:
    home, fixture, environment = skills_bootstrap
    lock = fixture / "skills.lock.json"
    settings = json.loads(lock.read_text())
    settings["commit"] = faker.sha1()
    lock.write_text(json.dumps(settings))
    result = subprocess.run(
        [str(fixture / "install"), "--skills-only"],
        env=environment,
        text=True,
        capture_output=True,
    )
    assert result.returncode != 0
    assert not (home / "dev").exists()
    assert not (home / "dev/my-skills").is_symlink()
    assert not (home / ".local/share/kornicameister/skills").exists()
    assert not (home / "events").exists()


def test_ignore_given_local_skill_exception_should_expose_only_selected_sources(
    faker: Faker,
    tmp_path: Path,
) -> None:
    import shutil

    repository = tmp_path / faker.slug()
    repository.mkdir()
    environment = ENVIRONMENT | {"GIT_CONFIG_GLOBAL": os.devnull, "GIT_CONFIG_NOSYSTEM": "1"}
    subprocess.run([REAL_GIT, "init", str(repository)], env=environment, check=True, capture_output=True)
    skills = repository / "skills"
    skills.mkdir()
    rules = skills / ".gitignore"
    shutil.copy2(REPOSITORY / "codex/skills/.gitignore", rules)
    selected = skills / faker.slug() / "SKILL.md"
    selected.parent.mkdir()
    selected.write_text(faker.paragraph())
    ignored = subprocess.run([REAL_GIT, "-C", str(repository), "check-ignore", "--no-index", str(selected)], env=environment, capture_output=True)
    assert ignored.returncode == 0
    rules.write_text(rules.read_text() + f"!{selected.parent.name}/\n!{selected.parent.name}/**\n")
    exposed = subprocess.run([REAL_GIT, "-C", str(repository), "check-ignore", "--no-index", str(selected)], env=environment, capture_output=True)
    assert exposed.returncode == 1


def test_settings_given_shared_configuration_should_exclude_project_environment_context() -> None:
    import json

    settings = json.loads((REPOSITORY / "claude/settings.json").read_text())
    contains_project_context = bool(settings.get("autoMode", {}).get("environment"))
    assert not contains_project_context, "Project environment context belongs in ignored project-local settings, never shared global settings."


def test_settings_given_shared_codex_template_should_exclude_local_project_trust() -> None:
    text = (REPOSITORY / "codex/config.toml").read_text()
    has_local_state = any(line.startswith(("[projects.", "[hooks.state")) for line in text.splitlines())
    assert not has_local_state, "Project trust and hook execution state must remain local."


def test_configuration_given_local_runtime_edits_should_preserve_them_outside_templates(
    faker: Faker,
    tmp_path: Path,
) -> None:
    import json

    home = tmp_path / faker.slug()
    home.mkdir()
    environment = ENVIRONMENT | {"HOME": str(home), "PATH": str(Path(NODE_BINARY).parent) + os.pathsep + ENVIRONMENT["PATH"]}
    command = [str(REPOSITORY / "install"), "--prepare-ai-configuration"]
    first = subprocess.run(command, env=environment, text=True, capture_output=True)
    assert first.returncode == 0, first.stdout + first.stderr
    local = home / ".claude/settings.json"
    assert not local.is_symlink()
    assert local.read_bytes() == (REPOSITORY / "claude/settings.json").read_bytes()
    personalization = {faker.word(): faker.paragraph()}
    local.write_text(json.dumps(personalization))
    repeated = subprocess.run(command, env=environment, text=True, capture_output=True)
    assert repeated.returncode == 0, repeated.stdout + repeated.stderr
    assert json.loads(local.read_text()) == personalization
    assert not (home / ".codex/config.toml").is_symlink()
