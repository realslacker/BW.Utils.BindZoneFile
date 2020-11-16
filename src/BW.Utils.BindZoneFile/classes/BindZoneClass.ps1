using namespace System.Collections.Generic

class BindZone:List[BindRecord] {

    [ValidateNotNullOrEmpty()]
    [string]$Origin
    [List[string]]$RecordOrder
    [List[string]]$SortOrder

    BindZone () {}

    BindZone ( [string]$Path ) {

        $Records = Resolve-Path $Path | Get-Content

        if ( $Records[0] -match '^\$ORIGIN\s+(?<Origin>\S+)\s*$' ) {

            $this.Origin = $Matches.Origin

            $Records = $Records | Select-Object -Skip 1

        }

        if ( -not $this.Origin ) {

            Write-Warning 'Zone did not include an $ORIGIN'

        }

        $this.__AddRecords( $Records )
    
    }

    BindZone ( [string[]]$Records ) {
    
        $this.__AddRecords( $Records )
    
    }

    BindZone ( [string[]]$Records, [string]$Origin ) {
    
        $this.Origin = $Origin
        $this.__AddRecords( $Records )
    
    }
    
    BindZone ( [BindRecord[]]$Records, [string]$Origin ) {

        $this.Origin = $Origin
        $this.__AddRecords( $Records )

    }

    hidden [void] __AddRecords ( [BindRecord[]]$Records ) {

        $this.AddRange( $Records )
    
    }

    [void] SortZone ( [string[]]$RecordOrder, [string[]] $SortOrder ) {

        $this.Sort()

    }

    [string] ToString () {

        if ( [BindZone]::HasErrors( $this ) ) {

            Write-Error 'Zone Errors Present' -ErrorAction Stop

        }

        # figure out column widths
        $ColumnWidths = @{
            HostName    = ( [string[]]$this.HostName    | Measure-Object -Maximum -Property Length ).Maximum
            TimeToLive  = ( [string[]]$this.TimeToLive  | Measure-Object -Maximum -Property Length ).Maximum
            RecordClass = ( [string[]]$this.RecordClass | Measure-Object -Maximum -Property Length ).Maximum
            RecordType  = ( [string[]]$this.RecordType  | Measure-Object -Maximum -Property Length ).Maximum
            RecordData  = ( [string[]]$this.RecordData  | Measure-Object -Maximum -Property Length ).Maximum
        }
    
        $Return = [System.Collections.Generic.List[string]]::new()

        if ( $this.Origin ) {
            
            $Return.Add( '$ORIGIN ' + $this.Origin )

        }

        $Format = "{0,-$($ColumnWidths.HostName)}  {1,$($ColumnWidths.TimeToLive)}  {2,-$($ColumnWidths.RecordClass)}  {3,-$($ColumnWidths.RecordType)}  {4}"

        $this |
            ForEach-Object { $Return.Add( $_.ToString( $this.IndexOf($_), $Format ) ) }

        return $Return -join "`r`n"
    
    }

    [void] SaveAs ( [string]$Path ) {

        $this.ToString() |
            Set-Content -Path $Path

    }

    static [bool] HasErrors ( [BindZone]$Zone ) {

        $HasErrors = $false

        if ( -not $Zone.Origin ) {

            Write-Warning 'Zone does not contain an $ORIGIN'

            $HasErrors = $true

        }

        if ( $Zone[0].RecordType -ne 'SOA' ) {

            Write-Warning 'Zone does not start with SOA record'

            $HasErrors = $true

        }

        if ( ( $Zone | Where-Object RecordType -eq 'SOA' ).Count -lt 1 ) {

            Write-Warning 'Zone does not contain an SOA record'

            $HasErrors = $true

        }

        if ( ( $Zone | Where-Object RecordType -eq 'SOA' ).Count -gt 1 ) {

            Write-Warning 'Zone contains more than one SOA record'

            $HasErrors = $true

        }

        if ( $Zone | Where-Object RecordType -eq 'TXT' | Group-Object 'HostName' | Where-Object { ( $_.Group.TimeToLive | Select-Object -Unique ).Count -gt 1 } ) {

            Write-Warning 'Zone contains one or more TXT records with dissimilar TTL values, all TTL values at the same level must match for TXT records'

            $HasErrors = $true

        }

        return $HasErrors

    }

}