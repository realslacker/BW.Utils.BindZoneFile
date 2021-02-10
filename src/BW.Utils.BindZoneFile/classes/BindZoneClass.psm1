using namespace System.IO
using namespace System.Collections.Generic
using module '.\BindRecordClass.psm1'

class BindZone:List[BindRecord] {

    [ValidateNotNullOrEmpty()]
    [string]$Origin

    BindZone() {}

    BindZone( [FileInfo]$FileInfo ) {

        $this.Import( $FileInfo )
        
    }

    BindZone( [string]$Origin ) {

        $this.Origin = $Origin

    }

    BindZone( [string[]]$Records ) {

        $this.__InitZone( $Records )
        
    }

    BindZone( [BindRecord[]]$Records ) {

        $this.__InitZone( $Records )
        
    }

    BindZone( [string]$Origin, [string[]]$Records ) {

        $this.Origin = $Origin
        $this.__InitZone( $Records )

    }

    BindZone( [string]$Origin, [BindRecord[]]$Records ) {

        $this.Origin = $Origin
        $this.__InitZone( $Records )

    }

    hidden [void] __InitZone( [BindRecord[]]$Records ) {

        $this.AddRange( $Records )

    }

    [string] ToString() {

        # figure out column widths
        $ColumnWidths = @{
            HostName    = ( [string[]]$this.HostName    | Measure-Object -Maximum -Property Length ).Maximum
            TimeToLive  = ( [string[]]$this.TimeToLive  | Measure-Object -Maximum -Property Length ).Maximum
            RecordClass = ( [string[]]$this.RecordClass | Measure-Object -Maximum -Property Length ).Maximum
            RecordType  = ( [string[]]$this.RecordType  | Measure-Object -Maximum -Property Length ).Maximum
            #RecordData  = ( [string[]]$this.RecordData  | Measure-Object -Maximum -Property Length ).Maximum
        }

        $Format = "{0,-$($ColumnWidths.HostName)}  {1,$($ColumnWidths.TimeToLive)}  {2,-$($ColumnWidths.RecordClass)}  {3,-$($ColumnWidths.RecordType)}  {4}"

        $Return = [List[string]]::new()

        if ( $this.Origin ) {
            
            $Return.Add( '$ORIGIN ' + $this.Origin )

        }

        $this |
            ForEach-Object { $Return.Add( $_.ToString( $Format ) ) }

        return $Return -join "`r`n"
    
    }

    [void] Import( [FileInfo]$Path ) {

        $ZoneOrigin = $null
        $Records = Resolve-Path $Path | Get-Content

        if ( $Records[0] -match '^\$ORIGIN\s+(?<Origin>\S+)\s*$' ) {

            $ZoneOrigin = $Matches.Origin
            $Records = $Records | Select-Object -Skip 1

        }

        if ( $ZoneOrigin ) {

            $this.Origin = $ZoneOrigin

        } else {
            
            Write-Warning 'Zone did not include an $ORIGIN'

        }

        $this.__InitZone( $Records )
        
    }

    [void] Export( [string]$Path ) {

        if ( $Errors = $this.GetErrors() ) {

            $Errors | ForEach-Object { Write-Warning $_ }

            Write-Error 'Zone Errors Present' -ErrorAction Stop

        }

        $this.ToString() |
            Set-Content -Path $Path

    }

    [List[string]] GetErrors() {

        [List[string]]$Errors = @()

        if ( -not $this.Origin ) {

            $Errors.Add( 'Zone Error - Must contain an $ORIGIN' )

        }

        if ( $this[0].RecordType -ne 'SOA' ) {

            $Errors.Add( 'Zone Error - Must start with SOA record' )

        }

        if ( ( $this | Where-Object RecordType -eq 'SOA' ).Count -lt 1 ) {

            $Errors.Add( 'Zone Error - Missing SOA record' )

        }

        if ( ( $this | Where-Object RecordType -eq 'SOA' ).Count -gt 1 ) {

            $Errors.Add( 'Zone Error - Multiple SOA records' )

        }

        $this |
            Group-Object 'HostName' |
            Where-Object { ( $_.Group.RecordType.Where({ $_ -eq 'CNAME' -or $_ -eq 'TXT' }) | Select-Object -Unique ).Count -gt 1 } |
            ForEach-Object {

                $Errors.Add( "Zone Error - Hostname '$($_.Name)' has conflicting record types, records may not have both a CNAME and a TXT record" )

            }

        $this |
            Where-Object RecordType -eq 'TXT' |
            Group-Object 'HostName' |
            Where-Object { ( $_.Group.TimeToLive | Select-Object -Unique ).Count -gt 1 } |
            ForEach-Object {

                $Errors.Add( "Zone Error - One or more TXT records for hostname '$($_.Name)' with dissimilar TTL values, all values for the same hostname must be the same" )

            }

        $this | ForEach-Object {

            if ( $RecordErrors = $_.GetErrors() ) {

                $RecordIndex = $this.IndexOf( $_ )

                $RecordErrors |
                    ForEach-Object { $Errors.Add( "Record $RecordIndex - $_" ) }

            }

        }

        return $Errors
    
    }

}