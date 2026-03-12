# Kiro Configuration

Kiro IDE configuration with agents, prompts, powers, and settings managed through dotfiles.

## Directory Structure

```
kiro/
├── agents/          # Agent configurations
├── prompts/         # Saved prompt instructions
├── powers/          # Kiro Powers (MCP + documentation)
└── settings/        # Global settings and MCP configuration
```

## Components

### 1. Agents (`agents/`)

Agent configurations define AI agent behavior, available tools, and MCP servers.

**Files:**
- `default_agent.json` - Default agent with all tools enabled
- `genai-rapid.json` - Specialized agent for GenAI RAPID assessments

**Key Configuration:**
- `tools` - Available tools (fsRead, fsWrite, executeBash, etc.)
- `mcpServers` - MCP server references (loaded from settings/mcp.json)
- `resources` - Files automatically loaded as context (README.md, AGENT.md, etc.)
- `prompt` - Custom system prompt for agent

**Usage:**
- Agents are selected in Kiro IDE
- Default agent is used unless specified otherwise

### 2. Prompts (`prompts/`)

Saved prompt instructions that can be injected into conversations using `/prompt` command.

**Available Prompts:**
- `aws-senior-architect.md` - AWS architecture expert with compliance focus
- `python-developer.md` - Python TDD developer (uv, pytest, ruff)
- `cdk-developer.md` - AWS CDK infrastructure developer
- `terraform-developer.md` - Terraform IaC specialist
- `frontend-developer.md` - Frontend developer (React, Vue, Astro, Vitest)
- `openapi-architect.md` - OpenAPI specification architect
- `prompt-developer.md` - Prompt engineering specialist
- `genai-rapid.md` - GenAI RAPID assessment specialist

**Usage:**
```
/prompt aws-senior-architect
```
This loads the prompt content into the current conversation context.

**Format:**
- Plain markdown files
- Include thinking protocols, workflows, constraints
- Can reference MCP tools and best practices

### 3. Powers (`powers/`)

Kiro Powers combine MCP servers with documentation and are automatically activated by keywords.

**Structure:**
```
powers/
├── aws-architect/
│   ├── POWER.md      # Documentation + metadata (keywords)
│   └── mcp.json      # MCP server configuration
├── python-developer/
│   ├── POWER.md
│   └── mcp.json
├── cdk-developer/
│   ├── POWER.md
│   └── mcp.json
├── terraform-developer/
│   ├── POWER.md
│   └── mcp.json
├── frontend-developer/
│   ├── POWER.md
│   └── mcp.json
└── researcher/
    ├── POWER.md
    └── mcp.json
```

**POWER.md Format:**
```yaml
---
name: "power-name"
displayName: "Human Readable Name"
description: "Clear description"
keywords:
  - keyword1
  - keyword2
author: "Your Name"
---

# Documentation content
```

**How Powers Work:**
1. Kiro scans `~/.kiro/powers/` for installed Powers
2. When you mention a keyword in conversation (e.g., "terraform", "cdk", "python")
3. Kiro automatically activates the matching Power
4. MCP servers from `mcp.json` are loaded
5. POWER.md content is added to agent context

**Available Powers:**

| Power | Keywords | MCP Servers |
|-------|----------|-------------|
| aws-architect | aws, architecture, cloud, well-architected, compliance, security, cost-optimization, bedrock, sagemaker | awsKnowledgeBase, context7, awsDiagram, fetch |
| python-developer | python, pytest, tdd, uv, ruff, testing | context7, awsKnowledgeBase, fetch |
| cdk-developer | cdk, aws-cdk, infrastructure, iac, cloudformation, tdd | awsKnowledgeBase, context7, fetch |
| terraform-developer | terraform, iac, infrastructure, aws | awsKnowledgeBase, fetch |
| frontend-developer | frontend, react, vue, astro, vitest, playwright, typescript, accessibility | context7, playwright, fetch |
| researcher | research, documentation, investigation, aws-docs, web-search | awsKnowledgeBase, webSearch, fetch |

**Powers vs Prompts:**
- **Powers**: Automatic activation by keywords + MCP tools + documentation
- **Prompts**: Manual activation via `/prompt` command + instructions only

### 4. Settings (`settings/`)

Global Kiro configuration and MCP server definitions.

**Files:**
- `cli.json` - Kiro CLI settings (beta features, telemetry, etc.)
- `mcp.json` - MCP server configurations

**mcp.json Structure:**
```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "package-name"],
      "env": {
        "API_KEY": "${ENV_VAR}"
      }
    }
  }
}
```

**Available MCP Servers:**
- `awsKnowledgeBase` - AWS documentation and knowledge base
- `context7` - Library documentation (Python, Node, etc.)
- `awsDiagram` - AWS architecture diagram generation
- `documentationGenerator` - Generate documentation from code
- `playwright` - Browser automation and testing
- `webSearch` - Brave Search integration
- `fetch` - HTTP fetch for documentation
- `strands` - Strands Agent SDK documentation

