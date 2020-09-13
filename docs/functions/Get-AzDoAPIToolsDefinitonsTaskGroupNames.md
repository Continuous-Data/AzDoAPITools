---
external help file: AzdoAPITools-help.xml
Module Name: AzDoAPITools
online version:
schema: 2.0.0
---

# Get-AzDoAPIToolsDefinitonsTaskGroupNames

## SYNOPSIS
Returns an array of names for all available Build / Release Definitions / Task Groups in a project.

## SYNTAX

```
Get-AzDoAPIToolsDefinitonsTaskGroupNames [-ApiType] <String> [-Projectname] <String> [[-profilename] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns an array of names for all available Build / Release Definitions / Task Groups in a project.

## EXAMPLES

### Example 1
```powershell
PS C:\> {Get-AzDoAPIToolsDefinitonsTaskGroupNames -ApiType 'BuildDefinition' -Projectname 'YourAzDoProject'
```

Will return an array with unique names of Build Definitions for YourAzDoProject.

### Example 2
```powershell
PS C:\> {Get-AzDoAPIToolsDefinitonsTaskGroupNames -ApiType 'ReleaseDefinition' -Projectname 'YourAzDoProject'
```

Will return an array with unique names of Release Definitions for YourAzDoProject.

### Example 3
```powershell
PS C:\> {Get-AzDoAPIToolsDefinitonsTaskGroupNames -ApiType 'TaskGroup' -Projectname 'YourAzDoProject'
```

Will return an array with unique names of found Task Groups for YourAzDoProject.

### Example 4
```powershell
PS C:\> {Get-AzDoAPIToolsDefinitonsTaskGroupNames -ApiType 'TaskGroup' -Projectname 'YourAzDoProject' -Profilename 'Alternative Alias in config.json'
```

Will return an array with unique names of found Task Groups for YourAzDoProject. Will use the Connection details specified in -profilename rather than the first entry in config.json.

## PARAMETERS

### -ApiType
Specifies what API to call. Knows BuildDefinition, ReleaseDefinition and TaskGroup as accepted values.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: BuildDefinition, ReleaseDefinition, TaskGroup

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
