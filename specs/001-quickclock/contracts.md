# Contratos e estrategia de testes

Inventario dos contratos implementados e estrategia de verificacao.

## API existente

Base `/api`; JSON com camelCase, datas `YYYY-MM-DD`, mes `YYYY-MM`.
Dinheiro em centavos inteiros, nunca float monetario.

| Metodo | Rota | Uso |
| --- | --- | --- |
| GET | /health | status OK |
| POST/GET | /companies | criar (201) / listar (200) |
| GET/PUT/DELETE | /companies/{id} | consultar, renomear, desativar (200) |
| GET/PUT | /companies/{id}/settings | valor e expediente (200) |
| GET | /companies/{id}/work-days?date=... ou month=... | lista (200) |
| GET/PUT | /companies/{id}/work-days/{date} | consultar/salvar (200) |
| PATCH | /companies/{id}/work-days/{date}/before-lunch/toggle | legado |
| PATCH | /companies/{id}/work-days/{date}/after-lunch/toggle | legado |
| POST/GET | /companies/{id}/additional-services | criar (201), listar por month |
| GET/PUT/DELETE | /companies/{id}/additional-services/{serviceId} | consultar/editar (200), excluir (204) |
| POST/GET | /companies/{id}/estimates | criar/listar; month opcional |
| GET/PUT/DELETE | /companies/{id}/estimates/{estimateId} | consultar/editar rascunho/cancelar |
| POST | /companies/{id}/estimates/{estimateId}/approve | aprovacao idempotente |
| GET | /companies/{id}/estimates/{estimateId}/history | snapshots das alteracoes |
| GET | /companies/{id}/reports?month=YYYY-MM | consolidado mensal |
| POST | /companies/{id}/incomes | recebimento integral da origem |
| DELETE | /companies/{id}/incomes/{incomeId} | estorno simples, 204 |
| GET | /finance?month=YYYY-MM | realizado, previsto e detalhes |
| GET/POST | /cards | listar/criar cartao |
| PUT | /cards/{cardId} | editar cartao; nao altera parcelas existentes |
| GET/POST | /expenses | listar por month/criar despesa e parcelas |
| PUT | /expenses/{expenseId}?scope=ONE\|UNPAID | editar valor de cada parcela em aberto |
| POST | /expenses/{expenseId}/pay | pagar despesa com date |
| DELETE | /expenses/{expenseId} | excluir somente despesa em aberto |

Company request: `{ "name": "Empresa" }`.
Work day request: `{ "workedBeforeLunch": true, "workedAfterLunch": false }`.
Service request: `{ "date": "2026-11-12", "description": "Reparo", "amountCents": 10000 }`.
Settings: halfDayValueCents e weekdays com mondayActive ate sundayActive.
Respostas incluem id, companyId quando aplicavel, createdAt/updatedAt conforme modelo.

Erros de negocio/validacao: 400; registro inexistente: 404.
Corpo existente: `{ "message": "...", "details": [] }`.
Padronizar ainda JSON malformado, falhas de concorrencia e autenticacao nas tasks
respectivas. Interface traduz mensagens tecnicas para feedback em portugues.

## Regras da integracao

- Frontend usa PUT com valores explicitos; nao repete PATCH toggle automaticamente.
- Encerrar loading em sucesso/falha; nao mostrar salvo antes da resposta.
- API indisponivel mostra erro e permite nova tentativa; sem fila offline.
- Fuso configurado deve ser unico para regra de hoje; datas civis nao passam por UTC.
- Consultas de ponto com date e month simultaneos retornam 400.
- HTTP mesma origem via proxy evita expor URL interna da API ao navegador;
  conforme decisao posterior do fundador, HTTPS e service worker estao adiados.

## Testes de aceite planejados

- Dominio: datas antiga/futura, meia-noite, expediente e empresa inativa.
- API: campos ausentes/invalidos, isolamento entre empresas, 404 e save repetido.
- PostgreSQL: migration limpa, constraints e duas escritas para mesma empresa/data.
- UI: loading/erro/vazio, selecao de empresa, reload e feedback de autosave.
- Financeiro: soma exata de parcelas, fronteiras de mes/ano, dupla receita/despesa.
- PWA: HTTP/IP no Safari real, PC indisponivel e reconexao ZeroTier; sem cache offline.
- PDF: exemplo RF06 e correspondencia de totais com API.

Executar testes focados red/green ao desenvolver regras e suite no fechamento da
branch. Resultados efetivamente executados devem constar no PR, sem inferencia.

## Dinheiro, origens e parcelas

WorkDay retorna beforeLunchValueCents/afterLunchValueCents: snapshots fixados
na primeira marcacao do respectivo periodo. Dias vazios nao entram no relatorio.
Orcamentos DRAFT/CANCELED nao entram; APPROVED entra no mes de approvedAt.
Historico guarda descricao, data, valor, status e acao; aprovados sao imutaveis.

Income request: `{sourceType, sourceId, incomeDate}`. Tipos WORK_REPORT
(sourceId e work_day.id), ADDITIONAL_SERVICE e APPROVED_ESTIMATE. Valor lido no servidor;
repetir a origem nao gera outra receita. Estorno remove o recebimento. O relatorio
retorna totalValueCents, receivedValueCents e pendingValueCents das suas origens,
independente do mes em que foram recebidas.

Expense request: `{description,date,amountCents,category,paymentMethod,cardId,
installmentTotal}`. amountCents e o total na criacao e o valor de cada parcela
na edicao. Formas CASH, PIX, DEBIT, CREDIT_CARD, OTHER. Cartao usa name,
closingDay e dueDay; compra no fechamento pertence aquela fatura. Parcelas
preservam centavos, numero/grupo e pagas. Data ajustada ao ultimo dia em meses
curtos. Alterar cartao afeta apenas novas compras.

Finance separa incomeCents/expenseCents pela data efetiva e previstos pela
origem/vencimento. expenses lista vencimentos do mes; paidExpenses lista
pagamentos efetivos do mes, inclusive vencimentos de outro mes. Nunca somar
as duas listas como novas despesas. Datas futuras de pagamento sao recusadas.
