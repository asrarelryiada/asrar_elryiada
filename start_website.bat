@echo off
chcp 65001 >nul
cd /d "%~dp0"
flutter run -d chrome
pause