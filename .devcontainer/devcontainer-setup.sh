#!/usr/bin/env bash

set -euo pipefail 

export DEBIAN_FRONTEND=noninteractive 
export GRADLE_VERSION=8.10.2 

# 1. 必要なツールをインストール 
sudo apt-get update -y 
sudo apt-get install -y --no-install-recommends curl unzip ca-certificates

# 2. Gradleのインストール
export GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION} 
if [ ! -x "${GRADLE_HOME}/bin/gradle" ]; then 
echo "[INFO] Start Download Gradle ${GRADLE_VERSION} to ${GRADLE_HOME}" 
curl -fsSL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/gradle.zip 
sudo mkdir -p /opt/gradle 
sudo unzip -q -d /opt/gradle /tmp/gradle.zip 
echo "[INFO] End Download Gradle Command..." 
fi 
export PATH=${GRADLE_HOME}/bin:${PATH} 
echo "GRADLE_HOME is set to ${GRADLE_HOME}" 

# 3. Javaの環境変数設定
export JAVA_HOME=/usr/lib/jvm/msopenjdk-current 
export PATH=${JAVA_HOME}/bin:${PATH} 
echo "JAVA_HOME is set to ${JAVA_HOME}" 

# 2. バージョン確認 
java -version 
gradle -v 

# 3. porject-setup のパーミッション設定 
chmod +x porject-setup.sh 

echo "[INFO] Setup completed successfully."