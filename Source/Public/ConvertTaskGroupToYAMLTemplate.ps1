function ConvertTaskGroupToYAMLTemplate {
    param (
        # Parameter help description
        [Parameter(mandatory=$true)]
        [Array]
        $TaskGroupsToConvert,
        # Projectname
        [Parameter(mandatory=$true)]
        [string]
        $Projectname,
        # Profilename
        [Parameter(mandatory=$false)]
        [string]
        $profilename,
        # OutputPath
        [Parameter(mandatory=$true)]
        [string]
        $OutputPath,
        # future switch for expanding nested taskgroups
        [Parameter(mandatory=$false)]
        [switch]
        $ExpandNestedTaskGroups
    )

    Import-Module powershell-yaml
    foreach ($TaskGroup in $TaskGroupsToConvert) {

        $yamlTemplate = [PSCustomObject]@{}

        $inputs = ConvertTGInputsTo-YamlTemplateInputs -InputArray $TaskGroup -Projectname $Projectname -profilename $profilename -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.IsPresent
        $steps = ConvertTaskStepsTo-YAMLSteps -InputArray $TaskGroup -projectname $projectname -profilename $profilename -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.IsPresent -inputtype $TaskGroup.type


        $yamlTemplate | Add-Member -NotePropertyName 'parameters' -NotePropertyValue $inputs
        $yamlTemplate | Add-Member -NotePropertyName 'steps' -NotePropertyValue $steps
        
        if (!(Test-Path $outputpath)) {
            if(Confirm "$outputpath not detected. Do you want to create it"){
                New-Item -path $OutputPath -ItemType 'Directory' | Out-Null
            }
        }
        
        $yamlTemplate | ConvertTo-Yaml | Out-File "$outputpath\$($taskgroup.name).yml" -encoding utf8
    }

    
}