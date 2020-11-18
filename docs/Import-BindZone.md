---
external help file: BW.Utils.BindZoneFile-help.xml
Module Name: BW.Utils.BindZoneFile
online version:
schema: 2.0.0
---

# Import-BindZone

## SYNOPSIS
Import a Bind zone file to a zone object

## SYNTAX

### Path
```
Import-BindZone [-Path] <String[]> [<CommonParameters>]
```

### LiteralPath
```
Import-BindZone -LiteralPath <String[]> [<CommonParameters>]
```

## DESCRIPTION
Import a Bind zone file to a zone object

## EXAMPLES

### Example 1
```powershell
PS C:\> $Zone = Import-BindZone '.\contoso.com.zone'
```

Import the contoso.com.zone file to a zone object.

## PARAMETERS

### -Path
The literal path to the zone file.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### BindZone[]

## NOTES

## RELATED LINKS
