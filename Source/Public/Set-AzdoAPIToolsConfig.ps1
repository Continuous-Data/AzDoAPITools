function Set-AzdoAPIToolsConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)] $configfilepath
    )
    
    process {

        if(!$configfilepath){
            Write-verbose "No `$configfilepath parameter supplier. setting to default path."
            $configfilepath = "{0}\AzDoAPITools\config.json" -f $env:appdata
        }

        if (Test-Path $configfilepath) {
            Write-Verbose "Found an existing configfile in $configfilepath. loading it"
            $existingconfig = Get-AzdoAPIToolsConfig -configfilepath $configfilepath
            
            if (confirm "Do you want to overwrite the existing config in [$configfilepath] (Y) or add to / replace in existing config (N)?") {
                $config = Get-AzDoAPIToolsConfigDetails -new
                $config | Out-File $configfilepath
            }else{
                $config = Get-AzDoAPIToolsConfigDetails | ConvertFrom-Json
                
                $matchingobject = $existingconfig.profiles | Where-Object {$_.profilename -eq $config.profilename}
                
                if( $matchingobject ){
                    Write-Host "Found [$($config.profilename)] in existing configfile. OverWriting existing entry"
                    $matchingobject.Organization = $config.Organization
                    $matchingobject.PAT = $config.PAT

                    $existingconfig | ConvertTo-Json -Depth 3 | Out-File $configfilepath

                }else{
                    Write-Verbose "found no profile with current details. Adding the new config"
                    $existingconfig.profiles += $config
                    $existingconfig | ConvertTo-Json -Depth 3 | Out-File $configfilepath
                }
                
            }
            
    
        }else{
            Write-verbose "no configfile found at $configfilepath. Continuing new file setup"
            $config = Get-AzDoAPIToolsConfigDetails -new
            $config | Out-File $configfilepath
        }
    }
}