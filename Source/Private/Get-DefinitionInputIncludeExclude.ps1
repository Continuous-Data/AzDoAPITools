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
        $return = [ordered]@{}
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
            $return.add('include',$included)
        }

        if ($excluded.count -ge 1) {
            $return.add('exclude',$excluded)
        }  

        return $return
    }

}