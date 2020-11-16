---
external help file: BW.Utils.BindZoneFile-help.xml
Module Name: BW.Utils.BindZoneFile
online version:
schema: 2.0.0
---

# Export-BindZone

## SYNOPSIS
Export a Bind zone object to a zone file

## SYNTAX

```
Export-BindZone [-Zone] <BindZone> -Path <String> [<CommonParameters>]
```

## DESCRIPTION
Export a Bind zone object to a zone file

## EXAMPLES

### Example 1
```powershell
PS C:\> Export-BindZone -Zone $Zone -Path '.\contoso.com.zone'
```

Exports a Bind zone to a zone file

## PARAMETERS

### -Path
Path to export the zone to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Zone
The zone object to export.

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

### BindZone

## OUTPUTS

### System.Void

## NOTES

## RELATED LINKS
