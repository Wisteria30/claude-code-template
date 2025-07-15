# GitHub Actions Workflows

このディレクトリには、プロジェクトの自動化を支援するGitHub Actionsワークフローが含まれています。

## ワークフロー一覧

### 1. Auto Issue Resolver (`auto-issue-resolver.yml`)

**概要**: Issue処理からPR作成まで全体のライフサイクルを管理する統合ワークフローです。

**トリガー**:
- スケジュール実行（20分ごと、24時間365日）
- 手動実行（workflow_dispatch）
- Issue コメント作成時（issue_comment）
- claude/issue-*ブランチへのプッシュ（push）
- Issue クローズ時（issues.closed）

**機能**:
- 優先度（high → middle → low）順にIssueを検索
- 未処理のIssueに@claudeメンションコメントを投稿
- ステートマシンによるラベル管理（queued → working → needs-review → done）
- Claude Code Action（claude.yml）の自動起動をトリガー
- Claudeが作成したブランチの変更を検出してPR作成
- テストとビルドの実行
- エラーハンドリングとラベル更新

### 2. Claude Code Review (`claude-code-review.yml`)

**概要**: プルリクエストの自動コードレビューを行います。

**トリガー**:
- `pull_request`イベント（opened、synchronize）

**機能**:
- PR作成時・更新時に自動的にコードレビューを実施
- コード品質とベストプラクティスの確認
- 潜在的なバグや問題の検出
- パフォーマンスとセキュリティの考慮事項をチェック

### 3. Claude (`claude.yml`)

**概要**: @claudeメンションを検出してClaude Code Actionを実行します。

**トリガー**:
- `issue_comment`イベント（@claudeメンション）
- `pull_request_review_comment`イベント（@claudeメンション）
- `issues`イベント（opened/assigned時に@claudeメンション）
- `pull_request_review`イベント（@claudeメンション）

**機能**:
- Claude Code Actionを使用してコードの修正を実施
- 変更をclaude/issue-*ブランチにプッシュ
- `CLAUDE_CODE_OAUTH_TOKEN`を使用

### 4. Sync Labels (`sync-labels.yml`)

**概要**: GitHubラベルの定義を同期し、ラベル管理を自動化します。

**トリガー**:
- 手動実行（workflow_dispatch）
- mainブランチへのプッシュ（`.github/labels.yml`ファイル変更時）

**機能**:
- `.github/labels.yml`ファイルからラベル設定を読み込み
- リポジトリのラベルを定義に合わせて更新
- 不要なラベルの削除も含む完全同期

## ラベル管理

以下のラベルが自動的に管理されます：

- `claude:queued` - Issueが処理待ちキューに入った状態（一時的）
- `claude:working` - Claudeが修正案を作成中
- `claude:needs-review` - PRが作成され、レビュー待ち
- `claude:done` - Issueがクローズされた状態
- `claude:failed` - 処理中にエラーが発生

## 必要なシークレット

以下のシークレットを設定してください：

- `CLAUDE_CODE_OAUTH_TOKEN` - Claude Code Actionの認証トークン（必須）

## 使用方法

### 自動実行

1. Issueに優先度ラベル（`high`、`middle`、`low`）を付ける
2. スケジュール実行時に自動的に処理される
3. @claudeメンションによりClaude Code Actionが起動
4. Claudeが修正を実装し、ブランチにプッシュ
5. 自動的にドラフトPRが作成される

### 手動実行

1. Actions タブから `Auto Issue Resolver` を選択
2. "Run workflow" をクリック
3. 実行を確認

## 動作フロー

1. **Auto Issue Resolver**が定期的に実行され、未処理のIssueを探す
2. 優先度の高いIssueから順に@claudeメンションコメントを投稿
3. **Claude Code Action**が自動起動し、Issueの内容を分析
4. Claudeが修正を実装し、`claude/issue-*`ブランチにプッシュ
5. **Auto Issue Resolver**がプッシュを検出してPRを作成
6. **Claude Code Review**が新しいPRを自動レビュー
7. ラベルが自動更新され、レビュー待ち状態になる
8. **Sync Labels**によりラベル管理が自動化される

## 注意事項

- 生成されたPRは必ずレビューしてからマージしてください
- テストが失敗した場合でもPRは作成されます（ドラフト状態）
- 同じIssueに対して複数の処理が同時実行されないよう、concurrencyグループが設定されています
- ANTHROPIC_API_KEYは使用しません（Claude Code Actionを利用）
- Personal Access Token (PAT)は不要です（GITHUB_TOKENで十分な権限があります）
- Auto Issue Resolverは統合機能として、Issue処理からPR作成までの全フローを管理します