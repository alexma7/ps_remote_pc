param ($type, $par_val, $par_check)


#"type - " + $type 
#"par_val - " + $par_val 
#"par_check - " + $par_check 

# ��������� �� 1, ���� ������ , �� ��������
if (  $null -eq $par_check)
{
    $par_check = 0
}

# �� HA �������� ����� �� 0-1, �����, ���� ��� ������������� � ���������
if ( $par_val -lt 1.0)
{
    $par_val = [math]::Round([float]$par_val * 100, 0)
}

# ������� ��������� � ������ 
$date_begin = Get-Date -Format "dd/MM/yyyy HH:mm"
$date_begin + ": type=" + $type + " par_val=" + $par_val + " par_check=" + $par_check  | Out-File C:\other\GIT\ps_remote_pc\logs.txt -append

# ������� ���� �� �����, �� exe ����� �� �������� $PSScriptRoot
$path_to_script = 
	if (-not $PSScriptRoot) 
	{  
		Split-Path -Parent (Convert-Path ([environment]::GetCommandLineArgs()[0])) 
	} 
	else 
	{
		$PSScriptRoot 
	}
$path_to_script
# �������� ������ �� JSON
$json = Get-Content ( $path_to_script + '\ps_remote_pc.json')  
$json = $json -replace '(?m)(?<=^([^"]|"[^"]*")*)//.*' -replace '(?ms)/\*.*?\*/' 
$json = $json | Out-String | ConvertFrom-Json


# ���������� ��� ������  $json.path_to_logs
$path_nircmd = $json.path_nircmd
$path_mon = $json.path_mon
$path_ds4windows = $json.path_ds4windows
$path_yuzu = $json.path_yuzu

# ���������� ��� ������
$path_free_file_sync = $json.path_free_file_sync
$path_save_local_sync = $json.path_save_local_sync

# $close_chrome = $json.close_chrome

$name_pc_speaker = "Speakers"  # ���� ����� �������, �� ����� ������ ��������
$name_receiver_speaker = "DENON-AVAMP"
# $close_process = ("*chrome*", "Teams")


# id ���������
$monitor_left_sname = $json.monitor_left_sname
$monitor_right_sname = $json.monitor_right_sname
$tv_sname = $json.tv_sname
# ������������ � �������

