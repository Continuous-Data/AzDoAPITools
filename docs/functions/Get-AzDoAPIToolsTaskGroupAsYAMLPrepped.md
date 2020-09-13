---
external help file: AzdoAPITools-help.xml
Module Name: AzDoAPITools
online version:
schema: 2.0.0
---

# Get-AzDoAPIToolsTaskGroupAsYAMLPrepped

## SYNOPSIS
Returns a YAML Prepped PSObject or yml file with all the elements of a YAML pipeline based on a(n Array) of Task Groups.

## SYNTAX

```
Get-AzDoAPIToolsTaskGroupAsYAMLPrepped [-TaskGroupsToConvert] <Array> [-Projectname] <String>
 [[-profilename] <String>] [-OutputPath] <String> [-ExpandNestedTaskGroups] [-Outputasfile]
 [<CommonParameters>]
```

## DESCRIPTION
This function takes one or more Task Groups where metadata is present from `Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList` or `Get-AzDoAPIToolsDefinitionsTaskGroupsByID` and prepares all elements in it for conversion to a YAML Template. if chosen it will output each Task Group to a seperate yml file.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-AzDoAPIToolsTaskGroupAsYAMLPrepped -TaskGroupsToConvert $ArrayOfTaskGroups -Projectname 'YourAzDoProject'
```

Will Take The Task Groups specified in $ArrayOfTaskGroups and for each object will extract all elements from a Task Group and converts them to a YAML ready PSObject. It will do this for the specified -Projectname on AzDo. Task Groups found in Task Group steps will be converted to a template call.

### Example 2
```powershell
PS C:\> Get-AzDoAPIToolsTaskGroupAsYAMLPrepped -TaskGroupsToConvert $ArrayOfTaskGroups -Projectname 'YourAzDoProject' -Profilename 'Alternative Alias in config.json'
```

Will Take The Task Groups specified in $ArrayOfTaskGroups and for each object will extract all elements from a Task Group and converts them to a YAML ready PSObject. It will do this for the specified -Projectname on AzDo. Task Groups found in Task Group steps will be converted to a template call. Will use the Connection details specified in -profilename rather than the first entry in config.json.

### Example 3
```powershell
PS C:\> Get-AzDoAPIToolsTaskGroupAsYAMLPrepped -TaskGroupsToConvert $ArrayOfTaskGroups -Projectname 'YourAzDoProject' -ExpandNestedTaskGroups
```

Will Take The Task Groups specified in $ArrayOfTaskGroups and for each object will extract all elements from a Task Group and converts them to a YAML ready PSObject. It will do this for the specified -Projectname on AzDo. Task Groups found in Task Group steps will be iterated over and expanded as seperate steps in the converted Task Group Template.

### Example 4
```powershell
PS C:\> Get-AzDoAPIToolsTaskGroupAsYAMLPrepped -TaskGroupsToConvert $ArrayOfTaskGroups -Projectname 'YourAzDoProject' -ExpandNestedTaskGroups -OutputAsFile -OutPutPath 'C:\OutPut'
```

Will Take The Task Groups specified in $ArrayOfTaskGroups and for each object will extract all elements from a Task Group and converts them to a yml file called TaskGroupName.yml inside C:\OutPut. It will do this for the specified -Projectname on AzDo. Task Groups found in Task Group steps will be iterated over and expanded as seperate steps in the converted Task Group Template.

## PARAMETERS

### -ExpandNestedTaskGroups
Switch to determine whether or not to expand found Task Groups or to call them as templates.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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
Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Outputasfile
{Switch to specify the output has to written to a file. When used also specify -OutPutPath. If not used the function will return a PSObject instead.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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
Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskGroupsToConvert
Array of Task Groups with MetaData to be converted to YAML Pipelines

```yaml
Type: Array
Parameter Sets: (All)
Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -profilename
Optional parameter to target a specific alias inside the config.json to use as a connection to AzDo. The -ProjectName provided should be accessible from this profile.

```yaml
Type: String
Parameter Sets: (All)
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
