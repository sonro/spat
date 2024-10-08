# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- **BREAKING**: argument types are now in `spat.argument`.

## [0.0.1] - 2024-08-09

### Added

#### Position argument parsing

- `Positional` comptime function taking `PositionalOptions`, allowing users
  to specify argumet information: 
  - argument names
  - types
  - custom parser
  - description
  - optional
  - default value
  - variadic
- `CustomParser` comptime function.
- `ArgType` enum.

## [0.0.0] - 2024-08-08

### Added

- Build system.

[Unreleased]: https://github.com/sonro/spat/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/sonro/spat/releases/tag/v0.0.1
[0.0.0]: https://github.com/sonro/spat/releases/tag/v0.0.0
