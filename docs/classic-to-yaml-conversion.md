# Migration of Classical Pipelines & Task Groups to Yaml templates

The main driver for combining this toolset was to automate the steps to convert classical pipelines (aka Build / Release Definitions) as well as Task Groups into YAML Pipelines / YAML Templates. This functionality mimics the 'View YAML' button inside steps / jobs. when doing a migration for a customer from classical to YAML pipelines I noticed how Azure DevOps does not provide a full experience.

Curently when you want to migrate a classical to YAML pipeline in Azure Devops it has to be done manually. You have the 'View YAML' button in classical pipelines for single steps which will give you the code for that particular step. However it does not work when you are selecting a Task Group step inside your classical pipeline. Furthermore useful properties such as triggers, variables, schedules, options and source options are not available from the Azure DevOps UI.

This means you are left with a lot of manual labor by having to select each and every step inside a single pipeline add it to a YAML file and when there are Task Groups in the mix you would need to open them one by one and copy the single steps inside them and past them. Then you would have to add the other very important properties of a pipeline yourself to that same YAML file you are trying to make.

This is not only tedious but if you have invested a lot of time and effort into Task Groups as a mean to 'Create Once, Use Many' philosophy in CI/CD best practices you would like to convert those to YAML Templates files and call them from your YAML Pipeline.

This Functionality does exactly that and automatically. It currently has two main features:

- Convert Task Groups to YAML step templates
  - steps: Iterates over steps and add them to the template
  - Task Groups: When a Task Group is found it can either be added as \-template: or iterate over the steps inside and be added as \-task:
  - Inputs: Task Group Inputs are converted to template parameters
- Convert Build Definitions to YAML Pipelines including pipelines properties such as:
  - Triggers: (both Path and Branch)
  - Schedules: (already converted into CRON and UTC w/o DST)
  - Variables: (Secret variables are skipped and set at queue time will be converted to parameters)
  - Agent Pools: (both at job and pipeline level)
  - Jobs: (and interdependendancies between them such as dependancies and conditions)
  - steps: (including non-default properties, inputs and conditions)
  - Task Groups: When a Task Group is found it can either be added as \-template: or iterate over the steps inside and be added as \-task:

The result of this conversion can either be used as a PSObject or be converted into a \*.yml file for direct usage. In the future I will create functionality to also import the results of the conversion as a new YAML Pipeline definition inside Azure DevOps. For items such as definition specific properties (triggers, schedules etc.) it will be an option to include them in the YAML file or you wish so (not recommended) have them be part of your YAML Pipeline definition.

## Usage

Below is explained how the module will do its work and what functions to call. No functions have pipeline support. I will be working on converting the module to have this as well as make use of Variable Sets, Classes and Types. I have just learned this exists in Powershell and did not want to halt the project on converting everthing.

### Task Group Conversion

In order to start with Task Group Conversion you will need a Powershell Array with Task Group names which you want to convert. This would look something like this: `$listofnames = @('Task Group 1', 'Task Group 2')`. If you do not have this list available you can call `Get-AzDoAPIToolsDefinitonsTaskGroupNames -ApiType 'Taskgroup' -Projectname 'Project on AzDo'` to get a list of names. Optionally you can provide the `-Profilename 'profile'` to address a specific profile saved in your `config.json`. By default it will pick the first entry in the `config.json` if not specified.

---

you will need to feed this array into `Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList` adding the array as `-nameslist` and using `-apitype 'Taskgroup' -projectname 'Project on AzDo'`. Optionally you can use the `-profilename` to specify a different profile. this function knows a set of switches which can be called optionally:

