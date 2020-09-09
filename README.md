# AzDoAPITools

<!-- [![Build Status]()]() -->
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Continuous-Data/AzDoAPITools/blob/master/LICENSE)
[![Documentation - AzDoAPITools](https://img.shields.io/badge/Documentation-AzDoAPITools-blue.svg)](https://github.com/Continuous-Data/AzDoAPITools/blob/master/docs/readme.md)
[![PowerShell Gallery - AzDoAPITools](https://img.shields.io/badge/PowerShell%20Gallery-AzDoAPITools-blue.svg)](https://www.powershellgallery.com/packages/AzDoAPITools)
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PowerShell-5.0-blue.svg)](https://github.com/PowerShell/PowerShell)

## Introduction

AzDoAPITools is a project which was born when doing a migration from classical pipelines to YAML pipelines for a customer. Which is the current function of the published module. The module will convert Task Groups and classical build pipelines to usable all in one YAML pipelines / step templates.

In the future you can expect other automations which i have done for customers such as automatic branching / mass policy application etc. to be bundled in this module.

## Requirements

- Powershell 5.0

## Module Dependancies

[Powershell-YAML](https://www.powershellgallery.com/packages/powershell-yaml) is required if you want to create \*.yml files with this Module. If you have a different method to convert a PSObject to YAML this module is optional. The module is capable of delivering a PSObject with all YAML components inside found in your Task Group / Definition.

## installation

Install this module from the Powershell Gallery

## First Time use

Run Set-AzDOAPIToolsConfig to create a config.json file which is stored inside the %APPData%\AzDoAPITools folder. Don't sweat if you forget this step. The module will prompt you if it does not find a configfile.

## Documentation

You can find documentation [here](/docs/README.md) or check specific functionality documentation below.

## Functionality

- [Convert Classical (GUI) Pipelines to YAML Pipelines](/docs/classic-to-yaml-conversion.md)
- [Convert Task Groups to YAML Templates](/docs/classic-to-yaml-conversion.md)
- Retrieve a list of names of Build / Release Definitions & Task Groups
- Retrieve details of Build / Release Definitions & Task Groups based of (a list of) names
- Filter Task Groups API to return highest / draft / preview of a Task Group

## How to Build locally

- Download Source code / Clone repo
- Run Invoke-Build from the modules root directory
  - You will need the following modules in order to use Invoke-Build:
    - InvokeBuild
    - Buildhelpers
    - PSScriptAnalyzer
    - Pester
- Load the module from the BuildOutput folder

## License

This project is licensed under the [MIT License](https://github.com/tsteenbakkers/AzDoAPITools/blob/master/LICENSE.md)
