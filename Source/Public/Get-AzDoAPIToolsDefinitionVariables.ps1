function Get-AzDoAPIToolsDefinitionVariables {
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
            $variables = @()
            $parameters = @()
            
            if ($definition.variables) {
                foreach ($var in $definition.variables.psobject.properties){                
                    if (!$var.value.issecret) {
                        if ($var.value.allowOverride) {
                            $parameter = [ordered]@{}
                            $parameter.Add('name',$var.name)
                            $parameter.Add('type','string')
                            $parameter.Add('default',$var.value.value)
                            $parameters += $parameter
                        }else{
                            $variable = [ordered]@{}
                            $variable.Add('name',$var.name)
                            $variable.Add('value',$var.value.value)
                            $variables += $variable
                        }
                        
                    }
                    else{
                        Write-Verbose "variable $($var.name) is either settable at queue time or secret. not exporting to yaml"
                    }
                }
            }

            if($definition.variableGroups){
                foreach($vargroup in $definition.variableGroups){
                    $variable = @{}
                    $variable.Add('group',$vargroup.name)
                    $variables += $variable
                }
            }
            $returnvar = [ordered]@{}
            if ($parameters.count -ge 1) {
                $returnvar.Add('parameters',$parameters)
            }
            if ($variables.count -ge 1) {
                $returnvar.Add('variables',$variables)
                
            }
            return $returnvar
        }
    }
    
}