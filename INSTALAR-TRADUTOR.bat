@echo off
rem INSTALAR-TRADUTOR - Tradutor v1.5
rem Criado por Nerisnelson Ferreira da Silva - Equipe Porta Aberta IA
rem Abre o instalador. Ele mostra o que vai fazer e pede ENTER antes de comecar.
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0programa\instalar.ps1"
