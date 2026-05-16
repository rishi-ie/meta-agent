# System Overview

## Purpose

Meta-agent transforms a job description into a specialized, self-improving AI agent. The agent evolves through iterative benchmarking and self-modification until it reliably performs the target role.

## Core Philosophy

```
Agent capability = Harness organization, not model weights
```

The same base model, under different harness configurations, produces fundamentally different agents. Meta-agent optimizes the harness — the cognitive runtime — not the underlying model.

## High-Level Architecture

```
USER (uploads job description)
     │
     ▼
INPUT PROCESSING
     │
     ├── Job Description
     ├── Capability Profile
     └── Task Library (pre-generated)
     │
     ▼
RUNTIME LAYER
     │
     ├── Harness Compiler
     └── Compiled Runtime (executing agent)
     │
     ▼
EVOLUTION LAYER
     │
     ├── Council of Agents
     ├── Benchmarks
     └── Self-Modification
```

## Key Design Principles

| Principle | Description |
|-----------|-------------|
| Declarative over Imperative | The harness is a blueprint, not a script |
| Evolution over Engineering | The system discovers solutions through iteration |
| Safety through Constitution | Hard boundaries prevent harmful behaviors |
| Validation before Application | All changes tested before being permanent |
| Transparency | Every change tracked, every decision logged |

## Module Structure

```
meta-agent/
│
├── constitution.md              # Universal rules
│
├── harness/
│   ├── harness.yaml            # Main blueprint
│   ├── prompts/                # Prompt templates
│   ├── configs/                 # Component configs
│   ├── skills/                  # Procedural knowledge
│   ├── tools/                   # Tool definitions
│   ├── memory/                  # Memory system
│   ├── contexts/                # Context management
│   ├── mcp/                     # Model Context Protocol
│   ├── tui/                     # Terminal UI
│   ├── personalities/           # Behavioral modifiers
│   └── subagents/               # Subagent configurations
│
├── docs/                        # Documentation (modular)
│   ├── 1-system-overview/
│   ├── 2-harness/
│   ├── 3-runtime-compiler/
│   ├── 4-constitution/
│   ├── 5-task-library/
│   ├── 6-evolution-engine/
│   ├── 7-council/
│   ├── 8-subagents/
│   ├── 9-validation/
│   ├── 10-sandbox/
│   ├── 11-state-management/
│   ├── 12-cli/
│   ├── 13-workflows/
│   ├── 14-interactions/
│   └── 15-edge-cases/
│
├── task_library/                # Pre-generated benchmarks
│
└── evolution/                   # State tracking
    ├── current.json
    ├── history/
    ├── candidates/
    └── failure_memory/
```

## Module Dependencies

```
1-system-overview          ← Entry point (no dependencies)
        │
        ▼
4-constitution              ← Standalone (no dependencies)
        │
        ▼
2-harness                  ← Depends on: constitution
        │
        ▼
3-runtime-compiler         ← Depends on: harness
        │
        ▼
5-task-library             ← Depends on: harness
        │
        ▼
9-validation                ← Depends on: subagents, task-library
        │
        ▼
8-subagents                 ← Depends on: harness, constitution
        │
        ▼
10-sandbox                  ← Depends on: subagents, constitution
        │
        ▼
6-evolution-engine          ← Depends on: all above
        │
        ▼
7-council                  ← Depends on: evolution-engine
        │
        ▼
11-state-management         ← Depends on: evolution-engine
        │
        ▼
12-cli                     ← Depends on: all modules
        │
        ▼
13-workflows               ← Depends on: all modules
        │
        ▼
14-interactions             ← Depends on: all modules
        │
        ▼
15-edge-cases               ← Depends on: all modules
```

## Key Concepts

### Harness

A declarative blueprint defining the complete cognitive architecture. The harness is the single source of truth — changing it changes agent behavior.

### Constitution

Universal rules governing the system. Applies to every harness regardless of target role.

### Task Library

Pre-generated benchmark tasks from real job postings. Defines what "success" looks like.

### Evolution Engine

Iterative self-improvement loop. Evaluates, proposes, validates, and applies harness modifications.

### Council

Multi-agent system coordinating self-improvement through structured decision-making.

### Subagents

Specialized agents spawned for specific tasks. Two types: tester (validates changes) and deployed (executes production tasks).

### Sandbox

Isolated execution environment ensuring safe benchmark evaluation.

## Next Steps

- [Harness Model](../2-harness/README.md) — The declarative blueprint
- [Constitution](../4-constitution/README.md) — Universal rules
- [Evolution Engine](../6-evolution-engine/README.md) — Self-improvement loop