function Remove-Namespace {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipeline)]
        [string]
        $CLSID
    )

    $CLSID = "{$($CLSID.trim('{}'))}"

    Remove-Item "HKCU:SOFTWARE\Classes\CLSID\$CLSID" -Recurse
    Remove-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\$CLSID"
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name $CLSID
}