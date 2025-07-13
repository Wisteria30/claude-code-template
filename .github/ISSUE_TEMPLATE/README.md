# Issue Templates

このディレクトリには、自動Issue解決システムで使用するIssueテンプレートが含まれています。

## テンプレート一覧

### 1. 🚨 Bug Fix (High Priority)
- **ファイル**: `bug-fix-high-priority.md`
- **ラベル**: `high`, `bug`
- **用途**: 緊急度の高いバグ修正
- **処理時間**: 最大20分以内に処理開始

### 2. ✨ Feature Request (Middle Priority)
- **ファイル**: `feature-middle-priority.md`
- **ラベル**: `middle`, `enhancement`
- **用途**: 新機能の実装リクエスト
- **処理時間**: 高優先度のIssueがない場合に処理

### 3. 📝 Code Improvement (Low Priority)
- **ファイル**: `improvement-low-priority.md`
- **ラベル**: `low`, `refactoring`
- **用途**: コードの改善やリファクタリング
- **処理時間**: 他の優先度のIssueがない場合に処理

### 4. 🤖 Auto Fix Request
- **ファイル**: `auto-fix-request.md`
- **ラベル**: ユーザーが選択（high/middle/lowのいずれか）
- **用途**: 汎用的な自動修正リクエスト

## 使い方

1. 新しいIssueを作成する際、適切なテンプレートを選択
2. テンプレートに従って必要な情報を記入
3. **重要**: 優先度ラベル（`high`、`middle`、`low`のいずれか）を必ず設定
4. Issueを作成すると、20分以内に自動処理が開始されます

## 自動処理の流れ

1. Auto Issue Resolverが20分ごとに実行
2. 優先度順（high → middle → low）でIssueを検索
3. 未処理のIssueに@claudeメンションを投稿
4. Claude Code Actionが起動し、修正を実装
5. 自動的にPRが作成される

## 注意事項

- 優先度ラベルがないIssueは自動処理されません
- 同時に処理されるのは1つのIssueのみです
- 生成されたPRは必ずレビューしてからマージしてください