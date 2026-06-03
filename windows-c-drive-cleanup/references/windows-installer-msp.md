# Windows Installer MSP Quarantine

`C:\Windows\Installer` contains Windows Installer package and patch caches. Deleting useful files can break repair, update, or uninstall workflows. Treat this area as high risk.

## Read-Only Checks

Measure `.msp` size:

```powershell
Get-ChildItem -LiteralPath C:\Windows\Installer -Force -File -Filter *.msp |
  Measure-Object Length -Sum
```

Compare cached `.msp` filenames with registered patch `LocalPackage` references:

```powershell
$registered = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\*\Products\*\Patches\*' -ErrorAction SilentlyContinue |
  ForEach-Object { (Get-ItemProperty -LiteralPath $_.PsPath -ErrorAction SilentlyContinue).LocalPackage } |
  Where-Object { $_ } |
  ForEach-Object { Split-Path $_ -Leaf }
```

If a `.msp` has no registry match, it is "orphan-like", not guaranteed safe. In the hardened edition, continue only with quarantine analysis and keep the original file in place.

## Safe Quarantine Pattern

Use `scripts/Quarantine-OrphanMsp.ps1` with a non-system quarantine directory.

The script should:

- Recompute orphan-like candidates immediately before action.
- Copy each candidate to quarantine.
- Verify file length and SHA256 hash.
- Write candidate and verified manifests.
- Never delete originals from `C:\Windows\Installer`.
- Keep quarantine files for at least one or two weeks.

## Restore Guidance

If an app later fails to repair, update, or uninstall and names a missing `.msp`, verify whether the original is still present before considering any restore action. If the app does not name a file, search manifests by filename to understand what was quarantined.
