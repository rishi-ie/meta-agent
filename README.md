# Meta Agent

Digital Employee Framework for Pi Agent. Clone, add API key, run.

## Quick Start

```bash
git clone https://github.com/rishi-ie/meta-agent.git
cd meta-agent
cp meta-agent-config/auth.json.example meta-agent-config/auth.json
# Edit auth.json - add your API key
./run.sh
```

## What It Does

1. Clones Pi Agent (first run)
2. Installs dependencies (first run)
3. Auto-detects provider & model from your API key
4. Launches with your extensions, skills, and prompts

## Structure

```
meta-agent/
├── pi/                    # Pi Agent (cloned automatically)
├── meta-agent-config/     # Your employee config
│   ├── auth.json         # API keys
│   ├── settings.json     # Provider/model
│   ├── extensions/        # Custom code (.ts)
│   └── skills/           # Knowledge (.md)
├── .pi/                   # Local state (gitignored)
└── run.sh                # Launch
```

## Supported Providers

Anthropic, Google, OpenAI, DeepSeek, Groq, Mistral, OpenRouter, Together AI, Fireworks, NVIDIA, Cerebras, Hugging Face

## Auto-Detection

| Provider | Model |
|----------|-------|
| Anthropic | claude-sonnet-4-5 |
| Google | gemini-2.5-flash |
| OpenAI | gpt-4o |
| DeepSeek | deepseek-chat |
| Groq | llama-3.3-70b-versatile |

## Configuration

Edit `meta-agent-config/` files:
- `auth.json` - API keys
- `settings.json` - Override provider/model
- `config.json` - Which extensions/skills to load
- `extensions/*.ts` - Custom behavior
- `skills/*.md` - Constitution, persona, domain knowledge

## License

MIT
