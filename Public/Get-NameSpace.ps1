function Get-NameSpace {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        [Parameter()]
        [string]
        $Name
    )
    Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace" |
        Foreach-Object {
            $NameSpace = Get-ItemProperty -Path ($_.Name -replace ('HKEY_CURRENT_USER','HKCU:')) -Name "(default)"
            [PSCustomObject]@{
                CLSID = $NameSpace.PSChildName
                Name= $NameSpace."(default)"
            } | Where-Object {$_.Name -match $Name}
        }
}