## Installation

Symlinks are created by the dotfiles install script:

```bash
~/.kiro/agents   -> dotfiles/kiro/agents
~/.kiro/prompts  -> dotfiles/kiro/prompts
~/.kiro/settings -> dotfiles/kiro/settings
~/.kiro/powers   -> dotfiles/kiro/powers
```

## Usage Examples

### Using Prompts
```
# In Kiro chat
/prompt aws-senior-architect

# Now ask AWS architecture questions with expert context
```

### Using Powers
```
# Powers activate automatically by keywords
"I need to create a CDK stack for Lambda"
→ cdk-developer Power activates

"Help me with Python testing using pytest"
→ python-developer Power activates

"Design AWS architecture for multi-region deployment"
→ aws-architect Power activates
```

### Using Agents
```
# Select agent in Kiro IDE settings
# Or specify in kiro-cli:
kiro-cli chat --agent genai-rapid
```

## Differences: Prompts vs Powers vs Skills

| Feature | Prompts | Powers | Skills |
|---------|---------|--------|--------|
| **Location** | `~/.kiro/prompts/` | `~/.kiro/powers/` | `~/.kiro/skills/` |
| **Activation** | Manual `/prompt name` | Automatic (keywords) | Automatic (context) |
| **MCP Tools** | ❌ No | ✅ Yes (mcp.json) | ❌ No |
| **Format** | Markdown | POWER.md + mcp.json | SKILL.md |
| **Purpose** | Instructions/context | Tools + documentation | Workflow instructions |
| **Standard** | Kiro-specific | Kiro Powers spec | Open AgentSkills spec |

## MCP Server Configuration

MCP servers can be configured at three levels:

1. **Global** (`~/.kiro/settings/mcp.json`) - Available to all agents/workspaces
2. **Workspace** (`.kiro/settings/mcp.json`) - Workspace-specific servers
3. **Powers** (`~/.kiro/powers/*/mcp.json`) - Auto-loaded when Power activates

Priority: Workspace > Global > Powers

## Best Practices

### Prompts
- Keep focused on specific roles/domains
- Include thinking protocols for structured reasoning
- Reference available MCP tools when relevant
- Use clear sections (Overview, How to work, Constraints)

### Powers
- Choose specific, domain-focused keywords (avoid generic terms like "test", "api")
- Keep POWER.md concise (< 500 lines) or use steering files
- Document all MCP tools with examples
- Include troubleshooting section

### Agents
- Use default agent for general development
- Create specialized agents for specific workflows (e.g., genai-rapid)
- Configure `allowedTools` to restrict tool access when needed
- Use `resources` to auto-load project-specific context

## Troubleshooting

### Powers not activating
- Check keywords in POWER.md frontmatter
- Restart Kiro IDE after adding new Powers
- Verify symlink: `ls -la ~/.kiro/powers`

### MCP servers not loading
- Check `settings/mcp.json` syntax
- Verify environment variables are set
- Check Kiro logs for MCP errors

### Prompts not found
- Verify symlink: `ls -la ~/.kiro/prompts`
- Check file has `.md` extension
- Use exact filename: `/prompt aws-senior-architect`

## Testing

### CLI Testing

Test agents and prompts from command line without opening IDE:

```bash
# Test with default agent
kiro-cli chat --no-interactive --agent default "how to list files changed in the branch"

# Test with specific agent
kiro-cli chat --no-interactive --agent genai-rapid "analyze this GenAI use case"
```

**Flags:**
- `--no-interactive` - Single question/answer, no conversation
- `--agent <name>` - Specify which agent to use

**Use Cases:**
- Quick testing of agent configurations
- CI/CD integration for automated checks
- Scripting repetitive tasks

**Note:** Powers are **only supported in Kiro IDE**, not in kiro-cli. Use IDE to test Power activation.

### IDE Testing

Test Powers in Kiro IDE:

```
# Powers activate automatically by keywords
"I need AWS architecture advice" → aws-architect Power
"Help with Python pytest" → python-developer Power
"Create CDK stack" → cdk-developer Power
"Terraform module for S3" → terraform-developer Power
"React component testing" → frontend-developer Power
```

Check IDE settings/Powers panel to verify installed Powers.

## References

- [Kiro Documentation](https://kiro.dev/docs/)
- [Kiro Powers Repository](https://github.com/kirodotdev/powers)
- [MCP Configuration](https://kiro.dev/docs/mcp/configuration/)
- [Agent Configuration Schema](https://raw.githubusercontent.com/aws/amazon-q-developer-cli/refs/heads/main/schemas/agent-v1.json)
