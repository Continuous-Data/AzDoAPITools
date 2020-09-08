function Get-AzDOAPIToolsTaskGroupAsYAMLPrepped {
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
        $ExpandNestedTaskGroups,
        # Switch to output file instead of retruning an object
        [Parameter(mandatory=$false)]
        [switch]
        $Outputasfile
    )

    Import-Module powershell-yaml
    foreach ($TaskGroup in $TaskGroupsToConvert) {

        $yamlTemplate = [PSCustomObject]@{}

        $inputs = ConvertTGInputsTo-YamlTemplateInputs -InputArray $TaskGroup -Projectname $Projectname -profilename $profilename -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.IsPresent
        $steps = ConvertTaskStepsTo-YAMLSteps -InputArray $TaskGroup -projectname $projectname -profilename $profilename -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.IsPresent -inputtype $TaskGroup.type


        $yamlTemplate | Add-Member -NotePropertyName 'parameters' -NotePropertyValue $inputs
        $yamlTemplate | Add-Member -NotePropertyName 'steps' -NotePropertyValue $steps
        
        if ($outputasfile.IsPresent) {
            if (!$outputpath) {
                Write-Error "You have used the -Outputfile switch without mentioning OutputPath"
            }else{
                Convert-YamlObjectToYAMLFile -InputObject $yamlTemplate -outputpath $OutputPath -Outputfilename "$($taskgroup.name).yml"
            }
            
        }else {
            return $yamlTemplate
        }
    }

    
}