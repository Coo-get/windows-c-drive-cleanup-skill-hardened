# Security Policy

## Safety Model

This skill is designed to help analyze Windows C: drive usage while reducing the risk of accidental system damage.

The hardened edition follows these rules:

- Do not delete files under `C:\Windows`.
- Do not change ACLs or take ownership of system files.
- Do not transmit scan results or file contents.
- Prefer read-only analysis before any cleanup recommendation.
- Treat personal files, app data, installer caches, and system folders as different risk categories.

## Reporting Issues

If you find unsafe behavior, please open a GitHub issue with:

- The script or document path.
- The exact command or prompt involved.
- Whether any file deletion, move, ACL change, uninstall, network access, or unexpected system change occurred.

Do not include private file contents in reports. Paths and sizes are usually enough.

## Known Risk Boundaries

`Analyze-CDrive.ps1` recursively enumerates files to calculate size. It does not delete data, but it may take time on large drives.

`Quarantine-OrphanMsp.ps1` copies orphan-like Windows Installer MSP candidates to a quarantine directory and verifies hashes. It does not delete originals from `C:\Windows\Installer`.
