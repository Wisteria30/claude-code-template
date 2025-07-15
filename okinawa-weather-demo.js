#!/usr/bin/env node

/**
 * 沖縄の天気取得デモンストレーション
 * 
 * このスクリプトは、o3 MCP サーバーを使用して
 * 明日の沖縄の天気情報を取得する方法を示します。
 * 
 * 使用方法：
 * 1. Docker環境を起動: `task up`
 * 2. コンテナに入る: `task exec`
 * 3. Claude Code でo3 MCP サーバーを使用してクエリを実行
 */

const WEATHER_QUERY = "明日の沖縄の天気はどうですか？";

console.log("🌤️  沖縄天気取得デモンストレーション");
console.log("=".repeat(50));
console.log();

console.log("📝 使用方法:");
console.log("1. Docker環境を起動:");
console.log("   task up");
console.log();

console.log("2. コンテナに入る:");
console.log("   task exec");
console.log();

console.log("3. Claude Code でo3 MCP サーバーを使用:");
console.log("   ccmanager");
console.log("   または");
console.log("   claude");
console.log();

console.log("4. Claude Code内で以下のクエリを実行:");
console.log(`   "${WEATHER_QUERY}"`);
console.log();

console.log("🔧 o3 MCP サーバー設定:");
console.log("- OpenAI API Key: 必要");
console.log("- 検索コンテキストサイズ: medium");
console.log("- 推論努力レベル: medium");
console.log("- タイムアウト: 600秒");
console.log();

console.log("📋 期待される結果:");
console.log("o3 MCP サーバーが最新の天気情報を検索し、");
console.log("明日の沖縄の天気予報を提供します。");
console.log();

console.log("⚠️  注意:");
console.log("- OPENAI_API_KEY環境変数が設定されている必要があります");
console.log("- インターネット接続が必要です");
console.log("- 天気情報の精度は検索結果に依存します");

if (require.main === module) {
    // このスクリプトが直接実行された場合の処理
    console.log();
    console.log("🚀 デモンストレーション完了!");
    console.log("実際の天気情報を取得するには、上記の手順に従って");
    console.log("Claude Code環境でo3 MCP サーバーを使用してください。");
}

module.exports = {
    WEATHER_QUERY
};