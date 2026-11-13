# infra-monitoring-project

## SSH и SCP

### 1. Генерация SSH-ключей (ssh-keygen)

```bash
ssh-keygen -t ed25519 -C "deploy@infra-monitoring" -f ~/.ssh/infra_deploy
```

Эта команда создаст два файла:
- `~/.ssh/infra_deploy` - приватный ключ, которй мы не должны передавать никомy
- `~/.ssh/infra_deploy.pub` - публичный ключ, который мы передадим на сервер

### 2. Копирование публичного ключа (ssh-copy-id)

```bash
ssh-copy-id -i ~/.ssh/infra_deploy.pub coolUser67@203.0.113.10
```

Чтобы зайти используем следующую команду:
```bash
ssh -i ~/.ssh/infra_deploy coolUser67@203.0.113.10
```

### 3. Передача архива проекта через scp или tar + ssh

#### a. Передача архива проекта через scp

```bash
tar czf smthProject.tar.gz .
scp -i ~/.ssh/infra_deploy smthProject.tar.gz coolUser67@203.0.113.10:~/
ssh -i ~/.ssh/infra_deploy coolUser67@203.0.113.10 'mkdir -p ~/app && tar xzf ~/smthProject.tar.gz -C ~/app'
```

#### b. tar + ssh

```bash
tar czf . | ssh -i ~/.ssh/infra_deploy coolUser67@203.0.113.10 'mkdir -p ~/app && tar xzf ~/smthProject.tar.gz -C ~/app'
```

### 4. Пример команды, которую я использовал бы для деплоя

```bash
ssh -i ~/.ssh/infra_deploy coolUser67@203.0.113.10 'cd ~/app && docker compose up -d'
```

## Запуск

```bash
chmod +x check_api.sh analyze_logs.sh

./check_api.sh https://httpbin.org/status/200
./check_api.sh https://httpbin.org/status/404

./analyze_logs.sh
./analyze_logs.sh 1000

docker compose up -d
curl http://localhost:80
docker compose down
```