$full_path = if (-not $PSScriptRoot) { [Environment]::GetCommandLineArgs()[0] } else { $PSScriptRoot + "\"+ $MyInvocation.MyCommand.Name}



# ������� ����������� �� ��������
if ($type -eq "win_on_monitor")
{
    # [Environment]::SetEnvironmentVariable("WHERE_PICTURE", $type, 'User')

    Get-Process -processName  "*openvpn-gui*" | Stop-Process
    & $path_nircmd setdefaultsounddevice $name_pc_speaker 1
    # Start-Sleep -Milliseconds 200
    & $path_nircmd setdefaultsounddevice $name_pc_speaker 2
   
    # Start-Sleep -Milliseconds 200
    & $path_mon /TurnOn $monitor_left_sname
    # Start-Sleep -Milliseconds 200
    & $path_mon /TurnOn $monitor_right_sname
    # Start-Sleep -Milliseconds 200
    # & $path_mon /SetPrimary "Name=" + $monitor_right_sname
    & $path_mon /SetMonitors "Name=$monitor_left_sname Width=1920 Height=1080 PositionX=0 PositionY=0 " "Name=$monitor_right_sname Width=1920 Height=1080 PositionX=0 PositionY=0 " 
    Start-Sleep -Milliseconds 100
    & $path_mon /SetPrimary $monitor_right_sname
    Start-Sleep -Milliseconds 500
    & $path_mon /disable $tv_sname
    Start-Sleep -Milliseconds 500
    & $path_mon /MoveWindow Primary All 
}
# ������� ����������� �� ���������
elseif ($type -eq "win_on_tv")
{

    # [Environment]::SetEnvironmentVariable("WHERE_PICTURE", $type, 'User')

    & $path_mon /enable $tv_sname
    Start-Sleep -Milliseconds 500
    & $path_mon /SetMonitors "Name=$tv_sname Width=3840 Height=2160 PositionX=0 PositionY=0" "Name=$monitor_left_sname Width=1920 Height=1080 PositionX=3840 PositionY=0 " "Name=$monitor_right_sname Width=1920 Height=1080 PositionX=5760 PositionY=0 " 
    Start-Sleep -Milliseconds 500
    & $path_mon /SetPrimary $tv_sname
    Save-Help
    Start-Sleep -Milliseconds 500
    & $path_mon /TurnOff $monitor_left_sname
    Start-Sleep -Milliseconds 50
    & $path_mon /TurnOff $monitor_right_sname
    tart-Sleep -Milliseconds 500
    & $path_mon /MoveWindow Primary All 
    # Start-Sleep -Milliseconds 500

    
    # Start-Sleep -Milliseconds 500
    & $path_nircmd setdefaultsounddevice $name_receiver_speaker 1
    & $path_nircmd setdefaultsounddevice $name_receiver_speaker 2

    # ���� �������� �� ����� "chrome", �� ������������� ��� �������� �� �������
    # if (($par_check -ne "chrome") -and ($close_chrome -ne "1"))
    # {
    #     $close_process | ForEach-Object {
    #         if(Get-Process -processName  $_ -ErrorAction SilentlyContinue)
    #         {
    #             Get-Process -processName  $_ | Stop-Process
    #         }
        
    #     }
    # }

    if ($par_check -eq "steam")
    {
        & "J:\Program Files (x86)\Steam\Steam.exe " -start steam://open/bigpicture
    }
    elseif ($par_check -eq "epic")
    {
        & "C:\Program Files (x86)\Epic Games\Launcher\Portal\Binaries\Win32\EpicGamesLauncher.exe"    
    }
    elseif ($par_check -eq "chrome")    
    {
        & "C:\Program Files\Google\Chrome\Application\chrome.exe"
    }
}
elseif ($type -eq "set_volume")
{
    #[Environment]::SetEnvironmentVariable("WHERE_PICTURE", $type, 'User')
    # ��������� ���������
    if ($par_check -eq 0)
    {
        Set-AudioDevice -PlaybackMute 1
    }
    # ���/���� ���������
    elseif ($par_check -eq 1)
    {
        Set-AudioDevice -PlaybackMute 0
    }
    #������������� ��������� �� par_val
    elseif ($par_check -eq 2)
    {
        Set-AudioDevice -PlaybackVolume ($par_val)
    }
    #������� ��������� + par_val
    elseif ($par_check -eq 3)
    {
        $vol_now = (get-AudioDevice -PlaybackVolume).split(',')[0].split('%')[0]
        $vol_now = [int]::Parse($vol_now)
        Set-AudioDevice -PlaybackVolume ($vol_now + $par_val)
    }
    elseif ($par_check -eq 4)
    {
        Set-AudioDevice -PlaybackMuteToggle 
    }
}
# ��������� ��������
elseif ($type -eq "off_monitors1")
{
    #& $path_mon /TurnOff $monitor_left_sname
    Start-Sleep -Milliseconds 500
    & $path_mon /TurnOff "Name=" + $monitor_right_sname
}
# �������� ��������
elseif ($type -eq "on_monitors")
{
    & $path_mon /enable "Name=" + $monitor_left_sname
    Start-Sleep -Milliseconds 500
    & $path_mon /enable "Name=" + $monitor_right_sname
}
# ��������� ��
elseif ($type -eq "off_pc")
{
    Stop-Computer
}

# ��������, ��� �����������
elseif ($type -eq "check_TV")
{
    if ([Environment]::GetEnvironmentVariable('WHERE_PICTURE', 'User') -eq "win_on_tv")
    {
        & $full_path win_on_monitor
    }
    
}

elseif ($type -eq "off_monitors3")
{
    New-Item -Name 'file.txt' -Path 'D:\' 
    Start-Sleep -Milliseconds 500
    & $path_mon /TurnOff "Name=" + $monitor_right_sname
    New-Item -Name 'file1.txt' -Path 'D:\' 
}

# ������� �� ����� ����� ������ ���� � ����������� �� �����
elseif ($type -eq "delete_file_dlna")
{
    Get-ChildItem  $json.path_hdd_dlna  | Sort-Object name | Select-Object -first 1 | Remove-Item
}


# ������� ����������� �� ��������
if ($type -eq "yuzu")
{
    # �������� DS4Windows
    & $path_ds4windows
    
    # �������� YUZU
    if(-not(Get-Process -processName  "YUZU" -ErrorAction SilentlyContinue))
    {
        & $path_yuzu
    }
    
}

# ���������� �� � ��������� ����������� � ������� ���������� �� ��������� ����
if ($type -eq "turn_off_local_bak")
{
    # ������ ����� ����������
    & $path_free_file_sync $path_save_local_sync

    # ��������� ����������� �� ��������
    & "C:\other\GIT\ps_remote_pc\ps_remote_pc.exe" win_on_monitor

    # ��������� ������� FreeFileSync, ���� �� ������, �� ����, ���� �� ���������
    Do {
        $FFSbusy = Get-Process -Name FreeFileSync -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name
        If ($FFSbusy) {
            Start-Sleep -Seconds 5
            "Wait exit FreeFileSync..."
        }
    } Until (!$FFSbusy)
    

    # ����� ������ ��������� ���������
    # New-Item -ItemType "file" -Path "D:\test.txt" # ��� �������
    Stop-Computer
    
    
    
}





