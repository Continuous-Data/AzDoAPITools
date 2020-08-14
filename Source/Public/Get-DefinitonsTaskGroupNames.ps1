function Get-DefinitonsTaskGroupNames {
  param (
    # type
    [Parameter(mandatory=$true)]
    [ValidateSet('BuildDefinition','ReleaseDefinition','TaskGroup')]
    [string]
    $ApiType,
    # Projectname
    [Parameter(mandatory=$true)]
    [string]
    $Projectname,
    # Profilename
    [Parameter(mandatory=$false)]
    [string]
    $profilename
  )


  switch ($apitype) {
    BuildDefinition {
      $response = CallAzDoAPI -method 'Get' -projectname $Projectname -area 'build' -resource 'definitions' -profilename $profilename -version '5.1-preview'

 
    }
    ReleaseDefinition {
      $response = CallAzDoAPI -method 'Get' -projectname $Projectname -area 'release' -resource 'definitions' -profilename $profilename -version '5.1-preview'
      
    }
    TaskGroup {
      $response = CallAzDoAPI -method 'Get' -projectname $Projectname -area 'distributedtask' -resource 'taskgroups' -profilename $profilename -version '5.1-preview'

    }
    Default {Write-Error "unaccepted type found. Accepted values are BuildDefintion, ReleaseDefinition, TaskGroup"}
  }

  $response = $response.value | Select-Object -ExpandProperty Name | Get-Unique

  return $response
  
}