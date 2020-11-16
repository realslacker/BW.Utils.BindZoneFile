---
external help file: BW.Utils.BindZoneFile-help.xml
Module Name: BW.Utils.BindZoneFile
online version:
schema: 2.0.0
---

# Set-BindRecord

## SYNOPSIS
Modify a record object

## SYNTAX

```
Set-BindRecord [-Record] <BindRecord> [[-HostName] <String>] [[-TimeToLive] <Int32>] [[-RecordClass] <String>]
 [[-RecordType] <BindRecordType>] [[-RecordData] <String>] [[-Comment] <String>] [-PassThru]
 [<CommonParameters>]
```

## DESCRIPTION
Modify a record object

## EXAMPLES

### Example 1
```powershell
PS C:\> $Zone | Where-Object RecordType -eq A | Set-BindRecord -TimeToLive 600
```

Set all A records to have a TTL of 10 minutes.

## PARAMETERS

### -Comment
Modify the record comment.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostName
Modify the record host name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Put modified records on the pipeline.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Record
The record object(s) to modify.

```yaml
Type: BindRecord
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -RecordClass
Modify the record class.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordData
Modify the record data.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RecordType
Modify the record type.

```yaml
Type: BindRecordType
Parameter Sets: (All)
Aliases:
Accepted values: SOA, NS, A, A_AAAA, AAAA, AFSDB, ALL, ANY, CNAME, DHCID, DNAME, DNSKEY, DS, HINFO, ISDN, MB, MD, MF, MG, MINFO, MR, MX, NSEC, NSEC3, NSEC3PARAM, NULL, OPT, PTR, RP, RRSIG, RT, SRV, TXT, UNKNOWN, WINS, WKS, X25

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeToLive
Modify the record TTL

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: TTL

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### BindRecord

## OUTPUTS

### BindRecord

## NOTES

## RELATED LINKS
