AzDoAPITools

# introduction

AzDoAPITools is a project which stems from various automations which I have done in the past in Azure DevOps. The published project on GitHub right now is all about converting classical pipelines to YAML pipelines. In the future you can expect other automations such as automatic branching / mass policy application etc. 
# Required Modules

Powershell-YAML is required since well we want to output yaml files with this module. since Powershell does not have built-in functionality 

# installation
1. install Powershell-YAML module
1. download AzDoAPITools from GitHub
1. load the module from the BuildOutput folder
1. Run Set-AzDOAPIToolsConfig to create a config file which is stored inside the %APPData% folder

# Migration of Classical Pipelines & Task Groups to Yaml templates

The main driver for combining this toolset was to automate the steps to convert classical pipelines (aka Build / Release Definitions) as well as Task Groups into YAML Pipelines / YAML Templates. This functionality mimics the 'View YAML' button inside steps / jobs. Difference being this will iterate over each step / task group and gather the results to a single as opposed to having to manually select each step and export by hand.

It will also convert Definition specific attributes such as triggers, variables and options into a pre-packed yaml file for immediate use as a complete pipeline

## Usage

## Examples

## Assumptions

Some assumptions had to be made while developing this functionality. Below is the explanation of these assumptions. 

### allow override variables --> Parameters

Classical Pipelines know variables. One particular property of a variable in classical pipelines is the ability to override values for variables at queue time rendering them into sort of parameters. With YAML Pipelines we now have the option to actually declare parameters in our yaml file. variables (declared in a yaml file, not in definitions) are static. 

The assumption is that if you have declared any variables with the property 'Allow value to be overwritten at queue time' you want them to be turned into YAML parameters.

If the module is expanded and the adding of converted yaml pipeline definitions (not the *.yml file itself but its definition) becomes available i might consider exporting variables into the definition rather than the yaml file (see next assumption)

### Definition specific properties are supposed to be inside YAML files rathen then in the YAML definition.

Now this needs some explanation... With classical pipelines you need to declare variables / triggers inside the Build / Release definition. However with YAML Pipelines you have the option to declare these in two possible ways:

- inside the YAML Pipeline definition (similar place as they would exist in a Build / Release definition)
- inside the YAML Pipeline itself (the *.yml file). These would become the trigger: / variables: properties of the YAML file.

The assumption from this tool is that users strive to use the best practices associated and that you want variables / triggers for your definition inside the yaml file rather than in the definition.

### calls to other templates assume they are in the same folder as the calling YAML file.

When converting Task Groups to YAML Templates they will be exported to a single output folder. If you have nested task groups or definitions caling task groups (and not using the ExpandNestedTaskgroups switch) the tool assumes the called / nested task group is in the same folder as its caller / parent. If you want to have this in a different way and use an external template repository you should add the resource for it, the path to where you store them and the @alias suffix yourself. When i have time I will attempt to add settings which will do these prefixes / suffixes based on a json file.

## Limitations

some buyers beware and known limitations of this product due to the behavior of Azure DevOps and the differences in classical vs yaml pipelines. These limitations will not be solved unless Micrsosoft will update their product and if i can find a stable way to implement it.

### Incompatible Tasks

If your task group contains a task which does not work with YAML pipelines expect your pipeline to crash on it. I noticed this first when running the 'Add Tag' task which can tag a release definition or build definition. Since YAML Pipelines are living in the 'Build' area of Azure DevOps it can't apply a tag to a release definition (since they no longer exist in YAML). These tasks are converted to YAML but will obviously fail when running the pipeline. Unfortunately it is quite impossible / undoable to determine if a custom task is YAML-proof.

### Secret variables

If you have any secret variables inside your Build / Release Definitions they will not be exported. Any calls or uses of these variables (in the $() format will be converted.). Since YAML is clear text it would not be advisable to store these secrets. Besides the default behavior of Azure DevOps is to not copy these over when cloning or importing a Build / Release Definition I decided not to convert them (technically also impossible). 

My suggestion is you use the built-in functionality in the Definition settings or Azure Keyvault to store these secrets instead. If you name them similar as your original variables they will be accessible to converted tasks.

