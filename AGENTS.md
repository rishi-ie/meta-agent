# Meta Agent - Project Context

> Digital Employee Framework for Pi Agent

## What This Project Is

Meta Agent transforms Pi Agent into a **digital employee factory**. Instead of a generic coding assistant, you create specialized employees with:

- **Constitution** — Domain-specific principles and rules
- **Persona** — Communication style and behavior
- **Skills** — Domain knowledge and capabilities
- **Extensions** — Custom tools (model router, memory, context manager)

This is a documentation-only project. The actual extensions and skills are implemented by users based on the patterns in `architecture.md`.

## Why This Project Exists

The goal is to make Pi Agent modular enough to create specialized digital employees that:
1. Have their own constitution (principles they follow)
2. Have their own persona (how they communicate)
3. Can route tasks to appropriate models
4. Can learn and persist memory across sessions
5. Can actively manage their context window

## Core Design Decisions

### 1. Everything as Extensions or Skills

The framework is built entirely on Pi Agent's extension system. No core modifications needed.

- Extensions: Code that runs in Pi Agent via `-e` flag
- Skills: Markdown files that load into system prompt via `--skill` flag

### 2. Constitution as Skill

A constitution is just a skill (markdown file) that gets loaded first. No special handling needed from Pi Agent.

### 3. Skill Priority via Naming

Skills load by filename prefix:
- `00-CONSTITUTION-*` → Loaded first
- `10-PERSONA-*` → Loaded second
- `20-SKILL-*` → Loaded third

This ensures constitution and persona always apply before domain skills.

### 4. Extensions Monitor Events

Extensions work by subscribing to Pi Agent events:
- `before_agent_start` — Inject context, route model
- `turn_end` — Store facts, check context
- `tool_result` — Learn from results

### 5. No Sub-Agents

The context manager is a single extension, not a sub-agent. It monitors events and acts on them, not a separate agent watching the main agent.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        META AGENT                           │
│                     Digital Employee Factory                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │ Constitution│  │   Persona   │  │   Skills    │          │
│  │   (Skill)   │  │   (Skill)   │  │  (Domain)   │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
│                                                             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐             │
│  │   Model    │  │   Memory   │  │  Context    │             │
│  │   Router   │  │  Extension │  │  Manager    │             │
│  │(Extension) │  │ (Extension)│  │(Extension)  │             │
│  └────────────┘  └────────────┘  └────────────┘             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Extensions (Implemented by Users)

### Model Router Extension
- Listens to `before_agent_start`
- Classifies task by keywords
- Routes to appropriate model (haiku/sonnet/opus)
- Can be rules-based or LLM-based

### Memory Extension
- Listens to `turn_end` and `tool_result`
- Extracts facts from interactions
- Persists via `appendEntry()`
- Retrieves relevant memories on `before_agent_start`

### Context Manager Extension
- Listens to `turn_end`
- Checks context usage via `getContextUsage()`
- Triggers compaction when > 85%
- Provides `/compact` command for manual compaction

### Persona Extension
- Listens to `before_agent_start`
- Generates behavioral cues based on context
- Injects via `sendMessage()`

## Skills (Created by Users)

### Constitution Skill
- Domain principles loaded first
- Format: Core principles, boundaries, escalation
- Naming: `00-CONSTITUTION-[domain].md`

### Persona Skill
- Communication style loaded second
- Format: Communication style, tone, response patterns
- Naming: `10-PERSONA-[domain].md`

### Domain Skills
- Additional knowledge loaded third
- Naming: `20-SKILL-[name].md`

## Employee Configuration

Each employee has a `config.json`:

```json
{
  "name": "medical-assistant",
  "version": "1.0.0",
  "description": "AI assistant for medical documentation",
  
  "constitution": {
    "path": "skills/constitutions/medical/00-CONSTITUTION-medical.md"
  },
  
  "persona": {
    "path": "skills/personas/medical/10-PERSONA-medical.md"
  },
  
  "extensions": [
    "model-router",
    "memory",
    "context-manager",
    "persona"
  ],
  
  "model": {
    "primary": "claude-sonnet",
    "routing": {
      "quick": "claude-haiku",
      "reasoning": "claude-sonnet",
      "strong": "claude-opus"
    }
  }
}
```

