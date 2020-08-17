function Get-DefinitionsTaskGroupsByNamesList {
    param (
      # Nameslist
      [Parameter(mandatory=$true)]
      [array]
      $NamesList,
      # Projectname
      [Parameter(mandatory=$true)]
      [string]
      $Projectname,
      # Profilename
      [Parameter(mandatory=$false)]
      [string]
      $profilename,
      # type
      [Parameter(mandatory=$true)]
      [ValidateSet('BuildDefinition','ReleaseDefinition','TaskGroup')]
      [string]
      $ApiType,
      # also return drafts
      [Parameter(mandatory=$false)]
      [switch]
      $includeTGdrafts,
      # also return previews
      [Parameter(mandatory=$false)]
      [switch]
      $includeTGpreview,
      # Return all versions
      [Parameter(mandatory=$false)]
      [switch]
      $AllTGVersions
    )
  
    $return = @()
  
  
    switch ($apitype) {
      BuildDefinition {
  
        $definitions = CallAzDoAPI -method 'Get' -projectname $Projectname -area 'build' -resource 'definitions' -profilename $profilename -version '5.1-preview'

        $filtereddefinitions = $definitions.value | Where-Object {$_.name -in $NamesList} 
        $filtereddefinitions | ForEach-Object{
          $filtereddefinitiondetails = CallAzDoAPI -url $_.url -method 'Get' -projectname $Projectname -profilename $profilename -version '5.1-preview'
          # $filtereddefinitiondetails
            $hash = @{}
            $hash.Add('id', $($_.id))
            $hash.Add('name', $($_.name))
            $hash.Add('url', $($_.url))
            $hash.Add('type', $apitype)
            $hash.Add('value',$filtereddefinitiondetails)
            
            $return += [PSCustomObject]$hash
        }
      }
      ReleaseDefinition {
  
          $definitions = CallAzDoAPI -method 'Get' -projectname $Projectname -area 'release' -resource 'definitions' -profilename $profilename -version '5.1-preview'
  
          $filtereddefinitions = $definitions.value | Where-Object {$_.name -in $NamesList} 
          
          $filtereddefinitions | ForEach-Object{
            $filtereddefinitiondetails = CallAzDoAPI -url $_.url -method 'Get' -projectname $Projectname -profilename $profilename -version '5.1-preview'
            $hash = @{}
            $hash.Add('id', $($_.id))
            $hash.Add('name', $($_.name))
            $hash.Add('url', $($_.url))
            $hash.Add('type', $apitype)
            $hash.Add('value',$filtereddefinitiondetails)
    
            $return += [PSCustomObject]$hash
          }
      }
      TaskGroup {

          $taskgroups = CallAzDoAPI -method 'Get' -projectname $Projectname -area 'distributedtask' -resource 'taskgroups' -profilename $profilename -version '5.1-preview'

          $filteredtaskgroups = $taskgroups.value | Where-Object {$_.name -in $NamesList} 

          $filteredproperties = $filteredtaskgroups 
          $filteredproperties | ForEach-Object {
            $hash = @{}
            $hash.Add('id', $($_.id))
            $hash.Add('name', $($_.name))
            $hash.Add('url', (CreateAzdoAPIURL -projectname $Projectname -area 'distributedtask' -resource 'taskgroups' -profilename $profilename -version '5.1-preview' -id $_.id))
            $hash.Add('type', $apitype)
            $hash.Add('version', $($_.version.major))
            if($_.version.istest){
              $hash.Add('Draft','True')
            }else{
              $hash.Add('Draft','False')
            }
            if ($_.preview) {
              $hash.Add('Preview','True')
            }else{
              $hash.Add('Preview','False')
            }
            $hash.Add('highestversion',(Get-HighestTaskGroupVersion -TaskGroupObject $filteredproperties -Taskgroupid $_.id -includeTGPreview:$includeTGpreview.IsPresent))
            
            $hash.Add('value',$_)
            
            $return += [PSCustomObject]$hash
          }

          if (-not $includeTGdrafts.IsPresent) {
            $return = $return | Where-Object {$_.Draft -eq $False}
          }
          if (-not $includeTGpreview.IsPresent) {
            $return = $return | Where-Object {$_.Preview -eq $False}
          }
          if (-not $AllTGVersions.IsPresent) {
            $return = $return | Where-Object {$_.version -eq $_.highestversion}
          }    
      }
      Default {Write-Error "unaccepted type found. Accepted values are BuildDefintion, ReleaseDefinition, TaskGroup"}
    }

    return $return
  
  }