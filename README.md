# 🎧 Tradutor — voz para o Cowork

**Feito para o Cowork, no app Claude para computador: o Claude trabalha, responde e o seu computador lê a resposta em voz alta. Você fala, e a sua frase aparece na caixa do Cowork — você confere e aperta Enter.**

Criado por **Nerisnelson Ferreira da Silva** · Equipe Porta Aberta IA

> *"Somos o melhor quando fazemos o melhor ao próximo."*

**Um projeto social:** o Tradutor nasceu para ajudar também **pessoas com baixa visão** —
em vez de forçar a vista para ler respostas longas na tela, a pessoa **ouve**.

🇧🇷 [Português](#português) · 🇺🇸 [English](#english)

❓ [Perguntas frequentes](#perguntas-frequentes) · [FAQ](#frequently-asked-questions)

---

## Português

### Por que é para o Cowork

O chat comum do Claude já tem jeitos próprios de conversar. O Tradutor foi feito para outro momento: quando o
Claude está **trabalhando no Cowork** (organizando arquivos, fazendo pesquisa, montando documentos) e você quer
**ouvir** o que ele responde e **falar** sem voltar pro teclado. O Claude do Cowork usa o navegador dele para
entregar a resposta ao Tradutor, que roda no seu próprio computador.

### Pra quem é

- **Pessoas com baixa visão:** ouvem as respostas em vez de ler, e podem aumentar as
  letras da página com o botão **A+**.
- **Idosos** e quem se cansa de tela.
- Quem está com as **mãos ocupadas** ou prefere **falar** do que digitar.

**Pessoas cegas:** a página tem rótulos para leitor de tela, mas ainda **não foi testada**
com NVDA ou Narrador. Se você usa leitor de tela, sua opinião ajuda muito.

### Explicação simples (sem termos técnicos)

O Tradutor é um programinha que fica aberto no seu computador, como um rádio
ligado num canto da tela.

1. **O Claude responde → o Tradutor lê em voz alta.** Você não precisa copiar nada.
2. **Você fala → o Tradutor escreve na caixa do chat do Claude.** Sem digitar. Ele avisa em voz
   alta quando a frase está na caixa; você confere e aperta **Enter** pra mandar
   (veja "Termos da Anthropic" abaixo).
3. Enquanto ele lê, o microfone **pausa sozinho**, pra não ouvir a si mesmo.
4. Pra ele não pegar a TV nem a conversa do lado, você começa cada frase com uma
   **palavra de chamada** (a padrão é "Tradutor"). Ex.: *"Tradutor, me explica isso de novo."*

Tudo acontece **no seu computador**. As respostas não vão pra servidor nenhum e somem
quando você fecha o programa.

**Em português ou inglês:** um botão no topo da página troca o idioma da tela, da voz que lê
e da escuta. Cada idioma tem a sua palavra de chamada ("Tradutor" / "Translator").

### O que você precisa

- Windows 10 ou 11
- Google Chrome ou Microsoft Edge
- O app **Claude** para computador, com o **Cowork**
- Um microfone (só se quiser falar)

### Como instalar (3 passos)

1. Baixe o pacote pronto **Tradutor-v1.8.zip** em **Releases** (no lado direito desta página)
   — ou toque em **Code → Download ZIP** — e extraia a pasta.
2. Dê dois cliques em **INSTALAR-TRADUTOR**. Ele mostra o que vai fazer e só começa
   quando você aperta **Enter**. Não pede senha de administrador.
   Se o Windows perguntar se quer mesmo abrir o arquivo, toque em **Executar**
   (ou **Mais informações → Executar assim mesmo**).
3. Pronto: aparece o ícone **Tradutor** na área de trabalho e no menu Iniciar.
   Dois cliques nele e o Tradutor abre numa janela própria. Toque em **LIGAR O TRADUTOR**.

**Pra desinstalar:** Configurações do Windows → **Aplicativos** → **Tradutor** → Desinstalar,
ou dois cliques em **DESINSTALAR-TRADUTOR**. Sai tudo.

**Sem instalar:** dentro da pasta **programa**, dois cliques em **ABRIR-TRADUTOR**.

### Perguntas frequentes

**É de graça?**
Sim. O Tradutor é gratuito e de código aberto (licença MIT). Não tem plano pago nem anúncio.

**Funciona no celular?**
Não. Ele roda no computador com **Windows 10 ou 11**, junto com o app **Claude para computador**.

**Funciona com ChatGPT, Gemini ou o chat comum do Claude?**
Não. Ele foi feito para o **Cowork**, no app Claude para computador. Quem manda as respostas
para o Tradutor é o próprio Claude do Cowork, depois que você ensina com o arquivo **para-o-claude**.

**Ele manda mensagens sozinho?**
Não. Ele só coloca a sua frase na caixa do chat. **Quem aperta Enter é você.**

**Precisa de microfone?**
Só se você quiser falar. Para apenas **ouvir** as respostas, não precisa.

**Precisa de internet?**
Sim, para o reconhecimento da sua fala (é o do navegador; no Chrome, a sua voz vai para o serviço
do Google virar texto). A **leitura** das respostas é feita pela voz do seu próprio computador.

**É vírus? O Windows deu um aviso.**
O aviso aparece porque o Tradutor não tem assinatura digital paga. Ele não pede senha de
administrador e é feito de arquivos de texto que qualquer pessoa pode abrir e conferir.
Veja a seção **É seguro?** logo abaixo.

**Serve para pessoas cegas?**
A página tem rótulos para leitor de tela, mas **ainda não foi testada** com NVDA ou Narrador.

**Não está lendo nada. O que eu confiro?**
1. A janela **TRADUTOR** está aberta (pode estar minimizada) e o botão diz **TRADUTOR LIGADO**.
2. O Claude do Cowork recebeu as instruções da pasta **para-o-claude**.
3. Você permitiu o endereço `http://127.0.0.1:47810` quando o app pediu.

**Como desinstalar?**
Configurações do Windows → **Aplicativos** → **Tradutor** → Desinstalar. Sai tudo.

### É seguro?

Explicado sem termos técnicos:

- **Você pode ver tudo.** O Tradutor não é um arquivo `.exe` fechado: são arquivos de texto
  que qualquer pessoa pode abrir e ler (no Bloco de Notas, por exemplo).
- **Não pede senha de administrador** e **não mexe no sistema do Windows**. Ele só coloca
  uma pasta na parte de programas do seu usuário, os ícones e o registro de
  "Aplicativos instalados". A lista do que foi criado fica no arquivo `instalado.txt`.
- **Não liga sozinho** quando o computador inicia. Só roda quando você abre.
- **Não fica escondido.** Enquanto está ligado, aparece uma janela minimizada chamada
  **TRADUTOR** na barra de tarefas, mostrando o que está fazendo. Fechou ela, desligou.
- **Só funciona dentro do seu computador.** Ninguém de fora consegue falar com ele, e ele
  recusa pedidos de outros sites abertos no navegador.
- **Não pede nem guarda senha**, e não usa a sua conta do Claude — o Claude continua no app
  oficial.
- **Não guarda suas conversas.** As respostas ficam só na memória enquanto ele está aberto.
- **Uma coisa que sai do computador:** o reconhecimento de fala é o do navegador. No Chrome,
  o áudio da sua fala vai para o serviço de voz do Google virar texto. A leitura das
  respostas não sai do seu computador.
- **Sai tudo ao desinstalar.**

O Windows pode avisar na primeira vez porque o Tradutor não tem assinatura digital paga
(um selo que custa caro todo ano). Isso não quer dizer que ele faz mal — e você pode
conferir os arquivos antes de abrir.

### Ensinar o Claude do Cowork a mandar as respostas

O Claude precisa saber que você usa o Tradutor. Na pasta **para-o-claude** tem as
instruções prontas (`SKILL.md`). Você pode:

- adicionar como **skill** no Claude; ou
- simplesmente colar o conteúdo no começo da tarefa no Cowork.

Na primeira vez, o app pede permissão para o navegador do Claude usar o endereço
`http://127.0.0.1:47810`. Toque em **permitir**: é o próprio Tradutor, no seu computador.

### Como usar

A página tem um botão **📖 Como usar — passo a passo** que explica tudo na própria tela.

| Quero… | Faço… |
|---|---|
| Ouvir as respostas | Toco em **LIGAR O TRADUTOR** |
| Falar sem digitar | Toco em **FALAR SEM CLICAR** e começo a frase com a palavra de chamada |
| Ouvir de novo | **LER DE NOVO** |
| Calar agora | **PARAR** |
| Parar de escutar | Digo *"pode parar"* ou toco no botão de novo |
| Letra maior | **A+** |
| Voz de mulher ou de homem | Escolho em **VOZ** e toco em **Ouvir** |
| Saber se a frase foi pra caixa | O Tradutor avisa em voz alta: *"Frase na caixa. Aperte Enter para mandar."* Se não deu, ele fala o motivo. |

### Explicação técnica (pra quem programa)

```
 Cowork (navegador do Claude) ──(POST /recado)──▶ tradutor.ps1 (127.0.0.1:47810) ◀──(espera longa)── pagina.html ──▶ voz do sistema
     ▲                                        │                                               │
     └────────── cola (Enter: você) ◀── POST /fala ─┴──────────────── reconhecimento de fala ◀──────┘
```

- **Pastas:** na raiz ficam `INSTALAR-TRADUTOR.bat`, `DESINSTALAR-TRADUTOR.bat`, o README e
  `para-o-claude/`; em `programa/` ficam `tradutor.ps1`, `pagina.html`, `tradutor.ico`,
  `instalar.ps1`, `desinstalar.ps1` e `ABRIR-TRADUTOR.bat`. O instalador copia para
  `%LOCALAPPDATA%\Programs\Tradutor` e cria atalhos que chamam `tradutor.ps1 -Abrir`
  (abre a página em janela de aplicativo do Chrome ou do Edge, com `--app`).
- **`tradutor.ps1`**: servidor HTTP mínimo em PowerShell 5.1 (já vem no Windows), escutando
  **só em 127.0.0.1**. Um laço único atende tudo; a pergunta da página fica
  "estacionada" até chegar resposta nova (até 20 s), então a leitura começa quase na hora.
- **Rotas:** `GET /` (página) · `GET /ping` · `POST /recado {texto}` · `GET /recado?desde=ID&esperar=1`
  · `POST /fala {texto}` (cola na caixa do app Claude; **nunca** aperta Enter) · `POST /limpar`.
- **Memória:** guarda as últimas 20 respostas **só na RAM**. Nada em disco.
- **Voz:** `speechSynthesis` do navegador (vozes do Windows). A próxima frase só começa
  quando a anterior termina (`onend`), nunca por cronômetro.
- **Escuta:** `SpeechRecognition` do navegador, em pt-BR, com filtro de certeza, palavra de
  chamada configurável e pausa automática enquanto lê.

### Segurança e privacidade

- O programa **só aceita conexões do próprio computador** (127.0.0.1).
- **Pedido vindo de outro site é recusado** (cabeçalhos `Origin` e `Sec-Fetch-Site`).
- **Endereço diferente de 127.0.0.1/localhost é recusado** (proteção contra *DNS rebinding*).
- Ao colar no chat, o programa **guarda o que estava copiado e devolve depois**.
- **Atenção:** o reconhecimento de fala é o do navegador. No Chrome, o áudio da sua fala é
  enviado ao serviço de voz do Google pra virar texto. A **leitura** das respostas não sai
  do seu computador.

### Sempre uma pessoa falando

O Tradutor **não é um robô** e não conversa com o Claude sozinho:

- só leva ao Cowork o que **uma pessoa falou de propósito**, começando com a palavra de
  chamada (ela fica sempre ligada — TV e conversa do lado nunca viram mensagem);
- **uma frase por vez**, no ritmo de gente: no máximo 1 a cada 3 segundos e 10 por minuto;
- **não usa** login, senha ou chave de ninguém — o Claude continua no app oficial, com a conta
  da própria pessoa;
- **quem envia é a pessoa:** a frase só aparece na caixa do chat, e a pessoa aperta **Enter**.

### Termos da Anthropic (leia antes de usar)

Os Termos de Uso da Anthropic para contas pessoais (Free, Pro e Max), seção 3, não permitem acessar
o Claude "por meios automatizados ou não humanos" (robô, script etc.), a não ser pela chave da API
ou com permissão explícita da Anthropic. Não há exceção publicada para tecnologia assistiva.
Consultamos o suporte da Anthropic (outubro de 2026): eles não dão aprovação nem proibição para
ferramentas de terceiros e indicaram a leitura dos próprios termos.

Por isso:

- **O Tradutor nunca aperta Enter.** Ele cola a sua frase na caixa do chat e **você aperta Enter**.
  Cada mensagem é um gesto seu — pode ser a tecla, um pedal ou um botão grande USB.
- Não existe opção de enviar sozinho. Se um dia a Anthropic permitir, ela pode voltar numa
  atualização.
- A leitura das respostas em voz alta é feita pelo próprio Claude do Cowork, que entrega a resposta
  ao Tradutor com as ferramentas do app; o Tradutor não entra no app nem lê nada de lá.

Termos: https://www.anthropic.com/legal/consumer-terms — este README não é aconselhamento jurídico.
Contas Team e Enterprise seguem os Termos Comerciais; a Política de Uso vale para todas.

### Limitações conhecidas

- Colar a fala no chat funciona **só no Windows** (usa recursos do Windows pra trazer a
  janela do Claude pra frente).
- O programa traz a janela do Claude pra frente a cada fala enviada.
- Precisa de internet pro reconhecimento de fala do navegador.
- Se você falar rápido demais (menos de 3 segundos entre frases), o Tradutor pede pra esperar
  e mostra a frase de novo.

### Autoria

Criado por **Nerisnelson Ferreira da Silva** — Equipe Porta Aberta IA, construindo
tecnologia pra quem o mundo costuma deixar de fora.

**Licença:** MIT — veja o arquivo `LICENSE`. Pode usar, copiar e modificar, mantendo o aviso de
autoria. O programa é entregue "como está", sem garantia.

**Aviso:** o Tradutor é um projeto independente, feito para usar junto com o Claude.
Não é um produto da Anthropic, nem feito ou apoiado por ela. "Claude" e "Anthropic" são
marcas da Anthropic, PBC.

---

## English

**Made for Cowork in the Claude desktop app: Claude works, answers, and your computer reads the answer out loud. You speak, your sentence appears in the Cowork box, and you press Enter.**

### Why Cowork

Tradutor is made for the moments when Claude is **working in Cowork** and you want to **hear** its answers and
**speak** without going back to the keyboard. Claude in Cowork uses its own browser to hand each answer to the
Tradutor, which runs on your own computer.

### Who it is for

**A social project:** Tradutor was made to help **people with low vision** — instead of
straining to read long answers on screen, they **listen**. Also for older adults, anyone tired
of screens, and people who would rather **speak** than type. The page has screen-reader labels
but has **not yet been tested** with NVDA or Narrator. **Portuguese or English:** a button at the top switches
the screen text, the reading voice and the listening language (wake word "Translator" in English).
You can also pick a **female or male voice** from the voices installed on your computer.

### Simple explanation

A small program stays open on your computer:

1. **Claude answers → the Tradutor reads it aloud.** Nothing to copy.
2. **You speak → the Tradutor types it into the Claude chat box.** It says out loud *"Sentence in the box. Press Enter to send."* (or what went wrong), then you check it and press **Enter** to send.
3. While it reads, the microphone **pauses by itself**.
4. A **wake word** (default "Tradutor") keeps the TV and nearby talk out.

Everything runs **on your computer**. Answers are kept in memory only.

### Requirements

Windows 10/11 · Google Chrome or Microsoft Edge · the Claude desktop app with Cowork · a microphone (optional).

### Install

1. Download **Tradutor-v1.8.zip** from **Releases** (right side of this page) — or **Code → Download ZIP** — and extract.
2. Double-click **INSTALAR-TRADUTOR**. It shows what it will do and only starts when you press
   **Enter**. No administrator password. (If Windows asks, choose *Run* / *More info → Run anyway*.)
3. A **Tradutor** icon appears on the desktop and in the Start menu; it opens in its own app window.

**Uninstall:** Windows Settings → **Apps** → **Tradutor** → Uninstall, or double-click
**DESINSTALAR-TRADUTOR**. **Without installing:** `programa/ABRIR-TRADUTOR.bat`.

### Frequently asked questions

**Is it free?** Yes. Free and open source (MIT license). No paid plan, no ads.

**Does it work on a phone?** No. It runs on a **Windows 10 or 11** computer with the **Claude desktop app**.

**Does it work with ChatGPT, Gemini or the regular Claude chat?** No. It is made for **Cowork** in the
Claude desktop app. Claude in Cowork sends the answers to the Tradutor once you teach it with **para-o-claude**.

**Does it send messages by itself?** No. It only puts your sentence in the chat box. **You press Enter.**

**Do I need a microphone?** Only if you want to speak. To just **listen**, no.

**Do I need internet?** Yes, for speech recognition (the browser's; in Chrome your voice goes to Google's
speech service). Reading the answers uses your computer's own voice.

**Windows showed a warning. Is it a virus?** The warning appears because the scripts are not code-signed.
No administrator password; plain text files anyone can read. See **Is it safe?** below.

**Is it for blind people?** The page has screen-reader labels but has **not yet been tested** with NVDA or Narrator.

**It is not reading anything. What do I check?** The **TRADUTOR** window is open (it can be minimized) and the
button says **TRADUTOR IS ON** · Claude in Cowork got the **para-o-claude** instructions · you allowed
`http://127.0.0.1:47810` when the app asked.

### Is it safe?

Plain text files anyone can read (no closed `.exe`) · no administrator password, no system changes ·
does not start with Windows · never hidden: a minimized **TRADUTOR** window shows what it is doing ·
works only inside your computer and refuses requests from other websites · never asks for or
stores passwords, never uses your Claude account · keeps answers only in memory · the only thing
that leaves your computer is your voice for the browser's speech recognition (Google, in Chrome) ·
uninstall removes everything (the list is in `instalado.txt`). Windows may warn the first time
because the scripts are not code-signed.

Then teach Claude in Cowork with **para-o-claude/SKILL.md** (add it as a skill or paste it at the start of the task). The first time, allow Claude's browser to use `http://127.0.0.1:47810` — that is the Tradutor on your own computer.

### Technical notes

A minimal HTTP server in Windows PowerShell 5.1 bound to **127.0.0.1:47810** only; long-polling
for instant playback; answers kept in RAM (last 20); browser `speechSynthesis` for reading and
`SpeechRecognition` for listening. Requests from other sites (`Origin`/`Sec-Fetch-Site`) and unknown
`Host` headers (DNS rebinding) are refused. **Always a person speaking:** it only sends what a person
said on purpose (wake word always on), one sentence at a time, at most 1 every 3 seconds and 10 per
minute; it never uses anyone's login or credentials. Speech recognition in Chrome sends your audio to
Google's speech service; reading answers never leaves your machine. Pasting into the chat is Windows-only.

### Anthropic's Terms (read before using)

Anthropic's Consumer Terms (Free, Pro and Max), section 3, do not allow accessing Claude "through
automated or non-human means, whether through a bot, script, or otherwise", except with an API key or
explicit permission from Anthropic. There is no published exception for assistive software, and
Anthropic support does not approve or forbid third-party tools. So **Tradutor never presses
Enter**: it only pastes your sentence into the chat box and **you press Enter** (a key, a foot pedal
or a big USB button). There is no "send by itself" option; it may come back in an update if
Anthropic ever allows it. Terms:
https://www.anthropic.com/legal/consumer-terms — this is not legal advice.

### Author

Created by **Nerisnelson Ferreira da Silva** — Equipe Porta Aberta IA.
**License:** MIT — see `LICENSE`. Provided "as is", without warranty.

**Notice:** Tradutor is an independent project made to be used with Claude. It is not an
Anthropic product and is not made or endorsed by Anthropic. "Claude" and "Anthropic" are
trademarks of Anthropic, PBC.
