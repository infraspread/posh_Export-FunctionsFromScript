# Powershell script function export utility
# Usage: 
# 1)    source this script:
#       . .\Export-FunctionsFromScript.ps1
# 2)    call this function:
#       Export-FunctionsFromScript -Script "C:\Users\Username\Powershell Scripts\MySourceScript.ps1" -Output "C:\Users\Username\Powershell Scripts\MyExportedFunctions.ps1"
#       If you ommit the output parameter, the exported functions will be saved in a file with the same name as the source script, but with the suffix "_exportedFn.ps1"
# 3)    call the exported function:
#       . .\MyExportedFunctions.ps1
#       MyExportedFunction

#       Example:
#       export-FunctionsFromScript -Script "C:\Users\Infraspread\Desktop\Powershell\MicroFunctions.ps1" -Output "test-exported_functions.ps1"

function dashLine {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [string]$MiddleText,
        [Parameter(Mandatory=$false)]
        [ConsoleColor]$ForegroundColor = "White",
        [Parameter(Mandatory=$false)]
        [ConsoleColor]$BackgroundColor = "Black"
    )
    
    $dashLine = "-" * $Host.UI.RawUI.WindowSize.Width
    Write-Host $dashLine -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    if ($MiddleText) {
        $middleLength = $MiddleText.Length+3
        $leftDashLength = ($Host.UI.RawUI.WindowSize.Width - $middleLength) / 2
        $rightDashLength = $Host.UI.RawUI.WindowSize.Width - $middleLength - $leftDashLength
        $leftDash = "-" * $leftDashLength
        $rightDash = "-" * $rightDashLength
        Write-Host "$leftDash $MiddleText $rightDash" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
        Write-Host $dashLine -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }
}

Function export-FunctionsFromScript(){
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Script to export functions from")]
        [string]$Script,
        [Parameter(Mandatory=$false)]
        [string]$Output,
        [Parameter(Mandatory=$false)]
        [Switch]$ConsoleOutput=$false
    )
    
    if (Test-Path $Script) {
        write-host $Script
        Write-Host "Script File found: $Script" -ForegroundColor Green
        
        if ($null -eq $Output) {
            $OutputFileName =$Script+"_exportetFn.ps1"
            $Output = $OutputFileName
        }
        
        [String]$Script:FunctionText=@()
        New-Variable astTokens -Force
        New-Variable astErr -Force
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($Script, [ref]$astTokens, [ref]$astErr)
        $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $true)
        write-host "Found the following $($functions.Count) Functions: "`n -ForegroundColor White
        write-host $Functions.Name -ForegroundColor Green 
        
        if ($ConsoleOutput) {
            $Functions | ForEach-Object { 
                dashLine -MiddleText "Start of Function: $($_.Name)" -ForegroundColor White -BackgroundColor Black
                $_.Extent.Text | write-host -BackgroundColor Black -ForegroundColor Red
                dashLine -MiddleText "End of Function: $($_.Name)" -ForegroundColor White -BackgroundColor Black
            } 
        }
        
        $Script:FunctionText+=$Functions.Extent.Text+"`n`n"
        $Script:FunctionText | Out-File $Output
    } else {
        Write-Host "Script File not found: $Script. Exiting..."
        return
    }
}

if (Test-Path .\test-exported_functions.ps1) {
    Remove-Item .\test-exported_functions.ps1
}


