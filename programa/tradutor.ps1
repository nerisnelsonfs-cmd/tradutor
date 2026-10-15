# =============================================================================
# TRADUTOR - programa local  v1.8
# Criado por Nerisnelson Ferreira da Silva - Equipe Porta Aberta IA
#
# O QUE FAZ
#   Roda SO no seu computador e faz tres coisas:
#   1. Mostra a pagina do Tradutor em http://127.0.0.1:47810
#   2. Guarda as respostas que o Claude manda (caixa de recado). A pagina
#      pega a resposta e le em voz alta com a voz do seu computador.
#   3. Recebe o que voce falou na pagina e COLA na caixa do chat do app
#      Claude. Quem manda e VOCE, apertando Enter.
#
# v1.7 (14/10/2026) - O TRADUTOR NUNCA APERTA ENTER
#   Os Termos de Uso da Anthropic para contas pessoais (secao 3) nao permitem
#   acessar o Claude por meios automaticos (bot, script) sem permissao. Por
#   isso o Tradutor so cola a frase na caixa do chat; quem envia e a pessoa,
#   apertando Enter (tecla, pedal ou botao grande). Nao existe opcao de enviar
#   sozinho nesta versao.
#
# v1.8 (15/10/2026) - AVISOS CALMOS
#   Quando a pagina fecha antes da resposta, a janela mostra uma linha calma
#   (no maximo uma por minuto), e nao mais "Pedido com problema".
#
# SEGURANCA
#   - So escuta no proprio computador (127.0.0.1). Ninguem de fora alcanca.
#   - Pedido vindo de outro site aberto no navegador e recusado (cabecalhos
#     Origin e Sec-Fetch-Site, que o navegador nao deixa site falsificar).
#   - Endereco diferente de 127.0.0.1/localhost e recusado (protege contra
#     o golpe chamado "DNS rebinding").
#   - Nada e gravado em disco: as respostas ficam so na memoria e somem
#     quando voce fecha o programa.
#   - Ao colar no chat, guarda o que estava copiado (Ctrl+C) e devolve depois.
#   - Ritmo de gente (v1.1): no maximo 1 fala a cada 3 segundos e 10 por
#     minuto. O Tradutor so leva ao chat o que uma PESSOA falou - nunca
#     manda mensagens sozinho, em sequencia, como um robo.
#
# ARQUIVO SO COM LETRAS SEM ACENTO DE PROPOSITO: o PowerShell do Windows le
# .ps1 sem BOM como ANSI e embaralha acento. A pagina e as falas vao em UTF-8.
#
# FUNCIONA NO: Windows 10/11 com Windows PowerShell 5.1 (ja vem no Windows).
# PARAR: feche a janela deste programa.
#
# -Abrir (v1.4): alem de ligar, abre a pagina numa janela propria de
# aplicativo (Edge ou Chrome, sem abas e sem barra de endereco). E o que o
# icone "Tradutor" da area de trabalho usa.
# =============================================================================
param([switch]$Abrir)

$ErrorActionPreference = 'Stop'
$VERSAO   = '1.8'
$PORTA    = 47810
$ORIGENS  = @("http://127.0.0.1:$PORTA", "http://localhost:$PORTA")
$HOSTS    = @("127.0.0.1:$PORTA", "localhost:$PORTA")
$MAX_TEXTO   = 8000     # tamanho maximo de uma resposta
$MAX_FALA    = 2000     # tamanho maximo de uma fala
$MAX_RECADOS = 20       # quantas respostas guarda na memoria
$ESPERA_MAX  = 20       # segundos que a pagina pode ficar esperando resposta nova
$FALA_INTERVALO = 3     # segundos minimos entre uma fala e outra
$FALA_POR_MINUTO = 10   # falas no maximo por minuto
$PASTA    = Split-Path -Parent $MyInvocation.MyCommand.Path
$PAGINA   = Join-Path $PASTA 'pagina.html'
$TESTE    = ($env:TRADUTOR_TESTE -eq '1')   # so para os testes: nao mexe em janela

if (-not $TESTE) {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type @'
using System;
using System.Runtime.InteropServices;
public static class Janela {
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
    [DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr h);
    [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint flags, UIntPtr extra);
}
'@
}

