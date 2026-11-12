# Tasks da spec 001

Fonte de requisitos: `spec.md`. Marcar tasks somente com verificacao e evidencias.
Fluxo de branches, commits, PRs e autorizacoes: `git-workflow.md`.
Issues antigas sao referencias, nao comprovacao de aceite desta spec.
Uma branch por task ou conjunto coeso; commits Conventional Commits com escopo e
ingles simples, incluindo motivo e verificacao no corpo quando relevante.

## Planejamento
- [x] T01 Revisar esta spec com o fundador e resolver decisoes pendentes.
  Decisoes aprovadas: HTTP/IP ZeroTier sem login, preco historico, recebimento
  integral, estorno simples e edicao de parcelas em aberto.
- [x] T02 Auditar backend #1-#5 e prototipo; mapear gaps por requisito.
  Evidencia: `audit.md` (inspecao estatica, sem nova execucao de testes).
- [x] T03 Documentar contratos HTTP, erros, datas e dinheiro; definir testes.
  Evidencia: `contracts.md`; contratos novos sao propostas, nao endpoints entregues.
- [x] T04 Ajustar backlog existente: backend #6-#9 e frontend #1-#11; substituir
  requisitos VPS/Cloudflare por execucao local aprovada, sem duplicar issues.
  Evidencia: 15 issues atualizadas via `update-backlog.ps1`, com milestone e tasks.

## Base e infraestrutura local
- [x] T05 Preparar frontend definitivo React/TypeScript no repositorio front,
  aproveitando o prototipo e removendo dados demonstrativos do fluxo real.
  Branch `feat/001-t05-react-foundation`: base tipada, API, empresas/settings,
  testes e build. T09 segue aberta ate verificacao do backend e aceite completo.
- [ ] T06 Criar Compose com API, PostgreSQL e frontend/proxy, volumes e healthchecks.
- [ ] T07 Configurar acesso HTTP/IP privado por ZeroTier sem login/DNS;
  restringir portas ao proxy/rede privada e validar no Safari do celular.
- [ ] T08 Validar build e inicializacao dos containers; documentar comandos e URL.

## Empresas e trabalho
- [ ] T09 Cobrir RF01 com testes de dominio/API; integrar telas de empresas/settings.
- [ ] T10 Cobrir RF02 com testes de fuso, meia-noite, expediente, empresa desativada,
  repeticao de save e concorrencia; corrigir backend e integrar home.
- [ ] T11 Implementar consulta por data/mes com isolamento e estados de erro/vazio.
- [ ] T12 Implementar politica de preco historico aprovada e migrations, se aplicavel.

## Servicos, orcamentos e relatorios
- [ ] T13 Validar CRUD de servicos e filtros de mes; integrar frontend (RF04).
- [ ] T14 Implementar orcamentos/historico/aprovacao e testes (backend #6, RF05).
- [ ] T15 Integrar telas de orcamento, detalhes, historico e confirmacao de aprovacao.
- [ ] T16 Implementar relatorio mensal consolidado (backend #7), testar totais,
  fronteiras de mes e exclusao de dias vazios/rascunhos.
- [ ] T17 Implementar tela e PDF com teste do exemplo de outubro/2026 (RF06).

## Financeiro
- [ ] T18 Definir modelo aprovado de recebiveis/pagamentos e migrations (apos T01).
- [ ] T19 Implementar marcar como pago com origem, data, idempotencia e estorno
  aprovado; testar ausencia de dupla receita (backend #8, RF07).
- [ ] T20 Implementar despesas, categorias e formas de pagamento com validacoes.
- [ ] T21 Implementar cartoes e parcelas: rateio em centavos, datas de fim de mes,
  virada de ano, alteracao e pagamento conforme regras aprovadas (RF08).
- [ ] T22 Integrar telas de recebimentos, gastos, cartoes e parcelas.
- [ ] T23 Implementar agregacoes mensais realizadas/previstas e dashboard (RF09).
- [ ] T24 Testar filtros, saldo, parcelas futuras e ausencia de dupla despesa.

## PWA e persistencia
- [ ] T25 Configurar manifesto e icones; testar adicao a tela inicial no Safari
  por HTTP/IP, sem service worker nem promessa de funcionamento offline.
- [ ] T26 Exigir API disponivel para salvar; mostrar servidor indisponivel e
  permitir nova tentativa. Identificar cache desatualizado, sem fila de escrita.
  Testar perda de conexao, ausencia de falso sucesso e recuperacao via ZeroTier.
- [ ] T27 Implementar exportacao/restauracao validada, testar backup em banco isolado.
- [ ] T28 Avaliar migracao do SQLite Flutter; mapear empresas, datas, valores e
  historico sem importar cargas de teste automaticamente.

## QA e entrega
- [ ] T29 Executar testes unitarios, HTTP e integracao com PostgreSQL real.
- [ ] T30 Executar testes ponta a ponta: empresa -> ponto -> servico/orcamento ->
  relatorio -> recebimento -> financeiro; incluir negativas e falhas de rede.
- [ ] T31 Conferir capturas em 320px, 390px e desktop, acessibilidade e PDF.
- [ ] T32 Conferir seguranca, atualizacao PWA, reinicio e restauracao de backup;
  testar celular fora de casa via ZeroTier/HTTP e PC/Docker/API desligados.
- [ ] T33 Atualizar READMEs e contexto dos tres projetos; registrar resultados,
  limitacoes e passos para uso local. Mergear somente branches verificadas.

Dependencias: T01-T04 antes da implementacao significativa; T07 segue acesso
HTTP/IP aprovado; T12/T18/T21 seguem decisoes registradas. T13-T15 podem seguir
independentemente apos contratos; relatorio depende dos tres tipos de trabalho.
Financeiro depende de origens e pagamentos definidos. QA participa desde T03.
