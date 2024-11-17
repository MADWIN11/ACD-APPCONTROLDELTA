@echo off
setlocal
set "repo_owner=MADWIN11"
set "repo_name=ACD-APPCONTROLDELTA"
set "file_name=main.bat"
set "local_version=1.0.0"
set "temp_file=%TEMP%\%file_name%"

set "latest_release_url=https://api.github.com/repos/%repo_owner%/%repo_name%/releases/latest"
set "download_url=https://raw.githubusercontent.com/%repo_owner%/%repo_name%/main/%file_name%"

for /f "tokens=*" %%i in ('curl -s %latest_release_url% ^| findstr /i "tag_name"') do set "latest_version=%%i"
set "latest_version=%latest_version:tag_name=%"
set "latest_version=%latest_version:"=%"
set "latest_version=%latest_version: =%"

echo Локальная версия: %local_version%
echo Последняя версия: %latest_version%

if not "%local_version%"=="%latest_version%" (
    echo update found 
    curl -o "%temp_file%" %download_url%
    if exist "%temp_file%" (
        echo del old ver
        copy /y "%temp_file%" "%~f0"
        del "%temp_file%"
        echo upd finish
        start "" "%~f0"
        exit /b
    ) else (
        echo eror111
    )
) else (
    echo you just installed last ver
)

echo started:da
pause
