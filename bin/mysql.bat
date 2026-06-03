@echo off
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\scripts\MySQL.ps1" %*
