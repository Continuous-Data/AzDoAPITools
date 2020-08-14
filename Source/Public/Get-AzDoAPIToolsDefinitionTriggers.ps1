function Get-AzDoAPIToolsDefinitionTriggers {
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

                    $branchtriggers = DefinitionInputIncludeExclude -inputs $citriggers.branchFilters
                    
                    if ($branchtriggers.count -ge 1) {
                        $triggers.add('branches', $branchtriggers)
                    }

                    $pathtriggers = DefinitionInputIncludeExclude -inputs $citriggers.pathFilters

                    if ($pathtriggers.count -ge 1) {
                        $triggers.add('paths' , $pathtriggers)
                    }

                    if ($citriggers.batchChanges -eq 'true') {

                        $triggers.add('batch',$citriggers.batchChanges) 
                    }

                    if ($triggers.Count -ge 1) {
                        $returnedtriggerobject = @{
                            'trigger' = $triggers
                        }
                    }
                    
                    
                }
            }else{
                throw;
            }

            return $returnedtriggerobject
        }
    }

}


