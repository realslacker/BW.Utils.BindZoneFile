---
external help file: BW.Utils.BindZoneFile-help.xml
Module Name: BW.Utils.BindZoneFile
online version:
schema: 2.0.0
---

# Add-BindRecordToZone

## SYNOPSIS
Add a Bind record to a Bind zone object

## SYNTAX

### Default (Default)
```
Add-BindRecordToZone [-Zone] <BindZone> [-Record] <BindRecord[]> [-PassThru] [<CommonParameters>]
```

### After
```
Add-BindRecordToZone [-Zone] <BindZone> [-Record] <BindRecord[]> -After <BindRecord> [-PassThru]
 [<CommonParameters>]
```

### Before
```
Add-BindRecordToZone [-Zone] <BindZone> [-Record] <BindRecord[]> -Before <BindRecord> [-PassThru]
 [<CommonParameters>]
```

### AtIndex
```
Add-BindRecordToZone [-Zone] <BindZone> [-Record] <BindRecord[]> -AtIndex <Int32> [-PassThru]
 [<CommonParameters>]
```

## DESCRIPTION
Add a Bind record to a Bind zone object

## EXAMPLES

### Example 1
```powershell
PS C:\> $Zone = Import-BindZone '.\contoso.com.zone'
PS C:\> Add-BindRecordToZone -Zone $Zone -Record 'www 600 IN A 127.0.0.1'
```

Appends a www record to the end of the zone.

### Example 2
```powershell
PS C:\> $Zone = Import-BindZone '.\contoso.com.zone'
PS C:\> $MxRecord = $Zone | Where-Object RecordType -eq MX | Select-Object -First 1
PS C:\> Add-BindRecordToZone -Zone $Zone -Record 'www 600 IN A 127.0.0.1' -Before $MxRecord
```

Adds a new A record before the first MX record.

## PARAMETERS

### -After
Causes the added record(s) to be inserted after the record supplied to this parameter.

```yaml
Type: BindRecord
Parameter Sets: After
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AtIndex
Causes the added record(s) to be inserted at the index supplied to this parameter.

```yaml
Type: Int32
Parameter Sets: AtIndex
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Before
Causes the added record(s) to be inserted before the record supplied to this parameter.

```yaml
Type: BindRecord
Parameter Sets: Before
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Pass through the record(s) to the pipeline for further manipulation.

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
The record(s) to add to the zone.

```yaml
Type: BindRecord[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Zone
The zone object to modify.

```yaml
Type: BindZone
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### BindRecord[]

## OUTPUTS

### BindRecord[]

## NOTES

## RELATED LINKS
