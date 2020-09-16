#requires -Modules InvokeBuild, Buildhelpers, PSScriptAnalyzer, Pester, PSDeploy, PlatyPS

$script:ModuleName = 'AzdoAPITools'
$Script:Author = 'Tobi Steenbakkers'
$Script:CompanyName = 'Continuous Data'
$script:Source = Join-Path $BuildRoot Source
$script:Output = Join-Path $BuildRoot BuildOutput
$script:DocPath =  Join-Path $BuildRoot "docs\functions"
$script:TestRoot = Join-Path $BuildRoot 'Tests\Unit'
$script:Destination = Join-Path $Output $ModuleName
$script:ModulePath = "$Destination\$ModuleName.psm1"
$script:ManifestPath = "$Destination\$ModuleName.psd1"
$script:Imports = ( 'Private','Public' )

task Default Clean, Build, AnalyzeErrors, Pester
task Build ModuleBuild, DocBuild
task Pester {ImportModule}, Test, {uninstall}
Task UpdateDocs {ImportModule}, CreateUpdateDocs, {uninstall}

task Local Default, UpdateSource, UpdateDocs
task CICD Default, UpdateVersion, {Uninstall}

Task Clean {
    If(Get-Module $moduleName){
        Remove-Module $moduleName
    }
    If(Test-Path $Output){
        $null = Remove-Item $Output -Recurse -ErrorAction Ignore
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
        Passthru = $true
        Verbose = $false
        EnableExit = $true
        OutputFile = 'Test-results.xml'
        OutputFormat = 'NunitXML'
        Path = $script:TestRoot  
    }

    $testResults = Invoke-Pester @invokePesterParams

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

Function ImportModule {
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

function Uninstall {
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

Task DocBuild {
    New-ExternalHelp $DocPath -OutputPath "$destination\EN-US"
}

Task CreateUpdateDocs {
    
    If(-not (Test-Path $DocPath)){
        "Creating Documents path: $DocPath"
        $null = New-Item -Type Directory -Path $DocPath -ErrorAction Ignore
    }

    "Creating new markdown files if any"
    New-MarkdownHelp -Module $modulename -OutputFolder $docpath -ErrorAction SilentlyContinue
    "Updating existing markdown files"
    Update-MarkdownHelp $docpath

}

task ModuleBuild {
    $pubFiles = Get-ChildItem "$Source\public" -Filter *.ps1 -File
    $privFiles = Get-ChildItem "$Source\private" -Filter *.ps1 -File
    If(-not(Test-Path $Destination)){
        New-Item $destination -ItemType Directory
    }
    ForEach($file in ($pubFiles + $privFiles)) {
        Get-Content $file.FullName | Out-File "$destination\$moduleName.psm1" -Append -Encoding utf8
    }
    Copy-Item "$Source\$moduleName.psd1" -Destination $destination

    $moduleManifestData = @{
        Author = $author
        Copyright = "(c) $((get-date).Year) $companyname. All rights reserved."
        Path = "$destination\$moduleName.psd1"
        FunctionsToExport = $pubFiles.BaseName
        RootModule = "$moduleName.psm1"
        ProjectUri = "https://github.com/Continuous-Data/$modulename"
    }
    Update-ModuleManifest @moduleManifestData
}