# Cleanup Policy

Use this reference to classify Windows C: drive cleanup candidates.

## Low Risk: Clear Contents After Approval

These are usually cache or diagnostic data. Apps may recreate them.

- `%TEMP%`
- `C:\Windows\Temp`
- `AppData\Local\Temp`
- Browser caches: `Cache`, `Code Cache`, `GPUCache`, `Service Worker\CacheStorage`
- Electron app caches for Slack, Discord, Notion, VS Code, Cursor, Teams, and similar apps
- NVIDIA or graphics caches: `DXCache`, `GLCache`, shader caches
- Game shader precaches, such as `ProgramData\<Game>\*.ushaderprecache`
- Crash dumps: `AppData\Local\CrashDumps`
- Clearly named non-system app updater, cache, or patch directories

Prefer clearing directory contents while keeping the parent directory.

## Medium Risk: Confirm Exact Intent

These may include useful personal data or app state.

- `Documents`, `Desktop`, `Downloads`, `Videos`, `Pictures`
- Chat and collaboration data: WeChat, QQ, Teams, Slack exports, meeting recordings
- Game saves, replays, mods, and user profiles
- IDE or editor data that may include extensions, settings, or workspace history
- Old per-user app version folders, such as `app-1.2.3`
- Python, Node, R, or Conda environments and package caches

Ask whether to delete, move to another drive, or keep.

## Uninstall Only

Do not delete these folders manually. Use Apps & Features, vendor uninstallers, winget, or the relevant package manager.

- `C:\Program Files\...`
- `C:\Program Files (x86)\...`
- Office, Adobe, SQL Server, NVIDIA tools, Lenovo/OEM tools
- VPN, endpoint security, device drivers, and enterprise agents
- Game launchers and stores
- Python distributions registered with Windows
- Large Python packages such as `torch`: use `python -m pip uninstall ...` for the intended interpreter.

## Avoid Manual Deletion

Do not manually delete:

- `C:\Windows\WinSxS`
- `C:\Windows\System32`
- `C:\Windows\SysWOW64`
- `C:\Windows\servicing`
- `C:\Windows\Installer` without the dedicated MSP quarantine workflow
- `C:\ProgramData\Package Cache` unless using vendor-supported cleanup
- Windows registry hives or user profile registry files
- `pagefile.sys`, `swapfile.sys`, `hiberfil.sys` unless using supported Windows settings

For Windows component cleanup, use Windows Disk Cleanup, Storage Sense, or elevated DISM commands.

## Reporting Template

| Risk | Path or app | Size | Recommended action | Notes |
|---|---:|---:|---|---|
| Low | `path` | `N GB` | Clear contents | Recreated by app |
| Medium | `path` | `N GB` | Ask user | Personal or app state |
| Uninstall | `program` | `N GB` | Use uninstaller | Do not delete folder |
| Avoid | `path` | `N GB` | Leave alone or use system tool | High risk |
