#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export GRADLE_VERSION=8.10.2

# 1. 必要なツールをインストール (apt-get が利用可能なら実行)
if command -v apt-get >/dev/null 2>&1; then
	sudo apt-get update -y
	sudo apt-get install -y --no-install-recommends curl unzip ca-certificates git git-secrets
else
	echo "[WARN] apt-get not available. Skipping package installation."
fi

# 2. Gradleのインストール
export GRADLE_HOME=/opt/gradle/gradle-${GRADLE_VERSION}
if [ ! -x "${GRADLE_HOME}/bin/gradle" ]; then
	echo "[INFO] Start Download Gradle ${GRADLE_VERSION} to ${GRADLE_HOME}"
	tmpzip="$(mktemp --tmpdir gradle.XXXXXX.zip)"
	curl -fsSL "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o "${tmpzip}"
	sudo mkdir -p /opt/gradle
	sudo unzip -q -d /opt/gradle "${tmpzip}"
	rm -f "${tmpzip}"
	echo "[INFO] End Download Gradle."
fi
export PATH=${GRADLE_HOME}/bin:${PATH}
echo "GRADLE_HOME is set to ${GRADLE_HOME}"

# 3. Javaの環境変数設定
export JAVA_HOME=/usr/lib/jvm/msopenjdk-current
export PATH=${JAVA_HOME}/bin:${PATH}
echo "JAVA_HOME is set to ${JAVA_HOME}"

# 4. バージョン確認 (失敗しても続行)
java -version || true
gradle -v || true

# 5. project-setup のパーミッション設定
chmod +x project-setup.sh || true

# 6. システム全体で恒久的に JAVA_HOME を設定 (可能なら /etc/profile.d、なければユーザの .profile に追記)
if command -v sudo >/dev/null 2>&1; then
	sudo tee /etc/profile.d/00-set-java-home.sh > /dev/null <<'EOF'
export JAVA_HOME=/usr/lib/jvm/msopenjdk-current
export PATH=${JAVA_HOME}/bin:${PATH}
EOF
	sudo chmod 644 /etc/profile.d/00-set-java-home.sh
	echo "/etc/profile.d/00-set-java-home.sh created"
else
	echo "export JAVA_HOME=/usr/lib/jvm/msopenjdk-current" >> "${HOME}/.profile"
	echo "export PATH=\${JAVA_HOME}/bin:\${PATH}" >> "${HOME}/.profile"
	echo "${HOME}/.profile updated (JAVA_HOME appended)"
fi

echo "[INFO] Setup completed successfully."

exit 0
