function Import-JSON {
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string]
        $JSONFile
    )
    try {
        $JSONObject = Get-Content $JSONFile -Raw | ConvertFrom-Json

        return $JSONObject
    }
    catch {

    Write-Error "Invalid JSON File or unable to import"
    $Error
    exit 1
        
    }
}