function Set-AzdoAPIToolsConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)] $configfilepath,
        [Parameter(Mandatory = $false)] $configfilename
    )
    
    process {

        if(!$configfilepath){
            Write-verbose "No `$configfilepath parameter supplier. setting to default path."
            $configfilepath = "{0}\AzDoAPITools\" -f $env:appdata
        }

        if(!$configfilename){
            Write-verbose "No `$configfilename parameter supplier. setting to default filename."
            $configfilename = "config.json"
        }

        if (($configfilepath -match '\\$') -eq $false) {
            $configfilepath = "$configfilepath\"
        }

        $configfilefullname = "$configfilepath$configfilename"


        if (Test-Path $configfilefullname) {
            Write-Verbose "Found an existing configfile in $configfilefullname. loading it"
            $existingconfig = Get-AzdoAPIToolsConfig -configfilepath $configfilefullname
            
            if (confirm "Do you want to overwrite the existing config in [$configfilefullname] (Y) or add to / replace in existing config (N)?") {
                $OutConfig = Get-AzDoAPIToolsConfigDetails -new
            }else{
                $config = Get-AzDoAPIToolsConfigDetails | ConvertFrom-Json
                
                $matchingobject = $existingconfig.profiles | Where-Object {$_.profilename -eq $config.profilename}
                
                if( $matchingobject ){
                    Write-Host "Found [$($config.profilename)] in existing configfile. OverWriting existing entry"
                    
                    $matchingobject.Organization = $config.Organization
                    $matchingobject.PAT = $config.PAT

                    $OutConfig = $existingconfig | ConvertTo-Json -Depth 3

                }else{
                    Write-Verbose "found no profile with current details. Adding the new config"
                    
                    $existingconfig.profiles += $config
                    
                    $OutConfig = $existingconfig | ConvertTo-Json -Depth 3
                }     
            }
        }else{
            Write-verbose "no configfile found at $configfilefullname. Continuing new file setup"
            $OutConfig = Get-AzDoAPIToolsConfigDetails -new
        }

        if ($OutConfig) {
            $OutConfig | Out-File $configfilefullname
        }
        

    }
}