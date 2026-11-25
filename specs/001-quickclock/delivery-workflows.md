# Entrega dos fluxos web - 2026-11-25

Branches coordenadas: `feat/001-t10-workflows` nos tres repositorios.
Escopo aprovado: T09-T24; sem deploy de producao ou migracao de banco pessoal.

- Backend: PR [#11](https://github.com/jvictornascimento/pabelis-quickclock-backend/pull/11), merge `fb2e7aa`.
- Frontend: PR [#15](https://github.com/jvictornascimento/pabelis-quickclock-front/pull/15), merge `85e452a`.
- Issues backend #6-#8 e frontend #2-#10/#14 encerradas pelas entregas verificadas.

## Funcionalidades

- Home com ponto real, autosave explicito, expediente e fuso Sao Paulo.
- Precos historicos por periodo e consulta por data/mes.
- Servicos, orcamentos, historico e aprovacao sem duplicidade.
- Consolidado mensal/PDF com dias marcados, totais, recebido e pendente.
- Recebimentos integrais com origem unica, estorno e bloqueio de origem paga.
- Despesas, cartoes, fechamento/vencimento e parcelas exatas.
- Edicao de uma parcela ou todas em aberto, preservando parcelas pagas.
- Dashboard global pelo menu, meses passados/futuros e realizado/previsto.

## Verificacoes executadas

- Backend: build Docker `mvn -B -ntp package`, 82 testes, nenhuma falha/erro,
  um teste condicional de migration PostgreSQL ignorado na suite H2.
- O teste condicional foi executado separadamente com PostgreSQL 17 real,
  junto de regras/HTTP/concorrencia de ponto: 26 testes passaram.
- Frontend: 36 testes Vitest passaram; build TypeScript/Vite e imagem Docker
  concluidos com sucesso.
- PostgreSQL 17 isolado: snapshots de preco, filtros, historico, aprovacao
  repetida, receitas idempotentes, estorno, isolamento entre empresas, bloqueio
  de origem paga e rejeicao de centavos fracionarios.
- Parcelamento R$100,01/3: 3334,3334,3333 centavos; edicao UNPAID e ONE
  preservou parcela paga e refletiu nos dois meses futuros.
- Chromium real: criar servico, aprovar orcamento, consultar historico,
  financeiro, relatorio e download PDF. Viewports 320,390 e 1440px sem overflow.
- Falha de rede real simulada: PUT persistido com resposta perdida foi
  reconciliado antes da proxima alteracao; falha de leitura nao mostra botoes
  editaveis nem sucesso falso. Regressao vinculada ao frontend #14.
- Outubro/2026: 21 dias, 41 periodos, R$4.100,00; sem dia12, somente manha20.
  PDF baixado e texto conferido com parser, incluindo datas e resumo.

## Reproduzir em QA

Executar Compose no frontend com `.env` de teste, porta livre e projeto separado:

```bash
npm test
npm run build
docker compose --env-file /caminho/qa.env -p quickclock-t06-qa build
docker compose --env-file /caminho/qa.env -p quickclock-t06-qa up -d --wait
```

Nesta verificacao foi usada `http://127.0.0.1:18088/`. Sao dados sinteticos
de QA, nao os registros Flutter nem dados pessoais. Nao executar `down -v`.

## Pendencias e limites

Safari/ZeroTier real, acesso fora de casa, instalacao na tela inicial,
auditoria completa de acessibilidade, backup/restauracao e importacao Flutter
continuam abertos. Sem login, HTTPS, service worker ou fila offline, conforme
decisao aprovada; nao expor o proxy publicamente.

V2 aproxima precos legados usando a configuracao existente (zero se ausente).
Nao e possivel reconstruir precos historicos nunca registrados. Migrar um banco
pessoal exige backup e aprovacao. PDF e gerado no navegador. Pagamentos de uma
origem podem ocorrer em outro mes: relatorio acompanha origens; dashboard
acompanha datas efetivas, sem contar vencimentos como pagamentos duplicados.
