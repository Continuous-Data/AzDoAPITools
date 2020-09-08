function Get-TaskProperties {
    param (
        # InputTaskObject
        [Parameter(Mandatory=$true)]
        [PSObject]
        $InputTaskObject,
        # properties to skip
        [Parameter(Mandatory=$false)]
        [array]
        $propertiestoskip
    )
    $FilteredTaskProperties = [PSCustomObject]@{}
    # $propertiestoskip = ('environment','inputs','task','AlwaysRun')
    $InputTaskObject.PSObject.Properties | ForEach-Object{
        $propertyname = $_.Name
        $propertyvalue = $_.value
        ### processing skipped properties
        if($propertyname -notin $propertiestoskip){
            ### Skipping Default values to keep output clean
            switch ($propertyname) {
                continueOnError {
                    if($propertyvalue -ne $false){
                        $FilteredTaskProperties | Add-Member -NotePropertyName $propertyname -NotePropertyValue $propertyvalue
                    }
                }
                condition {
                    if($propertyvalue -ne 'succeeded()'){
                        $FilteredTaskProperties | Add-Member -NotePropertyName $propertyname -NotePropertyValue $propertyvalue
                    }
                }
                enabled {
                    if($propertyvalue -ne $true){
                        $FilteredTaskProperties | Add-Member -NotePropertyName $propertyname -NotePropertyValue $propertyvalue
                    }
                }
                timeoutInMinutes {
                    if($propertyvalue -ne 0){
                        $FilteredTaskProperties | Add-Member -NotePropertyName $propertyname -NotePropertyValue $propertyvalue
                    }
                }
                Default {
                    $FilteredTaskProperties | Add-Member -NotePropertyName $propertyname -NotePropertyValue $propertyvalue
                }
            }
        }
    }
    return $FilteredTaskProperties
}
