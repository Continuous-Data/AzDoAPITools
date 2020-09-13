---
external help file: AzdoAPITools-help.xml
Module Name: AzDoAPITools
online version:
schema: 2.0.0
---

# Get-AzDoAPIToolsDefinitionStepsAsYAMLPrepped

## SYNOPSIS
Returns a YAML Prepped PSObject with the steps of a YAML pipeline based on a(n Array) of Build Definitions

## SYNTAX

```
Get-AzDoAPIToolsDefinitionStepsAsYAMLPrepped [-InputDefinitions] <Array> [-Projectname] <String>
 [[-profilename] <String>] [-ExpandNestedTaskGroups] [<CommonParameters>]
```

## DESCRIPTION
This function takes one or more Build Definition where metadata is present from `Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList` or `Get-AzDoAPIToolsDefinitionsTaskGroupsByID` and extracts the schedules from it and prepare it for conversion use in a YAML Pipeline. If desired use `Convert-AzDoAPIToolsYamlObjectToYAMLFile` to convert the extracted elements to a seperate yml file.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionStepsAsYAMLPrepped -InputDefinitions $ArrayOfBuildDefinitions -Projectname 'YourAzDoProject'
```

Will Take The definitions specified in $ArrayOfBuildDefinitions and for each definition will extract the steps from a Build Definition and converts them to a YAML ready PSObject. It will do this for the specified -Projectname on AzDo. Task Groups found in Build Definition steps will be converted to a template call.

### Example 2
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionStepsAsYAMLPrepped -InputDefinitions $ArrayOfBuildDefinitions -Projectname 'YourAzDoProject' -Profilename 'Alternative Alias in config.json'
```

Will Take The definitions specified in $ArrayOfBuildDefinitions and for each definition will extract the steps from a Build Definition and converts them to a YAML ready PSObject. It will do this for the specified -Projectname on AzDo. Task Groups found in Build Definition steps will be converted to a template call. Will use the Connection details specified in -profilename rather than the first entry in config.json.

### Example 3
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionStepsAsYAMLPrepped -InputDefinitions $ArrayOfBuildDefinitions -Projectname 'YourAzDoProject' -ExpandNestedTaskGroups
```

Will Take The definitions specified in $ArrayOfBuildDefinitions and for each definition will extract the steps from a Build Definition and converts them to a YAML ready PSObject. It will do this for the specified -Projectname on AzDo. Task Groups found in Build Definition steps will be iterated over and expanded as seperate steps in the converted Build Definition.

## PARAMETERS

### -ExpandNestedTaskGroups
Switch to determine whether or not to expand found Task Groups or to call them as templates.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputDefinitions
Array of Build Definitions with MetaData to be converted to YAML Pipelines

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Projectname
The project to use to call the AzDo API. Should be the same as the project used to add Metadata / retrieve the Build Definitions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -profilename
Optional parameter to target a specific alias inside the config.json to use as a connection to AzDo. The -ProjectName provided should be accessible from this profile.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
