# Claude Code Template

## Requirement
- docker compose
- task
- claude max or bedrock

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