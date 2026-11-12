# QuickClock pessoal: trabalhos e financeiro

Status: proposta para revisao do fundador. Esta unica spec cobre o produto;
as tasks permitem entregar por etapas. Nao exige instalacao do Spec Kit.

## Objetivo e contexto

Controlar trabalhos prestados a varias empresas, fechar relatorios mensais e
planejar receitas e despesas pessoais. A PWA evita distribuicao pela App Store.
Flutter e referencia funcional; `web-preview/` e referencia visual experimental,
com dados demonstrativos, e nao e a aplicacao definitiva.

Projetos relacionados:
- Flutter: `/mnt/c/projetos/ponto-eletronico`
- Backend: `/mnt/z/Spring/QuickClock`
- Frontend: `/mnt/z/react/QuickClock`

## Execucao local

Direcao solicitada: executar o sistema localmente no PC usando Docker.
VPS e Cloudflare deixam de ser requisitos da primeira entrega.
Recomendacao: manter Spring Boot e PostgreSQL; servir React e API pela mesma
origem com proxy reverso. Docker Compose sobe frontend, API e banco; volumes
preservam dados entre reinicios. O PC e Docker precisam estar ligados para a API
responder. No iPhone, localhost aponta para o telefone, nao para o PC.

Decisao aprovada: o celular acessa pelo navegador e instala como PWA. ZeroTier
no PC e no celular fornece a rede privada tambem fora de casa. A rede ZeroTier
deve autorizar ambos os dispositivos; o acesso depende de conectividade entre
eles. ZeroTier fornece conectividade, nao substitui HTTPS nem autenticacao.

Servir frontend e API pela mesma origem HTTPS, usando endereco estavel acessivel
pela rede ZeroTier e certificado confiavel no celular. Escolher o mecanismo de
certificado e nome antes da infraestrutura. Nao publicar portas do banco nem
expor a API diretamente na internet; restringir o ingresso ao proxy e a rede
autorizada. Manter Spring Boot e PostgreSQL, sem reescrita do backend.

Na primeira entrega, salvar exige conexao com a API. Nao ha fila de escrita nem
sincronizacao offline. Se PC, Docker, ZeroTier ou API estiverem indisponiveis,
mostrar "Servidor indisponivel" e permitir tentar novamente; nunca confirmar
salvamento sem resposta de sucesso. Cache de arquivos da PWA pode abrir a
interface, mas nao garante dados atuais nem permite salvar. Dados eventualmente
em cache devem ser identificados como desatualizados. Escrita offline fica para
uma evolucao futura, com regras proprias de conflitos e datas.

## Requisitos funcionais

### RF01 Empresas e configuracoes
Criar, listar, editar e desativar empresas preservando historico. Cada empresa
tem valor de meio periodo e dias de expediente; padrao de segunda a sexta.
A empresa selecionada permanece entre acessos. Valores monetarios sao centavos
inteiros; datas de trabalho sao datas locais sem conversao implicita para UTC.

### RF02 Registro diario
Home abre no lancamento de trabalho com dois botoes grandes: manha e tarde.
Estado inicial falso/cinza; marcado verdadeiro/vermelho. Cada toque salva e
mostra estados de salvando, salvo ou erro. Somente hoje pode ser editado, ate
23:59 no fuso definido para o usuario. Passado e futuro sao bloqueados na API.
Dia sem expediente mostra: "Hoje nao ha expediente. Aproveite sua folga!".
Uma data pode existir em varias empresas, uma unica vez em cada empresa.
Usar atribuicao explicita de estado ao salvar para evitar toggles duplicados
por repeticao de requisicao. Falha nunca pode aparecer como salvamento concluido.

### RF03 Consulta
Pesquisar por data e mes/ano, sempre por empresa. Exibir periodos registrados,
estados vazios e falhas com possibilidade de tentar novamente.

### RF04 Servicos adicionais
Cadastrar, consultar, editar e excluir data, descricao e valor por empresa.
Entram no relatorio do mes da prestacao. Confirmar exclusao; itens pagos precisam
de regra de estorno antes de alteracao ou exclusao financeira.

### RF05 Orcamentos
Cadastrar proposta com empresa, data, descricao e valor. Manter historico de
alteracoes e aprovacao. Rascunhos nao geram recebiveis. Aprovacao preserva o
registro e entra no relatorio pelo mes de approved_at; repetir aprovacao nao
duplica cobranca. Alteracoes posteriores nao apagam historico.

