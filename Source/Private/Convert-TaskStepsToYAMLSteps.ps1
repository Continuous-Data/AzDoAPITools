function Convert-TaskStepsToYAMLSteps {
    param (
    # input array
    [Parameter()]
    [Array]
    $InputArray,
    # inputtype
    [Parameter(mandatory=$true)]
    [string]
    $inputtype,
    # inputtype
    [Parameter(mandatory=$false)]
    [string]
    $parentinputtype,
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


    foreach ($input in $InputArray) {
        
        if ($inputtype -eq 'BuildDefinition') {
            $steps = $input.steps
        }elseif ($inputtype -eq 'TaskGroup') {
            $steps = $input.value.tasks
        }

        if($steps.count -ge 1){
            $taskscount = $input.count
            [array]$convertedsteps = @()
            $convertedcount = 0
            Write-verbose "Found $taskscount tasks"
            foreach ($step in $steps) {
                
                $yamlstep = [ordered]@{}
                
                $stepid = $step.task.id
                $stepversion = $step.task.versionspec.split(".`*")[0] -as [int]
                
                if($step.task.definitionType -eq 'task'){
                    #####converting TaskID to YAML taskidentifier
                    
                    Write-verbose "version $stepversion found in $inputtype for task $stepid"

                    $yamltaskid = Convert-TaskIDToYAMLTaskIdentifier -InputTaskID $stepid -InputTaskVersion $stepversion -profilename $profilename

                    $yamlstep.add('task',$yamltaskid)

                    ### Adding Other Task Properties to Step Object
                    $taskproperties = Get-TaskProperties -InputTaskObject $step -propertiestoskip @('environment','inputs','task','AlwaysRun','refName')
                    
                    $taskproperties.PSObject.Properties | ForEach-Object{
                        $yamlstep.add($_.name,$_.value)
                    }

                    #### Adding Inputs to the task
                    $YamlInputs = Get-TaskInputs -InputTaskObject $step -profilename $profilename -inputType $inputtype -parentinputtype $parentinputtype
                    
                    if ($YamlInputs.count -ge 1) {

                        $yamlstep.add('inputs', $YamlInputs)
                        
                    }
                    
                    #### Adding Step to Steps
                    [array]$convertedsteps += $yamlstep

                }elseif($step.task.definitionType -eq 'metaTask' -and $step.enabled -eq 'true'){

                    $TGtemplate = Get-AzDoAPIToolsDefinitionsTaskGroupsByID -ID $stepid -TGVersion $stepversion -ApiType 'TaskGroup' -Projectname $projectname -profilename $profilename

                    if ($ExpandNestedTaskGroups.IsPresent) {
                        [array]$nestedtaskgrouptasks = Convert-TaskStepsToYAMLSteps -profilename $profilename -Projectname $projectname -InputArray $TGTemplate -ExpandNestedTaskGroups -inputType $tgtemplate.type -parentinputtype $inputtype
                        [array]$convertedsteps += $nestedtaskgrouptasks
                    }else {
                        
                        $TGTemplateName = "$($TGTemplate.name).yml"
                        $yamlstep.add('template',$TGTemplateName)

                        $TGTemplateparameters = $YamlInputs = Get-TaskInputs -InputTaskObject $step -profilename $profilename -inputType $inputtype
                        
                        if ($TGTemplateparameters.count -ge 1) {

                            $yamlstep.add('parameters', $TGTemplateparameters)
                            
                        }
                        
                        [array]$convertedsteps += $yamlstep
                    }
                    
                }
            
            Write-Verbose "added taskids for $convertedcount steps"
            }   

        }else{
            Write-Verbose 'No Tasks found. skipping steps.'
        }
    if ($convertedsteps.Count -lt 1) {
        [array]$convertedsteps = @()
    }
    return $convertedsteps
    } 
    
}