# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function New-BindRecord {

    [OutputType( [BindRecord] )]
    [CmdletBinding( DefaultParameterSetName='FromString' )]
    param (

        [Parameter( Mandatory, Position=1, ParameterSetName='FromString' )]
        [ValidateNotNullOrEmpty()]
        [BindRecord]
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

        [BindZone]
        $BindZone,

        [switch]
        $PassThru

    )

    if ( $PSCmdlet.ParameterSetName -eq 'FromParams' ) {

        $RecordHashtable = @{}

        $PSBoundParameters.Keys |
            Where-Object { [BindRecord]::IsValidRecordProperty( $_ ) } |
            ForEach-Object { $RecordHashtable[$_] = $PSBoundParameters[$_] }

        $Record = [BindRecord]$RecordHashtable

    }

    if ( $BindZone ) {

        $BindZone.Add( $Record ) > $null

    }
    
    if ( -not $BindZone -or $PassThru ) {
        
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

        $ZoneFilePaths = switch ( $PSCmdlet.ParameterSetName ) {
            'Path'          { Resolve-Path -Path $Path }
            'LiteralPath'   { Resolve-Path -LiteralPath $LiteralPath | Convert-Path }
        }

        $ZoneFilePaths | ForEach-Object {

            if ( -not( Test-path $_ -PathType Leaf ) ) {
                
                Write-Error ( 'Path must be a zone file!' )
                return
            
            }

            return , [BindZone]::new( $_ )

        }

    }

}


# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Export-BindZone {

    [OutputType( [void] )]
    [CmdletBinding()]
    param(

        [Parameter( Mandatory, Position=1 )]
        [BindZone]
        $Zone,

        [Parameter( Mandatory )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path

    )

    $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath( $Path )

    $Zone.SaveAs( $Path ) | Out-Null

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

        [BindRecord[]]
        $Records

    )

    if ( $Records ) {

        $BindZone = [BindZone]::new( $Records, $Origin )

    } else {

        $BindZone = [BindZone]::new()
        $BindZone.Origin = $Origin

    }

    return $BindZone

}

# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Add-BindRecordToZone {

    [OutputType( [BindZone] )]
    [CmdletBinding( DefaultParameterSetName='Default' )]
    param (

        [Parameter( Mandatory, Position=1 )]
        [BindZone]
        $Zone,

        [Parameter( Mandatory, Position=2, ValueFromPipeline )]
        [BindRecord[]]
        $Record,

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

        $Records = [System.Collections.Generic.List[BindRecord]]::new()

    }

    process {

        $Records.AddRange( $Record )

    }

    end {

        if ( $After ) {

            $AtIndex = $Zone.IndexOf( $After ) + 1

        }

        if ( $Before ) {

            $AtIndex = $Zone.IndexOf( $Before )

        }
        
        if ( $AtIndex ) {

            Write-Verbose "Inserting at index $AtIndex"

            $Zone.InsertRange( $AtIndex, $Records )

        } else {

            $Zone.AddRange( $Records )

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
        [BindZone]
        $Zone,

        [Parameter( Mandatory, Position=2, ValueFromPipeline )]
        [BindRecord]
        $Record
    
    )

    process {

        $Record | ForEach-Object {

            $Zone.Remove( $_ ) | Out-Null

        }

    }

}


# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Test-BindZone {

    [OutputType( [bool] )]
    [CmdletBinding()]
    param (

        [Parameter( Mandatory, Position=1, ParameterSetName='Zone' )]
        [BindZone[]]
        $Zone,

        [Parameter( Mandatory, Position=1, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName='Path' )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path,
     
        [Parameter( Mandatory, ValueFromPipelineByPropertyName, ParameterSetName='LiteralPath' )]
        [ValidateNotNullOrEmpty()]
        [Alias('PSPath')]
        [string[]]
        $LiteralPath  
    
    )

    begin {

        $ReturnValue = $true

    }

    process {

        $Path = switch ( $PSCmdlet.ParameterSetName ) {
            'Path'          { Resolve-Path -Path $Path }
            'LiteralPath'   { Resolve-Path -LiteralPath $LiteralPath | Convert-Path }
        }

        $Zone = [BindZone[]]$Path

        foreach ( $ZoneItem in $Zone ) {

            if ( $ZoneItem.Origin ) {

                $ZoneName = $ZoneItem.Origin

            } else {

                $ZoneName = 'UNDEFINED'

            }

            Write-Verbose "Checking zone $ZoneName..."

            if ( [BindZone]::HasErrors( $ZoneItem ) -and $ReturnValue ) { $ReturnValue = $false }

        }

    }

    end {

        return $ReturnValue

    }

}

# .ExternalHelp BW.Utils.BindZoneFile-help.xml
function Invoke-BindZoneSort {

    [OutputType( [void] )]
    [CmdletBinding()]
    param (

        [Parameter( Mandatory, Position=1 )]
        [BindZone]
        $Zone

    )

    $Zone.Sort()

}