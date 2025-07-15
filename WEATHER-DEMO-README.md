# 沖縄天気取得デモンストレーション

このデモンストレーションは、o3 MCP サーバーを使用して明日の沖縄の天気情報を取得する方法を示します。

## 🚀 クイックスタート

### 1. 環境準備

```bash
# Docker環境を起動
task up

# コンテナに入る
task exec
```

### 2. Claude Code の起動

```bash
# 推奨：並列処理サポート付きで起動
ccmanager

# または通常の起動
claude
```

### 3. o3 MCP サーバーでの天気クエリ

Claude Code内で以下のクエリを実行してください：

```
明日の沖縄の天気はどうですか？詳細な天気予報を教えてください。
```

## 🔧 技術詳細

### o3 MCP サーバー設定

- **コマンド**: `npx o3-search-mcp`
- **環境変数**:
  - `OPENAI_API_KEY`: OpenAI API キー（必須）
  - `SEARCH_CONTEXT_SIZE`: medium
  - `REASONING_EFFORT`: medium
  - `OPENAI_API_TIMEOUT`: 600000ms

### 設定ファイル

設定は `setup/init-claude-mcp.sh` で自動化されています：

```bash
claude mcp add -s user o3 \
    -e OPENAI_API_KEY=$OPENAI_API_KEY \
    -e SEARCH_CONTEXT_SIZE=medium \
    -e REASONING_EFFORT=medium \
    -e OPENAI_API_TIMEOUT=600000 \
    -- npx o3-search-mcp
```

## 📋 使用例

### 基本的な天気クエリ

```
明日の沖縄の天気を教えてください
```

### 詳細な天気情報

```
明日の沖縄県那覇市の天気予報を詳しく教えてください。気温、湿度、降水確率も含めて。
```

### 週間天気予報

```
沖縄の今週の天気予報はどうですか？
```

## 🎯 期待される結果

o3 MCP サーバーは以下の情報を提供します：

- **天気概況**: 晴れ、曇り、雨など
- **気温**: 最高気温・最低気温
- **降水確率**: パーセンテージ
- **湿度**: 相対湿度
- **風速・風向**: 気象条件
- **注意事項**: 台風情報など

## 🛠️ デモスクリプトの実行

```bash
# デモスクリプトを実行
node okinawa-weather-demo.js
```

## ⚠️ 注意事項

1. **API キー**: `OPENAI_API_KEY` 環境変数が必要です
2. **インターネット接続**: 最新の天気情報を取得するため必要です
3. **精度**: 天気情報の精度は検索結果とソースに依存します
4. **タイムアウト**: 複雑なクエリには時間がかかる場合があります

## 🐛 トラブルシューティング

### API キーエラー

```
Error: OPENAI_API_KEY is not set
```

**解決方法**: `.env` ファイルに API キーを設定してください

### タイムアウトエラー

```
Error: Request timeout
```

**解決方法**: クエリをより簡潔にするか、タイムアウト値を増やしてください

### MCP サーバーが見つからない

```
Error: MCP server 'o3' not found
```

**解決方法**: MCP サーバーの初期化を確認してください：

```bash
# MCP サーバーの状態確認
claude mcp list

# 再初期化
/usr/local/bin/init-claude-mcp.sh
```

## 📚 関連リンク

- [Claude Code ドキュメント](https://docs.anthropic.com/en/docs/claude-code)
- [MCP (Model Context Protocol)](https://docs.anthropic.com/en/docs/claude-code/mcp)
- [o3 MCP サーバー](https://www.npmjs.com/package/o3-search-mcp)

## 🤝 コントリビューション

このデモンストレーションの改善提案や追加機能があれば、Issues または Pull Request でお知らせください。