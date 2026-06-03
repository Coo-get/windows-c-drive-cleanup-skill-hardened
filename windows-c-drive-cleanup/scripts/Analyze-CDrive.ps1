param(
  [ValidatePattern("^[A-Za-z]$")]
  [string]$DriveLetter = "C",

  [string]$UserProfilePath = [Environment]::GetFolderPath("UserProfile"),

  [ValidateRange(1, 200)]
  [int]$Top = 40,

  [string]$OutputDirectory = ""
)

$ErrorActionPreference = "Continue"

function Get-RootPath {
  param([string]$Letter)
  return ($Letter.TrimEnd(":") + ":\")
}

function Get-TreeSize {
  param([Parameter(Mandatory=$true)][string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) { return 0 }
  $sum = (Get-ChildItem -LiteralPath $Path -Force -Recurse -File -ErrorAction SilentlyContinue |
    Measure-Object -Property Length -Sum).Sum
  return ($sum + 0)
}

function Get-ChildrenBySize {
  param(
    [Parameter(Mandatory=$true)][string]$Path,
    [int]$TopCount = 40
  )
  if (-not (Test-Path -LiteralPath $Path)) { return @() }
  return Get-ChildItem -LiteralPath $Path -Force -ErrorAction SilentlyContinue |
    ForEach-Object {
      $bytes = if ($_.PSIsContainer) { Get-TreeSize $_.FullName } else { $_.Length }
      [PSCustomObject]@{
        Path = $_.FullName
        Type = if ($_.PSIsContainer) { "Dir" } else { "File" }
        SizeGB = [math]::Round($bytes / 1GB, 2)
      }
    } |
    Sort-Object SizeGB -Descending |
    Select-Object -First $TopCount
}

function Show-Section {
  param(
    [string]$Name,
    [object[]]$Rows,
    [string]$CsvName = ""
  )
  Write-Output ""
  Write-Output "== $Name =="
  $Rows | Format-Table -AutoSize -Wrap
  if ($OutputDirectory -and $CsvName) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    $Rows | Export-Csv -LiteralPath (Join-Path $OutputDirectory $CsvName) -NoTypeInformation -Encoding UTF8
  }
}

$root = Get-RootPath $DriveLetter
if (-not (Test-Path -LiteralPath $root)) {
  throw "Drive root not found: $root"
}

$drive = Get-PSDrive -Name $DriveLetter.TrimEnd(":")
$driveRows = @([PSCustomObject]@{
  Drive = $drive.Name
  UsedGB = [math]::Round($drive.Used / 1GB, 2)
  FreeGB = [math]::Round($drive.Free / 1GB, 2)
})

Show-Section -Name "Drive usage" -Rows $driveRows -CsvName "drive-usage.csv"
Show-Section -Name "Drive top-level" -Rows (Get-ChildrenBySize -Path $root -TopCount $Top) -CsvName "drive-top-level.csv"
Show-Section -Name "Windows" -Rows (Get-ChildrenBySize -Path (Join-Path $root "Windows") -TopCount $Top) -CsvName "windows.csv"
Show-Section -Name "User profile" -Rows (Get-ChildrenBySize -Path $UserProfilePath -TopCount $Top) -CsvName "user-profile.csv"
Show-Section -Name "AppData" -Rows (Get-ChildrenBySize -Path (Join-Path $UserProfilePath "AppData") -TopCount $Top) -CsvName "appdata.csv"
Show-Section -Name "ProgramData" -Rows (Get-ChildrenBySize -Path (Join-Path $root "ProgramData") -TopCount $Top) -CsvName "programdata.csv"
Show-Section -Name "Program Files" -Rows (Get-ChildrenBySize -Path (Join-Path $root "Program Files") -TopCount $Top) -CsvName "program-files.csv"
Show-Section -Name "Program Files (x86)" -Rows (Get-ChildrenBySize -Path (Join-Path $root "Program Files (x86)") -TopCount $Top) -CsvName "program-files-x86.csv"

$largestUserFiles = if (Test-Path -LiteralPath $UserProfilePath) {
  Get-ChildItem -LiteralPath $UserProfilePath -Force -Recurse -File -ErrorAction SilentlyContinue |
    Sort-Object Length -Descending |
    Select-Object -First $Top @{Name="SizeGB"; Expression={[math]::Round($_.Length / 1GB, 2)}}, FullName, LastWriteTime
} else {
  @()
}

Show-Section -Name "Largest user files" -Rows $largestUserFiles -CsvName "largest-user-files.csv"