## Running an Employee

```bash
# Load extensions
pi -e ./extensions/model-router.ts \
   -e ./extensions/memory.ts \
   -e ./extensions/context-manager.ts \
   -e ./extensions/persona.ts

# Load skills
pi --skill ./skills/constitutions/medical/00-CONSTITUTION-medical.md \
   --skill ./skills/personas/medical/10-PERSONA-medical.md

# Or combined
pi -e ./extensions/... --skill ./skills/...
```

## Directory Structure

```
meta-agent/
├── README.md              # Quick start guide
├── architecture.md         # Full technical documentation
├── AGENTS.md              # This file - project context
├── LICENSE                # MIT
│
├── extensions/            # User-implemented extensions
│   ├── model-router.ts
│   ├── memory.ts
│   ├── context-manager.ts
│   └── persona.ts
│
├── skills/                # User-created skills
│   ├── constitutions/
│   │   ├── 00-CONSTITUTION-template.md
│   │   └── [domain]/
│   │       └── 00-CONSTITUTION-[domain].md
│   ├── personas/
│   │   ├── 00-PERSONA-template.md
│   │   └── [domain]/
│   │       └── 10-PERSONA-[domain].md
│   └── domain/
│
└── employees/             # Employee configurations
    └── [name]/
        └── config.json
```

## Key Events (Extension Development)

| Event | When | Common Uses |
|-------|------|-------------|
| `session_start` | Session begins | Initialize state |
| `session_shutdown` | Session ends | Persist state |
| `before_agent_start` | Before each turn | Inject context, route model |
| `turn_end` | After each turn | Store facts, check context |
| `tool_result` | After tool execution | Learn from results |
| `message_start` | Message begins | Detect context |

## Context API (Extension Development)

```typescript
// Inject message (display: false = not shown in UI)
ctx.sendMessage({ customType: "...", content: "...", display: false });

// Persist data across sessions
ctx.appendEntry("my-data", { key: "value" });

// Access session entries
const entries = ctx.sessionManager.getEntries();

// Get context usage
const usage = ctx.getContextUsage();

// Trigger compaction
ctx.compact({ customInstructions: "Summarize" });

// Switch model
await pi.setModel(targetModel);

// Show notification
ctx.ui.notify("Message", "info");
```

## Testing Extensions

```bash
# Test single extension
pi -e ./extensions/model-router.ts

# Test with skills
pi -e ./extensions/model-router.ts \
   --skill ./skills/constitutions/00-CONSTITUTION-template.md
```

## Future Enhancements

- [ ] Vector-based memory retrieval
- [ ] LLM-based model routing
- [ ] Multi-agent coordination
- [ ] Employee marketplace
- [ ] Version management
- [ ] Testing framework

## Related Projects

- [Pi Agent](https://github.com/earendil-works/pi) - The base framework
- [Pi Agent Extensions](https://pi.dev) - Extension documentation

## Conventions

1. **Skill naming**: Priority prefix (00-, 10-, 20-)
2. **Extension exports**: Default function, receives `ExtensionAPI`
3. **Config format**: JSON with `name`, `version`, `description`
4. **Commands**: Prefix with `/` (e.g., `/compact`, `/memory-show`)
5. **File paths**: Relative to project root

## Memory Storage

### Session Memory
Stored in session via `appendEntry()`:
```typescript
ctx.appendEntry("learned-facts", { fact: "...", timestamp: Date.now() });
```

### Cross-Session Memory
File-based storage:
```
~/.meta-agent/memory/[employee-name].json
```

## Model Routing

### Default Routes (Rules-based)

| Task Type | Keywords | Model |
|-----------|----------|-------|
| Quick | format, lint, typo, comment | haiku |
| Reasoning | debug, fix, refactor, analyze | sonnet |
| Strong | architect, design, complex | opus |

### Advanced (LLM-based)

Can use a model to classify tasks, then route accordingly.

## Security Notes

- Extensions run with full system access
- Only install from trusted sources
- Review constitutions before deployment
- Consider sandboxing for untrusted employees