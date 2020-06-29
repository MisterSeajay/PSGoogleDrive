function New-GoogleDriveExplorerIcon{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()]
        [string]
        $GoogleDrivePath = "$($env:USERPROFILE)\Google Drive",

        [Parameter()]
        [string]
        $clsid = (New-Guid).Guid
    )

    while(-not (Test-Path $GoogleDrivePath)){
        $GoogleDrivePath = Read-Host "Enter path to Google Drive folder"
    }
    
    convertIniFileToVariables -Path "$GoogleDrivePath\desktop.ini"
    
    Write-Warning "Adding entries to registry"
    Write-Verbose "HKEY_CURRENT_USER\Software\Classes\CLSID\{$clsid}"
    
    $RegCommands = @(
        'New-Item -Path "HKCU:\Software\Classes\CLSID" -Name "{$clsid}" -Value "Google Drive" -Force'
        'New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{$clsid}" -Name "System.IsPinnedToNamespaceTree" -PropertyType DWORD -Value 0x1 -Force'
        'New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{$clsid}" -Name "SortOrderIndex" -PropertyType DWORD -Value 0x42 -Force'
        'New-Item -Path "HKCU:\Software\Classes\CLSID\{$clsid}" -Name "DefaultIcon" -Value "$IconFile,$IconIndex" -Force'
        'New-Item -Path "HKCU:\Software\Classes\CLSID\{$clsid}" -Name "InProcServer32" -Value "%SystemRoot%\system32\shell32.dll" -Force'
        'New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{$clsid}\InProcServer32" -Name "(Default)" -PropertyType ExpandString -Value "%SystemRoot%\system32\shell32.dll" -Force'
        'New-Item -Path "HKCU:\Software\Classes\CLSID\{$clsid}" -Name "Instance" -Force'
        'New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{$clsid}\Instance" -Name "CLSID" -PropertyType String -Value "{0E5AAE11-A475-4c5b-AB00-C66DE400274E}" -Force'
        'New-Item -Path "HKCU:\Software\Classes\CLSID\{$clsid}\Instance" -Name "InitPropertyBag" -Force'
        'New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{$clsid}\Instance\InitPropertyBag" -Name "Attributes" -PropertyType DWORD -Value 0x11 -Force'
        'New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{$clsid}\Instance\InitPropertyBag" -Name "TargetFolderPath" -PropertyType ExpandString -Value "$GoogleDrivePath" -Force'
        'New-Item -Path "HKCU:\Software\Classes\CLSID\{$clsid}" -Name "ShellFolder" -Force'
        'New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{$clsid}\ShellFolder" -Name "FolderValueFlags" -PropertyType DWORD -Value 0x28 -Force'
        'New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{$clsid}\ShellFolder" -Name "Attributes" -PropertyType DWORD -Value 0xF080004D -Force'
        'New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace" -Name "{$clsid}" -Value "Google Drive" -Force'
        'New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{$clsid}" -PropertyType DWORD -Value 0x1 -Force'
    )

    if($PSCmdlet.ShouldProcess("HKEY_CURRENT_USER","Invoke-Expression")){
        foreach($RegCommand in $RegCommands){
            Write-Debug $RegCommand
            try {
                Invoke-Expression $RegCommand | Out-Null
            }
            catch {
                throw
                exit 1
            }
        }
    } else {
        Write-Host ($RegCommands | Out-String)
    }
}