# Abre a pagina numa janela de aplicativo. Tenta o Chrome (a escuta foi
# testada nele), depois o Edge (ja vem no Windows); se nenhum for achado,
# abre no navegador padrao.
function Abrir-Janela {
    $url = "http://127.0.0.1:$PORTA/"
    # Montado com texto (nao Join-Path): se uma pasta nao existir no Windows,
    # o caminho so fica errado e e pulado, sem derrubar o programa.
    $pf86 = ${env:ProgramFiles(x86)}; $pf = $env:ProgramFiles; $local = $env:LOCALAPPDATA
    $candidatos = @(
        "$pf\Google\Chrome\Application\chrome.exe",
        "$pf86\Google\Chrome\Application\chrome.exe",
        "$local\Google\Chrome\Application\chrome.exe",
        "$pf86\Microsoft\Edge\Application\msedge.exe",
        "$pf\Microsoft\Edge\Application\msedge.exe"
    )
    foreach ($c in $candidatos) {
        if ($c -and (Test-Path $c)) {
            Start-Process -FilePath $c -ArgumentList @("--app=$url", '--window-size=600,940')
            return
        }
    }
    Start-Process $url
}

function Escrever($cor, $msg) {
    $hora = (Get-Date).ToString('HH:mm:ss')
    Write-Host "[$hora] $msg" -ForegroundColor $cor
}

# ---------------------------------------------------------------- chat do Claude
function Achar-Claude {
    # O app Claude do Windows roda como varios processos "Claude"; so um tem janela.
    $p = Get-Process -Name 'Claude' -ErrorAction SilentlyContinue |
         Where-Object { $_.MainWindowHandle -ne [IntPtr]::Zero } |
         Select-Object -First 1
    if ($p) { return $p.MainWindowHandle }
    return [IntPtr]::Zero
}

function Trazer-Pra-Frente($h) {
    if ([Janela]::IsIconic($h)) { [void][Janela]::ShowWindow($h, 9) }   # 9 = restaurar
    # O Windows so deixa trazer janela pra frente quem acabou de usar o teclado.
    # Aperta e solta o F24 (tecla que nao existe no teclado): libera a janela
    # sem abrir menu nenhum (o ALT abria o menu Arquivo do app Claude).
    [Janela]::keybd_event(0x87, 0, 0, [UIntPtr]::Zero)
    [Janela]::keybd_event(0x87, 0, 2, [UIntPtr]::Zero)
    [void][Janela]::SetForegroundWindow($h)
    Start-Sleep -Milliseconds 200
    return ([Janela]::GetForegroundWindow() -eq $h)
}

function Colar-No-Chat($texto) {
    if ($TESTE) { return @{ ok = $true; teste = $true; enviado = $false } }

    $h = Achar-Claude
    if ($h -eq [IntPtr]::Zero) { return @{ ok = $false; codigo = 'sem_claude'; erro = 'O app Claude nao esta aberto.' } }

    $antes = $null
    try { $antes = Get-Clipboard -Raw -ErrorAction Stop } catch { $antes = $null }

    Set-Clipboard -Value $texto
    if (-not (Trazer-Pra-Frente $h)) {
        if ($null -ne $antes) { Set-Clipboard -Value $antes }
        return @{ ok = $false; codigo = 'janela'; erro = 'O Windows nao deixou trazer o Claude pra frente. Clique na janela do Claude uma vez e fale de novo.' }
    }
    [System.Windows.Forms.SendKeys]::SendWait('^v')
    Start-Sleep -Milliseconds 150
    # v1.7: NAO aperta Enter. A pessoa confere a frase e envia.
    Start-Sleep -Milliseconds 400
    if ($null -ne $antes) { Set-Clipboard -Value $antes }
    return @{ ok = $true; enviado = $false }
}

# ---------------------------------------------------------------- HTTP simples
function Responder($stream, $codigo, $texto, $tipo, [byte[]]$bytes) {
    if ($null -eq $bytes) { $bytes = [byte[]]@() }
    $cab  = "HTTP/1.1 $codigo $texto`r`n"
    $cab += "Content-Type: $tipo`r`n"
    $cab += "Content-Length: $($bytes.Length)`r`n"
    $cab += "Cache-Control: no-store`r`n"
    $cab += "X-Content-Type-Options: nosniff`r`n"
    $cab += "X-Frame-Options: DENY`r`n"
    $cab += "Connection: close`r`n`r`n"
    $c = [System.Text.Encoding]::ASCII.GetBytes($cab)
    $stream.Write($c, 0, $c.Length)
    if ($bytes.Length -gt 0) { $stream.Write($bytes, 0, $bytes.Length) }
    $stream.Flush()
}

function Responder-Json($stream, $codigo, $texto, $obj) {
    $json = $obj | ConvertTo-Json -Compress -Depth 5
    Responder $stream $codigo $texto 'application/json; charset=utf-8' ([System.Text.Encoding]::UTF8.GetBytes($json))
}

