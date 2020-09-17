# AzDoAPITools Documentation

Welcome to the AzDoAPITools Documentation page. This page will help you get started or will answer specific questions about individual functions.

## Installation and setup

- Install from the [Powershell Gallery](https://www.powershellgallery.com/packages/AzdoAPITools) or [build locally](././readme.md/#how-to-build-local)
- Run Set-AzDoAPIToolsConfig to create a config.json file in %AppData%\AzDoAPITools
- Run separate functions or check the areas below

## Areas of Functionality

- [Convert Classical (GUI) Pipelines to YAML Pipelines](/docs/classic-to-yaml-conversion.md)
- [Convert Task Groups to YAML Templates](/docs/classic-to-yaml-conversion.md)
- Retrieve a list of names of Build / Release Definitions & Task Groups
- Retrieve details of Build / Release Definitions & Task Groups based of (a list of) names
- Filter Task Groups API to return highest / draft / preview of a Task Group

## Individual Functions

### [Convert-AzDoAPIToolsYamlObjectToYAMLFile](/docs/functions/Convert-AzDoAPIToolsYamlObjectToYAMLFile.md)

Converts a YAML PSOBject to YAML using [Powershell-YAML](https://www.powershellgallery.com/packages/powershell-yaml) and outs to a UTF-8 \*.yml file

### [Get-AzDoAPIToolsDefinitionAsYAMLPrepped](/docs/functions/Get-AzDoAPIToolsDefinitionAsYAMLPrepped.md)

Returns a YAML Prepped PSObject with all the elements of a pipeline (Build Definition) based on a(n Array) of Build Definitions

### [Get-AzDoAPIToolsDefinitionSchedulesAsYAMLPrepped](/docs/functions/Get-AzDoAPIToolsDefinitionSchedulesAsYAMLPrepped.md)

Returns a YAML Prepped PSObject with the Schedules of a pipeline (Build Definition) based on a(n Array) of Build Definitions

### [Get-AzDoAPIToolsDefinitionsTaskGroupsByID](/docs/functions/Get-AzDoAPIToolsDefinitionsTaskGroupsByID.md)

Returns a Build / Release Definition or Task Group by its ID with added metadata for easy use

### [Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList](/docs/functions/Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList.md)

Returns an array of Build / Release Definition or Task Group by an array of names with added metadata for easy use

### [Get-AzDoAPIToolsDefinitionStepsAsYAMLPrepped](/docs/functions/Get-AzDoAPIToolsDefinitionStepsAsYAMLPrepped.md)

Returns a YAML Prepped PSObject with the Steps of a pipeline (Build Definition) based on a(n Array) of Build Definitions

### [Get-AzDoAPIToolsDefinitionTriggersAsYAMLPrepped](/docs/functions/Get-AzDoAPIToolsDefinitionTriggersAsYAMLPrepped.md)

Returns a YAML Prepped PSObject with the Triggers of a pipeline (Build Definition) based on a(n Array) of Build Definitions

### [Get-AzDoAPIToolsDefinitionVariablesAsYAMLPrepped](/docs/functions/Get-AzDoAPIToolsDefinitionVariablesAsYAMLPrepped.md)

Returns a YAML Prepped PSObject with the Variables of a pipeline (Build Definition) based on a(n Array) of Build Definitions

### [Get-AzDoAPIToolsDefinitonsTaskGroupNames](/docs/functions/Get-AzDoAPIToolsDefinitonsTaskGroupNames.md)

Returns an array of names for all available Build / Release Definitions / Task Groups in a project.

### [Get-AzDoAPIToolsTaskGroupAsYAMLPrepped](/docs/functions/Get-AzDoAPIToolsTaskGroupAsYAMLPrepped.md)

Returns a YAML Prepped PSObject with all the elements of a Task Group based on a(n Array) of Task Groups

### [Set-AzdoAPIToolsConfig](/docs/functions/Set-AzdoAPIToolsConfig.md)

A simple tool to add & overwrite the config.json file used by the module
