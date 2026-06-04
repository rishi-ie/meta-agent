# Meta Agent

> Digital Employee Framework for Pi Agent

Transform Pi Agent into a **digital employee factory**. Configure your employee once, launch with one command.

---

## Project Structure

```
meta-agent/                     # Cloned from this repo
│
├── pi/                         # Cloned automatically on first run
│
├── meta-agent-config/          # Edit these files to configure your employee
│   ├── config.json             # Which extensions/skills/prompts to load
│   ├── settings.json           # Provider, model, thinking level (auto-detected)
│   ├── auth.json               # API keys (create from auth.json.example)
│   ├── auth.json.example       # Template for auth.json
│   │
│   ├── extensions/            # .ts files - custom behavior
│   ├── skills/                 # .md files - knowledge and behavior
│   └── prompts/                # .md files - extra system instructions
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

Edit `meta-agent-config/auth.json`:
- Find your provider section
- Add your API key to the `key` field

```json
{
  "anthropic": {
    "type": "api_key",
    "key": "sk-ant-your-actual-key-here"
  },
  "google": {
    "type": "api_key",
    "key": ""
  }
}
```

### 3. Run

```bash
./run.sh
```

That's it. Provider and model are **auto-detected** from your API key.

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

## What Happens When You Run `./run.sh`

1. **Checks for Pi Agent**: Clones from GitHub if missing
2. **Installs dependencies**: `npm install` in pi folder
3. **Creates directories**: `.pi/agent/sessions/`, `.pi/agent/bin/`
4. **Auto-detects provider**: Scans `auth.json` for first filled API key
5. **Auto-selects model**: Uses sensible default for your provider
6. **Copies settings**: To `.pi/agent/settings.json`
7. **Copies auth**: To `.pi/agent/auth.json`
8. **Sets environment variables**: `PI_CODING_AGENT_DIR=.pi/agent`
9. **Loads extensions/skills/prompts**: From `meta-agent-config/config.json`
10. **Launches Pi Agent**: With auto-detected configuration

---

## Auto-Detection

If you only fill in one API key, the system automatically:

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

If you want specific settings, edit `meta-agent-config/settings.json`:

```json
{
  "defaultProvider": "anthropic",
  "defaultModel": "claude-opus-4-5",
  "defaultThinkingLevel": "high"
}
```

---

## Configuration Files

| File | Purpose | Git Tracked |
|------|---------|-------------|
| `config.json` | Which modules to load | ✅ |
| `settings.json` | Override provider/model | ✅ |
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