---
external help file: BW.Utils.BindZoneFile-help.xml
Module Name: BW.Utils.BindZoneFile
online version:
schema: 2.0.0
---

# Remove-BindRecordFromZone

## SYNOPSIS
Remove a record object from a zone object

## SYNTAX

```
Remove-BindRecordFromZone [-BindZone] <BindZone> [-BindRecord] <BindRecord> [<CommonParameters>]
```

## DESCRIPTION
Remove a record object from a zone object

## EXAMPLES

### Example 1
```powershell
PS C:\> $Zone | Where-Object RecordType -eq MX | Remove-BindRecordFromZone -BindZone $Zone
```

Remove all MX records from the zone object $Zone.

## PARAMETERS

### -BindZone
The zone object to modify.

```yaml
Type: BindZone
Parameter Sets: (All)
Aliases: Zone

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BindRecord
The record object(s) to remove from the zone.

```yaml
Type: BindRecord
Parameter Sets: (All)
Aliases: Record

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### BindRecord

## OUTPUTS

### System.Void

## NOTES

## RELATED LINKS
