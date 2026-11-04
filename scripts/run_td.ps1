param([ValidateSet('check','regenerate','reapply','build')][string]$Action='check',
 [string]$TdExe='C:/Anlogic/TD_6.2.1_Engineer_6.2.168.116/bin/td_commands_prompt.exe')
$ErrorActionPreference='Stop'
$taskRoot=Split-Path -Parent $PSScriptRoot
if (!(Test-Path -LiteralPath $TdExe)) { throw "Set -TdExe to the installed TD executable." }
$names=@{check='check_project.tcl';regenerate='regenerate_hidden.tcl';reapply='reapply_display_patch.tcl';build='build_source.tcl'}
$markers=@{check='SUBMISSION_PROJECT_LOAD_COMPLETE';regenerate='SUBMISSION_HIDDEN_BITGEN_COMPLETE';reapply='SUBMISSION_REAPPLY_COMPLETE';build='SUBMISSION_FULL_SOURCE_PNR_COMPLETE'}
$scriptFile=Join-Path $PSScriptRoot $names[$Action]
# No download/program command is included.
Push-Location -LiteralPath $PSScriptRoot
try {
 $nativeLines='exit' | & $TdExe $names[$Action] 2>&1
 $nativeCode=$LASTEXITCODE
 $nativeLines | Write-Output
 $nativeText=$nativeLines -join "`n"
 if ($nativeCode -ne 0 -or $nativeText -match '\bERROR\b' -or $nativeText -notmatch [regex]::Escape($markers[$Action])) {
  throw "TD did not complete the requested action successfully (code $nativeCode)."
 }
} finally { Pop-Location }
