#requires -Modules InvokeBuild, Buildhelpers, PSScriptAnalyzer, Pester, PSDeploy, PlatyPS

$script:ModuleName = 'AzdoAPITools'

$script:Source = Join-Path $BuildRoot Source
$script:Output = Join-Path $BuildRoot BuildOutput
$script:DocPath =  Join-Path $BuildRoot "docs\functions"
$script:Destination = Join-Path $Output $ModuleName
$script:ModulePath = "$Destination\$ModuleName.psm1"
$script:ManifestPath = "$Destination\$ModuleName.psd1"
$script:Imports = ( 'Private','Public' )
# $script:TestFile = "$PSScriptRoot\output\TestResults_PS$PSVersion`_$TimeStamp.xml"
# $script:HelpRoot = Join-Path $Output 'help'

function TaskX($Name, $Parameters) {task $Name @Parameters -Source $MyInvocation}

task Default Clean, Build, AnalyzeErrors, Pester
task Build CopyToOutput, BuildPSM1, BuildPSD1, DocBuild 
task Pester ImportModule, Test

task Local Default, UpdateSource
task CICD Default, UpdateVersion, Uninstall

Task Clean {
    If(Get-Module $moduleName){
        Remove-Module $moduleName
    }
    If(Test-Path $Output){
        $null = Remove-Item $Output -Recurse -ErrorAction Ignore
    }
}

Task DocBuild {
    New-ExternalHelp $docPath -OutputPath "$destination\EN-US"
}

Task CopyToOutput {

    "  Create Directory [$Destination]"
    $null = New-Item -Type Directory -Path $Destination -ErrorAction Ignore

    Get-ChildItem $source -File |
        Where-Object name -NotMatch "$ModuleName\.ps[dm]1" |
        Copy-Item -Destination $Destination -Force -PassThru |
        ForEach-Object { "  Create [.{0}]" -f $_.fullname.replace($PSScriptRoot, '')}

    Get-ChildItem $source -Directory |
        Where-Object name -NotIn $imports |
        Copy-Item -Destination $Destination -Recurse -Force -PassThru |
        ForEach-Object { "  Create [.{0}]" -f $_.fullname.replace($PSScriptRoot, '')}
}

TaskX BuildPSM1 @{
    Inputs  = (Get-Item "$source\*\*.ps1")
    Outputs = $ModulePath
    Jobs    = {
        [System.Text.StringBuilder]$stringbuilder = [System.Text.StringBuilder]::new()
        foreach ($folder in $imports )
        {
            [void]$stringbuilder.AppendLine( "Write-Verbose 'Importing from [$Source\$folder]'" )
            if (Test-Path "$source\$folder")
            {
                $fileList = Get-ChildItem $source\$folder\ -Recurse -include *.ps1  | Where-Object Name -NotLike '*.Tests.ps1'
                foreach ($file in $fileList)
                {
                    $shortName = $file.fullname.replace($PSScriptRoot, '')
                    "  Importing [.$shortName]"
                    [void]$stringbuilder.AppendLine( "# .$shortName" )
                    [void]$stringbuilder.AppendLine( [System.IO.File]::ReadAllText($file.fullname) )
                }
            }
        }

        "  Creating module [$ModulePath]"
        Set-Content -Path  $ModulePath -Value $stringbuilder.ToString()
    }
}

TaskX BuildPSD1 @{
    Inputs  = (Get-ChildItem $Source -Recurse -File)
    Outputs = $ManifestPath
    Jobs    = {

        Write-Output "  Update [$ManifestPath]"
        Copy-Item "$source\$ModuleName.psd1" -Destination $ManifestPath

        $functions =  Get-ChildItem $source\Public -Recurse -include *.ps1 | Where-Object { $_.name -notmatch 'Tests'} | Select-Object -ExpandProperty basename
        Set-ModuleFunctions -Name $ManifestPath -FunctionsToExport $functions
    }
}

