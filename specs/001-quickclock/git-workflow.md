# Fluxo Git e autorizacoes - Spec 001

## Organizacao

- Spec central: Flutter, diretorio `specs/001-quickclock/`. Front/backend devem
  referenciar o link GitHub e manter PROJECT_CONTEXT.md alinhado.
- Backend e frontend continuam repositorios separados; migrar o prototipo para
  o front em tarefa propria, sem apagar arquivos locais pessoais.
- Criar milestone `QuickClock PWA Local - Spec 001` em cada repo envolvido.
- Aproveitar issues existentes; agrupar tasks pequenas relacionadas na mesma issue.
- Issue inclui IDs Txx, escopo, dependencias, aceite e verificacoes esperadas.
- O checklist nao comprova implementacao: marcar concluido somente apos verificacao.

## Branches

Partir de main sincronizada, verificar arvore de trabalho e divergencias antes
de editar. Nao misturar mudancas pessoais nem sobrescrever trabalho de terceiros.

Padrao: `<tipo>/001-tNN-descricao-curta`, em ingles simples.

Exemplos:
- `feat/001-t09-company-settings`
- `feat/001-t10-daily-work`
- `fix/001-t10-save-retry`
- `docs/001-t03-api-contracts`
- `chore/001-t06-local-compose`

Uma branch por task ou grupo coeso documentado na issue. Alteracoes coordenadas
em front/backend usam branches e PRs separados, vinculados entre si. Contrato e
backend devem estar disponiveis antes do merge da integracao frontend dependente.

## Commits e verificacao

Conventional Commits: `tipo(escopo): descricao`, ingles nivel B1, pequenos e focados.
Tipos usuais: feat, fix, test, refactor, docs, build, chore e ci.

Exemplo:
```text
feat(workday): block entries on days off

Read the company schedule before saving a work day.
Keep past records available for reports.

Refs #4
```

TDD usa execucao red/green focada na regra. Rodar suite completa, build e demais
checks pertinentes no final da branch, sem repeticao automatica a cada commit.
Falha ou limitacao relevante fica registrada; nao declarar aceite sem evidencia.

## Entrega por issue

1. Escolher issue com dependencias resolvidas e decisoes de produto aprovadas.
2. Criar branch, implementar e commitar em partes pequenas.
3. Verificar criterios e revisar diff, segredos e arquivos gerados.
4. Fazer push da branch; criar PR para main com tasks, testes e limitacoes.
5. Vincular issue com `Closes #N` somente quando seu escopo inteiro for atendido.
6. Usar merge commit para preservar commits; titulo Conventional Commits,
   por exemplo `chore(merge): complete company settings`.
7. Confirmar push/merge remoto; atualizar checklist e fechar issue atendida.
8. Prosseguir para proxima issue desbloqueada. Nao fazer deploy implicitamente.

GitHub e push devem usar PowerShell quando necessario para aproveitar a
autenticacao Windows ja configurada. Nao registrar tokens ou senhas em comandos,
arquivos versionados ou logs. Nao instalar bypass de revisao/checks.

## Autorizacoes ja concedidas

O fundador ja autorizou branches, commits pequenos, push para origin e merges
de entregas verificadas durante o desenvolvimento, pois o projeto nao esta no ar.
Tambem autorizou preparar spec/tasks e a execucao local Docker/PWA via ZeroTier.
Essas autorizacoes nao aprovam regras ainda pendentes nem publicacao em producao.

## Pacote proposto para aprovacao antecipada

Status: aprovado pelo fundador em 2026-11-12 ao autorizar o inicio da spec.
Aplicar somente ao escopo de rotina abaixo; as excecoes continuam exigindo aval.

- Gerenciar issues, milestones e PRs da spec nos tres repositorios, preservando
  historico e ajustando requisitos VPS/Cloudflare para execucao local.
- Implementar tasks cujas regras estejam aprovadas, corrigir defeitos dentro do
  escopo e continuar entre tarefas sem nova confirmacao de rotina.
- Instalar dependencias necessarias e executar testes, builds e containers locais;
  baixar imagens, usar portas livres e parar somente containers desta tarefa.
- Adicionar migrations incrementais previstas no modelo aprovado, validadas em
  banco de teste. Migrar banco pessoal existente exige backup e aprovacao propria.
- Reorganizar o prototipo no frontend e sincronizar documentacao sem remover dados
  pessoais; nunca incluir bancos, PDFs pessoais, .env ou segredos nos commits.

## Acoes que continuam exigindo aprovacao especifica

- Mudanca de regra de negocio, escopo significativo ou arquitetura aprovada.
- Novas decisoes ou alteracoes das regras aprovadas. Login e HTTPS foram
  dispensados na primeira entrega por decisao posterior registrada em spec.md;
  preco historico, pagamentos e parcelas tambem ja possuem regra aprovada.
- Excluir/substituir dados pessoais, importar sobre banco existente, remover volumes
  Docker ou executar migrations destrutivas/alteracoes criticas de banco.
- Force-push, reescrever historico compartilhado, remover repositorios ou mudar
  visibilidade e permissoes de acesso.
- Gastos, contratacao, exposicao publica de servicos e release em producao.
- Acesso a contas ZeroTier, autorizacao de dispositivos e instalacao de certificados
  confiaveis no celular/sistema devem seguir configuracao aprovada pelo fundador.

Autorizacao de produto nao elimina bloqueios tecnicos do sandbox. A ferramenta
pode solicitar permissao para rede, Docker ou escrita fora do workspace, mesmo
com o trabalho aprovado. Pedir a permissao necessaria sem ampliar seu escopo.
