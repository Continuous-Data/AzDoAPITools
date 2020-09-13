---
external help file: AzdoAPITools-help.xml
Module Name: AzDoAPITools
online version:
schema: 2.0.0
---

# Get-AzDoAPIToolsDefinitionTriggersAsYAMLPrepped

## SYNOPSIS
Returns a YAML Prepped PSObject with the triggers of a YAML pipeline based on a(n Array) of Build Definitions

## SYNTAX

```
Get-AzDoAPIToolsDefinitionTriggersAsYAMLPrepped [-InputDefinitions] <Array> [<CommonParameters>]
```

## DESCRIPTION
This function takes one or more Build Definition where metadata is present from `Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList` or `Get-AzDoAPIToolsDefinitionsTaskGroupsByID` and extracts the triggers from it and prepare it for conversion use in a YAML Pipeline. If desired use `Convert-AzDoAPIToolsYamlObjectToYAMLFile` to convert the extracted elements to a seperate yml file.

## EXAMPLES

### Example 1
```powershell
PS C:\> GGet-AzDoAPIToolsDefinitionTriggersAsYAMLPrepped -InputDefinitions $ArrayOfBuildDefinitions
```

Will Take The definitions specified in $ArrayOfBuildDefinitions and for each definition will extract the trigger elements from a Build Definition and converts them to a YAML ready PSObject.

## PARAMETERS

### -InputDefinitions
Array of Build Definitions with MetaData to be converted to YAML Pipelines

```yaml
Type: Array
Parameter Sets: (All)
Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
