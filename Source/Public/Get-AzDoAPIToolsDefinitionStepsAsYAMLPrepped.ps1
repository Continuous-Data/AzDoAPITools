function Get-AzDoAPIToolsDefinitionStepsAsYAMLPrepped {
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
              $steps = Convert-TaskStepsToYAMLSteps -InputArray $job -Projectname $projectname -profilename $profilename -inputtype $definitiontype -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.isPresent
              
              [bool]$custompool = ($job.target.PSobject.Properties.name.contains('queue'))

              [bool]$dependencies = ($job.PSobject.Properties.name.contains('dependencies'))

              $phaserefs.Add($job.refName,$job.name)

              if ($jobcount -gt 1 -or $custompool) {
                  
                $definitionjob.add('job',$job.name.replace(" ","_"))
                ### Adding displayname
                $definitionjob.add('displayName',$job.name)
                ### add job pool properties
                if ($custompool -and $job.target.type -eq 1) {

                    $poolToAdd = Get-AzDoAPIToolsAgentPool -poolURL $job.target.queue._links.self.href -AgentIdentifier $job.target.agentSpecification.identifier
                    
                }elseif (!$custompool -and $job.target.type -eq 1) {

                    $poolToAdd = Get-AzDoAPIToolsAgentPool -PoolURL $definition.queue._links.self.href -agentidentifier $definition.process.target.agentSpecification.identifier
                }
                elseif($job.target.type -eq 2){

                    $poolToAdd = 'server'
                }

                if ($pooltoAdd.count -ge 1) {
                    $definitionjob.add('pool',$poolToAdd)
                }

                ### Adding job demands
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

                if (!$steps.count -ge 1){
                    $steps = @()
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