function Get-AzdoAPIToolsConfig {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $false)] $configfilepath
        
    )

    if(!$configfilepath){
        Write-verbose "No `$configfilepath parameter supplier. setting to default path."
        $configfilepath = "{0}\AzDoAPITools\config.json" -f $env:appdata
        # $configfilepath = "$((Get-Item $PSScriptRoot).Parent.FullName)\config\config.json"
    }

    if (Test-Path $configfilepath) {
        $configJSON = Import-JSON -JSONFile $configfilepath

        return $configJSON
    }else{
        if (confirm "Would you like to create a new config file in $configfilepath ?") {
            Set-AzDoAPIToolsConfig -configfilepath $configfilepath
        }else{
            Write-Error "no configfile found at $configfilepath. please run Set-AzDoAPIToolsConfig to create a profile"
        }
    
    }
}