@echo off

set app_to_delete=com.amh.file_manager
set app_to_install=./build/app/outputs/flutter-apk/app-release.apk

adb shell pm list packages | findstr /r /c:"%app_to_delete%"
if %errorlevel% == 0 (
    echo "App %app_to_delete% found, uninstalling..."
    adb uninstall %app_to_delete%
) else (
    echo "App %app_to_delete% not found."
)

echo "Installing app %app_to_install%..."
adb install %app_to_install%
