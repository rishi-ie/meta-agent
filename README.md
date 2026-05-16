# Meta-Agent

**Self-evolving cognitive runtime for specialized agents.**

Inspired by [Meta-Harness research](https://arxiv.org/abs/meta-harness) — capability emerges from runtime organization, not model weights.

## Quick Start

```bash
# Install
npm install

# Build
npm run build

# See available commands
node dist/index.js --help
```

## How It Works

```
Job Description
     ↓
Task Library Generation (from real job postings)
     ↓
Harness Compiler reads harness.yaml
     ↓
Council of agents analyze → propose → validate changes
     ↓
Evolution Loop (self-improvement until quality threshold met)
     ↓
Specialist Agent (deployed runtime)
```

### The Key Insight

The same AI model, under different harness configurations, behaves like fundamentally different agents.

**Meta-agent optimizes the harness, not the model.**

## Core Concepts

### 1. Harness (harness.yaml)

A declarative blueprint that defines the entire agent:
- Which components exist (planner, verifier, tools, etc.)
- How they connect (topology/flow)
- Execution settings (model, timeouts, retries)
- What can be evolved

**The harness compiler interprets this file** — change the YAML, change the agent's behavior.

### 2. Constitution (constitution.md)

Universal rules governing evolution:
- Safety boundaries (what the agent cannot do)
- Council governance (how changes are decided)
- Quality thresholds (when evolution stops)

### 3. Task Library

Pre-generated benchmarks from real job postings. The agent evolves to perform well on these tasks.

### 4. Evolution Engine

Single agent + council loop:
1. Run current harness on benchmarks
2. Council analyzes failures
3. Propose harness modifications
4. Test harness validates changes
5. Apply improvements
6. Repeat

### 5. Runtime Compiler

Not hardcoded logic — the compiler reads `harness.yaml` and executes the agent according to that blueprint.

## File Structure

```
meta-agent/
├── harness/
│   ├── harness.yaml      # THE blueprint (evolves)
│   ├── prompts/          # Agent prompts
│   ├── configs/          # Configuration
│   └── subagents/        # Subagent harnesses
├── constitution.md      # Universal rules
├── task_library/        # Pre-generated benchmarks
├── evolution/           # State tracking
│   ├── current.json     # Current state
│   ├── history/          # Generation snapshots
│   └── failure_memory/  # Failed experiments
└── src/                 # Source code
```

## Commands

```bash
# Harness
node dist/index.js harness show       # Display config
node dist/index.js harness validate  # Validate YAML

# Constitution
node dist/index.js constitution show  # Show rules

# Evolution
node dist/index.js evolve start      # Start evolution
node dist/index.js evolve status     # Check progress
node dist/index.js evolve pause      # Pause
node dist/index.js evolve stop       # Stop

# State
node dist/index.js state show        # Current state
node dist/index.js state history     # View history

# Tasks
node dist/index.js tasks list        # List benchmarks
```

## Example: Create a Senior Backend Engineer Agent

```bash
# 1. Write job description
echo "Senior Backend Engineer..." > job.md

# 2. Generate task library from web
node dist/index.js tasks generate job.md

# 3. Start evolution
node dist/index.js evolve start --job job.md --threshold 85

# 4. Wait for specialist to emerge
# Evolution runs until 85% task success rate

# 5. Build and deploy
node dist/index.js build --output ./my-agent
```

## Quality Thresholds

Evolution stops when:
- Task success rate ≥ 85%
- Reliability ≥ 80%
- Efficiency ≤ 2x baseline

Or when max generations (50) reached.

## Safety

The constitution enforces hard boundaries:
- No privilege escalation
- No data exfiltration
- No self-replication outside the system
- Resource limits always enforced

## Development

```bash
# Watch mode
npm run dev

# Test
npm test

# Repl for interactive CLI
npm run cli
```

## License

MIT