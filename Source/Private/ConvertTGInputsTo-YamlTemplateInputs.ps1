function ConvertTGInputsTo-YamlTemplateInputs {
    param (
    # input array
    [Parameter()]
    [Array]
    $InputArray,
    # Projectname
    [Parameter(mandatory=$true)]
    [string]
    $Projectname,
    # Projectname
    [Parameter(mandatory=$false)]
    [string]
    $profilename,
    # future switch for expanding nested taskgroups
    [Parameter(mandatory=$false)]
    [switch]
    $ExpandNestedTaskGroups
  )

    foreach ($taskgroup in $InputArray) {

        $InputsArray = @()

        $taskgroup = $taskgroup.value

        if($taskgroup.inputs.count -ge 1){
            $taskgroup.inputs | ForEach-Object {
                $yamlparam = [ordered]@{}
                $yamlparam.Add('name', $_.name)
                $yamlparam.Add('type', 'string')
                $InputsArray += $yamlparam
            }

            
        }else{
            Write-Verbose "No inputs found for task group. skipping yaml generation"
        }

        if($ExpandNestedTaskGroups.IsPresent){
            $taskgrouptasks = $taskgroup.tasks | Where-Object {$_.task.definitionType -eq 'metaTask'}
            $taskgrouptaskscount = $taskgrouptasks | Measure-Object | Select-Object -ExpandProperty count
            if($taskgrouptaskscount -ge 1){
                foreach ($nestedtaskgrouptask in $taskgrouptasks) {
                    $nestedtaskgroupid = $nestedtaskgrouptask.task.id
                    $nestedtaskgroupversion = $nestedtaskgrouptask.task.versionspec.split(".`*")[0] -as [int]

                    $nestedtaskgroup = Get-AzDoAPIToolsDefinitionsTaskGroupsByID -apitype 'Taskgroup' -projectname $Projectname -profilename $profilename -id $nestedtaskgroupid -TGVersion $nestedtaskgroupversion 
                    $nestedtaskgroupinputs = ConvertTGInputsTo-YamlTemplateInputs -profilename $profilename -Projectname $Projectname -InputArray $nestedtaskgroup -ExpandNestedTaskGroups

                    foreach ($nestedinput in $nestedtaskgroupinputs) {
                        if ($nestedinput.name -notin $InputsArray.name) {
                            $InputsArray += $nestedinput
                        }
                    }
                }
            }
        }
        
        return $InputsArray
    
    }
}
    