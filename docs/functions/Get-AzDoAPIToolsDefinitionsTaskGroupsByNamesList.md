---
external help file: AzdoAPITools-help.xml
Module Name: AzDoAPITools
online version:
schema: 2.0.0
---

# Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList

## SYNOPSIS
Returns an array of Build / Release Definition or Task Group by an array of names with added metadata for easy use

## SYNTAX

```
Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList [-NamesList] <Array> [-Projectname] <String>
 [[-profilename] <String>] [-ApiType] <String> [-includeTGdrafts] [-includeTGpreview] [-AllTGVersions]
 [<CommonParameters>]
```

## DESCRIPTION
Returns a Build / Release Definition or Task Group by an array of names with added metadata for easy use. For Task Groups it has control over preview, version and drafts.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList -NamesList $nameslist -APIType 'BuildDefinition' -Projectname 'YourAzDoProject'
```

Will look for Build Definitions with names found in $nameslist in the Azure DevOps Project 'YourAzDoProject' The result will be a PSObject with the build definition along with some additional metdata.

### Example 2
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList -NamesList $nameslist -APIType 'BuildDefinition' -Projectname 'YourAzDoProject' -Profilename 'Alternative Alias in config.json'
```

Will look for Build Definitions with names found in $nameslist in the Azure DevOps Project 'YourAzDoProject' The result will be a PSObject with the build definition along with some additional metdata. Will use the Connection details specified in -profilename rather than the first entry in config.json.

### Example 3
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList -NamesList $nameslist -APIType 'ReleaseDefinition' -Projectname 'YourAzDoProject'
```

Will look for Release Definitions with names found in $nameslist in the Azure DevOps Project 'YourAzDoProject' The result will be a PSObject with the Release definition along with some additional metdata. EXPERIMENTAL FEATURE!!!

### Example 4
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList -NamesList $nameslist -APIType 'TaskGroup' -Projectname 'YourAzDoProject'
```

Will look for Task Groups with names found in $nameslist in the Azure DevOps Project 'YourAzDoProject' The result will be a PSObject with the highest version non draft non preview Task Group along with some additional metdata.

### Example 5
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList -NamesList $nameslist -APIType 'TaskGroup' -Projectname 'YourAzDoProject' -AllTGVersions
```

Will look for Task Groups with names found in $nameslist in the Azure DevOps Project 'YourAzDoProject' The result will be a PSObject with the Task Group and all its non-draft non-preview versions along with some additional metdata.

### Example 6
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList -NamesList $nameslist -APIType 'TaskGroup' -Projectname 'YourAzDoProject' -AllTGVersions -includeTGdrafts -includeTGpreview
```

Will look for Task Groups with names found in $nameslist in the Azure DevOps Project 'YourAzDoProject' The result will be a PSObject with the Task Group and all its draft and preview versions along with some additional metdata.

### Example 7
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList -NamesList $nameslist -APIType 'TaskGroup' -Projectname 'YourAzDoProject' -includeTGpreview
```

Will look for Task Groups with names found in $nameslist in the Azure DevOps Project 'YourAzDoProject' The result will be a PSObject with the highest version non-draft and with previews of the Task Group along with some additional metdata.

### Example 8
```powershell
PS C:\> Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList -NamesList $nameslist -APIType 'TaskGroup' -Projectname 'YourAzDoProject' -includeTGdrafts
```

Will look for Task Groups with names found in $nameslist in the Azure DevOps Project 'YourAzDoProject' The result will be a PSObject with the highest version draft non-preview of the Task Group along with some additional metdata.

## PARAMETERS

### -AllTGVersions
Switch to have the function return all versions of a Task Group given. Will only work for APIType 'TaskGroup'. If ommitted it will by default return the highest found version of the Task Group.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiType
Specifies what API to call. Knows BuildDefinition, ReleaseDefinition and TaskGroup as accepted values.

```yaml
Type: String
Parameter Sets: (All)
Accepted values: BuildDefinition, ReleaseDefinition, TaskGroup
Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NamesList
Array of names to look for in Build / Release Definitions or Task Groups.

```yaml
Type: Array
Parameter Sets: (All)
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

### -includeTGdrafts
If this switch is used it will include any Task Groups which are in Draft State. If you have specified a Draft ID and not use this switch your result will be null.

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

### -includeTGpreview
If this switch is used the results of the function will include previews of a task group. This might affect the Highest version returned from a task group.

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
