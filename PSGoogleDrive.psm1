Set-StrictMode -Version 2

###################################################################################################
# Dot-source functions

$PrivateFunctions = Join-Path $PSScriptRoot "Private"
$PublicFunctions = Join-Path $PSScriptRoot "Public"

foreach($Folder in @($PrivateFunctions,$PublicFunctions)){
    $Functions = Get-ChildItem -Path $Folder *.ps1

    foreach($Function in $Functions){
        . $Function.FullName
    }
}
