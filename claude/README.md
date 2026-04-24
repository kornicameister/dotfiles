# Claude Code Agent Configuration

This directory contains custom agents and configuration for Claude Code CLI, replicating the Amazon Q/Kiro agent setup.

## Directory Structure

```
claude/
├── agents/                      # Custom agent definitions
│   ├── terraform-developer.md
│   ├── python-developer.md
│   ├── cdk-developer.md
│   ├── frontend-developer.md
│   ├── aws-senior-architect.md
│   ├── openapi-architect.md
│   ├── prompt-developer.md
│   └── genai-rapid.md
├── settings.json               # Claude Code user settings
├── mcp-servers-template.json   # MCP server configuration template
└── README.md                   # This file
```

## Available Agents

### Default Agent (Router)

**default** - Default agent with intelligent routing (DEFAULT)
- Use for: General questions, exploration, any task where you're unsure
- Automatically suggests specialist agents when appropriate
- Has access to all 3 global MCP servers (context7, fetch, webSearch)
- Can handle simple tasks directly, routes complex tasks to specialists
- **This is the default agent** when you run `claude` without `--agent` flag

### Development Agents

1. **terraform-developer** - Expert Terraform developer for IaC implementations
   - Use for: Terraform configurations, modules, state management
   - Tools: Read, Write, Edit, Bash, Grep, Glob
   - Specialties: TDD, AWS provider, security best practices

2. **python-developer** - Senior Python developer with Django/FastAPI expertise
   - Use for: Python applications, APIs, data processing
   - Tools: Read, Write, Edit, Bash, Grep, Glob
   - Specialties: TDD, modern Python patterns, web frameworks

3. **cdk-developer** - Expert AWS CDK developer for infrastructure as code
   - Use for: CDK stacks, constructs, serverless applications
   - Tools: Read, Write, Edit, Bash, Grep, Glob
   - Specialties: TDD, L1/L2/L3 constructs, CloudFormation

4. **frontend-developer** - Senior frontend developer (React, Vue, Astro)
   - Use for: UI components, web applications, testing
   - Tools: Read, Write, Edit, Bash, Grep, Glob
   - Specialties: Vitest, Playwright, accessibility, performance

### Architecture & Design Agents

5. **aws-senior-architect** - AWS Senior Architect for cloud solutions
   - Use for: Architecture design, compliance, cost optimization
   - Tools: Read, Write, Edit, Bash, Grep, Glob
   - Specialties: Multi-region, security, AI/ML, Well-Architected Framework

6. **openapi-architect** - Expert OpenAPI architect for API specifications
   - Use for: API design, OpenAPI specs, SDK generation
   - Tools: Read, Write, Edit, Bash, Grep, Glob
   - Specialties: OAS 3.x, RESTful design, developer experience

7. **prompt-developer** - Prompt engineering specialist for agent creation
   - Use for: Creating new agent prompts, prompt optimization
   - Tools: Read, Write, Edit, Bash, Grep, Glob
   - Specialties: Minimal prompts, visible execution, actionable workflows

### Assessment Agents

8. **genai-rapid** - GenAI RAPID Assessment Architect (Read-only)
   - Use for: AI readiness assessments, ROI analysis, compliance review
   - Tools: Read, Grep, Glob (no Write or Bash - assessment only)
   - Specialties: RAPID framework, evidence-based analysis, business value

## Using Agents

### Default Behavior (Recommended)

Just run `claude` without any flags - you'll get the **default** agent which will:
- Help with general tasks
- Suggest specialist agents when appropriate
- Use MCP servers for research

```bash
cd /path/to/project
claude
# Uses "default" agent automatically
# It will suggest switching to specialists when needed
```

### Use Specialist Agent Directly

If you know what you need, activate a specialist directly:

```bash
# Use agent for current session
claude --agent terraform-developer

# Or specify when starting Claude Code
cd /path/to/project
claude --agent python-developer
```

### Agent Selection Guide

**Not sure what you need?**
- Just run `claude` - the **default** agent will guide you! 🎯

**Know exactly what you need?**
Use specialist directly:

**Infrastructure Tasks:**
- Terraform configurations → `claude --agent terraform-developer`
- AWS CDK stacks → `claude --agent cdk-developer`
- Architecture design → `claude --agent aws-senior-architect`

**Application Development:**
- Python backend → `claude --agent python-developer`
- React/Vue frontend → `claude --agent frontend-developer`
- API specifications → `claude --agent openapi-architect`

**Specialized Tasks:**
- Create new agent prompts → `claude --agent prompt-developer`
- AI readiness assessment → `claude --agent genai-rapid`

### Example Workflow

