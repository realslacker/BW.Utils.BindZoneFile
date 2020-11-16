class BindRecord:System.IComparable {

    [string]$HostName

    [ValidateRange( 60, [int]::MaxValue )]
    [System.Nullable[int]]$TimeToLive

    [string]$RecordClass
    
    [System.Nullable[BindRecordType]]$RecordType
    
    [string]$RecordData
    
    [string]$Comment

    static [string[]] $ValidRecordProperties = 'HostName', 'TimeToLive', 'RecordClass', 'RecordType', 'RecordData', 'Comment'

    static [bool] IsValidRecordProperty ( [string] $PropertyName ) {

        return $PropertyName -in [BindRecord]::ValidRecordProperties

    }

    BindRecord () {}

    BindRecord ( [string]$Record ) {
    
        $this.__ParseString( $Record, '' )
    
    }

    BindRecord ( [pscustomobject]$Record ) {

        $this.__InitRecord( $Record )
    
    }

    hidden [void] __ParseString ( [string]$Record, [string]$Origin ) {

        if ( $Record -match '^(?<HostName>\S+)\s+(?<TimeToLive>\d+)\s+(?<RecordClass>\S+)\s+(?<RecordType>\S+)\s+(?<RecordData>"[^"]*"|[^;]+)\s*;?\s*(?<Comment>.*)$' ) {
        
            $this.__InitRecord( [pscustomobject]$Matches )
        
        } elseif ( $Record -match '^;\s*(.*)$' ) {

            $this.Comment = $Matches[1]

        }
    
    }

    hidden [void] __InitRecord ( [pscustomobject] $Record ) {
        
        $Record |
            Get-Member -MemberType NoteProperty |
            Select-Object -ExpandProperty Name |
            Where-Object { [BindRecord]::IsValidRecordProperty( $_ ) -and -not [string]::IsNullOrEmpty( $Record.$_ ) } |
            ForEach-Object {
                
                if ( $Record.$_ -is [string] ) {

                    $this.$_ = ($Record.$_).Trim()

                } else {
                    
                    $this.$_ = $Record.$_

                }
            
            }

        if ( -not $this.RecordClass ) { $this.RecordClass = 'IN' }

    }

    [string] ToString () {
    
        return $this.ToString( '{0}  {1}  {2}  {3}  {4}' )
    
    }

    [string] ToString ( [string]$Format ) {

        return $this.ToString( 0, $Format )

    }

    [string] ToString ( [int]$Index, [string]$Format ) {

        if ( [BindRecord]::HasErrors( $Index, $this ) ) {

            Write-Error 'Record Errors Present' -ErrorAction Stop

        }

        $FormattedRecord = $Format -f $this.HostName, $this.TimeToLive, $this.RecordClass, $this.RecordType, $this.RecordData

        if ( [string]::IsNullOrWhiteSpace( $FormattedRecord ) -and -not [string]::IsNullOrEmpty( $this.Comment ) ) {
            
            return '; ' + $this.Comment.Trim()
        
        } elseif ( -not [string]::IsNullOrEmpty( $this.Comment ) ) {

            return $FormattedRecord.Trim() + ' ; ' + $this.Comment.Trim()

        } else {

            return $FormattedRecord.Trim()

        }
    
    }

    [bool] Equals ( $that ) {

        $IsEqual = $true

        [BindRecord]$that = $that

        $this |
            Get-Member -MemberType Property |
            Select-Object -ExpandProperty Name |
            Where-Object { $this.$_ -ne $that.$_ } |
            Select-Object -First 1 |
            ForEach-Object { $IsEqual = $false }

        return $IsEqual

    }

    [int] CompareTo ( $that ) {

        [BindRecord]$that = $that

        # SOA records are always before
        if ( $this.RecordType -eq 'SOA' -and $that.RecordType -ne 'SOA' ) { return -1 }
        if ( $this.RecordType -ne 'SOA' -and $that.RecordType -eq 'SOA' ) { return 1 }

        # now we sort by host name
        if ( $this.HostName -lt $that.HostName ) { return -1 }
        if ( $this.HostName -gt $that.HostName ) { return 1 }

        # now we sort record types based on the ENUM values
        if ( $this.RecordType -lt $that.RecordType ) { return -1 }
        if ( $this.RecordType -gt $that.RecordType ) { return 1 }

        # now we sort on record data
        if ( $this.RecordData -lt $that.RecordData ) { return -1 }
        if ( $this.RecordData -gt $that.RecordData ) { return 1 }

        # finally we sort on TTL
        if ( $this.TimeToLive -lt $that.TimeToLive ) { return -1 }
        if ( $this.TimeToLive -gt $that.TimeToLive ) { return 1 }

        # if everything is equal then the records are equal
        # we are ignoring comments for the sort
        return 0
    
    }

    static [bool] HasErrors ( [int]$Index, [BindRecord]$Record ) {

        # if all attributes are blank except a comment, then it's a valid comment
        if ( [string]::IsNullOrWhiteSpace( $Record.HostName     ) -and 
             [string]::IsNullOrWhiteSpace( $Record.TimeToLive   ) -and 
             [string]::IsNullOrWhiteSpace( $Record.RecordClass  ) -and 
             [string]::IsNullOrWhiteSpace( $Record.RecordType   ) -and 
             [string]::IsNullOrWhiteSpace( $Record.RecordData   ) -and
             -not [string]::IsNullOrWhiteSpace( $Record.Comment ) ) {
                 
                return $false
            
            }

        $ReturnValue = $false

        # if the hostname is not defined then it's invalid
        if ( [string]::IsNullOrWhiteSpace( $Record.HostName ) ) {

            Write-Warning "Record ${Index} - HostName is missing"

            $ReturnValue = $true

        }

        # if the TTL is not defined or less than 60 then it's invalid
        if ( [string]::IsNullOrWhiteSpace( $Record.TimeToLive ) -or [int]$Record.TimeToLive -lt 60 ) {

            Write-Warning "Record ${Index} - TimeToLive is missing or invalid, value must not be less than 60"

            $ReturnValue = $true

        }

        # if the RecordClass is empty it's invalid
        if ( [string]::IsNullOrWhiteSpace( $Record.RecordClass ) ) {

            Write-Warning "Record ${Index} - RecordClass is missing"

            $ReturnValue = $true

        # if the RecordClass is NOT 'IN' we throw a warning
        } elseif ( $Record.RecordClass -ne 'IN' ) {

            Write-Warning "Record ${Index} - RecordClass is not 'IN', please verify that is intentional"

        }

        # if the RecordType is empty it's invalid
        if ( [string]::IsNullOrWhiteSpace( $Record.RecordType ) ) {

            Write-Warning "Record ${Index} - RecordType is missing"

            $ReturnValue = $true

        # if the RecordType is UNKNOWN it's invalid
        } elseif ( $Record.RecordType -eq 'UNKNOWN' -or $Record.RecordType -notin [BindRecordType].GetEnumValues() ) {

            Write-Warning "Record ${Index} - RecordType is invalid"

            $ReturnValue = $true

        }

        # if the RecordData is empty it's invalid
        if ( [string]::IsNullOrWhiteSpace( $Record.RecordData ) ) {

            Write-Warning "Record ${Index} - RecordData is missing"

            $ReturnValue = $true

        }

        # if the RecordType is TXT and the RecordData is not enclosed in double quotes
        # then the value is invalid
        if ( $Record.RecordType -eq 'TXT' -and $Record.RecordData -notmatch '^".*"$' ) {

            Write-Warning "Record ${Index} - RecordType is TXT, RecordData needs to be enclosed in double quotes"

            $ReturnValue = $true

        }

        # if RecordData is enclosed in quotes, and contains unescaped quotes the data is invalid
        if ( $Record.RecordData -match '^".*"$' -and $Record.RecordData -replace '^"(.*)"$', '$1' -match '(?<!\\)"' ) {

            Write-Warning "Record ${Index} - RecordData is enclosed in quotes and contains unescaped quotes"

            $ReturnValue = $true

        }

        return $ReturnValue
    }

}