### RF06 Relatorios
Selecionar empresa e mes/ano. Mostrar nome da empresa, somente dias com ponto,
periodos, servicos e orcamentos aprovados em secoes separadas e total em reais.
Gerar PDF legivel, imprimivel e compartilhavel. Nao duplicar um orcamento aprovado
como servico adicional. Exemplo de conferencia: outubro/2026 sem finais de semana
e sem 12/10, com 20/10 somente manha: 21 dias, 41 periodos de R$100 = R$4.100.

### RF07 Recebimentos
Separar previsto de recebido. Registrar pagamento com origem, empresa, valor e
data efetiva; entradas financeiras usam o mes do recebimento. Operacao repetida
nao duplica entrada. Relatorio mensal agrega itens, nao cria uma segunda receita
para servicos ou orcamentos ja recebidos individualmente.

### RF08 Despesas e cartoes
Registrar data, descricao, valor, categoria opcional, forma de pagamento e
cartao quando aplicavel. Parcelamento tem grupo, numero 1/n e mes de cada parcela.
A soma das parcelas deve ser exatamente o valor total, distribuindo centavos
restantes de forma deterministica. Exibir planejado e pago separadamente.
Compra de cartao e pagamento da fatura nao podem duplicar a mesma despesa.

### RF09 Dashboard
Acesso por menu; nao substitui a home de trabalho. Seletor de mes e ano aceita
passado e futuro. Mostrar recebido, a receber, despesas pagas, despesas previstas,
saldo realizado e previsto, com detalhes por empresa, categoria, forma de
pagamento e cartao. Cada parcela aparece no mes correspondente. Previsao utiliza
lancamentos conhecidos, sem inventar dias trabalhados futuros.

### RF10 PWA e dados
Interface mobile first, teclado acessivel, rotulos nos controles e estados que
nao dependam apenas de cor. Layout sem rolagem horizontal a partir de 320px.
Manifesto, icones, instalacao e atualizacao segura do cache. Backup e restauracao
do banco com validacao e aviso antes de substituir dados. Nunca armazenar segredos
no frontend nem versionar backups pessoais.

## Decisoes pendentes antes das tasks dependentes

1. Seguranca: definir autenticacao e sessao para o uso pessoal na rede privada.
2. HTTPS: escolher nome estavel e certificado confiavel acessivel pelo ZeroTier.
3. Valor historico: congelar preco por periodo trabalhado e impedir que reajuste
   altere fechamentos antigos? Recomendado, depende de aprovacao e migration.
4. Pagamentos parciais, estornos, fechamento de cartao, vencimento e alteracao
   de parcelas ja pagas precisam de definicao antes do modulo financeiro.

## Arquitetura e qualidade

Manter monolito Spring Boot com dominio independente de framework, casos de uso,
portas e adapters HTTP/persistencia. React usa contratos HTTP documentados e
estado local apenas para interacao/cache; PostgreSQL e fonte dos dados persistidos.
Revisar implementacao existente antes de declarar requisitos atendidos.
TDD: escrever e executar testes de comportamento antes da implementacao (red),
implementar (green) e refatorar. Suite completa ao final de cada branch, sem
repeticao por commit quando nao ha mudanca de codigo. Testar PostgreSQL real
para migrations e constraints; H2 sozinho nao comprova compatibilidade.

## Aceite geral

O fluxo de entrega e as autorizacoes estao em `git-workflow.md`, parte desta spec.

- Todos os fluxos funcionam por empresa sem vazamento entre empresas.
- Regras de datas, dinheiro, idempotencia e parcelas possuem testes negativos.
- Reload preserva dados; reiniciar containers preserva banco.
- PDF confere com registros e total do exemplo RF06.
- Dashboard separa realizado e previsto e respeita mes/ano selecionado.
- Conferencia visual mobile/desktop e testes de navegacao executados.
- Backup restaurado em banco isolado e conferido antes de entrega.
- Limites offline e de acesso documentados e verificados conforme decisao.
- PWA acessivel no celular via ZeroTier fora da rede domestica, com HTTPS
  confiavel; verificar indisponibilidade do PC/API e recuperacao da conexao.
- Sem conexao, escritas sao bloqueadas ou falham claramente sem confirmar sucesso.
- Entrega local nao implica autorizacao para publicar em producao.
