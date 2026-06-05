# Meta Agent

Transform Pi Agent into a **digital employee factory**. Create specialized employees with their own personality, knowledge, and behavior.

## What is this?

Instead of one generic AI assistant, you create **digital employees** - each with:
- **Constitution** - Core principles and boundaries
- **Persona** - Communication style and tone
- **Skills** - Domain knowledge and capabilities
- **Extensions** - Custom behavior and tools

Each employee is isolated: its sessions, settings, and configuration live in its own folder and don't interfere with other employees or your global Pi Agent.

## Quick Start

```bash
git clone https://github.com/rishi-ie/meta-agent.git
cd meta-agent
cp meta-agent-config/auth.json.example meta-agent-config/auth.json
# Edit auth.json - add your API key
./run.sh
```

## How It Works

1. Clones Pi Agent (first run)
2. Installs dependencies (first run)
3. Reads your `auth.json` to detect provider and model
4. Loads your extensions, skills, and prompts
5. Launches Pi Agent with your configuration

All data stays in the `.pi/` folder - nothing touches your global `~/.pi/`.

## Project Structure

```
meta-agent/
├── pi/                    # Pi Agent (cloned automatically)
├── meta-agent-config/     # Your employee configuration
│   ├── auth.json         # API keys
│   ├── settings.json     # Provider, model, thinking level
│   ├── config.json       # Which modules to load
│   ├── extensions/       # Custom behavior (.ts files)
│   └── skills/           # Knowledge (.md files)
│       ├── constitutions/  # Core principles
│       ├── personas/       # Communication style
│       └── domain/        # Domain knowledge
├── .pi/                   # Local state (gitignored)
└── run.sh                 # Launch script
```

## Supported Providers

Anthropic, Google, OpenAI, DeepSeek, Groq, Mistral, OpenRouter, Together AI, Fireworks, NVIDIA NIM, Cerebras, Hugging Face

## Auto-Detection

Fill in one API key and the system auto-selects provider and model:

| Provider | Model |
|----------|-------|
| Anthropic | claude-sonnet-4-5 |
| Google | gemini-2.5-flash |
| OpenAI | gpt-4o |
| DeepSeek | deepseek-chat |
| Groq | llama-3.3-70b-versatile |

## Use Cases

- **Medical Assistant** - HIPAA-compliant, conservative recommendations
- **Code Reviewer** - Security-focused, best practices enforcement
- **Research Analyst** - Citation-heavy, fact-checking enabled
- **Customer Support** - Friendly, policy-compliant responses

Create new employees by:
1. Copying the repo
2. Editing constitution/persona/skills
3. Running `./run.sh`

## Architecture

See [architecture.md](./architecture.md) for technical details on extensions, events, and integration.

## License

MIT
