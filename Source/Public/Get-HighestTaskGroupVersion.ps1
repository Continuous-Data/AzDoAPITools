function Get-HighestTaskGroupVersion {
    param (
      $TaskGroupObject,
      $Taskgroupid
    )
    $versionnumber = 0
    $TaskGroupObject | ForEach-Object {
  
      #figure out a way to easily include preview
      if ($_.id -eq $Taskgroupid -and !$_.preview){
        if($_.version.major -gt $versionnumber){
          $versionnumber = $_.version.major
        }
      }
  
    }
    # Write-Output "Highest version for [$($Taskgroupid)] was [$($versionnumber)]"
    return $versionnumber
  }