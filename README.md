# Windows C Drive Cleanup Skill (Hardened Edition)

A privacy-first Codex Skill for safely analyzing and cleaning Windows system drive space.
This hardened edition is designed for users who want cleanup help without allowing deletion of files under `C:\Windows`.

This repository packages a reusable Skill named `windows-c-drive-cleanup`. It helps Codex perform cautious C: drive analysis, classify cleanup opportunities by risk, and guide users through safe space recovery without deleting anything until the user explicitly approves a specific action. The hardened edition adds an extra guardrail: it does not delete original files from `C:\Windows`, including Windows Installer cache files.

## Why This Exists

Many Windows users run out of C: drive space, but common cleanup advice is risky because system folders, installer caches, app data, and personal files are easy to confuse. This Skill turns cleanup into a staged workflow:

1. Read-only inventory first.
2. Risk classification before action.
3. Explicit approval before deletion, moving, ACL changes, or uninstalling.
4. Verification after each cleanup step.
5. Quarantine instead of blind deletion for high-risk Windows Installer artifacts.

## Privacy And Safety

- No telemetry.
- No network calls.
- No bundled user data.
- No machine-specific scan outputs.
- No hard-coded user names.
- Scripts operate only on the local machine where the user runs them.
- System-file deletion is disabled in the hardened edition. Windows Installer analysis is quarantine-only.

The Skill is designed to help an AI agent reason about cleanup safety. It is not a "delete everything" utility.

## Repository Layout

```text
windows-c-drive-cleanup-skill-hardened/
  README.md
  CHANGELOG.md
  CONTRIBUTING.md
  GITHUB_PUBLISHING.md
  LICENSE
  SECURITY.md
  .gitignore
  windows-c-drive-cleanup/
    SKILL.md
    agents/
      openai.yaml
    references/
      cleanup-policy.md
      windows-installer-msp.md
    scripts/
      Analyze-CDrive.ps1
      Quarantine-OrphanMsp.ps1
```

## Install

Copy the `windows-c-drive-cleanup` folder into your Codex skills directory.

Typical locations:

```powershell
$env:CODEX_HOME\skills
```

or, if `CODEX_HOME` is not set:

```powershell
$HOME\.codex\skills
```

## Example Requests

- "Analyze my Windows C: drive usage and tell me what is safe to clean."
- "Scan my C: drive, but do not delete anything."
- "Find high-value cleanup candidates and classify them by risk."
- "Check whether Windows Installer has suspicious orphan MSP cache files."
- "Help me clean low-risk caches after I approve the exact paths."

## Manual Script Usage

Run a read-only analysis:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\windows-c-drive-cleanup\scripts\Analyze-CDrive.ps1 -DriveLetter C -Top 40
```

Run a Windows Installer MSP quarantine analysis:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\windows-c-drive-cleanup\scripts\Quarantine-OrphanMsp.ps1 -QuarantineRoot <NonSystemDrive>:\InstallerPatchQuarantine
```

In the hardened edition, the script copies and hash-verifies orphan-like MSP candidates into quarantine but never deletes the originals from `C:\Windows\Installer`.

## Important Warning

Never manually delete these folders:

- `C:\Windows\WinSxS`
- `C:\Windows\System32`
- `C:\Windows\SysWOW64`
- `C:\Windows\servicing`
- `C:\Windows\Installer`, including "orphan-like" MSP files

Use Windows-supported cleanup tools or the Skill's guided workflow.
