# =============================================================================
# DESINSTALAR O TRADUTOR  v1.5
# Criado por Nerisnelson Ferreira da Silva - Equipe Porta Aberta IA
#
# Tira TUDO o que o instalador criou, e so isso:
#   - fecha o Tradutor se estiver aberto (so ele: confere a linha de comando)
#   - apaga os icones "Tradutor" (so os que apontam pra pasta do Tradutor)
#   - tira o Tradutor de "Aplicativos instalados"
#   - apaga a pasta  %LOCALAPPDATA%\Programs\Tradutor
# Nao mexe na pasta que voce baixou do GitHub.
#
# ARQUIVO SO COM LETRAS SEM ACENTO DE PROPOSITO (PowerShell do Windows).
# =============================================================================

$ErrorActionPreference = 'Stop'
$DESTINO = Join-Path $env:LOCALAPPDATA 'Programs\Tradutor'
$REG = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Tradutor'

try { $Host.UI.RawUI.WindowTitle = 'Desinstalar o Tradutor' } catch { }
function Linha($cor, $msg) { Write-Host $msg -ForegroundColor $cor }

Linha Cyan ''
Linha Cyan '  DESINSTALAR O TRADUTOR'
Linha Gray ''
Linha Gray "  Vai tirar: a pasta $DESTINO, os icones 'Tradutor'"
Linha Gray '  e o registro em "Aplicativos instalados".'
Linha Gray ''
Read-Host '  Aperte ENTER para desinstalar (ou feche esta janela para desistir)'

# Sai de dentro da pasta antes de apagar ela.
Set-Location $env:TEMP

# 1. Fecha o Tradutor instalado, se estiver aberto
$alvo = (Join-Path $DESTINO 'tradutor.ps1')
Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" |
    Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -and $_.CommandLine -like "*$alvo*" } |
    ForEach-Object { try { Stop-Process -Id $_.ProcessId -Force -ErrorAction Stop; Linha Gray '  Fechei o Tradutor que estava aberto.' } catch { } }

# 2. Icones: so apaga os que apontam pro Tradutor desta pasta
$shell = New-Object -ComObject WScript.Shell
foreach ($a in @(
    (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Tradutor.lnk'),
    (Join-Path ([Environment]::GetFolderPath('Programs')) 'Tradutor.lnk'))) {
    if (Test-Path $a) {
        $lnk = $shell.CreateShortcut($a)
        if ($lnk.Arguments -like "*$alvo*") { Remove-Item $a -Force; Linha Green "  ok  icone removido: $a" }
        else { Linha DarkYellow "  Deixei $a (nao e do Tradutor)." }
    }
}

# 3. "Aplicativos instalados"
if (Test-Path $REG) { Remove-Item $REG -Recurse -Force; Linha Green '  ok  tirado de "Aplicativos instalados"' }

# 4. A pasta do programa
Start-Sleep -Milliseconds 500
if (Test-Path $DESTINO) {
    try { Remove-Item $DESTINO -Recurse -Force; Linha Green "  ok  pasta apagada: $DESTINO" }
    catch { Linha DarkYellow "  Nao consegui apagar $DESTINO agora. Reinicie o computador e apague a pasta, ou rode de novo." }
}

Linha Green ''
Linha Green '  PRONTO. O Tradutor foi desinstalado.'
Read-Host '  Aperte Enter pra fechar'
