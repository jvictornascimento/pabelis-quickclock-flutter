# Contratos e estrategia de testes

T03: inventario dos contratos atuais e direcao de integracao. API nova deve ser
especificada na task correspondente antes de implementar; nao presumir endpoints.

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
- Consultas com date e month simultaneos precisam de regra explicita em T11.
- HTTP mesma origem via proxy evita expor URL interna da API ao navegador;
  conforme decisao posterior do fundador, HTTPS e service worker estao adiados.

## Testes de aceite planejados

- Dominio: datas antiga/futura, meia-noite, expediente e empresa inativa.
- API: campos ausentes/invalidos, isolamento entre empresas, 404 e save repetido.
- PostgreSQL: migration limpa, constraints e duas escritas para mesma empresa/data.
- UI: loading/erro/vazio, selecao de empresa, reload e feedback de autosave.
- Financeiro: soma exata de parcelas, fronteiras de mes/ano, dupla receita/despesa.
- PWA: HTTPS no celular, arquivos em cache, PC indisponivel e reconexao ZeroTier.
- PDF: exemplo RF06 e correspondencia de totais com API.

Executar testes focados red/green ao desenvolver regras e suite no fechamento da
branch. Resultados efetivamente executados devem constar no PR, sem inferencia.
