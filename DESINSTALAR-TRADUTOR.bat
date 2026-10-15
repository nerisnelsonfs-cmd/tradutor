@echo off
rem DESINSTALAR-TRADUTOR - Tradutor v1.5
rem Criado por Nerisnelson Ferreira da Silva - Equipe Porta Aberta IA
rem Tira tudo o que o instalador criou. Mostra antes e pede ENTER.
cd /d "%~dp0"
if exist "%LOCALAPPDATA%\Programs\Tradutor\desinstalar.ps1" (
  copy /y "%LOCALAPPDATA%\Programs\Tradutor\desinstalar.ps1" "%TEMP%\tradutor-desinstalar.ps1" >nul
  powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP%\tradutor-desinstalar.ps1"
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0programa\desinstalar.ps1"
)
