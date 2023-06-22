using namespace System.Collections.Generic

enum BindRecordType {
    UNKNOWN
    SOA
    NS
    A
    A_AAAA
    AAAA
    AFSDB
    ALL
    ANY
    CAA
    CNAME
    DHCID
    DNAME
    DNSKEY
    DS
    HINFO
    ISDN
    MB
    MD
    MF
    MG
    MINFO
    MR
    MX
    NSEC
    NSEC3
    NSEC3PARAM
    NULL
    OPT
    PTR
    RP
    RRSIG
    RT
    SRV
    TXT
    WINS
    WKS
    X25
}

enum BindRecordStatus {
    Disabled = 0
    Enabled  = 1
}

class BindRecord:IComparable {

    [string]$HostName

    [ValidateRange( 60, [int]::MaxValue )]
    [System.Nullable[int]]$TimeToLive

    [string]$RecordClass
    
    [System.Nullable[BindRecordType]]$RecordType
    
    [string]$RecordData
    
    [string]$Comment

    [BindRecordStatus]$Status = [BindRecordStatus]::Enabled

    BindRecord () {

        $this.__InitObject()
    }

    BindRecord ( [string]$Record ) {

        $this.__InitObject()

        if ( $Record -match '^(?<Enabled>;+\s*)?(?<HostName>\S+)\s+(?<TimeToLive>\d+)\s+(?<RecordClass>\S+)\s+(?<RecordType>\S+)\s+(?<RecordData>"[^"]*"|[^;]+)\s*;?\s*(?<Comment>.*)$' ) {

            $Matches.Status = [string]::IsNullOrEmpty($Matches.Enabled) -as [int]
        
            $this.__InitRecord( [pscustomobject]$Matches )
        
        } elseif ( $Record -match '^;\s*(.*)$' ) {

            $this.Comment = $Matches[1]

        }
    
    }

    BindRecord ( [pscustomobject]$Record ) {

        $this.__InitObject()

        $this.__InitRecord( $Record )
    
    }

    hidden [void] __InitObject () {

        [string[]]$DefaultProperties = 'HostName', 'TimeToLive', 'RecordClass', 'RecordType', 'RecordData', 'Comment', 'Status'

        $DefaultDisplayPropertySet = [System.Management.Automation.PSPropertySet]::new( 'DefaultDisplayPropertySet', $DefaultProperties )

        $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]$DefaultDisplayPropertySet

