@echo off
setlocal
where godot >nul 2>nul
if errorlevel 1 (
  echo Godot was not found in PATH.
  echo Open this project in Godot and use Project ^> Export ^> Android.
  pause
  exit /b 1
)
godot --headless --path "%~dp0" --export-debug Android "%~dp0build\PrehistoricSkies.apk"
if errorlevel 1 (
  echo Export failed. Confirm Android SDK, JDK 17 and Godot export templates are configured.
  pause
  exit /b 1
)
echo APK created at build\PrehistoricSkies.apk
pause