task AnalyzeErrors {
    $scriptAnalyzerParams = @{
        Path = $Destination
        Severity = @('Error')
        Recurse = $true
        Verbose = $false
        #ExcludeRule = 'PSUseDeclaredVarsMoreThanAssignments'
    }

    $saResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams

    if ($saResults) {
        $saResults | Format-Table
        throw "One or more PSScriptAnalyzer errors/warnings where found."
    }
}

task Analyze {
    $scriptAnalyzerParams = @{
        Path = $Destination
        Severity = @('Warning','Error')
        Recurse = $true
        Verbose = $false
        #ExcludeRule = 'PSUseDeclaredVarsMoreThanAssignments'
    }

    $saResults = Invoke-ScriptAnalyzer @scriptAnalyzerParams

    if ($saResults) {
        $saResults | Format-Table
        throw "One or more PSScriptAnalyzer errors/warnings where found."
    }
}

task Test {
    $invokePesterParams = @{
        Strict = $true
        Passthru = $true
        Verbose = $false
        EnableExit = $true
        OutputFile = 'Test-results.xml'
        OutputFormat = 'NunitXML'
        Script = '.\Tests\unit'
        
    }

    $testResults = Invoke-Pester @invokePesterParams;

    $numberFails = $testResults.FailedCount
    assert($numberFails -eq 0) ('Failed "{0}" unit tests.' -f $numberFails)
}

task UpdateVersion {
    try 
    {
        #$moduleManifestFile = ((($ManifestPath -split '\\')[-1] -split '\.')[0]+'.psd1')
        $manifestContent = Get-Content $ManifestPath -Raw
        [version]$version = [regex]::matches($manifestContent,"ModuleVersion\s=\s\'(?<version>(\d+\.)?(\d+\.)?(\*|\d+))") | ForEach-Object {$_.groups['version'].value}
        $newVersion = "{0}.{1}.{2}" -f $version.Major, $version.Minor, $ENV:Build_BuildID

        $replacements = @{
            "ModuleVersion = '.*'" = "ModuleVersion = '$newVersion'"            
        }

        $replacements.GetEnumerator() | ForEach-Object {
            $manifestContent = $manifestContent -replace $_.Key,$_.Value
        }
        
        $manifestContent | Set-Content -Path "$ManifestPath"
    }
    catch
    {
        Write-Error -Message $_.Exception.Message
        $host.SetShouldExit($LastExitCode)
    }
}

Task UpdateSource {
    Copy-Item $ManifestPath -Destination "$source\$ModuleName.psd1"
}

Task ImportModule {
    if ( -Not ( Test-Path $ManifestPath ) )
    {
        "  Modue [$ModuleName] is not built, cannot find [$ManifestPath]"
        Write-Error "Could not find module manifest [$ManifestPath]. You may need to build the module first"
    }
    else
    {
        if (Get-Module $ModuleName)
        {
            "  Unloading Module [$ModuleName] from previous import"
            Remove-Module $ModuleName
        }
        "  Importing Module [$ModuleName] from [$ManifestPath]"
        Import-Module $ManifestPath -Force
    }
}

task Uninstall {
    'Unloading Modules...'
    Get-Module -Name $ModuleName -ErrorAction 'Ignore' | Remove-Module

    'Uninstalling Module packages...'
    $modules = Get-Module $ModuleName -ErrorAction 'Ignore' -ListAvailable
    foreach ($module in $modules)
    {
        Uninstall-Module -Name $module.Name -RequiredVersion $module.Version -ErrorAction 'Ignore'
    }

    'Cleaning up manually installed Modules...'
    $path = $env:PSModulePath.Split(';').Where( {
            $_ -like 'C:\Users\*'
        }, 'First', 1)

    $path = Join-Path -Path $path -ChildPath $ModuleName
    if ($path -and (Test-Path -Path $path))
    {
        'Removing files... (This may fail if any DLLs are in use.)'
        Get-ChildItem -Path $path -File -Recurse |
            Remove-Item -Force | ForEach-Object 'FullName'

        'Removing folders... (This may fail if any DLLs are in use.)'
        Remove-Item $path -Recurse -Force
    }
}

task Publish {
    Invoke-PSDeploy -Path $PSScriptRoot -Force
}