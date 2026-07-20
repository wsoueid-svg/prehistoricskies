@echo off
setlocal
where godot >nul 2>nul
if errorlevel 1 (
  where godot4 >nul 2>nul
  if errorlevel 1 (
    echo Godot was not found in PATH.
    echo Open project.godot manually in Godot 4.7.1.
    pause
    exit /b 1
  )
  godot4 --path "%~dp0"
  exit /b %errorlevel%
)
godot --path "%~dp0"
