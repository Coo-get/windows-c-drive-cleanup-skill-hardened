# Contributing

Thanks for helping improve this skill.

## Principles

- Keep cleanup workflows staged and reversible.
- Prefer read-only scans and clear risk classification.
- Do not add system-file deletion under `C:\Windows`.
- Do not add telemetry, network calls, or collection of private file contents.
- Use exact paths and `-LiteralPath` when scripts touch the filesystem.

## Pull Request Checklist

- Explain the cleanup scenario the change supports.
- Note whether the change can delete, move, uninstall, change ACLs, or take ownership.
- Keep destructive behavior opt-in and limited to non-system paths.
- Update `README.md`, `SKILL.md`, or references when safety behavior changes.
- Run PowerShell parser checks for changed `.ps1` files before submitting.
