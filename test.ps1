# Получим путь до файла, из exe файла не работает $PSScriptRoot
$path_to_script = 
	if (-not $PSScriptRoot) 
	{  
		Split-Path -Parent (Convert-Path ([environment]::GetCommandLineArgs()[0])) 
	} 
	else 
	{
		$PSScriptRoot 
	}

# Получаем данные из JSON
$json = Get-Content ( $path_to_script + '\ps_remote_pc.json')  
$json = $json -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' 
$json = $json | Out-String | ConvertFrom-Json

# Переменные для работы  $json.path_to_logs
$path_nircmd = $json.path_nircmd
$path_mon = $json.path_mon
$name_pc_speaker = "Динамики"
$name_receiver_speaker = "DENON-AVAMP"
$close_process = ("*chrome*", "Teams")

# id мониторов
$monitor_left_id = $json.monitor_left_id
$monitor_right_id = $json.monitor_right_id
$tv_id = $json.tv_id
$path_mon
$monitor_left_id


    & $path_nircmd setdefaultsounddevice $name_pc_speaker 1
    & $path_nircmd setdefaultsounddevice $name_pc_speaker 2