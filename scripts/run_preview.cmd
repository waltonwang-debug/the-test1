@echo off
setlocal

set PORT=%1
if "%PORT%"=="" set PORT=4173

cd /d %~dp0\..

echo Starting preview server...
echo URL: http://127.0.0.1:%PORT%/preview.html
echo Press Ctrl+C to stop.

python -m http.server %PORT% --directory .
