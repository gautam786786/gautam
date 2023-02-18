# https://dev.to/azure/test-your-powershell-code-with-pester-4hlc

Install-Module -Name Pester -Force

Describe "A suite" {
    It "my first test" {
      $Value = "Value"
      $Value | Should -Be "Value"
    }
  }