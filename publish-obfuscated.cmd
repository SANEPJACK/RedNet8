@echo off
setlocal

REM Wrapper to run publish-obfuscated.ps1 even when PowerShell execution policy blocks scripts.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0publish-obfuscated.ps1" %*

