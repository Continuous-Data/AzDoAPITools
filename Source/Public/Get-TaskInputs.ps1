function Get-TaskInputs {
    param (
        # InputTaskObject
        [Parameter(Mandatory=$true)]
        [PSObject]
        $InputTaskObject,
        # inputtype
        [Parameter(mandatory=$true)]
        [string]
        $inputtype,
        # parentinputtype
        [Parameter(mandatory=$false)]
        [string]
        $parentinputtype,
        # profilename
        [Parameter(mandatory=$false)]
        [string]
        $profilename
    )
    # $ReturnedYAMLInputs = [PSCustomObject]@{}
    $TaskInputProperties = @{}
    if(!$InputTaskObject.inputs){

    }else{
        if($InputTaskObject.task.definitionType -eq 'task'){
            $InputTaskid = $InputTaskObject.task.id
            $InputTaskVersion = $InputTaskObject.task.versionspec.split(".`*")[0] -as [int]

            $task = CallAzDoAPI -method 'Get' -area 'distributedtask' -resource 'tasks' -profilename $profilename -version '5.1' -id $InputTaskID

        
            $task = $task.value | Where-Object {$_.version.major -eq $InputTaskVersion}
            $taskdefaultinputs = $task.inputs 
        }

        $InputTaskObject.Inputs.PSObject.Properties | ForEach-Object{
            $regexpatternSingle = '(?<prefix>\$\()(?<FullVariable>(?<SingleVariable>\w+))(?<suffix>\))'
            $regexpatternDouble = '(?<prefix>\$\()(?<FullVariable>(?<DoubleVariable>(?<DoubleFirstPart>\w+)\.+(?<DoubleSecondPart>\w+)))(?<suffix>\))'
            $inputname = $_.name
            $inputvalue = $_.value
            if($InputTaskObject.task.definitionType -eq 'task'){
                $defaultinput = $taskdefaultinputs | Where-Object {$_.name -eq $inputname}
                $defaultinputvalue = $defaultinput.defaultValue
            }
            if(( ($defaultinputvalue -ne $inputvalue) -or ($InputTaskObject.task.definitionType -ne 'task') ) ){
                if ($inputtype -eq 'TaskGroup' -and $parentinputtype -ne 'BuildDefinition') {
                    switch -regex ($inputvalue) {
                        $regexpatternSingle {
                            $inputvalue = $inputvalue -replace $regexpatternSingle, '${{parameters.$2}}'
        
                        }
                        $regexpatternDouble {
                            $predefinedvariableprefixes = @('Build', 'Agent', 'System', 'Pipeline', 'Environment', 'Release')
                            if ($matches.DoubleFirstPart -notin $predefinedvariableprefixes) {
                                $inputvalue = $inputvalue -replace $regexpatternDouble, '${{parameters.$2}}'
        
                            }
                        }
                        Default {}
                    }
                }            
                $TaskInputProperties.Add($inputname,$inputvalue)
            }else{
                write-verbose "Skipping input since it matches defaultvalue"
            }   

        }
        
        # $ReturnedYAMLInputs | Add-Member -NotePropertyName 'inputs' -NotePropertyValue $TaskInputProperties
    }
    return $TaskInputProperties 
}