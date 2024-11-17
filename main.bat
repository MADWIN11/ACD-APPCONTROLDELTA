@echo off
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
echo  AppControl Delta / 1.0 / Release
echo ===================================
echo [1] Show all installed applications
echo [2] Delete an application
echo [3] Screencast from phone
echo [4] About program
echo [5] Exit
echo =======================
set /p choice=Select an action: 

if "%choice%"=="1" goto show_apps
if "%choice%"=="2" goto delete_app
if "%choice%"=="3" goto screen_show
if "%choice%"=="4" goto about_prog
if "%choice%"=="5" exit /b

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
cd /d "C:\acd\scrcpy"
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
echo ====================================
pause
goto main_menu
