---
external help file: AzdoAPITools-help.xml
Module Name: AzDoAPITools
online version:
schema: 2.0.0
---

# Convert-AzDoAPIToolsYamlObjectToYAMLFile

## SYNOPSIS
{{ Converts a YAML PSOBject to YAML using Powershell-YAML and outs to a UTF-8 yml file }}

## SYNTAX

```powershell
Convert-AzDoAPIToolsYamlObjectToYAMLFile [-InputObject] <Object> [-outputpath] <String>
 [-Outputfilename] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Converts a YAML PSOBject to YAML using Powershell-YAML and outs to a UTF-8 yml file }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Convert-AzDoAPIToolsYamlObjectToYAMLFile -InputObject $objectToConvert -outputpath 'C:\OutPutPathToUse'
 -Outputfilename 'FileNameToUse.yml' }}
```

{{ This Example will convert the $ObjectToConvert to YAML notation and output it to  C:\OutPutPathToUse\FileNameToUse.yml. If the path does not exist it will prompt to create it for you. }}

## PARAMETERS

### -InputObject
{{ Object which is YAMLPrepped and needs conversion. }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Outputfilename
{{ String filename to use including extension to write. }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -outputpath
{{ String path name where you want the yml file to be written to. }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