### incompatible folders (predefined variables)

This predominantly concerns Tasks / Task Groups which are working in the Release Definition area. In YAML Pipelines all pipelines operate in the build area. Therefor Artifacts are downloaded to the path $(pipeline.workspace)\\<Artifact ALias> Which translates to <agentworkdir>\\<Artifact Alias>. In Release definitions this would have been $(Release.ArtifactsDirectory) which tranlates to <agentworkdir>\\a\\<artifact Alias>. Thie means that all tasks that expect to work from the \a directory will not automatically work. Predefined variables which are affected are:

- $(System.defaultworkingdirectory)
- $(Release.ArtifactsDirectory)

Also this means that predefined variables which start with release.* will not work. 

Since it is impossible for me to determine which task groups are used for which purpose in your use-case i opted for not converting these affected inputs to the $(pipeline.workspace). This might mean that your converted YAML pipeline will fail on 

If there is enough interest I can add a switch which does this for you though. Still it would mean manually flagging Task Groups which would need this behavior. This will not fix the default behavior of some of your 3rd party extensions / tasks. some of these will prefix $(system.defaultworkingdirectory) if you provide a relative path as an input to a task. These will have to be fixed by the original author. in most tasks if you prefix $(pipeline.workspace)\\<relative path> it will work most of the times.

### Manual stages in Release Definitions

Currently Microsoft does not allow for manual determined stages in YAML Pipelines. In Classical Pipelines it was possible to add multiple stages to your release definition which would not automatically trigger when a release was started. Instead you had to open up the newly created release and 'Deploy' to that stage. In YAML pipeline such a mechanic does not exist (yet). This means that if you make use of these manually triggered stages in your release definitions they will be exported as separate stages in the converted YAML file. However the behavior of YAML Pipelines is that all stages will run in parallel unless they have the dependsOn property. and even if that was declared it would still mean the stage would automatically execute. The only measure to prevent this would be to use manual approvals on an Environment. however this is still not a solution to this limitation. My suggestion is not to convert those classical pipelines to YAML or find a way to parameterize your pipeline in combination with say conditions to mimic the intended behavior. This is clearly out of the scope of this tool since we do not want to make too much assumptions in how the user wants its target produce. 

## ToDo list

Below is a short To Do list of functionality I wish to implement asap. the order in which they occur here is the priority i gave them.

### Schedules

Schedules are stored in a specific format inside the REST API for classical pipelines. The YAML definitions expect a CRON notation for the schedules: property. I have not found a good way to convert the notation used in the REST API to cron yet. Would love to get some help on this since it is the only thing currently lacking in the conversion.

### Release Definitions

I wanted to push this Module to GitHub and make it publicly available knowing this feature was not implemented yet. The reason is that release definitions are quite complex and are not fully compatible between classical vs YAML Pipelines. This has to do predominantly with the manual stages limitation. whenever i get more time i will include this functionality

### Adding converted Pipelines as actual definitions to Azure DevOps

right now the goal is to produce *.yml files which then can be used to create a new pipeline in Azure DevOps via the 'New Pipeline' button. This will create a 'Build Definition' on the background which points to the created *.yml file. It would be awesome if the user would not need to perform this manual step and have the already converted classical pipeline be automatically added as a new definition into Azure DevOps.

### Variables as Definition variables rather than YAML Template variables

As mentioned in the assumptions part of this readme right now Variables are assumed to be wanted as the variables: property inside a *.yml file. However even with YAML pipelines it is possible to have these variables defined as variables managed by Azure DevOps. If the option becomes available to add converted pipelines as a new definition the assumption on variables becomes a choice.

### support for TFS / Azure DevOps Server installations

Right now all the URL creation function allows for Azure DevOps URL creation. it does not support TFS / Azure DevOps Server local installation. In the case of TFS I am even unsure if YAML is supported at all. This needs further investigation.

### Support for TFVC, GitHub, BitBucket source

Right now the use-cases at the clients i've worked with was to deal with Azure DevOps hosted source code. I will need to do investigation / confirmation that this also works if you host your code externally and if not what changes are needed to incorporate this.