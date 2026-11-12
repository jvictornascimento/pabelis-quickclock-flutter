# Entrega inicial T04-T05

## Backlog
15 issues existentes atualizadas (front #1-#11, backend #6-#9), com milestone
QuickClock PWA Local - Spec 001 e IDs de tasks. VPS/Cloudflare retirados das
issues de infraestrutura. Nenhuma issue ampla deve ser fechada parcialmente.

## Frontend
Base no repositorio front: React/TypeScript, Vite, Vitest, cliente /api com timeout,
abort de leituras antigas e erros claros. Empresas: criar, renomear, desativar e
selecionar; settings: valor em centavos e sete dias. Sem empresas demonstrativas,
sem persistencia de registros de negocio no localStorage. Icones reutilizados.
Prototipo original preservado, sem novos registros copiados.

## Verificacao executada
- `npm test`: 15 testes passaram, incluindo rede indisponivel, resposta HTML,
  dinheiro em centavos e resposta de settings atrasada apos troca de empresa.
- `npm run build`: TypeScript e build Vite passaram.
- Chromium: 320px, 390px e 1440px; navegacao, estado vazio e API indisponivel,
  sem overflow horizontal ou erros de pagina. Respostas da API controladas por
  mocks, sem alegacao de teste ponta a ponta contra o backend.

## Limites
T09 continua aberta: testes de backend e aceite completo ainda pendentes.
Sem Compose nesta entrega. Sem registro diario, relatorio ou financeiro conectados.
Esses acessos indicam preparacao; nao apresentam dados ou totais ficticios.
Sem teste no Safari real. Sem teste ponta a ponta contra PostgreSQL/API reais.
Proxy de desenvolvimento aponta para localhost:8080 e pode ser configurado
por API_PROXY_TARGET. URL de desenvolvimento: http://localhost:5174/.
