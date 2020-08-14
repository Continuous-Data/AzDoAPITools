function Get-AzdoAPIToolsConfig {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $false)] $configfilepath
        
    )

    if(!$configfilepath){
        Write-verbose "No `$configfile parameter supplier. reverting to default path."
        $configfilepath = "{0}\AzDoAPITools\config.json" -f $env:appdata
        # $configfilepath = "$((Get-Item $PSScriptRoot).Parent.FullName)\config\config.json"
    }

    if (Test-Path $configfilepath) {
        $configJSON = Import-JSON -JSONFile $configfilepath

        return $configJSON
    }else{
        Write-Error "no configfile found at $configfilepath. please run Set-AzDoAPIToolsConfig to create a profile"
    }
}