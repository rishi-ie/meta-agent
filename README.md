# Meta Agent

> Digital Employee Framework for Pi Agent

Transform Pi Agent into a **digital employee factory**. Configure your employee once, launch with one command.

---

## Project Structure

```
meta-agent/                     # Cloned from this repo
│
├── pi/                         # Cloned Pi Agent (run ./run.sh from here)
│   ├── packages/
│   ├── scripts/
│   └── pi-test.sh
│
├── meta-agent-config/          # Edit these files to configure your employee
│   ├── extensions/              # .ts files - custom behavior
│   │   ├── model-router.ts
│   │   ├── memory.ts
│   │   ├── context-manager.ts
│   │   └── persona.ts
│   │
│   ├── skills/                 # .md files - knowledge and behavior
│   │   ├── constitutions/
│   │   │   └── 00-CONSTITUTION.md
│   │   ├── personas/
│   │   │   └── 10-PERSONA.md
│   │   └── domain/
│   │
│   ├── prompts/                # .md files - extra system instructions
│   │   └── extra-instructions.md
│   │
│   └── config.json             # Launch configuration
│
├── run.sh                       # Launch script (run this)
│
├── AGENTS.md                    # Project context (for AI agents)
├── architecture.md               # Full technical documentation
└── LICENSE                      # MIT
```

---

## Quick Start

### 1. Clone This Repo

```bash
git clone https://github.com/rishi-ie/meta-agent.git
cd meta-agent
```

### 2. Clone Pi Agent

```bash
git clone https://github.com/earendil-works/pi.git pi
cd pi && npm install && cd ..
```

### 3. Configure Your Employee

Edit files in `meta-agent-config/`:

| File | What to Edit |
|------|--------------|
| `extensions/*.ts` | Custom behavior code |
| `skills/constitutions/00-CONSTITUTION.md` | Core principles |
| `skills/personas/10-PERSONA.md` | Communication style |
| `prompts/extra-instructions.md` | Extra instructions |
| `config.json` | Launch settings |

### 4. Launch

```bash
./run.sh
```

---

## What You Can Configure

### Skills (Markdown Files)
Knowledge and behavior loaded into system prompt.

```
skills/
├── constitutions/       # Core principles
│   └── 00-CONSTITUTION.md
├── personas/           # Communication style
│   └── 10-PERSONA.md
└── domain/             # Domain knowledge
    └── 20-SKILL-*.md
```

### Extensions (TypeScript Files)
Custom code that runs in Pi Agent.

```
extensions/
├── model-router.ts       # Route tasks to models
├── memory.ts            # Learn and persist
├── context-manager.ts    # Manage context window
└── persona.ts           # Inject behavior
```

### Prompts (Markdown Files)
Extra system instructions.

```
prompts/
└── extra-instructions.md
```

---

## Three Types of Modular Components

| Type | Format | Purpose |
|------|--------|---------|
| **Skills** | .md files | What the employee knows and how it behaves |
| **Extensions** | .ts files | What the employee does (code) |
| **Prompts** | .md files | Extra system instructions |

Every module is either a **Skill**, **Extension**, or **Prompt**.

---

## Configuration

### Edit Skills

Create or edit `skills/constitutions/00-CONSTITUTION.md`:

```markdown
# My Employee Constitution

## Core Principles
1. Always prioritize safety
2. Be transparent about uncertainty

## Boundaries
- DO NOT make unilateral decisions
- DO ask for clarification when unsure
```

### Edit Extensions

Create or edit `extensions/my-extension.ts`:

```typescript
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function myExtension(pi: ExtensionAPI) {
  pi.on("before_agent_start", async (event, ctx) => {
    // Your logic here
  });
}
```

### Update Launch Config

Edit `meta-agent-config/config.json`:

```json
{
  "extensions": [
    "extensions/model-router.ts",
    "extensions/memory.ts"
  ],
  "skills": [
    "skills/constitutions/00-CONSTITUTION.md",
    "skills/personas/10-PERSONA.md"
  ],
  "prompts": [
    "prompts/extra-instructions.md"
  ]
}
```

---

## Skill Priority

Skills load by filename prefix (priority order):

```
00-CONSTITUTION-*  → Loaded first
10-PERSONA-*       → Loaded second
20-SKILL-*         → Loaded third
```

---

## Launch Command

```bash
./run.sh
```

This reads `meta-agent-config/config.json` and runs Pi Agent with all configured extensions and skills.

---

## Architecture

See [architecture.md](./architecture.md) for:
- Extension implementation guides
- Event system reference
- Memory system design
- Model routing algorithms
- Integration details

---

## License

MIT