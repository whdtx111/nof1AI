@echo off
echo.
echo ========================================
echo   Docker Desktop Installation Wizard
echo ========================================
echo.
echo Starting installation menu...
echo.

powershell -ExecutionPolicy Bypass -File "%~dp0install-docker-menu.ps1"

if errorlevel 1 (
    echo.
    echo An error occurred during installation
    pause
)
