function Get-DefinitionInputIncludeExclude {
    [CmdletBinding()]
    param (
        # inputs
        [Parameter(mandatory=$true)]
        [array]
        $inputs
    )
    begin{
        $included = @()
        $excluded = @()
        $return = @()
        $regex = '^([\+\-])[\\\/]?(.+)'
    }
    
    process {

        foreach ($input in $inputs) {
            if ($input.startswith("+")){
                $input = $input -replace $regex, '$2'
                $included += $input
            }elseif ($input.startswith("-")) {
                $input = $input -replace $regex, '$2'
                $excluded += $input
            }
        }

    }

    end{
        
        if ($included.count -ge 1) {
            $includedinput = @{
                'include' = $included
            }
            $return += $includedinput
        }

        if ($excluded.count -ge 1) {
            $excludedinput = @{
                'exclude' = $excluded
            }
            $return += $excludedinput
        }  

        return $return
    }

}