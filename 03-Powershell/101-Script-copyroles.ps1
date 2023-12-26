[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $roleslocation="/gautam"
)

$ErrorActionPreference = "Stop"


$roleslist = @(
    'gautam-roles'
    'gautam -roles'
)

foreach ($role in $roleslist) {

    if (-not(Test-Path $roleslocation/$role)) {
        git clone git@github.com:gautam/$role.git
        copy-item -Recurse -force $role $roleslocation
        Remove-Item $role -recurse -Force 
    }
    else {
        Write-Host "$role already cloned"
    }
}