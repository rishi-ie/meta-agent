# Meta Agent

> Digital Employee Framework for Pi Agent

Transform Pi Agent into a **digital employee factory**. Configure your employee once, launch with one command.

---

## Project Structure

```
meta-agent/                     # Cloned from this repo
│
├── pi/                         # Cloned automatically on first run
│   ├── packages/               # Pi Agent packages
│   ├── scripts/
│   └── pi-test.sh              # Pi Agent launcher
│
├── meta-agent-config/          # Edit these files to configure your employee
│   ├── config.json             # Which extensions/skills/prompts to load
│   ├── settings.json           # Provider, model, thinking level
│   ├── auth.json               # API keys (create from auth.json.example)
│   ├── auth.json.example       # Template for auth.json
│   │
│   ├── extensions/             # .ts files - custom behavior
│   │   ├── model-router.ts     # Routes tasks to appropriate models
│   │   ├── memory.ts           # Learns and persists across sessions
│   │   ├── context-manager.ts  # Manages context window
│   │   └── persona.ts          # Injects behavioral guidance
│   │
│   ├── skills/                 # .md files - knowledge and behavior
│   │   ├── constitutions/      # Core principles (priority: 00-)
│   │   │   └── 00-CONSTITUTION.md
│   │   ├── personas/           # Communication style (priority: 10-)
│   │   │   └── 10-PERSONA.md
│   │   └── domain/             # Domain knowledge (priority: 20-)
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

### 2. Add Your API Key

```bash
cp meta-agent-config/auth.json.example meta-agent-config/auth.json
```

Edit `meta-agent-config/auth.json` and fill in ONE provider's API key:

```json
{
  "anthropic": {
    "type": "api_key",
    "key": "sk-ant-your-actual-key-here"
  },
  "google": { "type": "api_key", "key": "" },
  "openai": { "type": "api_key", "key": "" }
}
```

### 3. Run

```bash
./run.sh
```

That's it. Provider and model are **auto-detected** from your API key.

---

## What Happens When You Run `./run.sh`

1. **Checks for Pi Agent**: Clones from GitHub if missing
2. **Installs dependencies**: `npm install` in pi folder
3. **Creates directories**: `.pi/agent/sessions/`, `.pi/agent/bin/`
4. **Auto-detects provider**: Scans `auth.json` for first filled API key
5. **Auto-selects model**: Uses sensible default for your provider
6. **Copies settings**: To `.pi/agent/settings.json`
7. **Copies auth**: To `.pi/agent/auth.json`
8. **Sets environment variables**: `PI_CODING_AGENT_DIR=.pi/agent`
9. **Loads extensions**: From `meta-agent-config/extensions/`
10. **Loads skills**: From `meta-agent-config/skills/`
11. **Loads prompts**: From `meta-agent-config/prompts/`
12. **Launches Pi Agent**: With all configurations

---

## Supported Providers

| Provider | API Key Env Var |
|-----------|-----------------|
| Anthropic | `ANTHROPIC_API_KEY` |
| Google | `GEMINI_API_KEY` |
| OpenAI | `OPENAI_API_KEY` |
| DeepSeek | `DEEPSEEK_API_KEY` |
| Groq | `GROQ_API_KEY` |
| Mistral | `MISTRAL_API_KEY` |
| OpenRouter | `OPENROUTER_API_KEY` |
| Together AI | `TOGETHER_API_KEY` |
| Fireworks AI | `FIREWORKS_API_KEY` |
| NVIDIA NIM | `NVIDIA_API_KEY` |
| Cerebras | `CEREBRAS_API_KEY` |
| Hugging Face | `HF_TOKEN` |

---

## Auto-Detection

If you fill in only ONE API key, the system automatically:

1. Detects which provider you have credentials for
2. Selects a sensible default model for that provider
3. Uses `medium` thinking level by default

| Provider | Auto-Selected Model |
|----------|---------------------|
| Anthropic | `claude-sonnet-4-5` |
| Google | `gemini-2.5-flash` |
| OpenAI | `gpt-4o` |
| DeepSeek | `deepseek-chat` |
| Groq | `llama-3.3-70b-versatile` |
| Mistral | `mistral-large-latest` |
| OpenRouter | `anthropic/claude-3.5-sonnet` |
| Together | `meta-llama/Llama-3.3-70B-Instruct` |

---

## Override Auto-Detection

To use specific settings, edit `meta-agent-config/settings.json`:

```json
{
  "defaultProvider": "anthropic",
  "defaultModel": "claude-opus-4-5",
  "defaultThinkingLevel": "high"
}
```

---

## Skill Priority System

Skills load by filename prefix (priority order):

```
00-CONSTITUTION-*  → Loaded first (core principles)
10-PERSONA-*       → Loaded second (communication style)
20-SKILL-*         → Loaded third (domain knowledge)
```

This ensures constitution always applies before persona, and both apply before domain skills.

---

## Configuration Files

| File | Purpose | Git Tracked |
|------|---------|-------------|
| `config.json` | Which modules to load | ✅ |
| `settings.json` | Provider, model, thinking | ✅ |
| `auth.json` | API keys | ❌ |
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

---

## Pre-Built Extensions

The following extensions are included (see `meta-agent-config/extensions/`):

| Extension | Purpose |
|-----------|---------|
| `model-router.ts` | Routes tasks to appropriate models |
| `memory.ts` | Learns and persists facts across sessions |
| `context-manager.ts` | Manages context window to prevent overflow |
| `persona.ts` | Injects behavioral guidance |

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