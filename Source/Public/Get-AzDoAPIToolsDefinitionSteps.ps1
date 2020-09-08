function Get-AzDoAPIToolsDefinitionSteps {
    [CmdletBinding()]
    param (
        # InputObjects
        [Parameter(Mandatory=$true)]
        [Array]
        $InputDefinitions,
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
    
    process {
       foreach ($definition in $inputdefinitions) {
           $definitiontype = $definition.type
           $definition = $definition.value
           $jobs = $definition.process.phases
           $jobcount = $jobs.count
           $definitionjobs = @()
           $retunreddefinitionjobs = [ordered]@{}
           $phaserefs = @{}

           foreach ($job in $jobs) {
               $definitionsteps = [ordered]@{}
                $definitionjob = [ordered]@{}
              $steps = ConvertTaskStepsTo-YAMLSteps -InputArray $job -Projectname $projectname -profilename $profilename -inputtype $definitiontype -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.isPresent
              
              [bool]$custompool = ($job.target.PSobject.Properties.name.contains('queue'))

              [bool]$dependencies = ($job.PSobject.Properties.name.contains('dependencies'))

              $phaserefs.Add($job.refName,$job.name)

              if ($jobcount -gt 1 -or $custompool) {
                  
                $definitionjob.add('job',$job.name.replace(" ","_"))
                ### add job pool properties
                if ($custompool) {

                    $poolToAdd = Get-AzDoAPIToolsAgentPool -poolURL $job.target.queue._links.self.href -AgentIdentifier $job.target.agentSpecification.identifier
                    if ($pooltoAdd.count -ge 1) {
                        $definitionjob.add('pool',$poolToAdd)
                    }
                }

                $jobproperties = Get-TaskProperties -InputTaskObject $job -propertiestoskip @('steps','target','name','refname','jobAuthorizationScope','dependencies')
                    
                $jobproperties.PSObject.Properties | ForEach-Object{
                    $definitionjob.add($_.name,$_.value)
                }

                #add section for dependancies
                if ($dependencies) {
                    $dependancy = $phaserefs.$($job.dependencies.scope)
                    $definitionjob.add('dependsOn',$dependancy.replace(" ","_"))
                }

                $definitionjob.add('steps',$steps)
                
                $definitionjobs += $definitionjob
              }else{
                $definitionsteps.add('steps',$steps)
              }
           }

           if ($jobcount -gt 1 -or $custompool) {
               $retunreddefinitionjobs.add('jobs',$definitionjobs)

               return $retunreddefinitionjobs

           }else{

               return $definitionsteps
           }
  
           
       } 
    }
}