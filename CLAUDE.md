# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Claude Code template repository that provides a containerized development environment with pre-configured tools and MCP (Model Context Protocol) servers for enhanced development workflows.

## Common Development Commands

### Container Management
- `task up` - Start Docker containers
- `task down` - Stop Docker containers
- `task restart` - Restart containers (rebuild if needed)
- `task exec` - Execute shell inside the container
- `task ps` - Show container status
- `task build` - Build Docker images

### Inside Container
- `ccmanager` - Run Claude Code with parallelization support (recommended)
- `claude` - Run Claude Code directly
- `ccusage` - Track Claude API usage and costs

## Architecture & Key Components

### Container Setup
- **Base**: Node 22 with Go 1.24.4
- **Git**: Version 2.48+ with `worktree.useRelativePaths` enabled for better worktree management
- **Shell**: Zsh with PowerLevel10k theme
- **Working Directory**: `/workspace` (mounted from host `./workspace`)

### MCP Servers
Automatically configured during container startup:
1. **Playwright** - Browser automation and screenshots
2. **TypeScript LSP** - Language server protocol for TypeScript
3. **o3** - AI-powered search and troubleshooting
4. **Context7** - Latest library information retrieval
5. **Task Master** - SSE-based task management (optional)

### Parallelization with ccmanager
- Uses Git worktrees for parallel Claude instances
- Configuration: `setup/ccmanager-config.json`
- Auto-creates worktrees in `.git/worktree-dir/{branch}`
- Default command: `claude --dangerously-skip-permissions --model opus`

### Key Configuration Files
- `compose.yml` - Docker Compose configuration
- `taskfile.yml` - Task definitions
- `setup/CLAUDE.md` - Claude-specific instructions (mounted to container)
- `setup/init-claude-mcp.sh` - MCP server initialization script
- `setup/ccmanager-config.json` - ccmanager configuration

## Development Workflow

1. Place your Git repositories in the `workspace/` directory on the host
2. Run `task up` to start the environment
3. Run `task exec` to enter the container
4. Navigate to your repository and use `ccmanager` to start Claude Code with parallelization support
5. Git operations can be performed from both container and host due to relative path configuration

## Important Notes

- The `workspace/` directory contains independent projects and should be excluded from this repository's configuration
- Git's `useRelativePaths` is enabled to allow pushing from the host machine
- The container runs with `--dangerously-skip-permissions` flag for Claude Code
- All MCP servers are automatically configured during container initialization