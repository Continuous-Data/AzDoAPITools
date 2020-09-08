function Convert-AzDoAPIToolsYamlObjectToYAMLFile {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [Object]
        $InputObject,
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [String]
        $outputpath,
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [String]
        $Outputfilename

    )
    
    process {

        if (!(Test-Path $outputpath)) {
            if(Confirm "$outputpath not detected. Do you want to create it"){
                New-Item -path $OutputPath -ItemType 'Directory' | Out-Null
            }
        }
        
        $InputObject | ConvertTo-Yaml | Out-File "$outputpath\$Outputfilename" -encoding utf8
    }
    
}