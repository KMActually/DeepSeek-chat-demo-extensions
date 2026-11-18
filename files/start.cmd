@echo off
setlocal
cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 (
  echo Node.js not found. Install Node.js 22.12 or newer first.
  pause
  exit /b 1
)

netstat -ano | findstr /r /c:":8090 .*LISTENING" >nul
if not errorlevel 1 (
  start "" http://localhost:8090
  exit /b 0
)

if not exist "node_modules" (
  echo Installing dependencies, this may take a few minutes...
  call npx -y pnpm@latest install --frozen-lockfile
  if errorlevel 1 (
    echo Dependency installation failed.
    pause
    exit /b 1
  )
)

start "" /b powershell -NoProfile -Command "Start-Sleep 5; Start-Process 'http://localhost:8090'"
call npx pnpm dev

echo.
echo Server stopped.
pause
