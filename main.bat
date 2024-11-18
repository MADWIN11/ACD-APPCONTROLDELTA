@echo off
color 4
title AppControl Delta

:check_adb
cls
echo =================================================
echo Checking for adb.
adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ADB is not installed or not added to PATH.
    echo Install ADB and add it to the PATH variable.
    echo.
    pause
    exit /b
)

:main_menu
cls
echo ===================================
echo  AppControl Delta / 1.1 / Release
echo ===================================
echo [1] Show all installed applications
echo [2] Delete an application
echo [3] Screencast from phone
echo [4] About program
echo [5] Phone control
echo [6] Settings
echo [7] Exit
echo.
set /p choice=Select an action: 

if "%choice%"=="1" goto show_apps
if "%choice%"=="2" goto delete_app
if "%choice%"=="3" goto screen_show
if "%choice%"=="4" goto about_prog
if "%choice%"=="5" goto phone_con
if "%choice%"=="6" goto test_settings
if "%choice%"=="7" exit /b

:show_apps
cls
echo Retrieving the list of applications...
adb shell pm list packages -f > log-of-apps.txt
if %errorlevel% neq 0 (
    echo Failed to retrieve the list of applications. Make sure the device is connected and ADB is enabled.
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
set /p package=Enter the package name of the application to delete (e.g., com.android.chrome): 
if "%package%"=="" (
    echo Package name cannot be empty.
    pause
    goto main_menu
)
cls
echo ==========================================================================
echo Deleting application %package%...
adb shell pm uninstall --user 0 %package% >nul 2>&1
if %errorlevel% neq 0 (
    echo Failed to delete the application. The package name might be incorrect.
    pause
    goto main_menu
)
echo Application %package% successfully deleted.
echo.
pause
goto main_menu

:screen_show
cls
echo ============================================
echo Make sure debugging mode is enabled on your phone
echo.
set /p choice=You ready? (y/n): 

if "%choice%"=="y" goto scrcpy
if "%choice%"=="n" goto main_menu

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
echo App Control Delta (ACD) - a program to manage your applications on your phone.
echo The program has raw functionality, but works without Root rights. 
echo The program is being actively updated. Also, go to the telegram 
echo channel to follow development news.
echo.
echo TGK: https://t.me/zh4eny
echo YT: https://www.youtube.com/@zhh4eny
echo.
pause
goto main_menu

:phone_con
cls
echo ======================================================================================
echo The function is in beta testing, and if the phone breaks down, WE ARE NOT RESPONSIBLE!
echo Do everything at your own RISK.
timeout /t 5 /nobreak >nul
cls
echo ======================================================================================
echo Its your device?
adb devices
set /p choice=Enter Y or N:

if "%choice%"=="y" goto phone_con2
if "%choice%"=="n" goto main_menu

:phone_con2
cls
echo =====================================================================================
echo [1] Reboot to fastboot                                                  Phone control 
echo [2] Reboot to fastbooTD
echo [3] Reboot to recovery
echo [4] Install magisk
echo [5] Install liveboot (ROOT)
echo [6] Return to main menu
echo.
set /p choice=Select number: 

if "%choice%"=="1" goto bootloader
if "%choice%"=="2" goto fastboottd
if "%choice%"=="3" goto recover
if "%choice%"=="4" goto magisk
if "%choice%"=="5" goto liveboot
if "%choice%"=="6" goto main_menu

:bootloader
echo reboot_to_bootloader
adb reboot bootloader
echo done!
timeout /t 3 /nobreak >nul
goto phone_con2

:recover
echo reboot_to_recovery
adb reboot recovery
echo done!
timeout /t 3 /nobreak >nul
goto phone_con2

:fastboottd
echo reboot_to_fastboottd
adb reboot fastboot
echo done!
timeout /t 3 /nobreak >nul
goto phone_con2

:magisk
cd /d "C:\App Control Delta\apk"
echo install_magisk
adb install magisk.apk
echo done!
timeout /t 3 /nobreak >nul
goto phone_con2

:liveboot
cd /d "C:\App Control Delta\apk"
echo install_liveboot
adb install liveboot.apk
echo done!
timeout /t 3 /nobreak >nul
goto phone_con2

:test_settings
echo. 
echo This feature is apparently not ready to be released yet.
timeout /t 3 /nobreak >nul
goto main_menu





