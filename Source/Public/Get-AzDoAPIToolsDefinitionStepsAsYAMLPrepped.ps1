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
           [bool]$pipelinedemands = ($definition.PSobject.Properties.name.contains('demands'))

           foreach ($job in $jobs) {

               $definitionsteps = [ordered]@{}
               $definitionjob = [ordered]@{}
               $demandstoadd = $null
               [array]$steps = @()

              [array]$steps = Convert-TaskStepsToYAMLSteps -InputArray $job -Projectname $projectname -profilename $profilename -inputtype $definitiontype -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.isPresent
              
              [bool]$custompool = ($job.target.PSobject.Properties.name.contains('queue'))

              [bool]$dependencies = ($job.PSobject.Properties.name.contains('dependencies'))

              [bool]$jobdemands = ($job.target.PSobject.Properties.name.contains('demands'))

              if ($jobcount -gt 1 -or $custompool -or $pipelinedemands -or $jobdemands) {
                  
                $definitionjob.add('job',$job.refName)
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
                if ($jobdemands) {
                    $demandstoadd += $job.target.demands
                }

                if ($pipelinedemands) {
                    $demandstoadd += $definition.demands
                }

                if ($demandstoadd.count -ge 1 -and $job.target.type -eq 1) {
                    if($definitionjob.Contains('pool')){
                        $definitionjob.pool.add('demands',$demandstoadd)
                    }else{
                        Write-Error "No Pool construct found to add demands to."
                    }
                    
                }

                $jobproperties = Get-TaskProperties -InputTaskObject $job -propertiestoskip @('steps','target','name','refname','jobAuthorizationScope','dependencies')
                    
                $jobproperties.PSObject.Properties | ForEach-Object{
                    $definitionjob.add($_.name,$_.value)
                }

                #add section for dependancies
                if ($dependencies) {
                    $definitionjob.add('dependsOn',$job.dependencies.scope)
                }
                
                #populating jobs/steps

                [array]$steps = Convert-TaskStepsToYAMLSteps -InputArray $job -Projectname $projectname -profilename $profilename -inputtype $definitiontype -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.isPresent


                $definitionjob.add('steps',$steps)
                
                $definitionjobs += $definitionjob
              }else{
                $definitionsteps.add('steps',$steps)
              }
           }

           if ($jobcount -gt 1 -or $custompool -or $pipelinedemands -or $jobdemands) {
               $retunreddefinitionjobs.add('jobs',$definitionjobs)

               return $retunreddefinitionjobs

           }else{

               return $definitionsteps
           }
  
           
       } 
    }
}