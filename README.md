# java-codespaces
Codespaces 上で Java を学ぶためのサンプルリポジトリ

## 使い方：プロジェクトを作る（最初の手順）
付属スクリプトで Gradle の Java プロジェクトを作成できます。例：

```bash
./project-setup.sh jp.co.example sample
```

上のコマンドは `sample` ディレクトリに Java 21 を使う Gradle プロジェクトを初期化します。

※ すでに同名ディレクトリが存在する場合は上書きされずエラーになります。上書きしたいときはディレクトリを手動で削除するか、将来的に `--force` オプションを追加してください。

## VS Code / Codespaces で開く
作成したフォルダを VS Code（または Codespaces）で開いてください。本リポジトリには `.devcontainer` が含まれており、再現可能な開発環境を提供します。

## devcontainer の再構築と確認
devcontainer の設定を変更した場合や環境を再作成したい場合は、コンテナを再構築して環境変数やツールが正しく設定されているか確認してください。

- **VS Code の UI から再構築**: コマンドパレット（Ctrl/Cmd+Shift+P）で `Dev Containers: Rebuild Container` を実行します（古いバージョンでは `Remote-Containers: Rebuild Container`）。
- **CLI から再構築**: devcontainer CLI を使う場合の手順:

```bash
# 一度だけインストール
npm install -g @devcontainers/cli

# ワークスペースの devcontainer をビルド（再構築）
devcontainer build --workspace-folder /workspaces/java-codespaces
```

- **再構築中に実行されること**: `postCreateCommand` で `./.devcontainer/devcontainer-setup.sh` が実行されます。このスクリプトは（必要に応じて）Gradle をダウンロード・インストールし、`JAVA_HOME` を設定し、可能であれば `/etc/profile.d/00-set-java-home.sh` を作成します（`sudo` がない場合は `~/.profile` に追記するフォールバックがあります）。

- **コンテナ内で簡単に確認するコマンド**: コンテナ内のターミナルで次を実行します。

```bash
echo "JAVA_HOME=$JAVA_HOME"
echo "PATH=$PATH"
gradle -v
```

- **トラブルシュート**:
  - 再構築が失敗した場合は、VS Code の "Dev Containers" 出力チャネルで `postCreateCommand` のログを確認してください。
  - コンテナユーザーに `sudo` 権限がない場合、セットアップスクリプトは `~/.profile` に追記するため、端末を再起動（または再ログイン）して環境変数が反映されるか確認してください。

これらの手順により、`JAVA_HOME` と Gradle が期待どおりに利用できることを確認できます。
