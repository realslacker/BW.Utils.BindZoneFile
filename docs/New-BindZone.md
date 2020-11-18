---
external help file: BW.Utils.BindZoneFile-help.xml
Module Name: BW.Utils.BindZoneFile
online version:
schema: 2.0.0
---

# New-BindZone

## SYNOPSIS
Create a bind zone object

## SYNTAX

```
New-BindZone [-Origin] <String> [[-BindRecords] <BindRecord[]>] [<CommonParameters>]
```

## DESCRIPTION
Create a bind zone object

## EXAMPLES

### Example 1
```powershell
PS C:\> $Zone = New-BindZone -Origin 'contoso.com.'
```

Create a new zone object for contoso.com.

## PARAMETERS

### -Origin
The zone origin for the zone object.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BindRecords
The bind record objects to append to the zone.

```yaml
Type: BindRecord[]
Parameter Sets: (All)
Aliases: Records

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### BindZone

## NOTES

## RELATED LINKS
