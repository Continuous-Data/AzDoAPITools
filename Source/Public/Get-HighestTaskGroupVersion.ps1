function Get-HighestTaskGroupVersion {
    param (
      $TaskGroupObject,
      $Taskgroupid,
      # also return previews
      [Parameter(mandatory=$false)]
      [switch]
      $includeTGpreview
    )
    
    $versionnumber = 0

    if (-not $includeTGpreview.IsPresent) {
      $TaskGroupObject = $TaskGroupObject | Where-Object {!$_.Preview}
    }

    $TaskGroupObject | ForEach-Object {
  
      #figure out a way to easily include preview
      if ($_.id -eq $Taskgroupid){
        if($_.version.major -gt $versionnumber){
          $versionnumber = $_.version.major
        }
      }
  
    }
    # Write-Output "Highest version for [$($Taskgroupid)] was [$($versionnumber)]"
    return $versionnumber
  }