---
external help file: BW.Utils.BindZoneFile-help.xml
Module Name: BW.Utils.BindZoneFile
online version:
schema: 2.0.0
---

# Test-BindZoneHasErrors

## SYNOPSIS
Test a zone

## SYNTAX

### Zone
```
Test-BindZoneHasErrors [-Zone] <BindZone[]> [<CommonParameters>]
```

### Path
```
Test-BindZoneHasErrors [-Path] <String[]> [<CommonParameters>]
```

### LiteralPath
```
Test-BindZoneHasErrors -LiteralPath <String[]> [<CommonParameters>]
```

## DESCRIPTION
Test a zone against common issues

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-BindZoneHasErrors -Path '.\contoso.com.zone'
```

Test the zone contained in the contoso.com.zone file.

### Example 2
```powershell
PS C:\> Test-BindZoneHasErrors $Zone
```

Test the zone object contained in the $Zone variable.

## PARAMETERS

### -LiteralPath
The literal path to the zone file.

```yaml
Type: String[]
Parameter Sets: LiteralPath
Aliases: PSPath

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Path
The path to the zone file.

```yaml
Type: String[]
Parameter Sets: Path
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Zone
The zone object to test.

```yaml
Type: BindZone[]
Parameter Sets: Zone
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

### System.String[]

## OUTPUTS

### System.Boolean

## NOTES

## RELATED LINKS
