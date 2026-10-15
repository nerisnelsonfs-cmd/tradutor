# =============================================================================
# INSTALAR O TRADUTOR  (a versao e lida do tradutor.ps1)
# Criado por Nerisnelson Ferreira da Silva - Equipe Porta Aberta IA
#
# O QUE FAZ (e so isso):
#   1. Copia o Tradutor para  %LOCALAPPDATA%\Programs\Tradutor
#      (a pasta de programas do SEU usuario - nao pede senha de administrador)
#   2. Cria o icone "Tradutor" na area de trabalho e no menu Iniciar
#   3. Registra o Tradutor em "Aplicativos instalados" do Windows, pra
#      desinstalar como qualquer programa
#   4. Anota tudo o que criou no arquivo instalado.txt, dentro da pasta
#
# NAO FAZ: nao mexe no sistema do Windows, nao instala servico, nao liga
# sozinho quando o computador inicia, nao baixa nada da internet.
#
# ARQUIVO SO COM LETRAS SEM ACENTO DE PROPOSITO (PowerShell do Windows).
# =============================================================================

$ErrorActionPreference = 'Stop'
$ORIGEM  = Split-Path -Parent $MyInvocation.MyCommand.Path
# v1.8: a versao vem do proprio tradutor.ps1 (antes era escrita aqui a mao e
# ficou parada em 1.5 enquanto o programa ja estava na 1.7).
$VERSAO  = '?'
try {
    $m = Select-String -Path (Join-Path $ORIGEM 'tradutor.ps1') -Pattern "^\`$VERSAO\s*=\s*'([0-9.]+)'" | Select-Object -First 1
    if ($m) { $VERSAO = $m.Matches[0].Groups[1].Value }
} catch { }
$DESTINO = Join-Path $env:LOCALAPPDATA 'Programs\Tradutor'
$ARQUIVOS = @('tradutor.ps1', 'pagina.html', 'tradutor.ico', 'desinstalar.ps1')
$PS = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'

try { $Host.UI.RawUI.WindowTitle = 'Instalar o Tradutor' } catch { }

function Linha($cor, $msg) { Write-Host $msg -ForegroundColor $cor }

Linha Cyan  ''
Linha Cyan  ("  INSTALAR O TRADUTOR  (versao $VERSAO)")
Linha Cyan  '  Converse com o Cowork pela voz - Equipe Porta Aberta IA'
Linha Gray  ''
Linha Gray  '  O que vai acontecer:'
Linha Gray  "   1. Copiar o Tradutor para: $DESTINO"
Linha Gray  '   2. Criar o icone "Tradutor" na area de trabalho e no menu Iniciar'
Linha Gray  '   3. Registrar em "Aplicativos instalados" (pra desinstalar facil)'
Linha Gray  ''
Linha Gray  '  Nao pede senha de administrador, nao mexe no sistema e nao baixa nada.'
Linha Gray  ''

foreach ($f in $ARQUIVOS) {
    if (-not (Test-Path (Join-Path $ORIGEM $f))) {
        Linha Red "  PAROU: falta o arquivo $f na pasta 'programa'. Baixe o Tradutor de novo."
        Read-Host '  Aperte Enter pra fechar'
        exit 1
    }
}

Read-Host '  Aperte ENTER para instalar (ou feche esta janela para desistir)'

