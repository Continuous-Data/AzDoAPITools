function Get-AzDoAPIToolsDefinitionSchedulesAsYAMLPrepped {
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
                
                $citriggers = $definition.triggers | Where-Object {$_.triggerType -eq 'schedule'}

                if ($citriggers.schedules) {
                    $schedules = @()
                    foreach ($schedule in $citriggers.schedules) {
                        $yamlschedule = [ordered]@{}

                        $cron = Get-CronFromSchedule -InputSchedules $schedule
                        $yamlschedule.add('cron', $cron)

                        if($schedule.branchFilters){
                            $branchtriggers = Get-DefinitionInputIncludeExclude -inputs $schedule.branchFilters
                        
                            if ($branchtriggers.count -ge 1) {
                                $yamlschedule.add('branches', $branchtriggers)
                            }
                        }     

                        if ($schedule.scheduleOnlyWithChanges -eq $false) {

                            $yamlschedule.add('always','true') 
                        }

                        $schedules += $yamlschedule
                    }
                    

                    if ($schedules.Count -ge 1) {
                        $returnedtriggerobject = @{
                            'schedules' = $schedules
                        }
                    }
                    
                    
                }
            }

            return $returnedtriggerobject
        }
    }

}


