---
external help file: BW.Utils.BindZoneFile-help.xml
Module Name: BW.Utils.BindZoneFile
online version:
schema: 2.0.0
---

# New-BindRecord

## SYNOPSIS
Create a new bind record object

## SYNTAX

### FromString (Default)
```
New-BindRecord [-Record] <BindRecord> [<CommonParameters>]
```

### FromParams
```
New-BindRecord -HostName <String> -TimeToLive <Int32> -RecordClass <String> -RecordType <BindRecordType>
 -RecordData <String> [-Comment <String>] [<CommonParameters>]
```

## DESCRIPTION
Create a new bind record object from a string or parameters.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Record = New-BindRecord 'www 600 IN A 127.0.0.1'
```

Create a new record for www.

### Example 2
```powershell
PS C:\> $Record = New-BindRecord -HostName 'www' -TimeToLive 600 -RecordType 'A' -RecordData '127.0.0.1'
```

Create a new record for www.

## PARAMETERS

### -Record
A bind zone formatted record to convert to a record object.

```yaml
Type: BindRecord
Parameter Sets: FromString
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostName
The host name of the record.

```yaml
Type: String
Parameter Sets: FromParams
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeToLive
The TTL of the record.

```yaml
Type: Int32
Parameter Sets: FromParams
Aliases: TTL

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordClass
The record class of the record.

```yaml
Type: String
Parameter Sets: FromParams
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordType
The record type of the record.

```yaml
Type: BindRecordType
Parameter Sets: FromParams
Aliases:
Accepted values: SOA, NS, A, A_AAAA, AAAA, AFSDB, ALL, ANY, CNAME, DHCID, DNAME, DNSKEY, DS, HINFO, ISDN, MB, MD, MF, MG, MINFO, MR, MX, NSEC, NSEC3, NSEC3PARAM, NULL, OPT, PTR, RP, RRSIG, RT, SRV, TXT, UNKNOWN, WINS, WKS, X25

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordData
The record data of the record.

```yaml
Type: String
Parameter Sets: FromParams
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Comment
A commend for the record.

```yaml
Type: String
Parameter Sets: FromParams
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Multiple

## OUTPUTS

### BindRecord

## NOTES

## RELATED LINKS
