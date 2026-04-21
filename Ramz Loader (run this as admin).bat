@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0RamZ script.ps1"
pause
