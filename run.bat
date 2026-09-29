@echo off
echo YeniYuva uygulamasi baslatiliyor...
cd /d "%~dp0"
C:\flutter\bin\flutter run -d edge --web-port=8080
pause