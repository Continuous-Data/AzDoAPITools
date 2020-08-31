function ConvertDefinitionToYAMLTemplate {
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
        [Parameter(mandatory=$true)]
        [string]
        $OutputPath,
        # future switch for expanding nested taskgroups
        [Parameter(mandatory=$false)]
        [switch]
        $ExpandNestedTaskGroups
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
        $schedules = Get-AzDoAPIToolsDefinitionSchedules -InputDefinitions $Definition
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
        

        if (!(Test-Path $outputpath)) {
            if(Confirm "$outputpath not detected. Do you want to create it"){
                New-Item -path $OutputPath -ItemType 'Directory' | Out-Null
            }
        }
        
        $yamlTemplate | ConvertTo-Yaml | Out-File "$outputpath\$($Definition.name).yml" -encoding utf8
    } 
}