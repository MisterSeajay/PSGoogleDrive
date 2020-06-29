[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Position=0)]
    [string]
    $clsid = [guid]::NewGuid().ToString().ToUpper(),

    [Parameter(Position=1)]
    [string]
    $GoogleDrivePath = "$($env:USERPROFILE)\Google Drive",

    [Parameter(Position=2)]
    [string]
    $GoogleDriveSync = "$($env:PROGRAMFILES)\Google\Drive\googledrivesync.exe"
)

Set-StrictMode -Version 2

if(-not (testCurrentVersion)){
    Write-Warning "This only works on Windows 10"
    exit 1
}

if(-not (Test-Path $GoogleDriveSync)){
    Write-Warning "Cannot find GoogleDriveSync at $GoogleDriveSync"
    exit 1
}

New-GoogleDriveExplorerIcon -clsid $clsid -GoogleDrivePath $GoogleDrivePath | Out-Null

Get-NameSpaces