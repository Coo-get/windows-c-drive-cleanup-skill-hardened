# Changelog

## 1.0.0 - 2026-06-03

- Initial hardened release.
- Added read-only C: drive analysis workflow.
- Added Windows Installer MSP quarantine analysis with copy and SHA256 verification.
- Removed support for deleting original files from `C:\Windows\Installer`.
- Added guardrail guidance that files under `C:\Windows` must not be deleted by this skill.
