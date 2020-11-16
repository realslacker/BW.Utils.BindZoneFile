---
external help file: BW.Utils.BindZoneFile-help.xml
Module Name: BW.Utils.BindZoneFile
online version:
schema: 2.0.0
---

# Invoke-BindZoneSort

## SYNOPSIS
Invoke the Sort method on the BindZone object

## SYNTAX

```
Invoke-BindZoneSort [-Zone] <BindZone> [<CommonParameters>]
```

## DESCRIPTION
Invoke the Sort method on the BindZone object. This cmdlet exists just to make sorting more discoverable.
You can also just call $Zone.Sort() for the same result.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-BindZoneSort -Zone $Zone
```

Sort the zone object passed.

## PARAMETERS

### -Zone
The zone object to sort.

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
