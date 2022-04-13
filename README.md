# ps_remote_pc
Скрипт на PowerShell, который переводит изображение на телевизор и обратно, выключает мониторы и включает, также регулирует звук и другие функции.

Для управления звуком надо запустить в PowerShell от админа Install-Module -Name AudioDeviceCmdlets  https://github.com/frgnca/AudioDeviceCmdlets

Для работы нужны программы nircmd и MultiMonitorTool их кидаем в папки соответственно:
- C:\Program Files\NirCmd\nircmd.exe
- C:\Program Files\multimonitortool\MultiMonitorTool.exe

В программе используется 3 параметра:
 ## $type  
  указывает в какой блок скрипта нужно запустить.\
  Список параметров:
  - win_on_monitor - изображение на мониторы
  - win_on_tv - изображение на телевизор
  - set_volume - установить громкость
  - off_monitors1
  - on_monitors


 ## $par_val 
   используется для установки громкости
 ## $par_check
   Список параметров:
   - Запуск программ:
      - chrome
      - steam
      - epic
      - chrome
  - если = 0, то выключить громкость
  - если = 1, то включить громкость
  - если = 2, то устанавливаем громкость из par_val, 
  - если = 3, то текущая громкость + par_val


Создаем ярлык для запуска скрипта с параметрами, через пробел.
C:\other\GIT\ps_remote_pc\ps_remote_pc.exe win_on_monitor


Установка компонента [AudioDeviceCmdlets](https://github.com/frgnca/AudioDeviceCmdlets) в powershell для работы функции set_vol. Запускаем powershell от админа и вводим команду:
```
Install-Module -Name AudioDeviceCmdlets
```