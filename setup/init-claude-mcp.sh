#!/bin/bash
set -euo pipefail

echo "Setting up Claude MCP servers..."

# Playwright MCP
echo "Adding Playwright MCP..."
if ! claude mcp add -s user playwright npx -- -y @playwright/mcp@latest --config /home/node/playwright-config.json; then
    echo "Warning: Failed to add Playwright MCP"
fi

# Typescript MCP
echo "Adding Typescript MCP..."
if ! claude mcp add -s user typescript npx -- -y @mizchi/lsmcp --language=typescript; then
    echo "Warning: Failed to add Typescript MCP"
fi

# o3 MCP (with conditional check)
if [ -n "${OPENAI_API_KEY:-}" ]; then
    echo "Adding o3 MCP..."
    if ! claude mcp add -s user o3 \
        -e OPENAI_API_KEY=$OPENAI_API_KEY \
        -e SEARCH_CONTEXT_SIZE=medium \
        -e REASONING_EFFORT=medium \
        -e OPENAI_API_TIMEOUT=600000 \
        -- npx o3-search-mcp; then
        echo "Warning: Failed to add o3 MCP"
    fi
else
    echo "Skipping o3 MCP (OPENAI_API_KEY not set)"
fi

# Context 7 MCP
echo "Adding Context 7 MCP..."
if ! claude mcp add -s user context7 npx -- -y @upstash/context7-mcp; then
    echo "Warning: Failed to add Context 7 MCP"
fi

# Task Master MCP (with conditional check)
if curl -s --connect-timeout 2 http://taskmaster:4891/health > /dev/null 2>&1; then
    echo "Adding Task Master MCP..."
    if ! claude mcp add -s user --transport sse taskmaster-http http://taskmaster:4891/sse; then
        echo "Warning: Failed to add Task Master MCP"
    fi
else
    echo "Skipping Task Master MCP (service not available)"
fi

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