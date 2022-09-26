using namespace System.IO
using namespace System.Collections.Generic
using module '.\classes\BindRecordClass.psm1'
using module '.\classes\BindZoneClass.psm1'

# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function New-BindRecord {

    [OutputType( [BindRecord] )]
    [CmdletBinding( DefaultParameterSetName='FromString' )]
    param (

        [Parameter( Mandatory, Position=1, ValueFromPipeline, ParameterSetName='FromString' )]
        [ValidateNotNullOrEmpty()]
        [BindRecord[]]
        $Record,

        [Parameter( Mandatory, ParameterSetName='FromParams' )]
        [ValidateNotNullOrEmpty()]
        [string]
        $HostName,

        [Parameter( Mandatory, ParameterSetName='FromParams' )]
        [Alias( 'TTL' )]
        [ValidateNotNullOrEmpty()]
        [int]
        $TimeToLive,

        [Parameter( Mandatory, ParameterSetName='FromParams' )]
        [ArgumentCompleter( {'IN'} )]
        [ValidateNotNullOrEmpty()]
        [string]
        $RecordClass,

        [Parameter( Mandatory, ParameterSetName='FromParams' )]
        [ValidateNotNullOrEmpty()]
        [BindRecordType]
        $RecordType,

        [Parameter( Mandatory, ParameterSetName='FromParams' )]
        [ValidateNotNullOrEmpty()]
        [string]
        $RecordData,

        [Parameter( ParameterSetName='FromParams' )]
        [string]
        $Comment,

        [Parameter( ParameterSetName='FromParams' )]
        [switch]
        $Enabled

    )

    process {

        if ( $PSCmdlet.ParameterSetName -eq 'FromParams' ) {

            $RecordHashtable = @{}

            $ValidProperties = [BindRecord].
                GetMembers().
                Where({ $_.MemberType -eq 'Property' }).
                Name

            $PSBoundParameters.Keys |
                Where-Object { $_ -in $ValidProperties } |
                ForEach-Object { $RecordHashtable[$_] = $PSBoundParameters[$_] }

            $Record = [BindRecord]$RecordHashtable

        }
        
        return $Record

    }

}

# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Set-BindRecord {

    [OutputType( [BindRecord] )]
    [CmdletBinding()]
    param (

        [Parameter( Mandatory, ValueFromPipeline )]
        [BindRecord]
        $Record,

        [ValidateNotNullOrEmpty()]
        [string]
        $HostName,

        [Alias( 'TTL' )]
        [ValidateNotNullOrEmpty()]
        [int]
        $TimeToLive,

        [ArgumentCompleter( {'IN'} )]
        [ValidateNotNullOrEmpty()]
        [string]
        $RecordClass,

        [ValidateNotNullOrEmpty()]
        [BindRecordType]
        $RecordType,

        [ValidateNotNullOrEmpty()]
        [string]
        $RecordData,

        [string]
        $Comment,

        [switch]
        $PassThru

    )

    process {

        foreach ( $RecordItem in $Record ) {

            'HostName', 'TimeToLive', 'RecordClass', 'RecordType', 'RecordData', 'Comment' |
                Where-Object { $PSBoundParameters.ContainsKey( $_ ) } |
                ForEach-Object { $RecordItem.$_ = $PSBoundParameters.$_ }

            if ( $PassThru ) { $RecordItem }

        }

    }

}


# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Import-BindZone {

    [OutputType( [BindZone] )]
    [CmdletBinding()]
    param(

        [Parameter( Mandatory, Position=1, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName='Path' )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path,
    
        [Parameter( Mandatory, ValueFromPipelineByPropertyName, ParameterSetName='LiteralPath', DontShow )]
        [ValidateNotNullOrEmpty()]
        [Alias( 'PSPath' )]
        [string[]]
        $LiteralPath

    )

    process {

        Get-Item @PSBoundParameters |
            ForEach-Object {

                return , [BindZone]$_

            }

    }

}


# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Export-BindZone {

    [OutputType( [void] )]
    [CmdletBinding()]
    param(

        [Parameter( Mandatory, Position=1 )]
        [Alias( 'Zone' )]
        [BindZone]
        $BindZone,

        [Parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path

    )

    $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath( $Path )

    $BindZone.Export( $Path ) | Out-Null

}


# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function New-BindZone {

    [OutputType( [BindZone] )]
    [CmdletBinding()]
    param (

        [Parameter( Mandatory )]
        [ValidatePattern( '^\S+\.$' )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Origin,

        [Alias( 'Records' )]
        [BindRecord[]]
        $BindRecords

    )

    if ( $BindRecords ) {

        $BindZone = [BindZone]::new( $Origin, $BindRecords )

    } else {

        $BindZone = [BindZone]::new( $Origin )

    }

    return , $BindZone

}

# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Add-BindRecordToZone {

    [OutputType( [BindZone] )]
    [CmdletBinding( DefaultParameterSetName='Default' )]
    param (

        [Parameter( Mandatory, Position=1 )]
        [Alias( 'Zone' )]
        [BindZone]
        $BindZone,

        [Parameter( Mandatory, Position=2, ValueFromPipeline )]
        [Alias( 'Record' )]
        [BindRecord[]]
        $BindRecord,

        [Parameter( Mandatory, ParameterSetName='After' )]
        [BindRecord]
        $After,

        [Parameter( Mandatory, ParameterSetName='Before' )]
        [BindRecord]
        $Before,

        [Parameter( Mandatory, ParameterSetName='AtIndex' )]
        [int]
        $AtIndex,

        [switch]
        $PassThru
    
    )

    begin {

        $Records = [List[BindRecord]]::new()

    }

    process {

        $Records.AddRange( $BindRecord )

    }

    end {

        if ( $After ) {

            $AtIndex = $BindZone.IndexOf( $After ) + 1

        }

        if ( $Before ) {

            $AtIndex = $BindZone.IndexOf( $Before )

        }
        
        if ( $AtIndex ) {

            Write-Verbose "Inserting at index $AtIndex"

            $BindZone.InsertRange( $AtIndex, $Records )

        } else {

            $BindZone.AddRange( $Records )

        }

        if ( $PassThru ) { $Records }

    }
    
}


# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Remove-BindRecordFromZone {

    [OutputType( [void] )]
    [CmdletBinding()]
    param (

        [Parameter( Mandatory, Position=1 )]
        [Alias( 'Zone' )]
        [BindZone]
        $BindZone,

        [Parameter( Mandatory, Position=2, ValueFromPipeline )]
        [Alias( 'Record' )]
        [BindRecord]
        $BindRecord
    
    )

    process {

        $BindRecord | ForEach-Object {

            $BindZone.Remove( $_ ) | Out-Null

        }

    }

}


# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Test-BindZoneHasErrors {

    [OutputType( [bool] )]
    [CmdletBinding()]
    param (

        [Parameter( Mandatory, Position=1, ParameterSetName='Zone' )]
        [Alias( 'Zone' )]
        [BindZone]
        $BindZone,

        [Parameter( Mandatory, Position=1, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName='Path' )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,
     
        [Parameter( Mandatory, ValueFromPipelineByPropertyName, ParameterSetName='LiteralPath' )]
        [ValidateNotNullOrEmpty()]
        [Alias('PSPath')]
        [string]
        $LiteralPath
    
    )

    process {

        if ( $PSCmdlet.ParameterSetName -ne 'Zone' ) {

            $BindZone = Get-Item @PSBoundParameters

        }

        $Errors = $BindZone.GetErrors()

        $Errors | ForEach-Object { Write-Warning $_ }

        return $Errors.Count -gt 0

    }

}

# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Invoke-BindZoneSort {

    [OutputType( [void] )]
    [CmdletBinding()]
    param (

        [Parameter( Mandatory, Position=1 )]
        [Alias( 'Zone' )]
        [BindZone]
        $BindZone

    )

    $BindZone.Sort()

}