AzDoAPITools

# introduction

AzDoAPITools is a project which stems from various automations I have done in the past in Azure DevOps. The published project on GitHub right now is all about converting classical pipelines to YAML pipelines. In the future you can expect other automations such as automatic branching / mass policy application etc. 
# Required Modules

Powershell-YAML is required since well we want to output yaml files with this module. since Powershell does not have built-in functionality 

# Usage
1. 
``

# Migration of Classical Pipelines & Task Groups to Yaml templates

## Assumptions

### allow override variables --> Parameters

### calls to other templates assume they are in the same folder as the calling YAML file.

## Limitations

some buyers beware and known limitations of this product due to the behavior of Azure DevOps and the differences in classical vs yaml pipelines. These limitations will not be solved unless Micrsosoft will update their product or if i can find a stable way to implement it.

### Incompatible Tasks

If your task group contains a task which does not work with YAML pipelines expect your pipeline to crash on it. I noticed this first when running the 'Add Tag' task which can tag a release definition or build definition. Since YAML Pipelines are living in the 'Build' area of Azure DevOps it can't apply a tag to a release definition (since they no longer exist in YAML). These tasks are converted to YAML but will obviously fail when running the pipeline. Unfortunately it is quite impossible / undoable to determine if a custom task is YAML-proof.

### Secret variables

If you have any secret variables inside your Build / Release Definitions they will not be exported. Any calls or uses of these variables (in the $() format will be converted.). Since YAML is clear text it would not be advisable to store these secrets and the default behavior of Azure DevOps to not copy these over when cloning or importing a Build / Release Definition I decided not to convert them (technically also impossible). My suggestion is you use the built-in functionality in the Definition settings or Azure Keyvault to store these secrets instead. If you name them similar as your original variables they will be accessible to converted tasks.

### incompatible folders (predefined variables)

This predominantly concerns Tasks / Task Groups which are working in the Release Definition area. In YAML Pipelines all pipelines operate in the build area. Therefor Artifacts are downloaded to the path $(pipeline.workspace)\<Artifact ALias> Which translates to <agentworkdir>\<Artifact Alias>. In Release definitions this would have been $(Release.ArtifactsDirectory) which tranlates to <agentworkdir>\a\<artifact Alias>. Thie means that all tasks that expect to work from the \a directory will not automatically work. Predefined variables which are affected are:

- $(System.defaultworkingdirectory)
- $(Release.ArtifactsDirectory)

Also this means that predefined variables which start with release.* will not work. 

Since it is impossible for me to determine which task groups are used for which purpose in your use-case i opted for not converting these affected inputs to the $(pipeline.workspace). This might mean that your converted YAML pipeline will fail on 

If there is enough interest I can add a switch which does this for you though. Still it would mean manually flagging Task Groups which would need this behavior.

### Manual stages in Release Definitions

Currently Microsoft does not allow for manual determined stages in YAML Pipelines. In Classical Pipelines it was possible to add multiple stages to your release definition which would not automatically trigger when a release was started. Instead you had to open up the newly created release and 'Deploy' to that stage. In YAML pipeline such a mechanic does not exist (yet). This means that if you make use of these manually triggered stages in your release definitions they will be exported as separate stages in the converted YAML file. However the behavior of YAML Pipelines is that all stages will run in parallel unless they have the dependsOn property. and even if that was declared it would still mean the stage would automatically execute. The only measure to prevent this would be to use manual approvals on an Environment. however this is still not a solution to this limitation. My suggestion is not to convert those classical pipelines to YAML or find a way to parameterize your pipeline in combination with say conditions to mimic the intended behavior. This is clearly out of the scope of this tool since we do not want to make too much assumptions in how the user wants its target produce. 

## Usage

## ToDo list

### Variables as Definition variables rather than YAML Template variables

### Schedules

### Release Definitions

I wanted to push this Module to GitHub and make it publicly available knowing this feature was not implemented yet. The reason is that release definitions are quite complex and are not fully compatible between classical vs YAML Pipelines. This has to do predominantly 

### Adding converted Pipelines as actual pipelines to Azure DevOps

right now 

### support for TFS / Azure DevOps Server installations

### Support for TFVC, GitHub, BitBucket source