- `-includeTGdrafts` : if your nameslist has Task Groups which are in draft the draft version will be included into the output of this function. This means you could have duplicate names in your resulting array which can cause overwritten files. It is best to seperate Draft Task Groups in a seperate nameslist
- `-includeTGpreview` : If your nameslist includes Task Groups of which you have a preview currently it will be taken into account when using this switch. By default the function will try to determine the highestversion of a task group and will exclude previews and only use stable versions. If you want your task groups to be converted if a preview is available use this switch to allow the highestversion of a Task Group to be a preview version.
- `-AllTGVersions` : For converting Task Groups it is not recommended to use this switch. Using this switch will return all versions of the task group in nameslist which will lead to duplicates. It might be useful for other puroposes but not for converting

This function will add some necessary MetaData as well as the actual definition to a PSObject which then can be used by subsequent functions which actually convert your task groups.

---

By running `Get-AzDoAPIToolsDefinitionsTaskGroupsByNamesList` and assigning it to a variable you are now ready to convert one or more Task Groups to YAML Templates.

use `Get-AzDoAPIToolsTaskGroupAsYAMLPrepped -TaskGroupsToConvert $arrayresult -projectname 'Project on AzDo'` To output the YAML Prepped PSObject for a Task Group. You can use `-profilename` to specify a different profile. 

if you specify the `-ExpandNestedTaskGroups` switch every 'nested Task Group' inside The current Task Group to be converted will be expanded into \-task: steps rather than \-template: calls to other Task Groups. However you want to use it is up to you. Sidenote. The Template referenced / expanded will be of the version which is being used by the initiating Task Group. That could result in expanding different versions of Task Groups if you have configured it like so. When not using this switch and using different versions of a Task Group it will only refer to the version of the originating task group you converted.

#### Example

Say you have 2 Task Groups referencing Different versions of another Task Group:

- Task Group 1 : References Task Group 3 Version 1
- Task Group 2 : References Task Group 3 Version 2

When __not__ using the `-ExpandNestedTaskGroups` both converted Task Group 1 & 2 will have a \-template: Task Group 3.yml reference. The reference to the template used will be dependant to which version of Task Group 3 you have converted into a \*.yml file. __Both will refer to the same version__. 

If you had used the `-ExpandNestedTaskGroups` switch Task Group 1 would have the expanded steps of Task Group 3 Version 1 whereas Task Group 2 would have the expanded steps of Task Group 3 Version 2.

If you need different versions of templates you will need to convert both templates and apply some manual labor. For the module it is impossible to convert this granularity without some manual labor. Maybe I will include the version number as a part of the filename when exporting in the future.

---

With these settings the function will output a PSObject with the YAML Prepped properties and values. If you wish to output it as a YAML file you need to use the `-Outputasfile` switch. If you do you will also need to specify the `-OutputPath` argument with a filepath to which the task groups are saved. By default the filename will be \<Name of Task Group\>.yml.

If you wish to store your templates in a different directory that is possible. Any references to existing templates in the form of \-template:taskgroup.yaml need to be changed to be prefixed with a pathname.

If you wish to store your templates in a seperate repository you need to add a `resources` component to the YAML file and suffix the reference to the YAML template with a `@aliastoexternalresource`.

### Build Definition conversion

## Examples

This section has some examples on how an example pipelines is converted by the module.

## Assumptions

Some assumptions had to be made while developing this functionality. Below is the explanation of these assumptions.

### Schedules are converted to UTC notation disregarding DST