function Ler-Pedido($stream) {
    # Le o cabecalho ate a linha em branco, depois o corpo pelo Content-Length.
    $buf = New-Object System.IO.MemoryStream
    $um = New-Object byte[] 1
    $fim = 0
    while ($buf.Length -lt 16384) {
        $n = $stream.Read($um, 0, 1)
        if ($n -le 0) { break }
        $buf.WriteByte($um[0])
        if (($fim -band 1) -eq 0 -and $um[0] -eq 13) { $fim++ }
        elseif (($fim -band 1) -eq 1 -and $um[0] -eq 10) { $fim++ }
        elseif ($um[0] -eq 13) { $fim = 1 }
        else { $fim = 0 }
        if ($fim -ge 4) { break }
    }
    $cabecalho = [System.Text.Encoding]::ASCII.GetString($buf.ToArray())
    $linhas = $cabecalho -split "`r`n"
    $primeira = ($linhas[0] -split ' ')
    $info = @{ metodo = $primeira[0]; caminho = ''; consulta = @{}; origem = ''; host = ''; site = ''; tamanho = 0; corpo = '' }
    if ($primeira.Length -gt 1) {
        $partes = $primeira[1] -split '\?', 2
        $info.caminho = $partes[0]
        if ($partes.Length -gt 1) {
            foreach ($par in ($partes[1] -split '&')) {
                $kv = $par -split '=', 2
                if ($kv.Length -eq 2) { $info.consulta[$kv[0]] = [System.Uri]::UnescapeDataString($kv[1]) }
            }
        }
    }
    foreach ($l in $linhas) {
        if ($l -match '^Origin:\s*(.+)$')         { $info.origem  = $matches[1].Trim() }
        if ($l -match '^Host:\s*(.+)$')           { $info.host    = $matches[1].Trim().ToLower() }
        if ($l -match '^Sec-Fetch-Site:\s*(.+)$') { $info.site    = $matches[1].Trim().ToLower() }
        if ($l -match '^Content-Length:\s*(\d+)') { $info.tamanho = [int]$matches[1] }
    }
    if ($info.tamanho -gt 0 -and $info.tamanho -le 65536) {
        $corpo = New-Object byte[] $info.tamanho
        $lido = 0
        while ($lido -lt $info.tamanho) {
            $n = $stream.Read($corpo, $lido, $info.tamanho - $lido)
            if ($n -le 0) { break }
            $lido += $n
        }
        $info.corpo = [System.Text.Encoding]::UTF8.GetString($corpo, 0, $lido)
    }
    return $info
}

# v1.8: a conexao caiu do lado da pagina? (o Windows diz "Uma conexao
# estabelecida foi anulada pelo software no computador host"). Procura o erro
# de rede dentro do erro do PowerShell, que embrulha um no outro.
$script:avisoDesconexao = $null
function E-Desconexao($ex) {
    $n = 0
    while ($null -ne $ex -and $n -lt 10) {
        if ($ex -is [System.IO.IOException] -or
            $ex -is [System.Net.Sockets.SocketException] -or
            $ex -is [System.ObjectDisposedException]) { return $true }
        $ex = $ex.InnerException
        $n++
    }
    return $false
}

function Ler-Texto($corpo) {
    try { return ([string](($corpo | ConvertFrom-Json).texto)).Trim() } catch { return '' }
}

# ---------------------------------------------------------------- caixa de recado
# Fica so na memoria. Cada resposta tem um numero (milissegundos) sempre crescente.
$script:recados = New-Object System.Collections.ArrayList
$script:ultimoId = [long]0
$script:esperando = New-Object System.Collections.ArrayList   # paginas esperando resposta nova
$script:falas = New-Object System.Collections.ArrayList       # horario das ultimas falas coladas

function Ritmo-Ok {
    $agora = Get-Date
    for ($i = $script:falas.Count - 1; $i -ge 0; $i--) {
        if (($agora - $script:falas[$i]).TotalSeconds -gt 60) { $script:falas.RemoveAt($i) }
    }
    if ($script:falas.Count -ge $FALA_POR_MINUTO) { return $false }
    if ($script:falas.Count -gt 0 -and ($agora - $script:falas[$script:falas.Count - 1]).TotalSeconds -lt $FALA_INTERVALO) { return $false }
    return $true
}

function Novo-Id {
    $id = [long]([DateTimeOffset]::UtcNow).ToUnixTimeMilliseconds()
    if ($id -le $script:ultimoId) { $id = $script:ultimoId + 1 }
    $script:ultimoId = $id
    return $id
}

