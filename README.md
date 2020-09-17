# AzDoAPITools

[![Build Status](https://dev.azure.com/ContinuousData/cdtestproject/_apis/build/status/tsteenbakkers.AzDoAPITools?branchName=master)](https://dev.azure.com/ContinuousData/cdtestproject/_build/latest?definitionId=4&branchName=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE.md)
[![Documentation - AzDoAPITools](https://img.shields.io/badge/Documentation-AzDoAPITools-blue.svg)](./docs/README.md)
[![PowerShell Gallery - AzDoAPITools](https://img.shields.io/badge/PowerShell%20Gallery-AzDoAPITools-blue.svg)](https://www.powershellgallery.com/packages/AzDoAPITools)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://github.com/PowerShell/PowerShell)

## Introduction

AzDoAPITools is a project which was born when doing a migration from classical pipelines to YAML pipelines for a customer. Which is the current function of the published module. The module will convert Task Groups and classical build pipelines to usable all in one YAML pipelines / step templates.

In the future you can expect other automations which i have done for customers such as automatic branching / mass policy application etc. to be bundled in this module.

## Requirements

- Powershell 5.1

## Module Dependancies

[Powershell-YAML](https://www.powershellgallery.com/packages/powershell-yaml) is required if you want to create \*.yml files with this Module. The module is capable of delivering a PSObject with all YAML components inside found in your Task Group / Definition if you wish to use a different convert to YAML tool.

## installation

Install this module from the [Powershell Gallery](https://www.powershellgallery.com/packages/AzdoAPITools) or by performing `Install-Module -Name AzdoAPITools`

## First Time use

Run Set-AzDOAPIToolsConfig to create a config.json file which is stored inside the %APPData%\AzDoAPITools folder. Don't sweat if you forget this step. The module will prompt you if it does not find a configfile.

## Documentation

You can find generic documentation [here](/docs/README.md) or check specific functionality documentation below.

## Functionality

- [Convert Classical (GUI) Pipelines to YAML Pipelines](/docs/classic-to-yaml-conversion.md)
- [Convert Task Groups to YAML Templates](/docs/classic-to-yaml-conversion.md)
- Retrieve a list of names of Build / Release Definitions & Task Groups
- Retrieve details of Build / Release Definitions & Task Groups based of (a list of) names
- Filter Task Groups API to return highest / draft / preview of a Task Group

## How to Build local

- Download Source code / Clone repo
- Run Invoke-Build from the modules root directory
  - You will need the following modules in order to use Invoke-Build:
    - InvokeBuild
    - Buildhelpers
    - PSScriptAnalyzer
    - Pester
    - PSDeploy
    - PlatyPS
- Load the module from the BuildOutput folder

## Pester Tests

Currently only placeholders have been made for each function. Tests were done on my personal Azure DevOps Instance and verified by using the actual converted pipelines to see how they work.

I need to gain more knowledge on Pester Tests and especially on how to mock the REST API calls. Tests will be added when I have this knowledged and time to create tests.

## License

This project is licensed under the [MIT License](https://github.com/tsteenbakkers/AzDoAPITools/blob/master/LICENSE.md)
