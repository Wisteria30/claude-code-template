# Claude Code Template

## Requirement
- docker compose
- task
- claude subscribe or bedrock
- git version 2.48>=

## Setup
```bash
task up
task exec
# exec in container shell
task run

# MCPs are automatically set up during container creation
# To manually add additional MCPs, edit setup/init-claude-mcp.sh
```

## Developments
copy develop code to workspace directory.

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