function Proximo-Recado([double]$desde) {
    foreach ($r in $script:recados) { if ($r.id -gt $desde) { return $r } }
    return $null
}

function Entregar($cliente, $stream, $r) {
    if ($r) { Responder-Json $stream 200 'OK' @{ ok = $true; id = $r.id; texto = $r.texto; quando = $r.quando; espera = $true } }
    else    { Responder-Json $stream 200 'OK' @{ ok = $true; vazio = $true; espera = $true } }
    $cliente.Close()
}

# ---------------------------------------------------------------- liga
$ouvinte = New-Object System.Net.Sockets.TcpListener ([System.Net.IPAddress]::Loopback, $PORTA)
try { $ouvinte.Start() }
catch {
    # A porta esta ocupada. Se for o proprio Tradutor ja aberto, tudo bem.
    $jaAberto = $false
    try {
        $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 -Uri "http://127.0.0.1:$PORTA/ping"
        $jaAberto = ($r.Content -match 'tradutor')
    } catch { $jaAberto = $false }
    if ($jaAberto) {
        if ($Abrir -and -not $TESTE) { Abrir-Janela }
        Escrever Green 'O Tradutor ja esta aberto em outra janela. Esta aqui fecha sozinha.'
        Start-Sleep -Seconds 4
        exit 0
    }
    Escrever Red "Nao consegui abrir a porta ${PORTA}: outro programa esta usando."
    Escrever Red 'Feche o outro programa ou reinicie o computador e tente de novo.'
    if (-not $TESTE) { Read-Host 'Aperte Enter pra fechar' }
    exit 1
}

try { $Host.UI.RawUI.WindowTitle = 'TRADUTOR - deixe esta janela aberta' } catch { }
Escrever Green "TRADUTOR ligado (versao $VERSAO)."
Escrever Gray  "A pagina esta em http://127.0.0.1:$PORTA"
Escrever Gray  'Deixe esta janela aberta (pode minimizar). Pra desligar, feche a janela.'
if ($Abrir -and -not $TESTE) { Abrir-Janela }
# v1.5 (29/09/2026 - Neris: "deixe so o necessario aberto"): esta janela preta
# e o motor. Ela vai sozinha pra barra de tarefas (minimizada) - continua
# funcionando igual. Pra desligar o Tradutor, feche esta janela.
if (-not $TESTE) { try { [void][Janela]::ShowWindow([Janela]::GetConsoleWindow(), 6) } catch { } }   # 6 = minimizar

