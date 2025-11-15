#!/usr/bin/env bash

set -euo pipefail

groupId="${1:?Usage: $0 <groupId> <artifactId>}"
artifactId="${2:?Usage: $0 <groupId> <artifactId>}"

echo "[INFO] Initializing Gradle project..."
mkdir -p -- "$artifactId"
cd -- "$artifactId"

export JAVA_HOME=/usr/lib/jvm/msopenjdk-current 
export PATH=${JAVA_HOME}/bin:${PATH} 
gradle -q init \
    --type java-application \
    --dsl kotlin \
    --project-name "$artifactId" \
    --package "$groupId" \
    --test-framework junit-jupiter \
    --java-version 21 \
    --use-defaults \
    --no-split-project \
    --no-incubating

echo "[INFO] End Initializing Gradle project..."
