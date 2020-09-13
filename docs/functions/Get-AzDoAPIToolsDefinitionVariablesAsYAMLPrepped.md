---
external help file: AzdoAPITools-help.xml
Module Name: AzDoAPITools
online version:
schema: 2.0.0
---

# Get-AzDoAPIToolsDefinitionVariablesAsYAMLPrepped

## SYNOPSIS
Returns a YAML Prepped PSObject with the parameters and variables of a YAML pipeline based on a(n Array) of Build Definitions

## SYNTAX

```
Get-AzDoAPIToolsDefinitionVariablesAsYAMLPrepped [-InputDefinitions] <Array> [<CommonParameters>]
```

## DESCRIPTION
This function takes one or more Build Definition where metadata is present from `Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList` or `Get-AzDoAPIToolsDefinitionsTaskGroupsByID` and extracts the variables from it, determine whether it needs conversion and if so as a parameter or a variable and prepare it for conversion use in a YAML Pipeline. If desired use `Convert-AzDoAPIToolsYamlObjectToYAMLFile` to convert the extracted elements to a seperate yml file.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionVariablesAsYAMLPrepped -InputDefinitions $ArrayOfBuildDefinitions
```

Will Take The definitions specified in $ArrayOfBuildDefinitions and for each definition will extract the variable elements from a Build Definition, determine if it needs conversion and if so as a parameter or a variable and converts them to a YAML ready PSObject.

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
