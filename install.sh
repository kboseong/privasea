#!/usr/bin/env bash
set -e

# 0. 현재 tmux 내부인지 확인
if [ -z "$TMUX" ]; then
  TMUX_SESSION_NAME="privasea"
  echo "현재 tmux 세션이 아닙니다. 새로운 tmux 세션($TMUX_SESSION_NAME)에서 스크립트를 실행합니다."
  tmux new -s "$TMUX_SESSION_NAME" "$0"
  # 사용자가 tmux를 detach하거나 session을 종료하면 여기로 돌아와서 스크립트가 종료됨
  exit 0
fi

echo "============================================="
echo "[tmux 세션: $TMUX] Privasea Node Setup 시작"
echo "============================================="
echo ""

################################################
# 1. Docker 설치 확인
################################################
if ! command -v docker &> /dev/null
then
  echo "Docker가 설치되어 있지 않습니다. 설치 진행..."
  sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce
  sudo systemctl start docker
  sudo systemctl enable docker
else
  echo "Docker가 이미 설치되어 있습니다. 건너뜁니다."
fi

echo ""
echo "Docker 버전:"
docker --version
echo ""

################################################
# 2. Privasea 이미지 Pull 여부
################################################
IMAGE_NAME="privasea/acceleration-node-beta:latest"
if ! docker images | grep -q "privasea/acceleration-node-beta"
then
  echo "이미지 [$IMAGE_NAME]이 없으므로 Pull 진행..."
  docker pull "$IMAGE_NAME"
else
  echo "이미지 [$IMAGE_NAME]이 이미 존재합니다. 건너뜁니다."
fi
