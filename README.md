# Meta-Agent

**Self-evolving cognitive runtime for specialized agents.**

Inspired by [Meta-Harness research](https://arxiv.org/abs/meta-harness) — capability emerges from runtime organization, not model weights.

## Quick Start

```bash
# View documentation
ls docs/

# System Overview
cat docs/1-system-overview/README.md

# Harness Model
cat docs/2-harness/README.md
```

## What is Meta-Agent?

Meta-agent transforms a job description into a specialized, self-improving AI agent. The agent evolves through iterative benchmarking and self-modification until it reliably performs the target role.

```
Job Description → Task Library → Evolution Loop → Specialist Agent
```

## Key Concepts

### Harness

A declarative blueprint defining the complete cognitive architecture. The harness is the single source of truth — changing it changes agent behavior.

### Constitution

Universal rules governing the system. Applies to every harness regardless of target role. Defines safety boundaries, council governance, and quality standards.

### Task Library

Pre-generated benchmark tasks from real job postings. Defines what "success" looks like for the target role.

### Evolution Engine

Iterative self-improvement loop. Evaluates, proposes, validates, and applies harness modifications.

### Council

Multi-agent system coordinating self-improvement through structured decision-making.

### Sandbox

Isolated execution environment ensuring safe benchmark evaluation.

## Documentation Structure

```
docs/
├── 1-system-overview/      # High-level architecture
├── 2-harness/            # Harness model and sections
├── 3-runtime-compiler/    # How harness is interpreted
├── 4-constitution/        # Universal rules
├── 5-task-library/        # Benchmark generation
├── 6-evolution-engine/    # Self-improvement loop
├── 7-council/             # Multi-agent decision making
├── 8-subagents/            # Task execution agents
├── 9-validation/          # Change testing pipeline
├── 10-sandbox/             # Isolated execution
├── 11-state-management/    # Evolution tracking
├── 12-cli/                 # CLI interface
├── 13-workflows/           # User workflows
├── 14-interactions/        # Component interactions
└── 15-edge-cases/         # Error handling
```

## Module Dependencies

```
1-system-overview          ← Entry point
        │
        ▼
4-constitution              ← Standalone
        │
        ▼
2-harness                  ← Depends on constitution
        │
        ▼
3-runtime-compiler         ← Depends on harness
        │
        ▼
5-task-library              ← Depends on harness
        │
        ▼
9-validation                ← Depends on subagents, task-library
        │
        ▼
8-subagents                 ← Depends on harness, constitution
        │
        ▼
10-sandbox                  ← Depends on subagents, constitution
        │
        ▼
6-evolution-engine          ← Depends on all above
        │
        ▼
7-council                   ← Depends on evolution-engine
        │
        ▼
11-state-management         ← Depends on evolution-engine
        │
        ▼
12-cli                      ← Depends on all modules
        │
        ▼
13-15                       ← Depends on all modules
```

## License

MIT