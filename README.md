# Claude Code Template

## Overview
This environment is designed to run Claude Code inside a container using the --dangerously-skip-permissions option.

If you configure a Git repository in the workspace directory on the host machine beforehand, you can run Claude Code with preconfigured parallel execution and MCP settings.

ccmanager supports and simplifies Claude Code’s officially recommended method for parallelisation using Git worktree. Furthermore, enabling Git's useRelativePaths setting and configuring the default worktree path under .git allows you to push changes from the host machine at any time.


- MCP: playwright, lsmcp(+ [add script](./setup/init-claude-mcp.sh))
- Parallelization: ccmanager
- Cost tracking: ccusage

## Requirement
- docker compose
- task
- claude subscription or bedrock
- git version 2.48>=

## GitHub Actions Configuration
When using this template with GitHub Actions (via `.github/workflows/claude.yml`), you need to configure the following repository secrets:

- `CLAUDE_CODE_OAUTH_TOKEN`: Your Claude Code OAuth token for authentication
- `OPENAI_API_KEY`: OpenAI API key required for the o3 search MCP server

## Setup
```bash
task up
task exec
# exec in container shell
cd any-repository
ccmanager # or claude

# MCPs are automatically set up during container creation
# To manually add additional MCPs, edit setup/init-claude-mcp.sh
```

## Developments
The workspace directory is mounted as a volume inside the container, enabling changes to be tracked from the host machine.

## FYI
- [claude code](https://github.com/anthropics/claude-code)
- [gwq](https://github.com/d-kuro/gwq)
- [task master](https://github.com/eyaltoledano/claude-task-master)
- [ccmanager](https://github.com/kbwo/ccmanager)
- [ccusage](https://github.com/ryoppippi/ccusage)

### MCP
#### Playwright
```
claude
/mcp
GoogleのHOMEをスクショして
```