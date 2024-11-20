@echo off
title AppControl Delta

:check_adb
cls
echo ===================================================
echo Checking for adb.
adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ADB is not installed or not added to PATH.
    echo Install ADB and add it to the PATH variable.
    echo.
    pause
    exit /b
)

cls
echo ===================================================
echo The idea was taken from the program "AdbAppControl"
timeout /t 1 /nobreak >nul
echo The program was tested on Redmi 10 2022 (Selene)
timeout /t 1 /nobreak >nul
echo Starting program.
timeout /t 1 /nobreak >nul
cls
echo ===================================================
timeout /t 1 /nobreak >nul
echo checking_for_adb
echo starting_adb
timeout /t 2 /nobreak >nul
echo created_adb_service
echo testing_app_func
echo brick_selene_lol_xd
timeout /t 1 /nobreak >nul
echo ready_for_start
timeout /t 1 /nobreak >nul
echo testing_on_selene
timeout /t 1 /nobreak >nul
echo starting_prog
timeout /t 1 /nobreak >nul
goto main_menu

:main_menu
cls
echo ===================================
echo  AppControl Delta / 1.2 / Release
echo.
echo [1] Show all installed applications
echo [2] Delete an application
echo [3] Screencast from phone
echo [4] About program
echo [5] Ram info
echo.
set /p choice=Select an action: 

if "%choice%"=="1" goto show_apps
if "%choice%"=="2" goto delete_app
if "%choice%"=="3" goto scrcpy
if "%choice%"=="4" goto about_prog
if "%choice%"=="5" goto ram_info

:show_apps
cls
echo Retrieving the list of applications...
adb shell pm list packages -f | findstr /i "package:" > log-of-apps.txt
if %errorlevel% neq 0 (
    echo Failed to retrieve the list of applications. Make sure the device is connected and ADB is enabled.
    pause
    goto main_menu
)

echo =======================
echo List of installed applications:
for /f "tokens=2 delims==" %%A in (log-of-apps.txt) do (
    echo %%A
)

echo.
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

:scrcpy
cls
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

:ram_info
cls
echo =========================
adb devices | findstr /i "device" >nul 2>&1
if %errorlevel% neq 0 (
    echo Phone don`t detected.
    pause
    exit /b
)

echo Retrieving information...

adb shell dumpsys meminfo | findstr /r "^[ ]*[0-9]" > log-of-ram.txt

echo RAM Usage (PSS) by Processes:
for /f "tokens=1,2,3,* delims= " %%A in (log-of-ram.txt) do (
    echo RAM: %%A - Process: %%B %%C %%D
)

echo.
echo Done!
echo.
pause
goto main_menu
