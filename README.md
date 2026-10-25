# Justfile Formatter for Pre-Commit

[![CI](https://github.com/Alirex/pre-commit-just/actions/workflows/ci.yml/badge.svg)](https://github.com/Alirex/pre-commit-just/actions/workflows/ci.yml)

A [pre-commit] / [prek] hook that runs `just --fmt` on every [just] file it finds and auto-fixes them: `justfile`,
`.justfile`, `Justfile` and `*.just` modules. Files that need no change are left alone; a file `just` cannot parse
fails the hook with the `just` error.

## Usage

[just] must be on `PATH` (the hook fails with a message otherwise). Add to `.pre-commit-config.yaml`:

```yaml
- repo: https://github.com/Alirex/pre-commit-just
  rev: "v0.2.2"
  hooks:
    - id: format-justfile
```

Works the same with `pre-commit` and `prek`, on Linux and macOS (bash 3.2). In CI, install `just` first, for example
`uv tool install rust-just`.

## Development

```bash
just dev-hooks   # install the git hook (needs prek)
just q-check     # every prek hook on all files, then tests/test.sh
just             # all recipes
```

`tests/test.sh` runs the script directly and through `prek try-repo`.

## License

This work is licensed under the ISC license, a copy of which can be found at [LICENSE.txt](LICENSE.txt).

[just] itself is licensed under the CC0 license.

[just]: https://github.com/casey/just
[pre-commit]: https://pre-commit.com
[prek]: https://github.com/j178/prek