try {
    # 1. Se uma versao instalada estiver rodando, fecha ela (confere a linha
    #    de comando: so fecha o Tradutor desta pasta, nenhum outro programa).
    $alvo = (Join-Path $DESTINO 'tradutor.ps1')
    Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" |
        Where-Object { $_.ProcessId -ne $PID -and $_.CommandLine -and $_.CommandLine -like "*$alvo*" } |
        ForEach-Object { try { Stop-Process -Id $_.ProcessId -Force -ErrorAction Stop; Linha Gray '  Fechei o Tradutor que estava aberto (versao anterior).' } catch { } }

    # 2. Copia os arquivos
    New-Item -ItemType Directory -Force -Path $DESTINO | Out-Null
    foreach ($f in $ARQUIVOS) {
        Copy-Item -Path (Join-Path $ORIGEM $f) -Destination (Join-Path $DESTINO $f) -Force
        # Tira a marca "baixado da internet" so das copias instaladas, pra o
        # Windows nao perguntar toda vez. Os arquivos continuam os mesmos, legiveis.
        try { Unblock-File -Path (Join-Path $DESTINO $f) } catch { }
    }
    Linha Green "  ok  arquivos copiados para $DESTINO"

    # 3. Icones (area de trabalho e menu Iniciar)
    $args1 = '-NoProfile -ExecutionPolicy Bypass -File "' + (Join-Path $DESTINO 'tradutor.ps1') + '" -Abrir'
    $icone = Join-Path $DESTINO 'tradutor.ico'
    $shell = New-Object -ComObject WScript.Shell
    $atalhos = @(
        (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Tradutor.lnk'),
        (Join-Path ([Environment]::GetFolderPath('Programs')) 'Tradutor.lnk')
    )
    foreach ($a in $atalhos) {
        $lnk = $shell.CreateShortcut($a)
        $lnk.TargetPath = $PS
        $lnk.Arguments = $args1
        $lnk.WorkingDirectory = $DESTINO
        $lnk.IconLocation = "$icone,0"
        $lnk.WindowStyle = 7          # a janela do programa abre minimizada
        $lnk.Description = 'Tradutor - converse com o Cowork pela voz'
        $lnk.Save()
    }
    Linha Green '  ok  icone "Tradutor" criado na area de trabalho e no menu Iniciar'

    # 4. "Aplicativos instalados" do Windows (so na parte do SEU usuario)
    $reg = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\Tradutor'
    New-Item -Path $reg -Force | Out-Null
    $tamanho = [int]((Get-ChildItem $DESTINO | Measure-Object -Property Length -Sum).Sum / 1KB)
    $valores = @{
        DisplayName     = 'Tradutor'
        DisplayVersion  = $VERSAO
        Publisher       = 'Equipe Porta Aberta IA'
        DisplayIcon     = $icone
        InstallLocation = $DESTINO
        UninstallString = '"' + $PS + '" -NoProfile -ExecutionPolicy Bypass -File "' + (Join-Path $DESTINO 'desinstalar.ps1') + '"'
    }
    foreach ($k in $valores.Keys) { Set-ItemProperty -Path $reg -Name $k -Value $valores[$k] }
    Set-ItemProperty -Path $reg -Name 'NoModify' -Value 1 -Type DWord
    Set-ItemProperty -Path $reg -Name 'NoRepair' -Value 1 -Type DWord
    Set-ItemProperty -Path $reg -Name 'EstimatedSize' -Value $tamanho -Type DWord
    Linha Green '  ok  registrado em "Aplicativos instalados"'

    # 5. Anota o que criou (transparencia: qualquer um confere)
    $nota = @(
        "Tradutor $VERSAO instalado em $(Get-Date -Format 'dd/MM/yyyy HH:mm')",
        '',
        'O que o instalador criou:',
        "  pasta:   $DESTINO",
        "  icone:   $($atalhos[0])",
        "  icone:   $($atalhos[1])",
        "  registro: $reg",
        '',
        'Pra tirar tudo: Configuracoes > Aplicativos > Tradutor > Desinstalar',
        'ou DESINSTALAR-TRADUTOR na pasta que voce baixou.'
    )
    Set-Content -Path (Join-Path $DESTINO 'instalado.txt') -Value $nota -Encoding UTF8
}
catch {
    Linha Red ''
    Linha Red "  Nao consegui terminar a instalacao: $($_.Exception.Message)"
    Linha Red '  Nada foi apagado. Tente de novo, ou use o DESINSTALAR-TRADUTOR pra limpar.'
    Read-Host '  Aperte Enter pra fechar'
    exit 1
}

Linha Green ''
Linha Green '  PRONTO! O Tradutor esta instalado.'
Linha Gray  '  Pra abrir: dois cliques no icone "Tradutor" da area de trabalho.'
Linha Gray  ''
$r = Read-Host '  Aperte ENTER para abrir o Tradutor agora (ou digite N e Enter para sair)'
if ($r -notmatch '^[nN]') {
    Start-Process -FilePath $PS -ArgumentList $args1 -WindowStyle Minimized -WorkingDirectory $DESTINO
}
