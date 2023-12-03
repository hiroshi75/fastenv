#!/bin/bash

# アプリ名をコマンドライン引数から取得
APP_NAME=$1

# 引数が指定されていない場合はエラーメッセージを表示して終了
if [ -z "$APP_NAME" ]; then
    echo "アプリ名をコマンドライン引数で指定してください。"
    exit 1
fi

# Viteを使ってReact+TypeScriptのプロジェクトを作成
echo "React+TypeScriptプロジェクトを作成中..."
npm create vite@latest $APP_NAME -- --template react-ts

# 作成したプロジェクトディレクトリに移動
cd $APP_NAME

# 依存関係のインストール
echo "依存関係をインストール中..."
npm install

# Storybookの初期化
echo "Storybookを初期化中...途中でブラウザでStorybookが起動します。それを確認したらCtrl+Cで終了してください。"
npx storybook init --builder @storybook/builder-vite

# ESLintの初期化
echo "ESLintを初期化中..."
npx eslint --init

# .eslintrc.cjsにルールを追加
echo "ESLint設定を更新中..."
sed -i '' '/rules: {/a \
  "react/react-in-jsx-scope": "off",\
' .eslintrc.cjs

# package.jsonにlintスクリプトを追加
echo "package.jsonを更新中..."
sed -i '' '/"scripts": {/a \
  "lint": "eslint src",\
' package.json

# Vitestと関連パッケージのインストール
echo "Vitestをインストール中..."
npm install -D vitest @testing-library/react @testing-library/jest-dom

# Vitestの設定ファイルを作成
echo "Vitest設定ファイルを作成中..."
echo "import { defineConfig } from 'vitest/config';\n\nexport default defineConfig({\n  test: {\n    globals: true,\n    environment: 'jsdom',\n  },\n});" > vitest.config.ts

# package.jsonにテストスクリプトを追加
echo "package.jsonにテストスクリプトを追加中..."
sed -i '' '/"scripts": {/a \
  "test": "vitest",\
  "coverage": "vitest run --coverage",\
' package.json

# Playwrightのインストール
echo "Playwrightをインストール中..."
npm init playwright@latest

echo "環境構築が完了しました。"
