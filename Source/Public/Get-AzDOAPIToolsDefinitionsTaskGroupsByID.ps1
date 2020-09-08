function Get-AzDoAPIToolsDefinitionsTaskGroupsByID {
    param (
      # Nameslist
      [Parameter(mandatory=$true)]
      [String]
      $ID,
      # Nameslist
      [Parameter(mandatory=$false)]
      [int]
      $TGVersion,
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
  
  
          $definitions = CallAzDoAPI -method 'Get' -projectname $Projectname -area 'build' -resource 'definitions' -profilename $profilename -version '5.1' -id $id
   
          $definitions | ForEach-Object{
            $hash = @{}
            $hash.Add('id', $($_.id))
            $hash.Add('name', $($_.name))
            $hash.Add('url', $($_.url))
            $hash.Add('type', $apitype)
            $hash.add('value',$_)
    
            $return += [PSCustomObject]$hash
          }
      }
      ReleaseDefinition {
  
          $definitions = CallAzDoAPI -method 'Get' -projectname $Projectname -area 'release' -resource 'definitions' -profilename $profilename -version '5.1-preview' -id $id
  
          $filtereddefinitions = $definitions.value | Where-Object {$_.name -in $NamesList} 
          
          $filtereddefinitions | ForEach-Object{
            $hash = @{}
            $hash.Add('id', $($_.id))
            $hash.Add('name', $($_.name))
            $hash.Add('url', $($_.url))
            $hash.Add('type', $apitype)
            $hash.Add('value',$_)
    
            $return += [PSCustomObject]$hash
          }
      }
      TaskGroup {
          $taskgroups = CallAzDoAPI -method 'Get' -projectname $Projectname -area 'distributedtask' -resource 'taskgroups' -profilename $profilename -version '5.1-preview' -id $id

          $filteredtaskgroups = $taskgroups.value 
          $filteredproperties = $filteredtaskgroups 
          $filteredproperties | ForEach-Object {
            $hash = @{}
            $hash.Add('id', $($_.id))
            $hash.Add('name', $($_.name))
            $hash.Add('url', (CreateAzdoAPIURL -projectname $Projectname -area 'distributedtask' -resource 'taskgroups' -profilename $profilename -version '5.1-preview' -id $id))
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
            if (!$TGVersion) {
              $hash.Add('highestversion',(Get-HighestTaskGroupVersion -TaskGroupObject $filteredproperties -Taskgroupid $_.id -includeTGPreview:$includeTGpreview.IsPresent)) 
            }
            
            $hash.Add('value',$_)

            $return += [PSCustomObject]$hash
          }

          if ($TGVersion) {

            $return = $return | Where-Object {$_.version -eq $TGVersion}

            if (($return | Measure-Object | Select-Object -ExpandProperty count) -ne 1) {

              Write-Error "version supplied $TGVersion not found for Task Group ID $ID"
              
              throw;
            }
            
          }else{

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
          
      }
      Default {Write-Error "unaccepted type found. Accepted values are BuildDefintion, ReleaseDefinition, TaskGroup"}
    }
    
    return $return  
    
  }