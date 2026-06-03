# Meta Agent Operating Principles

## Overview

Meta Agent is a digital employee framework built on top of Pi Agent. This file provides guidance for working with the Meta Agent codebase.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        META AGENT                           │
│                     Digital Employee Factory                │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │ Constitution│  │   Persona   │  │   Skills    │          │
│  │   (Skill)   │  │   (Skill)   │  │  (Domain)   │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
│                                                             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐             │
│  │   Model    │  │   Memory   │  │  Context    │             │
│  │   Router   │  │  Extension │  │  Manager    │             │
│  └────────────┘  └────────────┘  └────────────┘             │
└─────────────────────────────────────────────────────────────┘
```

## Directory Structure

```
meta-agent/
├── skills/              # Skill templates
│   ├── constitutions/   # Domain principles
│   ├── personas/        # Communication styles
│   └── domain/          # Domain knowledge
│
├── employees/           # Employee configurations
│   └── [name]/
│       └── config.json
│
├── architecture.md      # Full architecture docs
└── README.md            # User guide
```

## Extension Development

### Creating an Extension

Extensions are standard Pi Agent extensions that:
1. Subscribe to events
2. Register tools and commands
3. Manipulate context

```typescript
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function myExtension(pi: ExtensionAPI) {
  pi.on("before_agent_start", async (event, ctx) => {
    // Handle before each turn
  });
  
  pi.on("turn_end", async (event, ctx) => {
    // Handle after each turn
  });
  
  pi.registerTool({
    name: "my-tool",
    label: "My Tool",
    description: "Does something",
    parameters: Type.Object({ ... }),
    async execute(toolCallId, params, signal, onUpdate, ctx) {
      return { content: [{ type: "text", text: "Done" }] };
    }
  });
  
  pi.registerCommand("my-command", {
    description: "Does something",
    handler: async (args, ctx) => {
      ctx.ui.notify("Done", "info");
    }
  });
}
```

### Key Events

| Event | When | Use Case |
|-------|------|----------|
| `session_start` | Session begins | Initialize state |
| `session_shutdown` | Session ends | Persist state |
| `before_agent_start` | Before each turn | Inject context, route model |
| `turn_end` | After each turn | Store facts, check context |
| `tool_result` | After tool execution | Learn from results |

### Context API

```typescript
// Send message to agent (not shown in UI)
ctx.sendMessage({ customType: "...", content: "...", display: false });

// Persist data across sessions
ctx.appendEntry("my-data", { key: "value" });

// Access session state
const entries = ctx.sessionManager.getEntries();

// Get context usage
const usage = ctx.getContextUsage();

// Trigger compaction
ctx.compact({ customInstructions: "Summarize" });

// Switch model
await pi.setModel(targetModel);
```

## Skill Development

### Naming Convention

Skills use priority prefixes based on filename:

```
00-CONSTITUTION-*  → Priority 1 (loaded first)
10-PERSONA-*       → Priority 2
20-SKILL-*         → Priority 3
```

### Constitution Structure

```markdown
# [Name] Constitution

## Core Principles
1. [Principle 1]
2. [Principle 2]

## Decision Framework
Before any action:
- Does this align with core principles?
- Is there a risk I should consider?

## Boundaries
- DO NOT [prohibited action]
- DO [allowed action]

## Escalation
When uncertain:
1. Ask for clarification
2. Request human review
3. Document the issue
```

### Persona Structure

```markdown
# [Name] Persona

## Communication Style
- [Style 1]
- [Style 2]

## Tone
- [Tone description]

## Vocabulary
- Use: [preferred terms]
- Avoid: [terms to avoid]

## Response Patterns
- Greeting: [how to greet]
- Uncertainty: [how to express uncertainty]
- Closing: [how to close]
```

## Employee Configuration

### config.json

```json
{
  "name": "my-employee",
  "version": "1.0.0",
  "description": "My custom digital employee",
  
  "constitution": {
    "path": "skills/constitutions/my-domain/00-CONSTITUTION-my-domain.md"
  },
  
  "persona": {
    "path": "skills/personas/my-domain/10-PERSONA-my-domain.md"
  },
  
  "extensions": [
    "model-router",
    "memory",
    "context-manager",
    "persona"
  ],
  
  "model": {
    "primary": "claude-sonnet"
  }
}
```

## Running Employees

### Load Extensions

```bash
pi -e ./extensions/model-router.ts \
   -e ./extensions/memory.ts \
   -e ./extensions/context-manager.ts \
   -e ./extensions/persona.ts
```

### Load Skills

```bash
pi --skill ./skills/constitutions/my-domain/00-CONSTITUTION-my-domain.md \
   --skill ./skills/personas/my-domain/10-PERSONA-my-domain.md
```

### Complete Employee

```bash
pi -e ./extensions/model-router.ts \
   -e ./extensions/memory.ts \
   -e ./extensions/context-manager.ts \
   -e ./extensions/persona.ts \
   --skill ./skills/constitutions/my-domain/00-CONSTITUTION-my-domain.md \
   --skill ./skills/personas/my-domain/10-PERSONA-my-domain.md
```

## Code Quality

- Extensions must export a default function
- Use TypeBox for tool parameter schemas
- Follow Pi Agent naming conventions
- Test with `pi -e ./extensions/my-extension.ts`

## Adding New Extensions

1. Create extension file in `extensions/`
2. Export default function receiving `ExtensionAPI`
3. Register handlers, tools, and commands
4. Test with Pi Agent

## Adding New Skills

1. Create skill markdown file
2. Use priority prefix (00-, 10-, 20-)
3. Add to relevant subdirectory
4. Test with employee config

## Adding New Employees

1. Create `employees/[name]/` directory
2. Add `config.json`
3. Create skills directory
4. Add constitution and persona
5. Document in README