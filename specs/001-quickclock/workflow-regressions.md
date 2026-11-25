# Regressoes encontradas durante a integracao

## Problema

1. Se a API persistisse um ponto e sua resposta se perdesse, outro clique usava
   o estado antigo e podia desmarcar o periodo ja salvo.
2. Excluir um servico aberto em edicao mantinha o formulario apontando ao ID
   removido. Aprovar um orcamento em edicao tambem deve encerrar aquela edicao.

## Aceite da correcao

- Falha de confirmacao de ponto exige nova leitura antes de outra escrita.
- Nenhum periodo persistido pode ser perdido por reutilizacao do estado antigo.
- Exclusao/aprovacao bem-sucedida encerra a edicao do mesmo registro.
- Testes reproduzem as falhas antes da correcao e passam depois.

Encontrado por revisao QA da entrega T10-T17. Dados usados em testes sao isolados.
