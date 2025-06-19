# Claude Code Template

## Requirement
- docker compose
- task
- claude max or bedrock

## Setup
```bash
task up
task exec
# login
claude
# after login
claude --dangerously-skip-permissions

# add mcp
claude mcp add  --transport sse taskmaster-http http://taskmaster:4891/sse
```

## Developments
copy develop code to workspace directory.

## FYI
- [claude code](https://github.com/anthropics/claude-code)
- [gwq](https://github.com/d-kuro/gwq)
- [task master](https://github.com/eyaltoledano/claude-task-master)