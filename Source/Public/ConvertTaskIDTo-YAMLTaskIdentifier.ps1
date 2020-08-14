function ConvertTaskIDTo-YAMLTaskIdentifier {
    param (
        # TaskID
        [Parameter(Mandatory=$true)]
        [guid]
        $InputTaskID,
        [Parameter(mandatory=$false)]
        [string]
        $profilename,
        # TaskVersion
        [Parameter(Mandatory=$true)]
        [int]
        $InputTaskVersion
    )

    $task = CallAzDoAPI -method 'Get' -area 'distributedtask' -resource 'tasks' -profilename $profilename -version '5.1' -id $InputTaskID

    $task = $task.value | Where-Object {$_.version.major -eq $InputTaskVersion}
    

    if($task -and $task.count -le 1){
        $taskcontributionIdentifier = $task.contributionIdentifier

        $taskname = $task.name
        if ($taskcontributionIdentifier) {
            $yamltaskid = "$taskcontributionIdentifier.$taskname@$InputTaskVersion"
        }else{
            $yamltaskid = "$taskname@$InputTaskVersion"
        }
    }

    Return $yamltaskid
    
}