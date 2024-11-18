@echo off
chcp 65001 >nul
title AppControl Delta

:check_adb
cls
echo =================================================
echo Проверяем наличие ADB.
adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ADB не установлен или не добавлен в PATH.
    echo Установите ADB и добавьте его в переменную PATH.
    echo.
    pause
    exit /b
)

:main_menu
cls
echo ===================================
echo  AppControl Delta / 1.0 / Релиз
echo ===================================
echo [1] Показать все установленные приложения
echo [2] Удалить приложение
echo [3] Трансляция экрана телефона
echo [4] О программе
echo [5] Управление телефоном
echo [6] Выход
echo =======================
set /p choice=Выберите действие: 

if "%choice%"=="1" goto show_apps
if "%choice%"=="2" goto delete_app
if "%choice%"=="3" goto screen_show
if "%choice%"=="4" goto about_prog
if "%choice%"=="5" goto phone_con
if "%choice%"=="6" exit /b

:show_apps
cls
echo Получаем список приложений...
adb shell pm list packages -f > log-of-apps.txt
if %errorlevel% neq 0 (
    echo Не удалось получить список приложений. Убедитесь, что устройство подключено и ADB включён.
    pause
    goto main_menu
)

type log-of-apps.txt
echo =======================
pause
goto main_menu

:delete_app
cls
echo =========================================================================================
set /p package=Введите название пакета приложения для удаления (например, com.android.chrome): 
if "%package%"=="" (
    echo Название пакета не может быть пустым.
    pause
    goto main_menu
)
cls
echo ==========================================================================
echo Удаляем приложение %package%...
adb shell pm uninstall --user 0 %package% >nul 2>&1
if %errorlevel% neq 0 (
    echo Не удалось удалить приложение. Возможно, название пакета указано неверно.
    pause
    goto main_menu
)
echo Приложение %package% успешно удалено.
echo.
pause
goto main_menu

:screen_show
cls
echo ============================================
echo Убедитесь, что на телефоне включён режим отладки.
echo.
set /p choice=Вы готовы? (д/н): 

if "%choice%"=="д" goto scrcpy
if "%choice%"=="н" goto main_menu

:scrcpy
cd /d "C:\App Control Delta\scrcpy"
start scrcpy-noconsole.vbs
cls
echo =====================
pause
goto main_menu

:about_prog
cls
echo ==============================================================================
echo App Control Delta (ACD) - программа для управления приложениями на телефоне.
echo Программа обладает базовым функционалом, но работает без Root-прав. 
echo Программа активно обновляется. Следите за новостями на Telegram-канале.
echo.
echo TGK: https://t.me/zh4eny
echo YT: https://www.youtube.com/@zhh4eny
echo ====================================
pause
goto main_menu

:phone_con
cls
echo ======================================================================================
echo Функция находится в стадии тестирования, и если телефон выйдет из строя, МЫ НЕ НЕСЁМ ОТВЕТСТВЕННОСТИ!
echo Вы делаете всё на свой страх и риск.
timeout /t 5 /nobreak >nul
cls
echo ======================================================================================
echo Это ваше устройство?
adb devices
set /p choice=Введите Д или Н:

if "%choice%"=="д" goto phone_con2
if "%choice%"=="н" goto main_menu

:phone_con2
cls
echo =====================================================================================
echo [1] Перезагрузка в fastboot                                      Управление телефоном
echo [2] Перезагрузка в fastbootd
echo [3] Перезагрузка в recovery
echo [4] Установить Magisk
echo [5] Установить Liveboot (ROOT)
echo.
echo [6] Вернуться в главное меню

set /p choice=Выберите номер: 
if "%choice%"=="1" goto bootloader
if "%choice%"=="2" goto fastboottd
if "%choice%"=="3" goto recover
if "%choice%"=="4" goto magisk
if "%choice%"=="5" goto liveboot
if "%choice%"=="6" goto main_menu

:bootloader
echo Перезагрузка в загрузчик...
adb reboot bootloader
echo Готово!
timeout /t 3 /nobreak >nul
goto phone_con2

:recover
echo Перезагрузка в recovery...
adb reboot recovery
echo Готово!
timeout /t 3 /nobreak >nul
goto phone_con2

:fastboottd
echo Перезагрузка в fastbootd...
adb reboot fastboot
echo Готово!
timeout /t 3 /nobreak >nul
goto phone_con2

:magisk
cd /d "C:\App Control Delta\apk"
echo Устанавливаем Magisk...
adb install magisk.apk
echo Готово!
timeout /t 3 /nobreak >nul
goto phone_con2

:liveboot
cd /d "C:\App Control Delta\apk"
echo Устанавливаем Liveboot...
adb install liveboot.apk
echo Готово!
timeout /t 3 /nobreak >nul
goto phone_con2
