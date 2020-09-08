function Get-AzDoAPIToolsAgentPool {
    [CmdletBinding()]
    param (
        # PoolURL
        [Parameter(Mandatory = $true)]
        [String]
        $PoolURL,
        # agentidentifier
        [Parameter(Mandatory = $false)]
        [String]
        $agentidentifier
    )
    
    
    process {
        $returnedpool = @{}
        $pool = CallAzdoApi -url $PoolURL -method 'get'
        
        if ($pool.pool.isHosted -eq 'true') {
            $returnedpool.Add('vmImage',$agentidentifier)
        }else{
            $returnedpool.add('name',$pool.name)
        }
    }
    
    end {
        if ($returnedpool.Count -ge 1) {
            return $returnedpool
        }
    }
}