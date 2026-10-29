import os
import subprocess
from pathlib import Path

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


NODE_BINARY = subprocess.check_output(["node", "-p", "process.execPath"], text=True).strip()
REAL_GIT = subprocess.check_output(["which", "git"], text=True).strip()


def test_install_given_local_repository_should_run_both_modes_and_fail_when_repository_is_unavailable(
    faker: Faker,
    tmp_path: Path,
) -> None:
    import json
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
    for parameters, expected in [
        (["--skills-only"], ["skills"]),
        ([], ["packages", "links", "git", "skills", "nvim"]),
    ]:
        (home / "events").unlink(missing_ok=True)
        result = subprocess.run([str(fixture / "install"), *parameters], env=environment, text=True, capture_output=True)
        assert result.returncode == 0, result.stdout + result.stderr
        assert (home / "events").read_text().splitlines() == expected
    (home / "events").unlink()
    skill_failure = subprocess.run([str(fixture / "install")], env=environment | {"TEST_SKILLS_FAIL": faker.word()}, text=True, capture_output=True)
    assert skill_failure.returncode != 0
    assert (home / "events").read_text().splitlines() == ["packages", "links", "git"]
    lock.write_text(json.dumps({"repository": str(tmp_path / faker.slug()), "commit": faker.sha1(), "runner": "tsx@4.23.15"}))
    (home / "events").unlink()
    failed = subprocess.run([str(fixture / "install"), "--skills-only"], env=environment, text=True, capture_output=True)
    assert failed.returncode != 0
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
