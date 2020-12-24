# AzDoAPITools

[![Build Status](https://dev.azure.com/ContinuousData/cdtestproject/_apis/build/status/tsteenbakkers.AzDoAPITools?repoName=Continuous-Data%2FAzDoAPITools&branchName=master)](https://dev.azure.com/ContinuousData/cdtestproject/_build/latest?definitionId=4&repoName=Continuous-Data%2FAzDoAPITools&branchName=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE.md)
[![Documentation - AzDoAPITools](https://img.shields.io/badge/Documentation-AzDoAPITools-blue.svg)](./docs/README.md)
[![PowerShell Gallery - AzDoAPITools](https://img.shields.io/badge/PowerShell%20Gallery-AzDoAPITools-blue.svg)](https://www.powershellgallery.com/packages/AzDoAPITools)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.1-blue.svg)](https://github.com/PowerShell/PowerShell)

## Version 1.1 Changes

- added Pipeline / Job demands
- Added Step Properties (checkout, persistcredentials, lfs, submodules etc...)
- added Agentless pools
- Added Resource construct for non-AzureDevOps sources
- Changed Job id / displayName notation (added displayname and use actual API id as id instead of displayName as id)
- Changed order of triggers according to MS Export Tool ordering
- Changes order of job properties to MS Export Tool ordering
- fixed syntax for included / excluded paths and branches notation
- Fixed rare occurrence where executor of script would happen to be in a DST timezone where the target zone would not be.
- Fixed empty jobs syntax. will now be converted as empty array [] rather than a started array.
- Fixed notation for job properties for timeout and canceltimeout.
- updated documentation

## Introduction

AzDoAPITools is a project which was born while doing a migration from classical pipelines (GUI-based) to YAML pipelines (Pipeline as code) for a customer. Which is the current function of the published module. The module will convert Task Groups and classical build pipelines to usable all in one YAML pipelines / step templates.

In the future you can expect other automations which i have done for customers such as automatic branching / mass policy application etc. to be bundled in this module.

In [this blog post](https://www.continuous-data.nl/tools/intro-azdoapitools/) I have written an introduction into this tool and in [this blog post](https://www.continuous-data.nl/azure-devops/full-review-of-the-new-export-to-yaml-feature-in-azure-devops/) there is a comparison with the in-built "Export to YAML" functionality which was created by Microsoft in November 2020.

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