```bash
# Start with default assistant
cd ~/dev/my-terraform-project
claude
> "Help me set up a VPC module"

# default agent responds:
# "This looks like a Terraform task. I recommend using terraform-developer agent..."

# Switch to specialist
claude --agent terraform-developer
> "Help me set up a VPC module"
# Now you get expert Terraform help with TDD methodology
```

## MCP Server Configuration

MCP (Model Context Protocol) servers provide additional capabilities to agents like documentation lookup, web search, and AWS integration.

### Required MCP Servers (Global)

The following 3 MCP servers should be configured globally in `~/.claude.json`:

1. **context7** - Library documentation lookup
2. **fetch** - HTTP fetching for external resources
3. **webSearch** - Web search via DuckDuckGo

### Setup Instructions

Since `~/.claude.json` contains user-specific state and should not be symlinked, you need to manually merge the MCP configuration:

#### Option 1: Manual Configuration

1. Open `~/.claude.json` in your editor
2. Add the `mcpServers` section from `mcp-servers-template.json`
3. Merge with existing configuration if present

#### Option 2: Automated Setup (Coming Soon)

Run the setup script:
```bash
# TODO: Create setup-mcp.sh script
./claude/setup-mcp.sh
```

### MCP Configuration Template

See `mcp-servers-template.json` for the complete configuration:

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp"
    },
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    },
    "webSearch": {
      "command": "uvx",
      "args": ["duckduckgo-mcp-server"]
    }
  }
}
```

### Verify MCP Servers

After configuration, verify MCP servers are available:

```bash
claude mcp list
# Should show: context7, fetch, webSearch
```

## Settings

The `settings.json` file configures Claude Code behavior:

- `chat.enableThinking: true` - Show agent reasoning process
- `chat.enableKnowledge: true` - Enable knowledge base integration
- `telemetry.enabled: false` - Disable telemetry
- `autocomplete.fuzzySearch: true` - Enable fuzzy search in autocomplete

## Installation

The agents and settings are automatically symlinked via dotbot:

```yaml
# In install.conf.yaml
~/.claude/agents: claude/agents
~/.claude/settings.json: claude/settings.json
```

After running `./install`, verify:

```bash
ls -la ~/.claude/
# Should show symlinks for agents/ and settings.json
```

## Agent Design Philosophy

All agents follow consistent design principles:

1. **Thinking Protocol** - Show reasoning before acting (UNDERSTAND → ANALYZE → RESEARCH → PLAN → VALIDATE)
2. **Phased Execution** - Requirements capture → Planning → Execution
3. **Test-Driven** - Write tests before implementation
4. **Visible Progress** - State actions before performing them
5. **Minimal Code** - Avoid over-engineering, implement only what's needed
6. **Documentation** - Use plan.md and requirements.md for tracking

## Comparison with Amazon Q/Kiro

| Feature | Amazon Q (Kiro) | Claude Code |
|---------|----------------|-------------|
| **Agent Format** | JSON with `$schema` | Markdown with YAML frontmatter |
| **Config Location** | `~/.kiro/` | `~/.claude/` |
| **MCP Servers** | `kiro/settings/mcp.json` | `~/.claude.json` (merged) |
| **Tool Naming** | `fsRead`, `executeBash` | `Read`, `Bash` |
| **Specialist Agents** | 8 agents | 8 agents (equivalent) |
| **Default Agent** | None | **default** (router) |
| **Agent Routing** | Manual selection | Automatic suggestions |
| **Skills Support** | Limited | Full skill system (/commit, /review-pr) |

## Adding New Agents

To create a new agent:

1. Use the `prompt-developer` agent: `claude --agent prompt-developer`
2. Describe the role and requirements
3. Agent will create a new `.md` file in `agents/` directory
4. Test the new agent: `claude --agent <new-agent-name>`

## Troubleshooting

### Agent not found
```bash
# Verify symlink exists
ls -la ~/.claude/agents/

# Check agent file exists
ls -la ~/.claude/agents/terraform-developer.md
```

### MCP servers not available
```bash
# List configured MCP servers
claude mcp list

# Check ~/.claude.json contains mcpServers section
cat ~/.claude.json | grep -A 10 mcpServers
```

### Settings not applied
```bash
# Verify settings symlink
ls -la ~/.claude/settings.json

# Check settings content
cat ~/.claude/settings.json
```

## Future Enhancements

- [ ] Create `setup-mcp.sh` script for automated MCP configuration
- [ ] Add per-project agent configurations
- [ ] Create agent usage metrics/analytics
- [ ] Add more specialized agents (e.g., rust-developer, go-developer)
- [ ] Integrate additional MCP servers (awsKnowledgeBase, awsDiagram, etc.)

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [MCP Protocol Specification](https://modelcontextprotocol.io/)
- [Agent SDK Documentation](https://github.com/anthropics/claude-agent-sdk)
- [Amazon Q Developer](https://aws.amazon.com/q/developer/)
