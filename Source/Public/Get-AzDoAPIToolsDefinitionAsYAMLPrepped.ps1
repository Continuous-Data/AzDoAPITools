function Get-AzDoAPIToolsDefinitionAsYAMLPrepped {
    param (
        # Parameter help description
        [Parameter(mandatory=$true)]
        [Array]
        $DefinitionsToConvert,
        # Projectname
        [Parameter(mandatory=$true)]
        [string]
        $Projectname,
        # Profilename
        [Parameter(mandatory=$false)]
        [string]
        $profilename,
        # OutputPath
        [Parameter(mandatory=$false)]
        [string]
        $OutputPath,
        # switch for expanding nested taskgroups
        [Parameter(mandatory=$false)]
        [switch]
        $ExpandNestedTaskGroups,
        # Switch to output file instead of retruning an object
        [Parameter(mandatory=$false)]
        [switch]
        $Outputasfile
    )

    Import-Module powershell-yaml
    foreach ($Definition in $DefinitionsToConvert) {

        $yamlTemplate = New-Object PSObject
        $yamlarray = @()

        if ($definition.value.buildNumberFormat) {
            $name = @{'name' = $definition.value.buildNumberFormat}
        }else {
            $name = @{'name' = '$(buildid)'}
        }

        $inputs = Get-AzDoAPIToolsDefinitionVariables -InputDefinitions $Definition
        $triggers = Get-AzDoAPIToolsDefinitionTriggers -InputDefinitions $Definition
        $schedules = Get-AzDoAPIToolsDefinitionSchedulesAsYAMLPrepped -InputDefinitions $Definition
        $pool = Get-AzDoAPIToolsAgentPool -PoolURL $Definition.value.queue._links.self.href -agentidentifier $Definition.value.process.target.agentSpecification.identifier
        $pooltoadd = @{}
        $pooltoadd.add('pool',$pool)
        $steps = Get-AzDoAPIToolsDefinitionSteps -InputDefinitions $Definition -projectname $projectname -profilename $profilename -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.IsPresent
        
        if ($name) {
            $yamlarray += $name
        }
        
        if ($pooltoadd) {
            $yamlarray += $pooltoadd
        }

        if ($inputs) {
            $yamlarray += $inputs
        }
        
        if ($triggers) {
            $yamlarray += $triggers
        }
        
        if ($schedules) {
            $yamlarray += $schedules
        }

        if ($steps) {
            $yamlarray += $steps
        }

        foreach ($yamlobject in $yamlarray) {
            $yamlobject.getEnumerator() | ForEach-Object{

                $yamlTemplate | Add-Member -NotePropertyName $_.name -NotePropertyValue $_.value
            }
        }
        
        if ($outputasfile.IsPresent) {
            if (!$outputpath) {
                Write-Error "You have used the -Outputfile switch without mentioning OutputPath"
            }else{
                Convert-AzDoAPIToolsYamlObjectToYAMLFile -InputObject $yamlTemplate -outputpath $OutputPath -Outputfilename "$($Definition.name).yml"
            }
            
        }else {
            return $yamlTemplate
        }
    } 
}