while ($true) {
    # 1. Paginas esperando: chegou resposta nova ou acabou o tempo? Responde.
    for ($i = $script:esperando.Count - 1; $i -ge 0; $i--) {
        $e = $script:esperando[$i]
        $r = Proximo-Recado $e.desde
        if ($r -or (Get-Date) -ge $e.ate) {
            try { Entregar $e.cliente $e.stream $r } catch { try { $e.cliente.Close() } catch { } }
            $script:esperando.RemoveAt($i)
        }
    }

    # 2. Pedido novo? Se nao tem, descansa um pouquinho.
    if (-not $ouvinte.Pending()) { Start-Sleep -Milliseconds 60; continue }

    $cliente = $ouvinte.AcceptTcpClient()
    $fechar = $true
    try {
        $cliente.ReceiveTimeout = 1500
        $s = $cliente.GetStream()
        $p = Ler-Pedido $s

        $hostOk   = ($HOSTS -contains $p.host)
        $origemOk = (($p.origem -eq '') -or ($ORIGENS -contains $p.origem))
        $siteOk   = (($p.site -ne 'cross-site') -and ($p.site -ne 'same-site'))

        if (-not $hostOk) {
            Responder-Json $s 403 'Forbidden' @{ ok = $false; erro = 'endereco recusado' }
            Escrever DarkYellow "Recusei um pedido com endereco estranho ($($p.host))."
        }
        elseif (-not ($origemOk -and $siteOk)) {
            Responder-Json $s 403 'Forbidden' @{ ok = $false; erro = 'pedido de outro site recusado' }
            Escrever DarkYellow "Recusei um pedido de outro site ($($p.origem))."
        }
        elseif ($p.metodo -eq 'GET' -and ($p.caminho -eq '/' -or $p.caminho -eq '/index.html')) {
            if (Test-Path $PAGINA) {
                Responder $s 200 'OK' 'text/html; charset=utf-8' ([System.IO.File]::ReadAllBytes($PAGINA))
            } else {
                Responder-Json $s 500 'Internal Server Error' @{ ok = $false; erro = 'pagina.html nao esta na pasta do programa' }
            }
        }
        elseif ($p.metodo -eq 'GET' -and $p.caminho -eq '/ping') {
            Responder-Json $s 200 'OK' @{ ok = $true; tradutor = $VERSAO; ultimo = $script:ultimoId }
        }
        elseif ($p.metodo -eq 'POST' -and $p.caminho -eq '/recado') {
            $texto = Ler-Texto $p.corpo
            if ($texto.Length -eq 0) {
                Responder-Json $s 400 'Bad Request' @{ ok = $false; erro = 'texto vazio' }
            } else {
                if ($texto.Length -gt $MAX_TEXTO) { $texto = $texto.Substring(0, $MAX_TEXTO) }
                $r = @{ id = (Novo-Id); texto = $texto; quando = (Get-Date).ToString('s') }
                [void]$script:recados.Add($r)
                while ($script:recados.Count -gt $MAX_RECADOS) { $script:recados.RemoveAt(0) }
                Responder-Json $s 200 'OK' @{ ok = $true; id = $r.id; tamanho = $texto.Length }
                Escrever Cyan "Resposta recebida ($($texto.Length) letras)."
            }
        }
        elseif ($p.metodo -eq 'GET' -and $p.caminho -eq '/recado') {
            $desde = [double]0
            [void][double]::TryParse([string]$p.consulta['desde'], [ref]$desde)
            $r = Proximo-Recado $desde
            if ($r -or -not $p.consulta['esperar']) {
                if ($r) { Responder-Json $s 200 'OK' @{ ok = $true; id = $r.id; texto = $r.texto; quando = $r.quando; espera = $true } }
                else    { Responder-Json $s 200 'OK' @{ ok = $true; vazio = $true; espera = $true } }
            } else {
                # Segura a resposta ate chegar recado novo (ou ate ESPERA_MAX segundos).
                [void]$script:esperando.Add(@{ cliente = $cliente; stream = $s; desde = $desde; ate = (Get-Date).AddSeconds($ESPERA_MAX) })
                $fechar = $false
            }
        }
        elseif ($p.metodo -eq 'POST' -and $p.caminho -eq '/fala') {
            $texto = Ler-Texto $p.corpo
            if ($texto.Length -eq 0) {
                Responder-Json $s 400 'Bad Request' @{ ok = $false; erro = 'texto vazio' }
            } elseif (-not (Ritmo-Ok)) {
                Responder-Json $s 429 'Too Many Requests' @{ ok = $false; codigo = 'ritmo'; erro = 'Devagar: espere uns segundos e fale de novo.' }
                Escrever DarkYellow 'Fala recusada: rapida demais (limite de ritmo).'
            } else {
                if ($texto.Length -gt $MAX_FALA) { $texto = $texto.Substring(0, $MAX_FALA) }
                [void]$script:falas.Add((Get-Date))
                $r = Colar-No-Chat $texto
                if ($r.ok) {
                    Responder-Json $s 200 'OK' $r
                    Escrever Cyan 'Fala colada na caixa do Claude. Aperte Enter pra mandar.'
                } else {
                    Responder-Json $s 409 'Conflict' $r
                    Escrever Red $r.erro
                }
            }
        }
        elseif ($p.metodo -eq 'POST' -and $p.caminho -eq '/limpar') {
            $script:recados.Clear()
            Responder-Json $s 200 'OK' @{ ok = $true; limpo = $true }
        }
        else {
            Responder-Json $s 404 'Not Found' @{ ok = $false }
        }
    }
    catch {
        # v1.8: pagina que fecha a conexao antes da resposta (aba recarregada,
        # janela fechada, Tradutor acabando de ligar) NAO e problema. Antes saia
        # um aviso amarelo assustador; agora sai uma linha calma, no maximo uma
        # vez por minuto. Erro de verdade continua aparecendo em amarelo.
        if (E-Desconexao $_.Exception) {
            $agora = Get-Date
            if ($null -eq $script:avisoDesconexao -or ($agora - $script:avisoDesconexao).TotalSeconds -ge 60) {
                $script:avisoDesconexao = $agora
                Escrever Gray 'Uma pagina fechou antes da resposta. Normal, nada a fazer.'
            }
        } else {
            Escrever DarkYellow "Pedido com problema, ignorado: $($_.Exception.Message)"
        }
    }
    finally {
        if ($fechar) { try { $cliente.Close() } catch { } }
    }
}
