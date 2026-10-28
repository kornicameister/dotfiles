import argparse
import random
import re
import sys

DENSITY_BY_MODE = {"official": 0.01, "unofficial": 0.05}
KINDS = ("double", "drop", "swap")
PROTECTED = re.compile(
    r"(```.*?```|`[^`\n]*`|https?://\S+|\S+@\S+|@\w+|:[\w+-]+:|<[^>\n]*>)",
    re.DOTALL,
)
CANDIDATE = re.compile(r"(?<![\w@#/\\.:$-])[^\W\d_]{5,}(?![\w@/\\-])(?!\.\w)")
WORD = re.compile(r"[^\W\d_]+")


def corrupt(
    *,
    rng: random.Random,
    kind: str,
    word: str,
) -> str:
    position = rng.randrange(1, len(word) - 1)
    match kind:
        case "double":
            return word[:position] + word[position] + word[position:]
        case "drop":
            return word[:position] + word[position + 1 :]
        case _:
            return (
                word[:position]
                + word[position + 1]
                + word[position]
                + word[position + 2 :]
            )


def typo_count(
    *,
    rng: random.Random,
    words: int,
    density: float,
) -> int:
    expected = density * words
    whole = int(expected)
    return whole + int(rng.random() < expected - whole)


def inject(
    *,
    rng: random.Random,
    text: str,
    limit: int | None,
    density: float,
) -> tuple[str, list[tuple[str, str]]]:
    """Give the text typos in proportion to its length, keeping first letters.

    The expected number of typos is `density` times the number of prose words;
    the fractional part is decided by a coin flip, so a short text usually gets
    none and sometimes one, while a long text gets several. Only plain lowercase
    words are touched. Code, links, mentions, shortcodes and `<...>` placeholders
    are never changed and never counted.

    Args:
        rng: Random source.
        text: Final draft.
        limit: Optional hard cap on the number of typos.
        density: Share of prose words that should carry a typo.

    Returns:
        The text and a list of (original, typo) pairs.
    """
    segments = PROTECTED.split(text)
    prose = [(index, segment) for index, segment in enumerate(segments) if index % 2 == 0]
    words = sum(len(WORD.findall(segment)) for _, segment in prose)
    count = typo_count(rng=rng, words=words, density=density)
    if limit is not None:
        count = min(count, limit)
    candidates = [
        (index, match)
        for index, segment in prose
        for match in CANDIDATE.finditer(segment)
        if match.group().islower()
    ]
    rng.shuffle(candidates)
    picked = []
    for index, match in candidates:
        if len(picked) == count:
            break
        typo = corrupt(rng=rng, kind=rng.choice(KINDS), word=match.group())
        if typo != match.group():
            picked.append((index, match, typo))
    changes: list[tuple[str, str]] = []
    for index, match, typo in sorted(picked, key=lambda item: (item[0], -item[1].start())):
        segments[index] = (
            segments[index][: match.start()] + typo + segments[index][match.end() :]
        )
        changes.append((match.group(), typo))
    return "".join(segments), changes


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max", dest="limit", type=int)
    parser.add_argument("--mode", choices=sorted(DENSITY_BY_MODE), required=True)
    parser.add_argument("--seed", type=int)
    parser.add_argument("--density", type=float)
    args = parser.parse_args()
    density = DENSITY_BY_MODE[args.mode] if args.density is None else args.density
    if not 0 <= density <= 1:
        parser.error("--density must be in [0, 1]")
    text, changes = inject(
        rng=random.Random(args.seed),
        text=sys.stdin.read(),
        limit=args.limit,
        density=density,
    )
    sys.stdout.write(text)
    for original, typo in changes:
        print(f"typo: {original} -> {typo}", file=sys.stderr)


if __name__ == "__main__":
    main()
