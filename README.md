# Meta Agent

> Digital Employee Framework for Pi Agent

Transform Pi Agent into a **digital employee factory**. Configure your employee once, launch with one command.

---

## Project Structure

```
meta-agent/                     # Cloned from this repo
│
├── pi/                         # Cloned Pi Agent
│   ├── packages/
│   ├── scripts/
│   └── pi-test.sh
│
├── meta-agent-config/          # Edit these files to configure your employee
│   ├── config.json             # Which extensions/skills/prompts to load
│   ├── settings.json           # Provider, model, thinking level
│   ├── auth.json               # API keys (create from auth.json.example)
│   ├── auth.json.example       # Template for auth.json
│   │
│   ├── extensions/            # .ts files - custom behavior
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
│   └── prompts/                # .md files - extra system instructions
│       └── extra-instructions.md
│
├── .pi/                        # Local Pi Agent state (gitignored)
│   └── agent/
│       ├── settings.json       # Copied from meta-agent-config on launch
│       ├── auth.json           # Copied from meta-agent-config on launch
│       ├── sessions/           # Your conversation sessions
│       └── bin/                # Local binaries (fd, ripgrep)
│
├── run.sh                      # Launch script (run this)
│
├── AGENTS.md                   # Project context (for AI agents)
├── architecture.md             # Full technical documentation
└── LICENSE                    # MIT
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

### 3. Add Your API Key

```bash
cp meta-agent-config/auth.json.example meta-agent-config/auth.json
```

Edit `meta-agent-config/auth.json` and add your API key:

```json
{
  "anthropic": {
    "type": "api_key",
    "key": "sk-ant-your-actual-key-here"
  }
}
```

### 4. Configure (Optional)

Edit `meta-agent-config/settings.json` to set your provider and model:

```json
{
  "defaultProvider": "anthropic",
  "defaultModel": "claude-sonnet-4-5",
  "defaultThinkingLevel": "medium"
}
```

### 5. Launch

```bash
./run.sh
```

---

## What Happens When You Run `./run.sh`

1. **Creates directories**: `.pi/agent/sessions/`, `.pi/agent/bin/`
2. **Copies settings**: `meta-agent-config/settings.json` → `.pi/agent/settings.json`
3. **Copies auth**: `meta-agent-config/auth.json` → `.pi/agent/auth.json`
4. **Sets environment variables**: `PI_CODING_AGENT_DIR=.pi/agent`
5. **Loads extensions/skills/prompts**: From `meta-agent-config/config.json`
6. **Launches Pi Agent**: With all your configurations

---

## Configuration Files

| File | Purpose | Git Tracked |
|------|---------|-------------|
| `config.json` | Which modules to load | ✅ |
| `settings.json` | Provider, model, thinking | ✅ |
| `auth.json` | API keys | ❌ (add to .gitignore) |
| `extensions/*.ts` | Custom behavior code | ✅ |
| `skills/*.md` | Knowledge and behavior | ✅ |
| `prompts/*.md` | Extra instructions | ✅ |

---

## Three Types of Modular Components

| Type | Format | Purpose |
|------|--------|---------|
| **Skills** | .md files | What the employee knows and how it behaves |
| **Extensions** | .ts files | What the employee does (code) |
| **Prompts** | .md files | Extra system instructions |

Every module is either a **Skill**, **Extension**, or **Prompt**.

---

## Edit Skills

Create or edit `meta-agent-config/skills/constitutions/00-CONSTITUTION.md`:

```markdown
# My Employee Constitution

## Core Principles
1. Always prioritize safety
2. Be transparent about uncertainty

## Boundaries
- DO NOT make unilateral decisions
- DO ask for clarification when unsure
```

---

## Edit Extensions

Create or edit `meta-agent-config/extensions/my-extension.ts`:

```typescript
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function myExtension(pi: ExtensionAPI) {
  pi.on("before_agent_start", async (event, ctx) => {
    // Your logic here
  });
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