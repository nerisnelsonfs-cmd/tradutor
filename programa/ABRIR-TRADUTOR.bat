@echo off
rem ABRIR-TRADUTOR (sem instalar) - Tradutor v1.5
rem Criado por Nerisnelson Ferreira da Silva - Equipe Porta Aberta IA
rem Liga o programa (janela minimizada) e abre a pagina numa janela de aplicativo.
cd /d "%~dp0"
start "TRADUTOR" /min powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tradutor.ps1" -Abrir
exit
