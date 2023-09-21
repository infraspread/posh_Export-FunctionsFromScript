# posh_Export-FunctionsFromScript
Powershell script function export utility
## Usage: 
1)    source this script:
      . .\Export-FunctionsFromScript.ps1
2)    call this function:
      Export-FunctionsFromScript -Script "C:\Users\Username\Powershell Scripts\MySourceScript.ps1" -Output "C:\Users\Username\Powershell Scripts\MyExportedFunctions.ps1"
      If you ommit the output parameter, the exported functions will be saved in a file with the same name as the source script, but with the suffix "_exportedFn.ps1"
3)    call the exported function:
      . .\MyExportedFunctions.ps1
      MyExportedFunction

      Example:
      export-FunctionsFromScript -Script "C:\Users\Infraspread\Desktop\Powershell\MicroFunctions.ps1" -Output "test-exported_functions.ps1"
