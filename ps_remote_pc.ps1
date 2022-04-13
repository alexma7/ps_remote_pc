param ($type, $par_val, $par_check)

#"type - " + $type 
#"par_val - " + $par_val 
#"par_check - " + $par_check 

if (  $null -eq $par_check)
{
    $par_check = 0
}

# Переменные для работы
$path_nircmd = "C:\Program Files\NirCmd\nircmd.exe"
$path_mon = "C:\Program Files\multimonitortool\MultiMonitorTool.exe"
$name_pc_speaker = "Динамики"
$name_receiver_speaker = "DENON-AVAMP"
$close_process = ("*chrome*", "Teams")

# id мониторов
$monitor_left_id = "PCI\VEN_10DE&DEV_1C03&SUBSYS_32831462&REV_A1"
$monitor_right_id = "PCI\VEN_10DE&DEV_1C03&SUBSYS_32831462&REV_A1"
$tv_id = "PCI\VEN_10DE&DEV_1C03&SUBSYS_32831462&REV_A1"
#   

$full_path = if (-not $PSScriptRoot) { [Environment]::GetCommandLineArgs()[0] } else { $PSScriptRoot + "\"+ $MyInvocation.MyCommand.Name}



# выводим изображение на мониторы
if ($type -eq "win_on_monitor")
{
    [Environment]::SetEnvironmentVariable("WHERE_PICTURE", $type, 'User')

    Get-Process -processName  "*openvpn-gui*" | Stop-Process
    & $path_nircmd setdefaultsounddevice $name_pc_speaker 1
    Start-Sleep -Milliseconds 200
    & $path_nircmd setdefaultsounddevice $name_pc_speaker 2
   
    Start-Sleep -Milliseconds 200
    & $path_mon /TurnOn $monitor_left_id
    Start-Sleep -Milliseconds 200
    & $path_mon /TurnOn $monitor_right_id
    Start-Sleep -Milliseconds 200
    & $path_mon /SetPrimary $monitor_right_id
    & $path_mon /disable $tv_id
    Start-Sleep -Milliseconds 500
    & $path_mon /MoveWindow Primary All
}
# выводим изображение на телевизор
elseif ($type -eq "win_on_tv")
{

    [Environment]::SetEnvironmentVariable("WHERE_PICTURE", $type, 'User')

    & $path_mon /enable $tv_id
    Start-Sleep -Milliseconds 1000
    & $path_mon /SetPrimary $tv_id
    Start-Sleep -Milliseconds 1500

    & $path_mon /TurnOff $monitor_left_id
    Start-Sleep -Milliseconds 500
    & $path_mon /TurnOff $monitor_right_id
    Start-Sleep -Milliseconds 500

    & $path_mon /MoveWindow Primary All
    Start-Sleep -Milliseconds 500
    & $path_nircmd setdefaultsounddevice $name_receiver_speaker 1
    & $path_nircmd setdefaultsounddevice $name_receiver_speaker 2

    # Если параметр не равен "chrome", то останавливаем все процессы из массива
    if ($par_check -ne "chrome")
    {
        $close_process | ForEach-Object {
            if(Get-Process -processName  $_ -ErrorAction SilentlyContinue)
            {
                Get-Process -processName  $_ | Stop-Process
            }
        
        }
    }

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
    # выключить громкость
    if ($par_check -eq 0)
    {
        Set-AudioDevice -PlaybackMute 1
    }
    # вкл/откл громкость
    elseif ($par_check -eq 1)
    {
        Set-AudioDevice -PlaybackMute 0
    }
    #устанавливаем громкость из par_val
    elseif ($par_check -eq 2)
    {
        Set-AudioDevice -PlaybackVolume ($par_val)
    }
    #текущая громкость + par_val
    elseif ($par_check -eq 3)
    {
        $vol_now = (get-AudioDevice -PlaybackVolume).split(',')[0].split('%')[0]
        $vol_now = [int]::Parse($vol_now)
        Set-AudioDevice -PlaybackVolume ($vol_now + $par_val)
    }
}
# выключаем мониторы
elseif ($type -eq "off_monitors1")
{
    #& $path_mon /TurnOff $monitor_left_id
    Start-Sleep -Milliseconds 500
    & $path_mon /TurnOff $monitor_right_id
}
# включаем мониторы
elseif ($type -eq "on_monitors")
{
    & $path_mon /enable $monitor_left_id
    Start-Sleep -Milliseconds 500
    & $path_mon /enable $monitor_right_id
}
# выключаем ПК
elseif ($type -eq "off_pc")
{
    Stop-Computer
}

# проверка, где изображение
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
    & $path_mon /TurnOff $monitor_right_id
    New-Item -Name 'file1.txt' -Path 'D:\' 
}




