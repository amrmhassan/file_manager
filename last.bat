@echo off

@REM set app_to_delete=com.amh.file_manager
set app_to_install=./build/app/outputs/flutter-apk/app-release.apk

@REM adb shell pm list packages | findstr /r /c:"%app_to_delete%"
@REM if %errorlevel% == 0 (
@REM     echo "App %app_to_delete% found, uninstalling..."
@REM     adb uninstall %app_to_delete%
@REM ) else (
@REM     echo "App %app_to_delete% not found."
@REM )

echo "Installing app %app_to_install%..."
adb install %app_to_install%
