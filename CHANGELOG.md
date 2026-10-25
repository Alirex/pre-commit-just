# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.2.2] - 2026-10-25

### Fixed

- The hook no longer runs on files whose name merely ends in `just`, such as `robust` or `adjust.txt`. It matches
  `justfile`, `.justfile`, `Justfile` (any case of the first letter) and `*.just`.
- A file `just` cannot parse now prints the `just` error instead of failing silently.

### Changed

- The script starts with `#!/usr/bin/env bash` (it was `#!/bin/bash`), for systems without `/bin/bash` such as NixOS.
- Tests (`tests/test.sh`: direct run, spaces in paths, modules, syntax errors, missing `just`, `prek try-repo`) run in
  CI on Linux and macOS (bash 3.2).

## [0.2.1] - 2025-01-08

- Workflow and README fixes.

## [0.2.0] - 2025-01-08

- First tagged version: the `format-justfile` hook.

[Unreleased]: https://github.com/Alirex/pre-commit-just/compare/v0.2.2...HEAD
[0.2.2]: https://github.com/Alirex/pre-commit-just/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/Alirex/pre-commit-just/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/Alirex/pre-commit-just/releases/tag/v0.2.0