        $this | Add-Member -MemberType MemberSet -Name 'PSStandardMembers' -Value $PSStandardMembers
    
    }

    hidden [void] __InitRecord ( [pscustomobject] $Record ) {

        $ValidProperties = ( $this | Get-Member -MemberType Property, ScriptProperty ).Name

        $Record.
            PSObject.
            Members.
            Where({
                $_.MemberType -eq 'NoteProperty' -and
                $_.Name -in $ValidProperties -and
                -not [string]::IsNullOrEmpty( $_.Value )
            }).
            Foreach({
                $this.($_.Name) = ([string]$_.Value).Trim()
            })

        if ( -not $this.RecordClass ) {
            $this.RecordClass = 'IN'
        }

    }

    [string] ToString () {
    
        return $this.ToString( '{5}{0}  {1}  {2}  {3}  {4}' )
    
    }

    [string] ToString ( [string]$Format ) {

        $FormattedRecord = $Format -f $this.HostName, $this.TimeToLive, $this.RecordClass.ToUpper(), $this.RecordType, $this.RecordData, (';;','')[$this.Status]

        if ( [string]::IsNullOrWhiteSpace( $FormattedRecord ) -and -not [string]::IsNullOrWhiteSpace( $this.Comment ) ) {
            
            return '; ' + $this.Comment.Trim()
        
        } elseif ( -not [string]::IsNullOrWhiteSpace( $this.Comment ) ) {

            return $FormattedRecord.Trim() + ' ; ' + $this.Comment.Trim()

        } else {

            return $FormattedRecord.Trim()

        }
    
    }

    [bool] Equals ( $that ) {

        $IsEqual = $true

        [BindRecord]$that = $that

        $this.
            PSObject.
            Members.
            Where({
                $_.MemberType -eq 'Property' -and
                $_.Name -ne 'Comment' -and
                [string]::Compare( $_.Value, $that.($_.Name), [StringComparison]::Ordinal ) -ne 0
            }).
            ForEach({
                Write-Verbose ( 'Property {0} is not equal.' -f $_.Name )
                $IsEqual = $false
            })

        return $IsEqual

    }

    [int] CompareTo ( $that ) {

        [BindRecord]$that = $that

        # SOA records are always before
        if ( $this.RecordType -eq 'SOA' -and $that.RecordType -ne 'SOA' ) { return -1 }
        if ( $this.RecordType -ne 'SOA' -and $that.RecordType -eq 'SOA' ) { return 1 }

        # @ records are always first
        if ( $this.HostName -eq '@' -and $that.HostName -ne '@' ) { return -1 }
        if ( $this.HostName -ne '@' -and $that.HostName -eq '@' ) { return 1 }

        # * records are always next
        if ( $this.HostName -eq '*' -and $that.HostName -ne '*' ) { return -1 }
        if ( $this.HostName -ne '*' -and $that.HostName -eq '*' ) { return 1 }
        
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

    [List[string]] GetErrors() {

        [List[string]]$Errors = @()

        # if all attributes are blank except a comment, then it's a valid comment
        if ( [string]::IsNullOrEmpty( $this.HostName ) -and 
            $null -eq $this.TimeToLive -and 
            [string]::IsNullOrEmpty( $this.RecordClass ) -and 
            $null -eq $this.RecordType -and 
            [string]::IsNullOrEmpty( $this.RecordData ) -and
            -not [string]::IsNullOrEmpty( $this.Comment ) ) {

                return $Errors
            
            }

        # if the hostname is not defined then it's invalid
        if ( [string]::IsNullOrEmpty( $this.HostName ) ) {

            $Errors.Add( 'HostName is missing' )

        }

        # if the TTL is not defined or less than 60 then it's invalid
        if ( [string]::IsNullOrEmpty( $this.TimeToLive ) -or [int]$this.TimeToLive -lt 60 ) {

            $Errors.Add( 'TimeToLive is missing or invalid, value must not be less than 60' )

        }

        # if the RecordClass is empty it's invalid
        if ( [string]::IsNullOrEmpty( $this.RecordClass ) ) {

            $Errors.Add( 'RecordClass is missing' )

        }

        # if the RecordType is empty it's invalid
        if ( [string]::IsNullOrEmpty( $this.RecordType ) ) {

            $Errors.Add( 'RecordType is missing' )

        # if the RecordType is UNKNOWN it's invalid
        } elseif ( $this.RecordType -eq 'UNKNOWN' -or $this.RecordType -notin [BindRecordType].GetEnumValues() ) {

            $Errors.Add( 'RecordType is invalid' )

        }

        # if the RecordData is empty it's invalid
        if ( [string]::IsNullOrEmpty( $this.RecordData ) ) {

            $Errors.Add( 'RecordData is missing' )

        }

        # if the RecordType is CAA and the RecordData is not properly formatted then
        # the record is invalid
        if ( $this.RecordType -eq 'CAA' -and $this.RecordData -notmatch '^(\d|[1-9]\d|1[0-1]\d|12[0-8])\s+(issue|issuewild|iodef)\s+"[^"]+"$' ) {

            $Errors.Add( 'RecordType is CAA, RecordData must be formatted as ''<Priority> <PropertyType> "<CAAControl>"''' )
            
        }

        # if the RecordType is TXT and the RecordData is not enclosed in double quotes
        # then the value is invalid
        if ( $this.RecordType -eq 'TXT' -and $this.RecordData -notmatch '^".*"$' ) {

            $Errors.Add( 'RecordType is TXT, RecordData needs to be enclosed in double quotes' )

        }

        # if RecordData is enclosed in quotes, and contains unescaped quotes the data is invalid
        if ( $this.RecordData -match '^".*"$' -and $this.RecordData -replace '^"(.*)"$', '$1' -match '(?<!\\)"' ) {

            $Errors.Add( 'RecordData is enclosed in quotes and contains unescaped quotes' )

        }
        
        return $Errors
    
    }

}