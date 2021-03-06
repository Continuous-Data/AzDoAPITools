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
               [array]$stepsPlusStepproperties = @()
               $steppropertiestoadd = [ordered]@{}
               [bool]$custompool = ($job.target.PSobject.Properties.name.contains('queue'))
               [bool]$dependencies = ($job.PSobject.Properties.name.contains('dependencies'))
               [bool]$jobdemands = ($job.target.PSobject.Properties.name.contains('demands'))
                
               #populating stepproperties
               
               #first do checkout as it has to be the first task always
                
               if($definition.repository.properties.skipSyncSource -eq 'true'){
                   $steppropertiestoadd.add('checkout', 'none')
               }else {
                    $steppropertiestoadd.add('checkout', 'self')
               }

                #adding other properties
                $repooptions = Get-TaskProperties -InputTaskObject $definition.repository -propertiestoskip @('properties','id','type','name','url','defaultBranch')
                
                $repooptions.PSobject.Properties | ForEach-Object{
                    $steppropertiestoadd.add($_.name,$_.value)
                }

                $repoproperties = Get-TaskProperties -InputTaskObject $definition.repository.properties -propertiestoskip @('labelSources','labelSourcesFormat','reportBuildStatus','cleanOptions','skipSyncSource')
                
                $repoproperties.PSobject.Properties | ForEach-Object{
                        if ($_.name -eq 'submodules') {
                            $steppropertiestoadd.$($_.name) = $_.value 
                        }else{
                            $steppropertiestoadd.add($_.name,$_.value)
                        }
                }
                
                if ($job.target.allowScriptsAuthAccessOption -eq 'true') {

                    $steppropertiestoadd.add('persistCredentials', 'true')
                    
                }

              if ($jobcount -gt 1 -or $custompool -or $pipelinedemands -or $jobdemands) {
                  
                $definitionjob.add('job',$job.refName)
                ### Adding displayname
                $definitionjob.add('displayName',$job.name)

                ### add job pool properties
                if ($custompool -and $job.target.type -eq 1) {

                    $poolToAdd = Get-AzDoAPIToolsAgentPool -poolURL $job.target.queue._links.self.href -AgentIdentifier $job.target.agentSpecification.identifier
                    
                    
                    [array]$stepsPlusStepproperties = $steppropertiestoadd   
                    
                }elseif (!$custompool -and $job.target.type -eq 1) {

                    $poolToAdd = Get-AzDoAPIToolsAgentPool -PoolURL $definition.queue._links.self.href -agentidentifier $definition.process.target.agentSpecification.identifier
                    
                    [array]$stepsPlusStepproperties = $steppropertiestoadd
                }
                elseif($job.target.type -eq 2){

                    $poolToAdd = 'server'

                    [array]$stepsPlusStepproperties = @()
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
                ### Adding Job Properties
                
                #pipeline specific timeouts
                if($definition.jobTimeoutInMinutes -ne 60){
                    $definitionjob.add('timeoutInMinutes',$definition.jobTimeoutInMinutes)

                }

                if($definition.jobCancelTimeoutInMinutes -ne 5){
                    $definitionjob.add('cancelTimeoutInMinutes',$definition.jobCancelTimeoutInMinutes)
                }

                #job specific properties
                $jobproperties = Get-TaskProperties -InputTaskObject $job -propertiestoskip @('steps','target','name','refname','jobAuthorizationScope','dependencies')
                    
                $jobproperties.PSObject.Properties | ForEach-Object{
                    if ($_.name -eq 'timeoutInMinutes' -and ($definitionjob.timeoutInMinutes)) {
                        $definitionjob.timeoutInMinutes = $_.value
                        
                    }elseif ($_.name -eq 'cancelTimeoutInMinutes' -and ($definitionjob.cancelTimeoutInMinutes)) {
                        $definitionjob.cancelTimeoutInMinutes = $_.value
                        
                    }else{
                        $definitionjob.add($_.name,$_.value)
                    }
                    
                }

                #add section for dependancies
                if ($dependencies) {
                    $definitionjob.add('dependsOn',$job.dependencies.scope)
                }
                
                #populating jobs/steps

                [array]$steps = Convert-TaskStepsToYAMLSteps -InputArray $job -Projectname $projectname -profilename $profilename -inputtype $definitiontype -ExpandNestedTaskGroups:$ExpandNestedTaskGroups.isPresent

                [array]$stepsPlusStepproperties += $steps

                $definitionjob.add('steps',$stepsPlusStepproperties)
                
                $definitionjobs += $definitionjob

              }else{
                $definitionsteps.add('steps',$stepsPlusStepproperties)
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