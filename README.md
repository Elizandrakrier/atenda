# Atenda: helpdesk com IA

Central de chamados com controle de SLA e triagem automática por IA (Gemini).
Projeto de portfólio fullstack: API REST em Java com Spring Boot, MySQL e MongoDB no backend, Next.js com NextAuth no frontend.

> **Status:** em construção. Fase atual: **Fase 0, preparação**.

---

## Sumário

- [Sobre o projeto](#sobre-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Tecnologias](#tecnologias)
- [Arquitetura](#arquitetura)
- [Como rodar localmente](#como-rodar-localmente)
- [Variáveis de ambiente](#variáveis-de-ambiente)
- [Documentação da API](#documentação-da-api)
- [Padrões do projeto](#padrões-do-projeto)
- [Roadmap](#roadmap)
- [Decisões técnicas](#decisões-técnicas)
- [Aprendizados](#aprendizados)
- [Autora](#autora)

---

## Sobre o projeto

**O problema:** em muitas empresas, o atendimento ao cliente ainda vive em planilhas. Chamados chegam sem prioridade definida, ninguém sabe quanto tempo falta para estourar o prazo e o gestor não tem números para decidir.

**A solução:** o Atenda organiza o atendimento de ponta a ponta. O cliente abre o chamado, a IA sugere categoria e prioridade, o atendente confirma e responde (com ajuda de uma sugestão de resposta gerada pela IA), o SLA é acompanhado em tempo real e o gestor vê tudo num painel de métricas.

**Perfis de usuário:**

| Perfil | O que faz |
| --- | --- |
| Cliente | Abre chamados, conversa com o atendente e avalia o atendimento |
| Atendente | Pega chamados da fila, confirma a triagem da IA, responde e resolve |
| Gestor | Acompanha métricas, transfere chamados e cadastra atendentes |

---

## Funcionalidades

Marque conforme for entregando.

- [ ] Cadastro de cliente e login com JWT
- [ ] Login com Google (NextAuth)
- [ ] Abertura e listagem de chamados por perfil
- [ ] Fluxo de status: Aberto, Em atendimento, Aguardando cliente, Resolvido, Fechado
- [ ] Fechamento automático após 3 dias resolvido
- [ ] SLA por prioridade, com pausa em Aguardando cliente, alerta de risco e estouro
- [ ] Mensagens entre cliente e atendente
- [ ] Histórico de eventos do chamado (MongoDB)
- [ ] Triagem automática com Gemini (categoria e prioridade)
- [ ] Mascaramento de dados pessoais antes do envio à IA
- [ ] Sugestão de resposta para o atendente (limite de 5 por chamado)
- [ ] Avaliação do atendimento (nota de 1 a 5)
- [ ] Painel do gestor com taxa de acerto da IA

---

## Tecnologias

| Camada | Tecnologia |
| --- | --- |
| Backend | Java 21, Spring Boot, Spring Web, Spring Data JPA, Spring Data MongoDB, Spring Security, Validation |
| Autenticação | JWT no backend, NextAuth (Auth.js) no frontend |
| Banco relacional | MySQL 8, com migrações pelo Flyway |
| Banco de documentos | MongoDB |
| IA | API do Gemini (Google AI Studio) |
| Frontend | Next.js (App Router), React, Tailwind CSS |
| Testes | JUnit 5, Mockito, Rest Assured |
| Documentação da API | springdoc-openapi (Swagger) |
| Infra | Docker e Docker Compose |
| Design | Protótipo das telas no Claude Design |

---

## Arquitetura

```
atenda/
├── backend/          API REST em Java com Spring Boot
├── frontend/         Next.js com React e NextAuth
├── infra/            docker-compose e arquivos de ambiente
├── docs/             prints, diagramas e decisões do projeto
└── README.md
```

**Onde cada dado fica:**

- **MySQL:** usuários, chamados, mensagens e avaliações. São dados com estrutura fixa e relacionamento entre si.
- **MongoDB:** histórico de eventos do chamado e registro de cada interação com a IA. São registros que crescem rápido, mudam de formato conforme o tipo e são lidos em sequência.

**Organização do backend (por funcionalidade):**

```
backend/src/main/java/com/elizandra/atenda/
├── config/        configurações gerais, Swagger, CORS
├── security/      filtro JWT e Spring Security
├── common/        exceções e tratamento global de erros
├── usuario/
├── chamado/
├── mensagem/
├── avaliacao/
├── sla/
├── evento/        histórico no MongoDB
├── ia/            cliente do Gemini, triagem, sugestão, mascaramento
└── painel/
```

Cada pasta segue as camadas `controller`, `service`, `repository`, `dto` e `entity`.

---

## Como rodar localmente

> Seção a completar ao final da Fase 1 e atualizar a cada fase.

**Pré-requisitos:** JDK 21, Node.js (LTS), Docker Desktop e Git.

1. Clonar o repositório
2. Copiar `infra/.env.example` para `infra/.env` e preencher os valores
3. Subir os bancos com Docker Compose
4. Rodar o backend
5. Rodar o frontend
6. Acessar o sistema e o Swagger

**Usuários de teste:**

| Perfil | E-mail | Senha |
| --- | --- | --- |
| Cliente | a definir | a definir |
| Atendente | a definir | a definir |
| Gestor | a definir | a definir |

---

## Variáveis de ambiente

Nunca suba valores reais para o GitHub. O arquivo `.env` fica no `.gitignore` e só o `.env.example` vai para o repositório.

| Variável | Para quê |
| --- | --- |
| `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DATABASE` | conexão com o MySQL |
| `MYSQL_USER`, `MYSQL_PASSWORD` | usuário do MySQL |
| `MONGO_URI` | conexão com o MongoDB |
| `JWT_SECRET` | chave de assinatura dos tokens |
| `GEMINI_API_KEY` | chave da API do Gemini |
| `NEXTAUTH_URL`, `NEXTAUTH_SECRET` | configuração do NextAuth |
| `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` | login com Google |
| `API_URL` | endereço do backend usado pelo frontend |

---

## Documentação da API

> Link do Swagger a incluir quando o backend estiver rodando.

As regras de negócio completas (RN01 a RN39) e o modelo de dados estão em [`docs/regras-de-negocio.md`](docs/regras-de-negocio.md).

---

## Padrões do projeto

### Branches

| Branch | Uso |
| --- | --- |
| `main` | sempre funcionando; só recebe código por Pull Request |
| `feature/<nome>` | nova funcionalidade. Ex.: `feature/sla`, `feature/triagem-ia` |
| `fix/<nome>` | correção de erro. Ex.: `fix/calculo-pausa-sla` |
| `docs/<nome>` | só documentação. Ex.: `docs/readme-como-rodar` |
| `test/<nome>` | só testes. Ex.: `test/sla-service` |
| `chore/<nome>` | configuração, dependências, ajustes sem regra de negócio |

Regras:

- Nomes em minúsculas, palavras separadas por hífen, sem acento.
- Uma branch por funcionalidade, de vida curta. Terminou, abre o Pull Request e apaga a branch depois do merge.
- Sempre criar a branch a partir da `main` atualizada.

### Commits

Padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/), com a descrição em português:

```
tipo(escopo): descrição curta no imperativo
```

| Tipo | Quando usar |
| --- | --- |
| `feat` | nova funcionalidade |
| `fix` | correção de erro |
| `refactor` | mudança no código sem alterar o comportamento |
| `test` | criação ou ajuste de testes |
| `docs` | documentação (README, comentários, `docs/`) |
| `style` | formatação, sem mudança de lógica |
| `chore` | configuração, dependências, tarefas de manutenção |
| `build` | Docker, Maven, scripts de build |
| `ci` | pipeline de integração contínua |
| `perf` | melhoria de desempenho |

**Escopos sugeridos:** `usuario`, `auth`, `chamado`, `mensagem`, `sla`, `evento`, `ia`, `avaliacao`, `painel`, `front`, `infra`, `readme`.

**Exemplos:**

```
feat(chamado): adiciona abertura de chamado com validação de título
feat(sla): pausa o prazo quando o chamado aguarda o cliente
fix(sla): corrige recálculo do prazo ao trocar a prioridade
test(sla): cobre cenários de pausa e estouro do prazo
feat(ia): mascara CPF, e-mail e telefone antes do envio ao Gemini
docs(readme): adiciona passo a passo para rodar localmente
chore(infra): adiciona MySQL e MongoDB ao docker-compose
```

Regras:

- Descrição com até cerca de 70 caracteres, começando com verbo (adiciona, corrige, remove, ajusta).
- Um commit por mudança lógica. Evite commits como "ajustes" ou "várias coisas".
- Se precisar explicar o porquê, deixe uma linha em branco e escreva no corpo do commit.
- Cite a regra de negócio quando fizer sentido. Ex.: `feat(chamado): fecha chamado resolvido após 3 dias (RN12)`.

### Pull Requests

Título no mesmo padrão do commit. Descrição com:

```
## O que foi feito
## Regras de negócio atendidas (RN)
## Como testar
## Prints (se tiver tela)
## Checklist
- [ ] Rodei a aplicação e testei o fluxo
- [ ] Testes passando
- [ ] Sem dados sensíveis ou chaves no código
- [ ] README atualizado, se necessário
```

### Versões

Uma tag ao fim de cada fase, para marcar a evolução do projeto:

| Tag | Marco |
| --- | --- |
| `v0.1.0` | bancos rodando com Docker |
| `v0.2.0` | backend completo |
| `v0.3.0` | frontend completo |
| `v1.0.0` | projeto no ar |

---

## Roadmap

- [ ] **Fase 0:** preparação do ambiente e repositório
- [ ] **Fase 1:** MySQL e MongoDB com Docker
- [ ] **Fase 2:** backend Java
- [ ] **Fase 3:** frontend Next.js com NextAuth
- [ ] **Fase 4:** projeto completo rodando com Docker Compose
- [ ] **Fase 5:** deploy
- [ ] **Fase 6:** portfólio no Framer

---

## Decisões técnicas

Registre aqui cada decisão importante, com o motivo. Vira material de entrevista.

| Data | Decisão | Motivo |
| --- | --- | --- |
| 16/11/2026 | MySQL para chamados e MongoDB para histórico e IA | dados estruturados e relacionados no relacional; registros que crescem rápido e mudam de formato no documento |
| 16/11/2026 | Chamada ao Gemini só no backend | protege a chave da API e permite mascarar dados pessoais antes do envio |
| 16/11/2026 | Falha da IA não bloqueia o chamado | o cliente nunca fica esperando; o chamado entra como "A classificar" |
| 16/11/2026 | Monorepo | um link só para a história inteira do projeto |

---

## Aprendizados

Anote os problemas que deram trabalho e como resolveu.

| Data | Problema | Como resolvi |
| --- | --- | --- |
| | | |

---

## Autora

**Elizandra Krier**, desenvolvedora backend Java.

- LinkedIn: [linkedin.com/in/elizandra-reis-pereira-krier-467854131](https://www.linkedin.com/in/elizandra-reis-pereira-krier-467854131)
- GitHub: [github.com/Elizandrakrier](https://github.com/Elizandrakrier)
- Portfólio: a incluir

---

## Licença

MIT
