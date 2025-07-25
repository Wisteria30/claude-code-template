#!/bin/bash
set -euo pipefail

echo "Setting up Claude MCP servers..."

# Playwright MCP
echo "Adding Playwright MCP..."
claude mcp add -s user playwright npx -- -y @playwright/mcp@latest --config /home/node/playwright-config.json

# Typescript MCP
echo "Adding Typescript MCP..."
claude mcp add -s user typescript npx -- -y @mizchi/lsmcp --language=typescript

# o3 MCP
echo "Adding o3 MCP..."
claude mcp add -s user o3 \
	-e OPENAI_API_KEY=$OPENAI_API_KEY \
	-e SEARCH_CONTEXT_SIZE=medium \
	-e REASONING_EFFORT=medium \
    -e OPENAI_API_TIMEOUT=600000 \
	-- npx o3-search-mcp

# Context 7 MCP
echo "Adding Context 7 MCP..."
claude mcp add -s user context7 npx -- -y @upstash/context7-mcp

# Task Master MCP (既にREADMEに記載されているもの)
# echo "Adding Task Master MCP..."
# claude mcp add -s user --transport sse taskmaster-http http://taskmaster:4891/sse

# 他のMCPサーバーを追加したい場合はここに記載
# 例:
# echo "Adding Git MCP..."
# claude mcp add git npx @anthropic/mcp-git@latest
# 
# echo "Adding Filesystem MCP..."
# claude mcp add filesystem npx @anthropic/mcp-filesystem@latest
#
# echo "Adding Slack MCP..."
# claude mcp add slack npx @anthropic/mcp-slack@latest

echo "MCP setup complete!"
exec /bin/zsh