When converting schedules from the buil-in GUI editor to CRON notation inside YAML I had to follow the guidelines which are stated [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/scheduled-triggers?view=azure-devops&tabs=yaml#migrating-from-the-classic-editor). These instructions tells us that schedules in YAML pipelines are expected as CRON notation, but more notably in UTC format. In the classical pipeline you can determine in which timezone OffSet you want to run the schedule. In YAML there is no such way and it expects a UTC based notation.

DayLightSaving corrections are ignored by YAML pipelines. e.g CEST will not be +2 based on UTC but rather +1 (based of the non-DST timezone CET). Converted schedules are formatted as UTC w/o DST correction. This might mean that the schedule in the YAML file has a different day / time as configured in the GUI pipeline. this is all based on the [guidelines for manually converting schedules to YAML notation](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/scheduled-triggers?view=azure-devops&tabs=yaml#migrating-from-the-classic-editor)

#### example

Schedule on Tokyo Time (UTC+9) on Saturday at 1:00 (AM) means it needs to be corrected with -9 hours to be in UTC. Your converted YAML Schedule in CRON will read Friday 16:00 (PM) (0 16 \* \* 5)

similarly if you have a UTC - x timezone scheduled near the end of your timezones day it will be planned on the next day(s).

### allow override variables --> Parameters

Classical Pipelines know variables. One particular property of a variable in classical pipelines is the ability to override values for variables at queue time rendering them into sort of parameters. With YAML Pipelines we now have the option to actually declare parameters in our yaml file. Variables (declared in a yaml file, not in definitions) are static.

The assumption is that if you have declared any variables with the property 'Allow value to be overwritten at queue time' you want them to be turned into YAML parameters.

If the module is expanded and the adding of converted yaml pipeline definitions (not the *.yml file itself but its definition) becomes available i might consider exporting variables into the definition rather than the yaml file (see next assumption)

### Definition specific properties are supposed to be inside YAML files rathen then in the YAML definition

Now this needs some explanation... With classical pipelines you need to declare variables / triggers inside the Build / Release definition. However with YAML Pipelines you have the option to declare these in two possible ways:

- inside the YAML Pipeline definition (similar place as they would exist in a Build / Release definition)
- inside the YAML Pipeline itself (the *.yml file). These would become the trigger: / variables: properties of the YAML file.

The assumption from this tool is that users strive to use the best practices associated and that you want variables / triggers for your definition inside the yaml file rather than in the definition.

### calls to other templates assume they are in the same folder as the calling YAML file

When converting Task Groups to YAML Templates they will be exported to a single output folder. If you have nested task groups or definitions caling task groups (and not using the ExpandNestedTaskgroups switch) the tool assumes the called / nested task group is in the same folder as its caller / parent. If you want to have this in a different way and use an external template repository you should add the resource for it, the path to where you store them and the @alias suffix yourself. When i have time I will attempt to add settings which will do these prefixes / suffixes based on a json file.

## Limitations

some buyers beware and known limitations of this product due to the behavior of Azure DevOps and the differences in classical vs yaml pipelines. These limitations will not be solved unless Micrsosoft will update their product and if i can find a stable way to implement it.

### Incompatible Tasks

If your task group contains a task which does not work with YAML pipelines expect your pipeline to crash on it. I noticed this first when running the 'Add Tag' task which can tag a release definition or build definition. Since YAML Pipelines are living in the 'Build' area of Azure DevOps it can't apply a tag to a release definition (since they no longer exist in YAML). These tasks are converted to YAML but will obviously fail when running the pipeline. Unfortunately it is quite impossible / undoable to determine if a custom task is YAML-proof.

### Secret variables

If you have any secret variables inside your Build / Release Definitions they will not be exported. Any calls or uses of these variables (in the $() format will be converted.). Since YAML is clear text it would not be advisable to store these secrets. Besides the default behavior of Azure DevOps is to not copy these over when cloning or importing a Build / Release Definition I decided not to convert them (technically also impossible).

My suggestion is you use the built-in functionality in the Definition settings or Azure Keyvault to store these secrets instead. If you name them similar as your original variables they will be accessible to converted tasks.

### incompatible folders (predefined variables)

This predominantly concerns Tasks / Task Groups which are working in the Release Definition area. In YAML Pipelines all pipelines operate in the build area. Therefor Artifacts are downloaded to the path $(pipeline.workspace)\\(Artifact ALias)  directory Which translates to (agentworkdir)\\(Artifact Alias). In Release definitions this would have been $(Release.ArtifactsDirectory) which tranlates to (agentworkdir)\\a\\(artifact Alias). Thie means that all tasks that expect to work from the \a directory will not automatically work. Predefined variables which are affected are:

- $(System.defaultworkingdirectory)
- $(Release.ArtifactsDirectory)
- $(Agent.ReleaseDirectory)

Also this means that predefined variables which start with release.* will not work.

Since it is impossible for me to determine which task groups are used for which purpose in your use-case i opted for not converting these affected inputs to the $(pipeline.workspace). This might mean that your converted YAML pipeline will fail on folder errors / file not found errors.

If there is enough interest I can add a switch which does this for you though. Still it would mean manually flagging Task Groups which would need this behavior. This will not fix the default behavior of some of your 3rd party extensions / tasks. some of these will prefix $(system.defaultworkingdirectory) if you provide a relative path as an input to a task. These will have to be fixed by the original author. in most tasks if you prefix $(pipeline.workspace)\\(relative path) it will work most of the times.

### Manual stages in Release Definitions

Currently Microsoft does not allow for manual determined stages in YAML Pipelines. In Classical Pipelines it was possible to add multiple stages to your release definition which would not automatically trigger when a release was started. Instead you had to open up the newly created release and 'Deploy' to that stage. In YAML pipeline such a mechanic does not exist (yet). This means that if you make use of these manually triggered stages in your release definitions they will be exported as separate stages in the converted YAML file. However the behavior of YAML Pipelines is that all stages will run in parallel unless they have the dependsOn property. and even if that was declared it would still mean the stage would automatically execute. The only measure to prevent this would be to use manual approvals on an Environment. however this is still not a solution to this limitation. My suggestion is not to convert those classical pipelines to YAML or find a way to parameterize your pipeline in combination with say conditions to mimic the intended behavior. This is clearly out of the scope of this tool since we do not want to make too much assumptions in how the user wants its target produce.

## ToDo list

Below is a short To Do list of functionality I wish to implement asap. the order in which they occur here is the priority i gave them.

### Apply resource checkout options

stuff like checkout: clean, LFS and other git options which are specified in a build definitions sources part needs to be translated to steps - checkout options.

### Converted parameters from queue time variables are called as variable instead of a parameter

When converting variables to parameters which have the AllowOveride property and are thus settable at queue time are put into the parameters section of the YAML file.

However when calling such parameter inside a step input it is being referred to as $(variablename) rather than $(parameters.variablename) / ${{parameters.variablename}}. This means an overhaul of the Get-Inputs function and rethink the logic behind it.

### Release Definitions

I wanted to push this Module to GitHub and make it publicly available knowing this feature was not implemented yet. The reason is that release definitions are quite complex and are not fully compatible between classical vs YAML Pipelines. This has to do predominantly with the manual stages limitation. whenever i get more time i will include this functionality

### Adding converted Pipelines as actual definitions to Azure DevOps

right now the goal is to produce \*.yml files which then can be used to create a new pipeline in Azure DevOps via the 'New Pipeline' button. This will create a 'Build Definition' on the background which points to the created \*.yml file. It would be awesome if the user would not need to perform this manual step and have the already converted classical pipeline be automatically added as a new definition into Azure DevOps.

### Variables as Definition variables rather than YAML Template variables

As mentioned in the assumptions part of this readme right now Variables are assumed to be wanted as the variables: property inside a *.yml file. However even with YAML pipelines it is possible to have these variables defined as variables managed by Azure DevOps. If the option becomes available to add converted pipelines as a new definition the assumption on variables becomes a choice.

### support for TFS / Azure DevOps Server installations

Right now all the URL creation function allows for Azure DevOps URL creation. it does not support TFS / Azure DevOps Server local installation. In the case of TFS I am even unsure if YAML is supported at all. This needs further investigation.

### Support for TFVC, GitHub, BitBucket source

Right now the use-cases at the clients i've worked with was to deal with Azure DevOps hosted source code. I will need to do investigation / confirmation that this also works if you host your code externally and if not what changes are needed to incorporate this.
