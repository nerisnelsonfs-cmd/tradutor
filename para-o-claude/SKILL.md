---
name: tradutor-voz
description: Use no Cowork quando a pessoa usa o Tradutor (programa local em http://127.0.0.1:47810): toda resposta final vai também para o Tradutor, que lê em voz alta com a voz do computador dela.
---

# Tradutor — no Cowork, toda resposta também em voz alta

A pessoa usa o **Tradutor** no Cowork: um programa no computador dela que lê em voz
alta as respostas que você manda e cola na tarefa o que ela fala. Regra: **toda
resposta final vai em texto E para o Tradutor.** Nem resposta curta fica de fora.

## Como mandar

Use o navegador do Claude (o navegador embutido do app, no computador da pessoa):

1. Abra uma aba em `http://127.0.0.1:47810/`. Na primeira vez, o app pede permissão
   para usar esse endereço — peça com escopo do site ("site"), para não perguntar sempre.
2. Rode nessa aba:

```js
const partes = ["frase 1", "frase 2"];
const r = [];
for (const t of partes) {
  const x = await fetch('/recado', {method:'POST', headers:{'Content-Type':'application/json'},
                                    body: JSON.stringify({texto: t})});
  r.push(x.status);
  await new Promise(s => setTimeout(s, 1500));
}
r
```

3. Todas as partes devem voltar **200**. Se falhar (programa fechado, computador
   desligado, aba sem permissão), diga numa linha do texto que a voz não saiu e por quê.

## Como escrever para a voz

- No idioma da pessoa (português ou inglês), falado, frases curtas, de 2 a 8 partes.
- Sem markdown, sem símbolos, sem links, sem nomes de arquivo com extensão.
- Números e endereços por extenso quando importam.
- Nunca fale senhas, chaves ou dados pessoais.
- Mesma ideia do texto, resumida.

## O caminho de volta

Quando a pessoa fala no Tradutor, a frase aparece na caixa do Cowork e ELA aperta Enter
(o Tradutor nunca aperta Enter sozinho, por causa da seção 3 dos Termos da Anthropic).
Chega como uma mensagem normal dela. Responda como a qualquer mensagem.
