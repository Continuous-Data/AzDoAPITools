AzDoAPITools

# introduction

AzDoAPITools is a project which stems from various automations which I have done in the past in Azure DevOps. The published project on GitHub right now is all about converting classical pipelines to YAML pipelines. In the future you can expect other automations such as automatic branching / mass policy application etc. 

# Requirements

- Powershell 5.0

# Module Dependancies

[Powershell-YAML](https://www.powershellgallery.com/packages/powershell-yaml) is required since well we want to output yaml files with this module. since Powershell does not have built-in functionality we need an additional source

# installation

install this module from the Powershell Gallery

# First Time use

Run Set-AzDOAPIToolsConfig to create a config file which is stored inside the %APPData%\AzDoAPITools folder

# Functionality

- [Convert Classical (GUI) Pipelines to YAML Pipelines](/docs/classic-to-yaml-conversion.md)
- [Convert Task Groups to YAML Templates](/docs/classic-to-yaml-conversion.md)
- Retrieve a list of names of Build / Release Definitions & Task Groups
- Retrieve details of Build / Release Definitions & Task Groups based of (a list of) names
- Filter Task Groups API to return highest / draft / preview of a Task Group

# How to Build locally

- Download Source code / Clone repo
- Run Invoke-Build 
  - You will need the following modules in order to use Invoke-Build:
    - InvokeBuild
    - Buildhelpers
    - PSScriptAnalyzer
    - Pester

# License

This project is licensed under the [MIT License](https://github.com/tsteenbakkers/AzDoAPITools/blob/master/LICENSE.md)