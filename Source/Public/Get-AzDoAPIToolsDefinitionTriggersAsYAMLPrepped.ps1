function Get-AzDoAPIToolsDefinitionTriggersAsYAMLPrepped {
    [CmdletBinding()]
    param (
        # InputObjects
        [Parameter(Mandatory=$true)]
        [Array]
        $InputDefinitions
    )
    
    process {
        foreach ($definition in $InputDefinitions) {
            $definition = $definition.value

            if ($definition.triggers) {
                
                $citriggers = $definition.triggers | Where-Object {$_.triggerType -eq 'continuousIntegration'}

                if ($citriggers) {
                    $triggers = [ordered]@{}

                    if ($citriggers.batchChanges -eq 'true') {

                        $triggers.add('batch',$citriggers.batchChanges) 
                    }

                    if($citriggers.branchFilters){
                        $branchtriggers = Get-DefinitionInputIncludeExclude -inputs $citriggers.branchFilters
                    
                        if ($branchtriggers.count -ge 1) {
                            $triggers.add('branches', $branchtriggers)
                        }
                    }
                    
                    if($citriggers.pathFilters){
                        $pathtriggers = Get-DefinitionInputIncludeExclude -inputs $citriggers.pathFilters

                        if ($pathtriggers.count -ge 1) {
                            $triggers.add('paths' , $pathtriggers)
                        }

                    }

                    if ($triggers.Count -ge 1) {
                        $returnedtriggerobject = @{
                            'trigger' = $triggers
                        }
                    }
                    
                    
                }
            }

            return $returnedtriggerobject
        }
    }

}


