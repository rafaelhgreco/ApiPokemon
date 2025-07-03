# API Pokemon + Frontend Flutter

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- **WSL2** (Windows) ou **Linux** nativo
- **Docker** e **Docker Compose**
- **Flutter SDK** (para o frontend)

## 🐳 Configuração da API (Local)

### 1️⃣ Verificação de Portas

Para evitar conflitos, verifique se as portas necessárias estão disponíveis:

| Serviço | Porta | Descrição |
|---------|-------|-----------|
| API | 3000 | Servidor da aplicação |
| PostgreSQL | 5432 | Banco de dados |

#### Windows (CMD/PowerShell)
```bash
netstat -ano | findstr ":5432"
netstat -ano | findstr ":3000"
```

#### WSL/Linux
```bash
sudo lsof -i :5432
sudo lsof -i :3000
```

> ⚠️ **Importante**: Se algum processo estiver usando essas portas, finalize-o antes de continuar.

### 2️⃣ Construção e Execução

Na raiz do projeto, execute:

```bash
docker-compose up --build
```

O parâmetro `--build` garante que todas as alterações do código sejam aplicadas nas imagens Docker.

### 3️⃣ Verificação dos Contêineres

Confirme se os serviços estão rodando corretamente:

```bash
docker ps -a
```

Você deve ver o status `Up` ou `Running` para:
- `api-pokemon` (aplicação)
- `postgres` (banco de dados)

## 🌐 Acesso à API

Após a configuração, a API estará disponível em:
```
http://localhost:3000
```

## 📱 Frontend Flutter

### Instalação
```bash
flutter pub get
```

### Execução
```bash
flutter run
```

## 🛠️ Comandos Úteis

### Parar os contêineres
```bash
docker-compose down
```

### Ver logs da aplicação
```bash
docker-compose logs -f api-pokemon
```

### Rebuild completo
```bash
docker-compose down
docker-compose up --build
```

## 🐛 Troubleshooting

### Porta já em uso
Se encontrar erro de porta em uso, execute:
```bash
# Para finalizar processo na porta 3000
sudo fuser -k 3000/tcp

# Para finalizar processo na porta 5432
sudo fuser -k 5432/tcp
```

### Contêineres não iniciam
1. Verifique se o Docker está rodando
2. Certifique-se de que tem permissões adequadas
3. Tente executar com `sudo` se necessário
