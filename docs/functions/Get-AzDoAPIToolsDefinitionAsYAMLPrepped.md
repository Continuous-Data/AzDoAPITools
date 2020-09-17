---
external help file: AzdoAPITools-help.xml
Module Name: AzDoAPITools
online version:
schema: 2.0.0
---

# Get-AzDoAPIToolsDefinitionAsYAMLPrepped

## SYNOPSIS
Returns a YAML Prepped PSObject or yml file with all the elements of a YAML pipeline based on a(n Array) of Build Definitions.

## SYNTAX

```
Get-AzDoAPIToolsDefinitionAsYAMLPrepped [-DefinitionsToConvert] <Array> [-Projectname] <String>
 [[-profilename] <String>] [[-OutputPath] <String>] [-ExpandNestedTaskGroups] [-Outputasfile]
 [<CommonParameters>]
```

## DESCRIPTION
This function takes one or more Build Definition where metadata is present from `Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList` or `Get-AzDoAPIToolsDefinitionsTaskGroupsByID` and prepares all elements in it for conversion to a YAML Pipeline. if chosen it will output each build definition to a seperate yml file.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionAsYAMLPrepped -DefinitionsToConvert $ArrayOfBuildDefinitions -Projectname 'YourAzDoProject'
```

Will Take The definitions specified in $ArrayOfBuildDefinitions and for each definition will extract all elements from a Build Definition and converts them to a YAML ready PSObject. It will do this for the specified -Projectname on AzDo. Task Groups found in Build Definition steps will be converted to a template call.

### Example 2
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionAsYAMLPrepped -DefinitionsToConvert $ArrayOfBuildDefinitions -Projectname 'YourAzDoProject' -Profilename 'Alternative Alias in config.json'
```

Will Take The definitions specified in $ArrayOfBuildDefinitions and for each definition will extract all elements from a Build Definition and converts them to a YAML ready PSObject. It will do this for the specified -Projectname on AzDo. Task Groups found in Build Definition steps will be converted to a template call. Will use the Connection details specified in -profilename rather than the first entry in config.json.

### Example 3
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionAsYAMLPrepped -DefinitionsToConvert $ArrayOfBuildDefinitions -Projectname 'YourAzDoProject' -ExpandNestedTaskGroups
```

Will Take The definitions specified in $ArrayOfBuildDefinitions and for each definition will extract all elements from a Build Definition and converts them to a YAML ready PSObject. It will do this for the specified -Projectname on AzDo. Task Groups found in Build Definition steps will be iterated over and expanded as seperate steps in the converted Build Definition.

### Example 4
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionAsYAMLPrepped -DefinitionsToConvert $ArrayOfBuildDefinitions -Projectname 'YourAzDoProject' -ExpandNestedTaskGroups -OutputAsFile -OutPutPath 'C:\OutPut'
```

Will Take The definitions specified in $ArrayOfBuildDefinitions and for each definition will extract all elements from a Build Definition and converts them to a yml file called BuildDefinitionName.yml inside C:\OutPut. It will do this for the specified -Projectname on AzDo. Task Groups found in Build Definition steps will be iterated over and expanded as seperate steps in the converted Build Definition.

## PARAMETERS

### -DefinitionsToConvert
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

### -OutputPath
If Specified will write to this path when -OutPutAsFile is used. If the specified path does not exist you will be prompted to have it created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Outputasfile
Switch to specify the output has to written to a file. When used also specify -OutPutPath. If not used the function will return a PSObject instead.

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
