function Get-AzdoAPIToolsProfile {
    [cmdletbinding()]
    param (

        [Parameter(Mandatory = $false)] 
        [psobject]
        $configfile,
        # profilename
        [Parameter(mandatory = $false)]
        [string]
        $profilename
        
    )
    process{

        if(!$configfile){
            Write-verbose "No `$configfile parameter supplied. attempting to grab it from profile"
    
            $configfile = Get-AzdoAPIToolsConfig
        }

        if ($configfile.profiles) {
            if ($profilename) {
                Write-verbose "Searching profiles for $profilename"
                $profile = $configfile.profiles | Where-Object {$_.profilename -eq $profilename}


            }else{
                Write-Verbose "Returning first profile found"
                $profile = $configfile.profiles | Select-Object -First 1
            }

            if ($profile) {
                return $profile
            }else{
                Write-Error "Unable to find $profilename in configfile provided"
                throw;
            } 
            
        }else{
            Write-Error 'Unable to find profiles section in configfile'
            throw;
        }
            
    }
    


}