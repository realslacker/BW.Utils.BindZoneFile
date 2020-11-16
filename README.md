# BW.Utils.BindZoneFile
Read and write Bind zone files in pure PowerShell

## Installing
This module can be installed directly from the gallery.

```powershell
PS> Install-Module BW.Utils.BindZoneFile -Force
```

## Example Usage

### Example Zone

```
$ORIGIN @
@   3600  IN  SOA  ns1-205.azure-dns.com. azuredns-hostmaster.microsoft.com. 1 3600 300 2419200 300
@  43200  IN  NS   ns3-205.azure-dns.org.
@  43200  IN  NS   ns4-205.azure-dns.info.
@  43200  IN  NS   ns2-205.azure-dns.net.
@  43200  IN  NS   ns1-205.azure-dns.com.
```

### Importing a Zone File

```powershell
PS> $Zone = Import-BindZone .\contoso-com.zone

PS> $Zone | ft

HostName TimeToLive RecordClass RecordType RecordData                                                                       Comment
-------- ---------- ----------- ---------- ----------                                                                       -------
@              3600 IN                 SOA ns1-205.azure-dns.com. azuredns-hostmaster.microsoft.com. 1 3600 300 2419200 300        
@             43200 IN                  NS ns3-205.azure-dns.org.                                                                  
@             43200 IN                  NS ns4-205.azure-dns.info.                                                                 
@             43200 IN                  NS ns2-205.azure-dns.net.                                                                  
@             43200 IN                  NS ns1-205.azure-dns.com. 

```

### Adding Records

```powershell
# using parameters
PS> New-BindRecord -HostName '@' -TimeToLive 3600 -RecordClass IN -RecordType A -RecordData '40.76.4.15' -BindZone $Zone

PS> New-BindRecord -HostName '@' -TimeToLive 3600 -RecordClass IN -RecordType A -RecordData '40.112.72.205' -BindZone $Zone

PS> New-BindRecord -HostName '@' -TimeToLive 3600 -RecordClass IN -RecordType A -RecordData '40.113.200.201' -BindZone $Zone

# using bind format, note that we can pass bind format directly on the pipeline
PS> '@ 3600 IN A 104.215.148.63', '@ 3600 IN A 13.77.161.179' | New-BindRecord -BindZone $Zone

PS> $Zone | ft

HostName TimeToLive RecordClass RecordType RecordData                                                                       Comment
-------- ---------- ----------- ---------- ----------                                                                       -------
@              3600 IN                 SOA ns1-205.azure-dns.com. azuredns-hostmaster.microsoft.com. 1 3600 300 2419200 300        
@             43200 IN                  NS ns3-205.azure-dns.org.                                                                  
@             43200 IN                  NS ns4-205.azure-dns.info.                                                                 
@             43200 IN                  NS ns2-205.azure-dns.net.                                                                  
@             43200 IN                  NS ns1-205.azure-dns.com.                                                                  
@              3600 IN                   A 40.76.4.15                                                                              
@              3600 IN                   A 40.112.72.205                                                                           
@              3600 IN                   A 40.113.200.201                                                                          
@              3600 IN                   A 104.215.148.63                                                                          
@              3600 IN                   A 13.77.161.179
```

### MX Records (Records With Spaces)
Note that the data section is not validated at this time.

```powershell
PS> $MxRecord = New-BindRecord '@ 3600 IN MX 10 contoso-com.mail.protection.outlook.com. ; using Office 365'

PS> $MxRecord

HostName    : @
TimeToLive  : 3600
RecordClass : IN
RecordType  : MX
RecordData  : 10 contoso-com.mail.protection.outlook.com.
Comment     : using Office 365
```

Note that the comment is parsed. Multi-line comments are not supported.

Here we are inserting the new MX record after the last NS record...

```powershell
PS> $LastNSRecord = $Zone | Where-Object RecordType -eq 'NS' | Select-Object -Last 1

PS> Add-BindRecordToZone -Zone $Zone -Record $MxRecord -After $LastNSRecord

PS> $Zone | ft

HostName TimeToLive RecordClass RecordType RecordData                                                                       Comment         
-------- ---------- ----------- ---------- ----------                                                                       -------         
@              3600 IN                 SOA ns1-205.azure-dns.com. azuredns-hostmaster.microsoft.com. 1 3600 300 2419200 300                 
@             43200 IN                  NS ns3-205.azure-dns.org.                                                                           
@             43200 IN                  NS ns4-205.azure-dns.info.                                                                          
@             43200 IN                  NS ns2-205.azure-dns.net.                                                                           
@             43200 IN                  NS ns1-205.azure-dns.com.                                                                           
@              3600 IN                  MX 10 contoso-com.mail.protection.outlook.com.                                      using Office 365
@              3600 IN                   A 40.76.4.15                                                                                       
@              3600 IN                   A 40.112.72.205                                                                                    
@              3600 IN                   A 40.113.200.201                                                                                   
@              3600 IN                   A 104.215.148.63                                                                                   
@              3600 IN                   A 13.77.161.179
```

