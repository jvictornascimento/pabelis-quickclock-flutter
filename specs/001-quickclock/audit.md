# Auditoria inicial - 2026-11-12

T02: inspecao estatica do backend e prototipo. Nao substitui QA ou testes de runtime.

| Requisito | Situacao observada | Proxima entrega |
| --- | --- | --- |
| RF01 | CRUD com desativacao e settings no backend | T09 integrar e cobrir validacao |
| RF02 | Save explicito, toggles e politica de data | T10 expediente, empresa ativa, fuso e concorrencia |
| RF03 | Consultas por data/mes implementadas | T11 integrar interface e falhas |
| RF04 | CRUD e listagem mensal implementados | T13 integrar e testar fronteiras |
| RF05 | Tabelas iniciais; sem fluxo de API | T14-T15 |
| RF06 | PDF Flutter; web apenas impressao do prototipo | T16-T17 consolidar API e PDF |
| RF07-RF09 | Schema inicial; sem modulo financeiro real | T18-T24 |
| RF10 | Icones e manifesto no prototipo; sem service worker | T25-T28 |

Achados concretos:
- WorkDayService verifica existencia da empresa e data, mas nao consulta settings
  de expediente nem rejeita empresa desativada.
- TimeConfig usa Clock.systemDefaultZone; controller tambem usa YearMonth.now
  sem Clock. Container pode escolher data diferente do usuario.
- Toggles nao sao seguros para repetir automaticamente; frontend deve usar PUT
  com estado desejado, mantendo erro visivel se nao houver confirmacao.
- Requests usam long/boolean primitivos: campo ausente pode virar zero/false;
  rever obrigatoriedade para evitar apagar valores sem intencao.
- Testes HTTP existentes usam datas reais e regex para ler JSON; melhorar com
  Clock fixo e ObjectMapper ao ampliar cobertura.
- Migrations testadas com H2; validar PostgreSQL real antes de declarar compatibilidade.
- Front separado so tem documentacao; AGENTS ainda herdado do Flutter.
- web-preview usa localStorage e empresas de exemplo, sem API, auth ou expediente.
- Valor do periodo configurado recalcula historico no prototipo; depende de T12.

Primeiro passo de codigo: T05 corrigir guia do front e preparar base tipada.
T01 segue parcial: execucao local e rotina aprovadas; regras pendentes continuam
listadas em spec.md. T04 exige atualizar issues remotas antes de iniciar cada escopo.
