$ModulePSD1 = Resolve-Path "$PSScriptRoot\..\src\BW.Utils.BindZoneFile\BW.Utils.BindZoneFile.psd1" | Convert-Path
Import-Module $ModulePSD1 -Force -ErrorAction Stop

InModuleScope -ModuleName BW.Utils.BindZoneFile -ScriptBlock {
    
    Describe 'BW.Utils.BindZoneFile' {

        Context 'is module ENUM values' {

            It 'should have the [BindRecordType] defined' {

                { [BindRecordType].GetType() } | Should -Not -Throw

            }

            It 'should have a value UNKNOWN with value 0' {

                [BindRecordType]::UNKNOWN | Should -Be 0
                
            }

            It 'should have a value SOA with value 1' {

                [BindRecordType]::SOA | Should -Be 1
                
            }

            It 'should have a value NS with value 2' {

                [BindRecordType]::NS | Should -Be 2
                
            }

            It 'should have remaining values in alphabetical order' {

                $Names = [bindrecordtype].GetEnumNames() | Select-Object -Skip 3

                $Sorted = $Names | Sort-Object

                $Names.ToString() | Should -BeExactly $Sorted.ToString()

            }

        }

        Context 'is module classes' {

            It 'should have the [BindRecord] class defined' {

                { [BindRecord]::new() } | Should -Not -Throw

            }

            It 'should have the [BindZone] class defined' {

                { [BindZone]::new() } | Should -Not -Throw

            }

        }

        Context 'is importing a zone file' {

            It 'should Import a bind zone file without error' {

                { $Global:__BindZone = Import-BindZone -Path "$PSScriptRoot\contoso-com.zone" } | Should -Not -Throw

            }

            It 'should contain four name servers' {

                $Global:__BindZone | Where-Object RecordType -eq 'NS' | Should -HaveCount 4

            }

            It 'should contain one MX record at index 5' {

                $MxRecord = $Global:__BindZone | Where-Object RecordType -eq 'MX'
                
                $MxRecord | Should -HaveCount 1

                $Global:__BindZone.IndexOf( $MxRecord ) | Should -Be 5

            }

            It 'should contain five unique A records' {

                $ARecord = $Global:__BindZone | Where-Object RecordType -eq 'A'

                $ARecord | Should -HaveCount 5

                $ARecord.RecordData | Select-Object -Unique | Should -HaveCount 5

            }

            It 'should contain two unique TXT records' {

                $TxtRecord = $Global:__BindZone | Where-Object RecordType -eq 'TXT'

                $TxtRecord | Should -HaveCount 2

                $TxtRecord.RecordData | Select-Object -Unique | Should -HaveCount 2

            }

        }

        Context 'is error checking' {

            It 'should have errors' {

                Test-BindZoneHasErrors -Zone $Global:__BindZone -WarningAction SilentlyContinue | Should -Be $true

            }

            It 'should be resolved by setting all TXT record TTLs to 60' {

                { $Global:__BindZone | Where-Object RecordType -eq 'TXT' | Set-BindRecord -TimeToLive 60 } | Should -Not -Throw

                Test-BindZoneHasErrors -Zone $Global:__BindZone -WarningAction SilentlyContinue | Should -Be $false

            }

        }

    }

}