### Adding TXT Records
First let's add the MS verification record...

```powershell
PS> New-BindRecord '@ 3600 IN TXT "MS=ms47806392" ; Microsoft verification for Office 365' -BindZone $Zone

PS> $Zone | Where-Object RecordType -eq 'TXT' | ft

HostName TimeToLive RecordClass RecordType RecordData      Comment                              
-------- ---------- ----------- ---------- ----------      -------                              
@              3600 IN                 TXT "MS=ms47806392" Microsoft verification for Office 365
```

What happens if we add a record with a different TTL on the same domain?

```powershell
PS> New-BindRecord -HostName '@' -TimeToLive 600 -RecordClass IN -RecordType TXT -RecordData '"v=spf1 include:spf.protection.outlook.com -all"' -BindZone $Zone

PS> $Zone | Where-Object RecordType -eq 'TXT' | ft

HostName TimeToLive RecordClass RecordType RecordData                                       Comment                              
-------- ---------- ----------- ---------- ----------                                       -------                              
@              3600 IN                 TXT "MS=ms47806392"                                  Microsoft verification for Office 365
@               600 IN                 TXT "v=spf1 include:spf.protection.outlook.com -all"
```

As you can see it allows you to add an invalid TXT record, but if you try to test it...

```powershell
PS> Test-BindZone -Zone $Zone

WARNING: Zone contains one or more TXT records with dissimilar TTL values, all TTL values at the same level must match for TXT records
True
```

### Exporting a Zone File

If you try to export a zone file with errors you will get an exception...

```powershell
PS> Export-BindZone -Zone $Zone -Path .\contoso-com.zone

WARNING: Zone contains one or more TXT records with dissimilar TTL values, all TTL values at the same level must match for TXT records
Zone Errors Present
At line:1 char:1
+ Export-BindZone -Zone $Zone -Path .\contoso-com.zone
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException
```

First, correct any errors...

```powershell
PS> $Zone | Where-Object { $_.HostName -eq '@' -and $_.RecordType -eq 'TXT' } | Set-BindRecord -TimeToLive 3600

PS> $Zone | Where-Object RecordType -eq 'TXT' | ft

HostName TimeToLive RecordClass RecordType RecordData                                       Comment                              
-------- ---------- ----------- ---------- ----------                                       -------                              
@              3600 IN                 TXT "MS=ms47806392"                                  Microsoft verification for Office 365
@              3600 IN                 TXT "v=spf1 include:spf.protection.outlook.com -all"
```

Then export the zone

```powershell
PS> Export-BindZone -Zone $Zone -Path .\contoso-com.zone
```

The resulting zone file

```
$ORIGIN contoso.com.
@   3600  IN  SOA  ns1-205.azure-dns.com. azuredns-hostmaster.microsoft.com. 1 3600 300 2419200 300
@  43200  IN  NS   ns3-205.azure-dns.org.
@  43200  IN  NS   ns4-205.azure-dns.info.
@  43200  IN  NS   ns2-205.azure-dns.net.
@  43200  IN  NS   ns1-205.azure-dns.com.
@   3600  IN  MX   10 contoso-com.mail.protection.outlook.com. ; using Office 365
@   3600  IN  A    40.76.4.15
@   3600  IN  A    40.112.72.205
@   3600  IN  A    40.113.200.201
@   3600  IN  A    104.215.148.63
@   3600  IN  A    13.77.161.179
@   3600  IN  TXT  "MS=ms47806392" ; Microsoft verification for Office 365
@   3600  IN  TXT  "v=spf1 include:spf.protection.outlook.com -all"
```

### Sorting a Zone
You can easily sort a zone file

```powershell
PS> Invoke-BindZoneSort -Zone $Zone
```

You can also use the builtin Sort method

```powershell
PS> $Zone.Sort()
```

This will move the SOA and NS records to the top of each subdomain and sort the remaining records by HostName, RecordType, and RecordData.

### Cleaning Up Zone Files
If you want to bulk reformat and sort zones...

```powershell
PS> $ZoneFiles = Get-ChildItem -Path .\path\to\zones\ -Filter *.zone

PS> $ZoneFiles | ForEach-Object { $Zone = $_ | Import-BindZone; Invoke-BindZoneSort -Zone $Zone; Export-BindZone -Zone $Zone -Path $_ }
```
