function Get-AzdoAPIToolsConfig {
    param (

        [Parameter(Mandatory = $false)] $configfilepath
        
    )

    if(!$configfilepath){
        Write-verbose "No `$configfile parameter supplier. reverting to default path."

        $configfilepath = "$((Get-Item $PSScriptRoot).Parent.FullName)\config\config.json"
    }

    $configJSON = Import-JSON -JSONFile $configfilepath

    return $configJSON


}