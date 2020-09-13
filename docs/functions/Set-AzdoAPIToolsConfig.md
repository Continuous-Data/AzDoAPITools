---
external help file: AzdoAPITools-help.xml
Module Name: AzDoAPITools
online version:
schema: 2.0.0
---

# Set-AzdoAPIToolsConfig

## SYNOPSIS
A simple function to add & overwrite the config.json file used by the module.

## SYNTAX

```
Set-AzdoAPIToolsConfig [[-configfilepath] <Object>] [<CommonParameters>]
```

## DESCRIPTION
A simple function to add & overwrite the config.json file used by the module.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-AzdoAPIToolsConfig
```

Will start the process to save a config.json file used by this module in %AppData%\AzDoAPITools. If a config file exists you will be prompted if you want to overwrite the existing file or if you want to append / add to the existing config.json file. If you choose to overwrite it will create a new config.json file with the details requested. If you choose to append / add you will be prompted for the details. If the Alias you entered for the connection to save exists in the configfile you will be prompted if it needs to be overwritten or appended.

### Example 2
```powershell
PS C:\> Set-AzdoAPIToolsConfig -configfilepath C:\testpath
```

Will start the process to save a config.json file used by this module in C:\testpath. If a config file exists you will be prompted if you want to overwrite the existing file or if you want to append / add to the existing config.json file. If you choose to overwrite it will create a new config.json file with the details requested. If you choose to append / add you will be prompted for the details. If the Alias you entered for the connection to save exists in the configfile you will be prompted if it needs to be overwritten or appended.

## PARAMETERS

### -configfilepath
Specifies a path where to save your configfile.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
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
