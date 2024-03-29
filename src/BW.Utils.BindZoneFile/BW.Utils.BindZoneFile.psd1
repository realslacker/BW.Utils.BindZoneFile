﻿#
# Module manifest for module 'BW.Utils.BindZoneFile'
#
# Generated by: Shannon Graybrook
#
# Generated on: 10/1/2020
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'BW.Utils.BindZoneFile.psm1'

# Version number of this module.
ModuleVersion = '22.10.28.1000'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '791e6415-45e5-4a7c-bd89-cd686dd512a6'

# Author of this module
Author = 'Shannon Graybrook'

# Company or vendor of this module
CompanyName = 'Brooksworks'

# Copyright statement for this module
Copyright = 'Shannon Graybrook (c) 2020'

# Description of the functionality provided by this module
Description = 'Read and write Bind zone files'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = ''

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# NOTE: BindRecordClass.ps1 needs to load before BindZoneClass.ps1 as the object class needs to already be defined when the list class is loaded.
# ScriptsToProcess = 'classes\BindRecordTypeEnum.ps1', 'classes\BindRecordClass.ps1', 'classes\BindZoneClass.ps1'

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = '*-*'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Bind', 'DNS'

        # A URL to the license for this module.
        LicenseUri = 'https://raw.githubusercontent.com/realslacker/BW.Utils.BindZoneFile/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/realslacker/BW.Utils.BindZoneFile'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''
        
        # External dependent modules of this module
        # ExternalModuleDependencies = ''

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

