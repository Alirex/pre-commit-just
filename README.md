# Justfile Formatter for Pre-Commit

---

This repository contains a pre-commit config for running `just --fmt` on any
discovered [just] files.
It will auto-fix the files.

## Usage

You must have [just] installed on your system for this hook to work.

```yaml
- repo: https://github.com/Alirex/pre-commit-just
  rev: "v0.2"
  hooks:
    - id: format-justfile
```

## Development

Register the hook with pre-commit:

```bash
just pre-commit-i-install-i-hooks
```

Other useful commands can be found with:

```bash
just --list
```

If you don't have [just] installed, you can find commands for installation here:

- [just.just](just/dev/just.just)

## License

This work is licensed under the ISC license, a copy of which can be found at [LICENSE.txt](LICENSE.txt).

[just] itself is licensed under the CC0 license.

[just]: https://github.com/casey/just
