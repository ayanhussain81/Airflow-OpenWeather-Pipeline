#!/usr/bin/env bash
# Run on a fresh Amazon Linux 2023 EC2 instance:  bash ec2_setup.sh
set -euo pipefail

REPO=https://github.com/ayanhussain81/Airflow-OpenWeather-Pipeline.git

# 1. Docker + Compose v2 plugin
sudo dnf update -y
sudo dnf install -y docker git
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL "https://github.com/docker/compose/releases/download/v2.29.7/docker-compose-linux-$(uname -m)" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# 2. Clone
[ -d Airflow-OpenWeather-Pipeline ] || git clone "$REPO"
cd Airflow-OpenWeather-Pipeline
mkdir -p dags logs plugins config

# 3. .env with a fresh Fernet key
if [ ! -f .env ]; then
  KEY=$(openssl rand -base64 32 | tr '+/' '-_')
  sed "s|^FERNET_KEY=.*|FERNET_KEY=$KEY|; s|^AIRFLOW_UID=.*|AIRFLOW_UID=$(id -u)|" .env.example > .env
fi

# 4. Build + start (sudo because the docker group isn't active in this shell yet)
sudo docker compose build
sudo docker compose up airflow-init
sudo docker compose up -d
echo "Airflow UI: http://<EC2-public-IP>:8080  (user/pass from .env, default airflow/airflow)"
