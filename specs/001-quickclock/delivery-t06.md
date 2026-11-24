# Entrega T06 e T08 - Docker local

## Implementacao

Compose no frontend com PostgreSQL 17, Spring Boot e Nginx/React. Somente o proxy
publica porta HTTP, em 127.0.0.1 por padrao; API e banco nao publicam portas.
Volume nomeado preserva o banco. Todos os servicos possuem healthcheck, incluindo
o frontend pela imagem. Nginx preserva /api e resolve o endereco da API via DNS Docker.
API roda com usuario sem privilegios e curl para o healthcheck HTTP.
READMEs explicam variaveis, senha, caminhos e acesso opcional pelo IP ZeroTier.

## Evidencias executadas nesta entrega

- Compose config --quiet passou (Docker Compose 2.32.4).
- Imagens frontend e API construidas; TypeScript validado no build frontend.
- Build API executou 22 testes sem falhas.
- up --wait concluiu com os tres servicos saudaveis.
- Flyway aplicou V1 no PostgreSQL real e Hibernate validou o schema ao iniciar.
- HTTP via proxy 18088: empresa criada, settings consultadas/atualizadas para
  10010 centavos e sexta-feira desativada; nome vazio retornou 400 e rota API
  desconhecida retornou 404 sem HTML da SPA.
- down/up sem -v preservou empresa ID 1, valor e expediente no volume de QA.
- API parada retornou HTTP 502 pelo proxy; recuperacao com up --wait confirmou
  novamente os tres servicos saudaveis.

## Limites e pendencias

Usado projeto exclusivo quickclock-t06-qa, volume proprio e porta 18088.
Nenhum dado pessoal foi importado ou volume removido. O check HTTP da API nao
comprova disponibilidade continua do banco; CRUD foi verificado separadamente.
T07 permanece pendente para ZeroTier/Safari reais.
Sem publicacao externa ou release em producao. Stack pessoal requer .env local;
a porta normal documentada e 8088. Issues frontend #11 e backend #9 continuam
abertas, pois incluem tarefas alem desta entrega.
