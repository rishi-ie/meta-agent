# Meta-Agent: Complete Architecture Documentation

> This document describes every component, interaction, and mechanism in the meta-agent system. No implementation code — pure design documentation.

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [The Harness Model](#2-the-harness-model)
3. [The Runtime Compiler](#3-the-runtime-compiler)
4. [The Constitution](#4-the-constitution)
5. [Task Library Generation](#5-task-library-generation)
6. [Evolution Engine](#6-evolution-engine)
7. [Council Governance](#7-council-governance)
8. [Subagent System](#8-subagent-system)
9. [Validation Pipeline](#9-validation-pipeline)
10. [Sandbox Architecture](#10-sandbox-architecture)
11. [State Management](#11-state-management)
12. [CLI Interface](#12-cli-interface)
13. [User Workflows](#13-user-workflows)
14. [Component Interactions](#14-component-interactions)
15. [Data Flow Diagrams](#15-data-flow-diagrams)
16. [Edge Cases and Error Handling](#16-edge-cases-and-error-handling)

---

## 1. System Overview

### 1.1 Purpose

Meta-agent is a system that transforms a job description into a specialized, self-improving AI agent. The agent evolves through iterative benchmarking and self-modification until it reliably performs the target role.

### 1.2 Core Philosophy

```
Agent capability = Harness organization, not model weights
```

The same base model, under different harness configurations, produces fundamentally different agents. Meta-agent optimizes the harness — the cognitive runtime — not the underlying model.

### 1.3 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                          USER                                   │
│              (uploads job description)                          │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    INPUT PROCESSING                              │
│                                                                 │
│  ┌──────────────────┐    ┌──────────────────┐                   │
│  │ Job Description  │ → │ Capability       │                   │
│  │ (raw text)       │   │ Profile          │                   │
│  └──────────────────┘    └────────┬─────────┘                   │
│                                   │                             │
│                                   ▼                             │
│                    ┌──────────────────────────┐                 │
│                    │   Task Library            │                 │
│                    │   (pre-generated)        │                 │
│                    └────────┬──────────────────┘                 │
└─────────────────────────────┼───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      RUNTIME LAYER                               │
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐                     │
│  │   Harness       │ → │  Runtime        │                     │
│  │   Compiler      │   │  Compiler       │                     │
│  └─────────────────┘    └────────┬────────┘                     │
│                                   │                             │
│                                   ▼                             │
│                    ┌──────────────────────────┐                 │
│                    │   Compiled Runtime       │                 │
│                    │   (executing agent)     │                 │
│                    └────────┬──────────────────┘                 │
└─────────────────────────────┼───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   EVOLUTION LAYER                                │
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │   Council   │ ← │   Bench-    │ → │   Harness   │         │
│  │   of Agents │   │   marks     │   │   Patch     │         │
│  └──────┬──────┘    └─────────────┘    └─────────────┘         │
│         │                                                        │
│         ▼                                                        │
│  ┌─────────────────────────────────────┐                        │
│  │         Self-Modification            │                        │
│  │         (rewrite harness)            │                        │
│  └─────────────────────────────────────┘                        │
└─────────────────────────────────────────────────────────────────┘
```

### 1.4 Key Design Principles

1. **Declarative over Imperative**: The harness is a blueprint, not a script
2. **Evolution over Engineering**: The system discovers solutions through iteration
3. **Safety through Constitution**: Hard boundaries prevent harmful behaviors
4. **Validation before Application**: All changes tested before being permanent
5. **Transparency**: Every change tracked, every decision logged

---

## 2. The Harness Model

### 2.1 What is a Harness?

A harness is a structured configuration file that defines the complete cognitive architecture of an agent. It specifies:
- What components exist
- How components connect
- What behaviors are possible
- What constraints apply

The harness is the **single source of truth** for agent behavior. Changing the harness changes the agent.

### 2.2 Harness Structure

The harness is organized into sections, each governing a different aspect of the agent:

```
Harness
├── meta                    # Identity and versioning
├── structure               # Component registry
├── execution               # Model and timeout settings
├── topology                # Execution flow and routing
├── planning                # Task decomposition strategy
├── verification            # Output validation rules
├── memory                  # Memory type and retrieval
├── tools                   # Available tool categories
├── mcp                     # Model Context Protocol integrations
├── skills                  # Procedural knowledge
├── personality             # Behavioral modifiers
├── subagents               # Subagent configurations
├── tui                     # Terminal UI settings
├── safety                  # Resource limits and safety rules
└── evolution               # Evolution configuration
```

### 2.3 Meta Section

Contains identity information:

| Field | Purpose | Example |
|-------|---------|---------|
| `name` | Agent identifier | `senior-backend-engineer` |
| `version` | Harness version | `1.3.2` |
| `created` | Creation timestamp | `2024-05-16T00:00:00Z` |
| `last_evolved` | Last evolution timestamp | `2024-05-17T12:30:00Z` |
| `constitution_version` | Governing constitution | `1.0` |

### 2.4 Structure Section

Defines all components that exist in the agent:

```yaml
structure:
  components:
    - name: planner
      type: agent-component
      path: prompts/planner.md
      description: "Task decomposition and planning"
    
    - name: verifier
      type: agent-component
      path: prompts/verifier.md
      description: "Output validation and quality checking"
  
  systems:
    - name: memory
      type: system-component
      path: memory/
    
    - name: context
      type: system-component
      path: contexts/
```

Component types:
- **agent-component**: Prompt-driven reasoning components (planner, verifier, router, executor)
- **system-component**: Infrastructure components (memory, context, tools)
- **capability**: Tool definitions and access
- **integration**: External system connections (MCP servers)
- **knowledge**: Procedural skills and knowledge bases
- **presentation**: UI and output formatting
- **behavior**: Personality and communication style

### 2.5 Execution Section

Controls the base model and execution parameters:

```yaml
execution:
  model: gpt-4o              # Base reasoning model
  code_model: gpt-4o          # Code-specific model
  max_retries: 3              # Failed task retry limit
  timeout_ms: 30000           # Request timeout
  max_tokens_per_request: 32000
  parallel_subagents: true    # Allow parallel subagent execution
  max_parallel_agents: 4      # Maximum concurrent subagents
  stream_output: true         # Enable streaming responses
```

### 2.6 Topology Section

Defines the execution flow — how data moves through components:

```yaml
topology:
  flow:
    - from: user_input
      to: router
      condition: always
    
    - from: router
      to: planner
      condition: task.type == "complex"
    
    - from: planner
      to: executor
      condition: always
    
    - from: executor
      to: verifier
      condition: always
    
    - from: verifier
      to: output
      condition: passed
    
    - from: verifier
      to: planner
      condition: failed && retries < max_retries
  
  routing:
    rules:
      - condition: "task contains 'debug' or 'fix'"
        route: debugging-flow
      
      - condition: "task contains 'deploy'"
        route: deployment-flow
      
      - condition: "default"
        route: default-flow
```

### 2.7 Planning Section

Controls task decomposition behavior:

```yaml
planning:
  decomposition:
    enabled: true
    max_depth: 4              # Maximum subtask nesting
    min_subtasks: 1
    max_subtasks: 10
  
  subtasks:
    parallel_execution: true
    dependency_tracking: true
    failure_handling: retry_top_level
  
  reflection:
    enabled: true
    frequency: after_each_step
    depth_limit: 2
```

### 2.8 Verification Section

Defines output validation rules:

```yaml
verification:
  enabled: true
  
  trigger:
    - after_tool_execution
    - after_planning_step
    - before_output
  
  strictness:
    correctness: high
    style: medium
    efficiency: low
  
  auto_correct: true
  max_correction_attempts: 2
  
  criteria:
    - name: completeness
      weight: 0.3
    
    - name: correctness
      weight: 0.4
    
    - name: efficiency
      weight: 0.2
    
    - name: safety
      weight: 0.1
```

### 2.9 Memory Section

Configures the memory system:

```yaml
memory:
  type: hybrid               # semantic | episodic | hybrid
  
  retrieval:
    strategy: semantic_topk
    top_k: 5
    similarity_threshold: 0.7
    reranking: true
  
  context:
    max_window: 10           # Context window size
    compression: true
    compression_threshold: 0.8
  
  persistence:
    enabled: true
    base_dir: memory/
    eviction_policy: lru     # least recently used
  
  importance:
    tracking: true
    decay_rate: 0.95
```

Memory types explained:
- **semantic**: Vector-based similarity search
- **episodic**: Event-based sequence memory
- **hybrid**: Combines both approaches

### 2.10 Tools Section

Defines available tool categories and permissions:

```yaml
tools:
  categories:
    - name: terminal
      enabled: true
      permissions:
        - execute_commands
        - read_files
        - write_files
    
    - name: browser
      enabled: false
      permissions:
        - navigation
        - screenshot
    
    - name: filesystem
      enabled: true
      permissions:
        - read
        - write
        - glob
  
  execution:
    timeout_ms: 30000
    retry_on_failure: true
    max_retries: 2
  
  selection:
    auto_select: true
    prefer_builtin: true
```

### 2.11 Safety Section

Defines hard resource limits:

```yaml
safety:
  limits:
    max_runtime_seconds: 600
    max_tool_calls: 100
    max_memory_mb: 2048
    max_tokens: 100000
  
  constitution:
    enabled: true
    ref: ../constitution.md
    validate_on_start: true
  
  audit:
    enabled: true
    log_path: evolution/audit.log
    log_level: info
```

### 2.12 Evolution Section

Controls what can be modified during self-improvement:

```yaml
evolution:
  enabled: true
  
  evolvable:
    - prompts
    - configs
    - topology
    - tools
    - skills
  
  protected:
    - constitution.md
    - meta section
    - safety limits
  
  behavior:
    validate_before_apply: true
    require_council_approval: true
    log_all_changes: true
    preserve_failure_memory: true
```

---

## 3. The Runtime Compiler

### 3.1 What is the Runtime Compiler?

The runtime compiler is the engine that interprets the harness and produces an executing agent. It reads the harness blueprint and builds an executable runtime from it.

### 3.2 Compiler Pipeline

```
harness.yaml
     │
     ▼
┌─────────────────┐
│  PARSER         │  Validate YAML structure against schema
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  RESOLVER       │  Resolve component paths, load files
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  VALIDATOR      │  Check constitutional compliance
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  COMPILER       │  Build execution graph from topology
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  EXECUTOR       │  Run agent according to compiled graph
└─────────────────┘
```

### 3.3 Parser Stage

The parser validates and parses the YAML into internal data structures:

1. **Schema Validation**: Ensures all required fields exist and have correct types
2. **Enum Validation**: Checks that enum values are valid options
3. **Reference Validation**: Ensures referenced files exist

### 3.4 Resolver Stage

The resolver loads all referenced components:

1. **Component Files**: Loads prompts, configs, and other text files
2. **Directory Structures**: Validates that referenced directories exist
3. **Dependency Graph**: Builds a dependency map for all components

### 3.5 Validator Stage

The validator checks constitutional compliance:

1. **Safety Boundaries**: Ensures no violations of constitutional rules
2. **Resource Limits**: Verifies all limits are within allowed ranges
3. **Evolution Rules**: Confirms evolvable sections are not protected

### 3.6 Compiler Stage

The compiler builds the execution graph:

1. **Flow Graph**: Converts topology into a directed graph
2. **Routing Map**: Builds condition → route lookup table
3. **Execution Plan**: Creates a sequential execution plan

### 3.7 Executor Stage

The executor runs the agent:

1. **Component Initialization**: Creates component instances
2. **Flow Execution**: Processes input through the graph
3. **Result Aggregation**: Collects and formats output

### 3.8 Self-Modification Protocol

The compiler also handles self-modification:

```
┌─────────────────────────────────────────────────────────────┐
│           SELF-MODIFICATION PROTOCOL                        │
│                                                             │
│  1. Council proposes harness modification                   │
│  2. Test harness subagent validates the modification         │
│  3. If valid, compiler compiles new harness version          │
│  4. New harness replaces current harness                    │
│  5. State manager records the change                       │
│  6. Git commit created for rollback capability              │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. The Constitution

### 4.1 What is the Constitution?

The constitution is a markdown document containing universal rules that govern the meta-agent system. It applies to every harness, regardless of target role or capability domain.

### 4.2 Constitutional Articles

The constitution is organized into articles, each covering a different aspect of governance:

| Article | Coverage |
|---------|----------|
| I: Purpose | Goals and principles |
| II: Safety Boundaries | Non-negotiable restrictions |
| III: Council Governance | Multi-agent decision making |
| IV: Evolution Protocol | How evolution works |
| V: Quality Standards | When evolution stops |
| VI: Harness Structure | Required components |
| VII: Amendment Process | How rules change |
| VIII: Transition Rules | Deployment procedures |

### 4.3 Article II: Safety Boundaries

These are absolute restrictions that cannot be violated:

```
┌─────────────────────────────────────────────────────────────┐
│                    SAFETY BOUNDARIES                        │
│                                                             │
│  1. No privilege escalation                                 │
│     → Harness may not request host system admin access     │
│                                                             │
│  2. No data exfiltration                                    │
│     → Harness may not transmit user data to unauthorized   │
│       external endpoints                                    │
│                                                             │
│  3. No self-replication                                     │
│     → Harness may not spawn evolution loops outside the    │
│       system without explicit user consent                  │
│                                                             │
│  4. No constitution override                                 │
│     → Harness may not modify this constitution file         │
│                                                             │
│  5. Resource bounds enforced                                │
│     → All execution respects CPU, memory, and time limits   │
│       Violation → immediate halt                            │
│                                                             │
│  6. No authority escalation                                  │
│     → Harness may not modify its own execution permissions  │
│       or sandbox boundaries                                 │
└─────────────────────────────────────────────────────────────┘

Violation Consequence: Immediate halt → rollback to last stable state → log incident
```

### 4.4 Article III: Council Governance

The constitution defines the council structure:

```
┌─────────────────────────────────────────────────────────────┐
│                    COUNCIL ROLES                             │
│                                                             │
│  ┌─────────────┬───────────────────┬─────────────────────┐ │
│  │ Role        │ Responsibility    │ Output              │ │
│  ├─────────────┼───────────────────┼─────────────────────┤ │
│  │ Analyzer    │ Examine failed    │ Weakness Report    │ │
│  │             │ traces, identify  │                    │ │
│  │             │ weak components   │                    │ │
│  ├─────────────┼───────────────────┼─────────────────────┤ │
│  │ Proposer    │ Generate harness  │ Candidate Patches   │ │
│  │             │ modification      │                    │ │
│  │             │ proposals        │                    │ │
│  ├─────────────┼───────────────────┼─────────────────────┤ │
│  │ Validator   │ Test proposed     │ Validation Results │ │
│  │             │ changes against  │                    │ │
│  │             │ benchmarks        │                    │ │
│  ├─────────────┼───────────────────┼─────────────────────┤ │
│  │ Synthesizer │ Merge council     │ Final Change Set   │ │
│  │             │ decisions, manage│                    │ │
│  │             │ evolution strategy│                    │ │
│  └─────────────┴───────────────────┴─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 4.5 Decision Thresholds

The constitution specifies voting requirements:

| Change Type | Threshold |
|-------------|-----------|
| Parameter changes (prompts, configs) | Simple majority (50%+1) |
| New component additions | 2/3 majority |
| Structural changes (topology) | Unanimous consent |
| Constitutional changes | 80% supermajority + human review |

### 4.6 Conflict Resolution

When council members disagree:

1. **Main agent veto**: Main agent may override with documented reasoning
2. **Tie breaking**: Defer to last stable state
3. **Escalation**: Blocking minority may escalate to human review

### 4.7 Article V: Quality Standards

Evolution stops when quality thresholds are met:

| Metric | Threshold | Measurement |
|--------|-----------|-------------|
| Task Success Rate | ≥ 85% | On held-out benchmark tasks |
| Reliability | ≥ 80% | Consistency across 10 independent runs |
| Efficiency | ≤ 2x baseline | Token/latency compared to base model |
| Safety | 100% | Zero constitutional violations |

### 4.8 Stop Conditions

Evolution stops when any of these occur:

1. Quality threshold met (all metrics satisfied)
2. Generation limit reached (default: 50 generations)
3. Plateau detected (no improvement for 5 consecutive generations)
4. User halt (manual stop by operator)
5. Safety violation (constitutional boundary crossed)

### 4.9 Constitutional Amendment

The constitution can evolve, but with strict requirements:

```
AMENDMENT PROCESS

1. Amendment proposed by council with full rationale
2. Requires 80% council vote
3. Human review required (user must approve)
4. Approved amendments logged with date, rationale, and vote count
5. Constitution file updated with amendment history
```

---

## 5. Task Library Generation

### 5.1 Purpose of Task Library

The task library is a collection of benchmark tasks that define what "success" looks like for the target role. It is the evaluation signal that drives evolution.

### 5.2 Pre-Generation Requirement

**Task library generation must complete before evolution begins.** This is a constitutional requirement.

```
┌─────────────────────────────────────────────────────────────┐
│              TASK LIBRARY GENERATION WORKFLOW                │
│                                                             │
│  Job Description                                             │
│       │                                                     │
│       ▼                                                     │
│  Web Agents Crawl Real Job Postings                         │
│       │                                                     │
│       ▼                                                     │
│  Capability Extraction                                       │
│       │                                                     │
│       ▼                                                     │
│  LLM Generates Realistic Task Specifications               │
│       │                                                     │
│       ▼                                                     │
│  Task Validation (executable?)                              │
│       │                                                     │
│       ▼                                                     │
│  Task Library Stored                                        │
│       │                                                     │
│       ▼                                                     │
│  Evolution Begins                                           │
└─────────────────────────────────────────────────────────────┘
```

### 5.3 Web Agent Data Sources

Web agents crawl real-world job postings to extract authentic task requirements:

| Source Type | Examples |
|------------|----------|
| Job boards | LinkedIn, Indeed, Glassdoor |
| Company career pages | Individual company job postings |
| Technical communities | Hacker News "Who Is Hiring", Stack Overflow |
| Open source repos | GitHub job requirements, CONTRIBUTING files |

### 5.4 Capability Extraction

From job postings, the system extracts:

1. **Technical skills**: Languages, frameworks, tools
2. **Domain knowledge**: Industry-specific concepts
3. **Process requirements**: Workflow, methodology
4. **Soft requirements**: Communication, collaboration

These become capability categories for task generation.

### 5.5 Task Format

Each task in the library follows a standard format:

```yaml
id: coding-001
category: coding
difficulty: medium
capabilities:
  - api-integration
  - error-handling
  - code-testing

description: |
  Implement a REST API endpoint that:
  - Accepts JSON payload with user email and preferences
  - Validates email format
  - Stores in mock database
  - Returns 201 with user ID

success_criteria:
  - endpoint exists at /api/users
  - accepts POST with valid JSON
  - validates email format
  - returns 201 status
  - response contains user_id

timeout_seconds: 60

metadata:
  source: "linkedin-job-12345"
  generated_at: "2024-05-16T00:00:00Z"
```

### 5.6 Task Categories

Typical task categories include:

| Category | Examples |
|----------|----------|
| coding | Implement feature, write tests, refactor code |
| debugging | Fix error, investigate crash, trace issue |
| deployment | Configure CI/CD, deploy to cloud, set up containers |
| research | Find documentation, compare tools, analyze options |
| communication | Write documentation, explain decision, summarize |

### 5.7 Task Difficulty Distribution

A balanced task library includes:

- **Easy** (30%): Single-step tasks, well-defined requirements
- **Medium** (50%): Multi-step tasks, some ambiguity
- **Hard** (20%): Complex tasks, multiple valid approaches

### 5.8 Task Validation

Before tasks enter the library, they are validated:

1. **Executable**: Can be run in sandbox environment
2. **Measurable**: Has clear success/failure criteria
3. **Reproducible**: Same input produces same output
4. **Relevant**: Directly relates to job requirements

---

## 6. Evolution Engine

### 6.1 What is the Evolution Engine?

The evolution engine is the core loop that drives self-improvement. It iteratively evaluates the current harness, proposes modifications, validates them, and applies improvements.

### 6.2 Evolution Loop

```
┌─────────────────────────────────────────────────────────────┐
│                    EVOLUTION LOOP                            │
│                                                             │
│  while (score < threshold && generation < max):             │
│                                                             │
│    ┌─────────────────────────────────────────────────┐     │
│    │ 1. RUN BENCHMARK                                  │     │
│    │    Execute current harness on task library       │     │
│    └──────────────────────┬──────────────────────────┘     │
│                           │                                  │
│                           ▼                                  │
│    ┌─────────────────────────────────────────────────┐     │
│    │ 2. COLLECT RESULTS                               │     │
│    │    Gather scores, traces, failure data           │     │
│    └──────────────────────┬──────────────────────────┘     │
│                           │                                  │
│                           ▼                                  │
│    ┌─────────────────────────────────────────────────┐     │
│    │ 3. COUNCIL ANALYSIS                              │     │
│    │    Analyze failures, identify weak areas        │     │
│    └──────────────────────┬──────────────────────────┘     │
│                           │                                  │
│                           ▼                                  │
│    ┌─────────────────────────────────────────────────┐     │
│    │ 4. PROPOSE CHANGES                              │     │
│    │    Generate specific harness modifications      │     │
│    └──────────────────────┬──────────────────────────┘     │
│                           │                                  │
│                           ▼                                  │
│    ┌─────────────────────────────────────────────────┐     │
│    │ 5. VALIDATE CHANGES                             │     │
│    │    Test harness validates modifications          │     │
│    └──────────────────────┬──────────────────────────┘     │
│                           │                                  │
│                           ▼                                  │
│    ┌─────────────────────────────────────────────────┐     │
│    │ 6. APPLY CHANGES                                │     │
│    │    If valid, modify harness                     │     │
│    └──────────────────────┬──────────────────────────┘     │
│                           │                                  │
│                           ▼                                  │
│    ┌─────────────────────────────────────────────────┐     │
│    │ 7. RECORD STATE                                │     │
│    │    Update state, create git snapshot            │     │
│    └──────────────────────┬──────────────────────────┘     │
│                           │                                  │
│                           ▼                                  │
│                      Next Generation                         │
└─────────────────────────────────────────────────────────────┘
```

### 6.3 Generation Counter

Each iteration increments the generation counter. The counter tracks:
- Current generation number
- Best generation (highest score)
- Improvement trajectory

### 6.4 Score Calculation

The overall score is a weighted combination:

```
overall_score =
  (task_success * 0.5) +
  (reliability * 0.2) +
  (efficiency * 0.15) +
  (trace_quality * 0.1) +
  (judge_score * 0.05)
```

Weights can be adjusted per job description.

### 6.5 Change Types

Evolution can modify different harness sections:

| Change Type | Risk Level | Validation Required |
|-------------|------------|---------------------|
| Prompt edits | Low | 5 benchmarks |
| Config parameter | Medium | 10 benchmarks |
| New tool | Medium | Integration test + 10 benchmarks |
| Topology change | High | Full benchmark suite |
| Harness rewrite | Critical | Full suite + edge cases |

### 6.6 Improvement Detection

The engine detects improvement patterns:

1. **Monotonic**: Score increases consistently
2. **Plateau**: Score stabilizes with small fluctuations
3. **Declining**: Score decreases
4. **Oscillating**: Score fluctuates significantly

### 6.7 Loop Prevention

The engine detects when the same harness is repeated:

- Tracks harness content hashes
- If same harness appears 3+ times → halt
- Prevents infinite loops in evolution

### 6.8 Early Termination

Evolution can end early if:
- Quality threshold met
- Plateau detected (no improvement in 5 generations)
- User manually stops

---

## 7. Council Governance

### 7.1 What is the Council?

The council is a multi-agent system that coordinates self-improvement. It distributes expertise across different aspects of the harness, preventing single-point-of-failure evolution.

### 7.2 Council Roles

Each council member has a specialized role:

```
┌─────────────────────────────────────────────────────────────┐
│                    COUNCIL STRUCTURE                        │
│                                                             │
│     ┌─────────────┐                                         │
│     │  ANALYZER  │ ← Examines failed traces, identifies     │
│     │            │   weak components in current harness     │
│     └──────┬──────┘                                         │
│            │                                                │
│            ▼                                                │
│     ┌─────────────┐                                         │
│     │  PROPOSER  │ ← Generates specific modification        │
│     │            │   proposals based on analysis           │
│     └──────┬──────┘                                         │
│            │                                                │
│            ▼                                                │
│     ┌─────────────┐                                         │
│     │ VALIDATOR  │ ← Tests proposed changes against         │
│     │            │   benchmarks, measures improvement       │
│     └──────┬──────┘                                         │
│            │                                                │
│            ▼                                                │
│     ┌─────────────┐                                         │
│     │ SYNTHESIZER │ ← Merges council decisions, manages    │
│     │            │   overall evolution strategy             │
│     └──────┬──────┘                                         │
│            │                                                │
│            ▼                                                │
│     ┌─────────────┐                                         │
│     │ MAIN AGENT  │ ← Applies final changes, coordinates    │
│     │            │   subagents, manages state               │
│     └─────────────┘                                         │
└─────────────────────────────────────────────────────────────┘
```

### 7.3 Communication Protocol

Council members communicate through structured messages:

```
ANALYZER → WEAKNESS REPORT → PROPOSER
PROPOSER → CANDIDATE PATCH → VALIDATOR
VALIDATOR → VALIDATION RESULT → SYNTHESIZER
SYNTHESIZER → FINAL CHANGE SET → MAIN AGENT
MAIN AGENT → APPLY HARNESS CHANGE
```

### 7.4 Voting Protocol

When a decision is required:

1. **Proposal**: Proposer generates candidate changes
2. **Distribution**: All council members receive the proposal
3. **Analysis**: Each member analyzes from their perspective
4. **Vote**: Members cast approve/reject/abstain votes
5. **Tally**: Votes are counted against the threshold
6. **Resolution**: If threshold met, changes proceed

### 7.5 Specialization Rules

Council members may specialize:

- **Domain specialists**: Focus on specific harness sections (prompts, tools, memory)
- **Before voting**: Specialists must share context with full council
- **Cross-domain changes**: Require consent from affected specialists

### 7.6 Conflict Resolution

When council cannot reach agreement:

1. **Document disagreement**: Each member records reasoning
2. **Main agent review**: Main agent examines the disagreement
3. **Veto possibility**: Main agent may veto with documented rationale
4. **Human escalation**: Blocking minority may escalate to user

### 7.7 Council Memory

The council maintains a shared memory:

- Past proposals and their outcomes
- Failed experiments and analysis
- Successful modifications that improved scores
- Patterns identified across generations

---

## 8. Subagent System

### 8.1 What are Subagents?

Subagents are specialized agents that handle specific tasks within the system. They are spawned on demand, execute their task, and terminate.

### 8.2 Subagent Types

| Type | Purpose | Harness |
|------|---------|---------|
| **Tester** | Validates harness changes | Evolving harness (candidate) |
| **Deployed** | Executes production tasks | Fixed harness |

### 8.3 Tester Subagent

The tester subagent validates proposed harness changes:

```
┌─────────────────────────────────────────────────────────────┐
│                 TESTER SUBAGENT WORKFLOW                    │
│                                                             │
│  1. Receive candidate harness configuration                   │
│  2. Instantiate test harness                                │
│  3. Execute on benchmark subset (10-20 tasks)               │
│  4. Collect metrics:                                        │
│     - task success rate                                     │
│     - latency                                               │
│     - tool usage                                            │
│     - error frequency                                       │
│  5. Compare to current harness baseline                     │
│  6. Return validation result:                               │
│     - PASS: improvement > threshold                          │
│     - FAIL: regression or no improvement                    │
└─────────────────────────────────────────────────────────────┘
```

### 8.4 Deployed Subagent

The deployed subagent executes production tasks:

```
┌─────────────────────────────────────────────────────────────┐
│                DEPLOYED SUBAGENT WORKFLOW                    │
│                                                             │
│  1. Receive task + context                                   │
│  2. Load fixed harness configuration                         │
│  3. Execute task through compiled runtime                    │
│  4. Return result to parent                                  │
│  5. Terminate                                               │
└─────────────────────────────────────────────────────────────┘
```

### 8.5 Spawning Policy

Subagents are spawned according to policy:

```yaml
subagents:
  enabled: true
  
  spawn:
    auto_spawn: true          # Automatically spawn as needed
    max_concurrent: 4         # Maximum parallel subagents
    idle_timeout_seconds: 300 # Terminate after 5 min idle
```

### 8.6 Lifecycle

```
SPAWN REQUEST
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│  CHECK POOL                                                 │
│  Is there an idle subagent of this type?                    │
│                                                             │
│  YES ──→ REUSE IDLE SUBAGENT                                 │
│  NO  ──→ CREATE NEW SUBAGENT                                 │
└─────────────────────────────────────────────────────────────┘
     │
     ▼
EXECUTE TASK
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│  IDLE POOL                                                  │
│  Subagent waits for next task (up to idle_timeout)          │
│                                                             │
│  TASK AVAILABLE ──→ EXECUTE NEXT TASK                       │
│  TIMEOUT ──→ TERMINATE SUBAGENT                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.7 Task Model

Subagents follow a simple task model:

```yaml
Input:
  - task: Task description
  - context: Supporting context (memory, history)
  - harness: Harness configuration

Output:
  - result: Task outcome
  - trace: Execution trace
  - metrics: Performance metrics
```

---

## 9. Validation Pipeline

### 9.1 Purpose of Validation

Validation ensures that proposed changes are safe and effective before being applied to the main harness.

### 9.2 Validation Stages

```
┌─────────────────────────────────────────────────────────────┐
│                  VALIDATION PIPELINE                        │
│                                                             │
│  ┌───────────────┐    ┌───────────────┐    ┌─────────────┐ │
│  │ CONSTITUTIONAL│ → │  SYNTAX       │ → │  FUNCTIONAL │ │
│  │ VALIDATION    │    │  VALIDATION   │    │  VALIDATION │ │
│  │               │    │               │    │             │ │
│  │ Check safety  │    │ Validate YAML │    │ Test on     │ │
│  │ boundaries    │    │ structure     │    │ benchmarks  │ │
│  └───────────────┘    └───────────────┘    └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 9.3 Constitutional Validation

Ensures proposed changes don't violate safety boundaries:

1. **Boundary check**: Does the change violate any Article II rule?
2. **Scope check**: Is the change attempting to modify protected sections?
3. **Authority check**: Does the proposing agent have permission?

### 9.4 Syntax Validation

Ensures the harness is structurally valid:

1. **Schema validation**: All required fields present
2. **Type validation**: All values have correct types
3. **Reference validation**: All file paths exist
4. **Enum validation**: All enum values are valid

### 9.5 Functional Validation

Tests the harness in a sandbox:

1. **Subset testing**: Run on 10-20 benchmark tasks
2. **Baseline comparison**: Compare to current harness scores
3. **Improvement threshold**: Must improve by minimum percentage
4. **Regression check**: Must not degrade other metrics

### 9.6 Validation Thresholds

Different change types require different thresholds:

| Change Type | Required Improvement |
|-------------|---------------------|
| Prompt edit | > 5% |
| Config param | No regression |
| New tool | > 10% |
| Topology | > 15% |
| Harness rewrite | > 20% |

### 9.7 Failure Handling

If validation fails:

1. **Record failure**: Store in failure_memory/
2. **Analyze cause**: Identify why change failed
3. **Propose alternatives**: Generate alternative changes
4. **Loop prevention**: Track failures to avoid retrying same change

---

## 10. Sandbox Architecture

### 10.1 Purpose of Sandbox

The sandbox provides isolated execution environments for running harnesses and benchmarks. It ensures that:
- Untrusted code cannot affect the host system
- Resources are bounded
- Execution is reproducible

### 10.2 Sandbox Types

The sandbox adapts to the capability domain:

| Capability | Sandbox Type | Features |
|------------|--------------|----------|
| Coding | Terminal + Filesystem | Command execution, file read/write |
| Browser | Headless Browser | DOM interaction, navigation |
| Research | Internet Access | Web search, retrieval |
| Deployment | Docker-enabled | Container creation, deployment |

### 10.3 Two-Tier Sandbox Strategy

Different changes use different sandbox levels:

```
┌─────────────────────────────────────────────────────────────┐
│                    TWO-TIER SANDBOX                         │
│                                                             │
│  TIER 1: IN-PROCESS SANDBOX                                 │
│  ┌─────────────────────────────────────────────────────┐  │
│  │ • Fast iteration (~100ms)                            │  │
│  │ • For parameter changes (prompts, configs)            │  │
│  │ • Timeout + memory guard                              │  │
│  │ • Within main Node.js process                         │  │
│  └─────────────────────────────────────────────────────┘  │
│                                                             │
│  TIER 2: SUBPROCESS SANDBOX                                 │
│  ┌─────────────────────────────────────────────────────┐  │
│  │ • Isolated execution (~2-5s)                         │  │
│  │ • For structural changes (topology, new tools)       │  │
│  │ • Kill switch, resource limits, stdout capture      │  │
│  │ • Separate child process                            │  │
│  └─────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 10.4 Resource Limits

Every sandbox enforces resource constraints:

```yaml
safety:
  limits:
    max_runtime_seconds: 600    # 10 minute max
    max_tool_calls: 100         # Max 100 tool invocations
    max_memory_mb: 2048         # 2GB memory limit
    max_tokens: 100000          # Max context size
```

### 10.5 Isolation Layers

The sandbox provides multiple isolation layers:

1. **Process isolation**: Subprocess runs in separate process
2. **Filesystem jail**: Only allowed directories accessible
3. **Network restrictions**: Only whitelisted endpoints reachable
4. **Syscall filtering**: Only allowed system calls permitted
5. **Resource quotas**: CPU, memory, time all bounded

### 10.6 Kill Switch

The sandbox includes a kill switch for runaway processes:

- **Timeout monitoring**: Track elapsed time
- **Memory monitoring**: Track memory usage
- **Termination**: Kill process if limits exceeded
- **Recovery**: Log incident, return error to parent

### 10.7 Sandbox Manager

The sandbox manager orchestrates all sandboxes:

```yaml
Interface:
  createSandbox(type):        # Create ephemeral sandbox
  runInSandbox(sandbox, task): # Execute in sandbox
  destroySandbox(sandbox):    # Cleanup sandbox
  listActiveSandboxes():      # List running sandboxes
```

---

## 11. State Management

### 11.1 Purpose of State Management

State management tracks the evolution process, enabling:
- Progress monitoring
- Rollback capability
- Change history
- Failure analysis

### 11.2 State Components

```
┌─────────────────────────────────────────────────────────────┐
│                    STATE COMPONENTS                          │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ current.json                                        │   │
│  │ • Current generation                                 │   │
│  │ • Best score and generation                          │   │
│  │ • Last change                                        │   │
│  │ • Benchmark scores                                   │   │
│  │ • Status (running/paused/completed)                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ history/                                             │   │
│  │ • gen-001.json, gen-002.json, ...                   │   │
│  │ • Snapshot of each generation                       │   │
│  │ • Includes scores, changes, votes                    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ candidates/                                          │   │
│  │ • Proposed but not yet applied changes              │   │
│  │ • Includes votes and validation results             │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ failure_memory/                                     │   │
│  │ • Failed experiments with analysis                 │   │
│  │ • Prevents retrying same failures                   │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### 11.3 Current State Format

```json
{
  "generation": 12,
  "best_score": 84.7,
  "best_generation": 10,
  "harness_version": "v12-harness.yaml",
  "last_change": "prompts/planner.md: improved decomposition prompt",
  "benchmark_scores": {
    "overall": 82.4,
    "task_success": 85.1,
    "reliability": 79.2,
    "efficiency": 78.5,
    "categories": {
      "coding": 88.3,
      "debugging": 76.1,
      "deployment": 81.4
    }
  },
  "status": "running",
  "started_at": "2024-05-16T10:00:00Z",
  "updated_at": "2024-05-16T12:30:00Z"
}
```

### 11.4 Git Integration

State management integrates with git for version control:

1. **Every change creates a commit**: Full change history
2. **Branches per generation**: Easy rollback to any generation
3. **Diff tracking**: Understand what changed and why
4. **Review capability**: Examine changes before applying

### 11.5 Rollback Protocol

If a change causes problems:

```
┌─────────────────────────────────────────────────────────────┐
│                    ROLLBACK PROTOCOL                         │
│                                                             │
│  1. Detect regression (score drops significantly)           │
│  2. Identify last working generation                        │
│  3. Checkout git branch for that generation                 │
│  4. Restore harness to working state                        │
│  5. Record rollback in state                                │
│  6. Analyze what caused the regression                       │
└─────────────────────────────────────────────────────────────┘
```

### 11.6 Trend Analysis

State management includes trend analysis:

```yaml
Trend Calculation:
  - Compare last 5 generations' scores
  - Calculate average delta
  - Determine direction:
    • improving: delta > +2
    • declining: delta < -2
    • stable: delta between -2 and +2
```

### 11.7 Loop Detection

State tracks harness content hashes to detect loops:

- If same harness appears 3+ times → halt
- Log incident to failure_memory
- Alert user to potential issue

---

## 12. CLI Interface

### 12.1 Command Structure

The CLI follows a git-like command structure:

```
meta-agent <command> <subcommand> [options] [arguments]
```

### 12.2 Command Categories

```
INITIALIZATION
  meta-agent init [name]          # Create new project

HARNESS MANAGEMENT
  meta-agent harness show          # Display configuration
  meta-agent harness validate      # Validate harness.yaml

CONSTITUTION
  meta-agent constitution show     # Display rules summary
  meta-agent constitution validate # Check constitutional compliance

TASK LIBRARY
  meta-agent tasks generate <file>  # Generate tasks from job description
  meta-agent tasks list             # List available tasks
  meta-agent tasks validate         # Validate task executability

EVOLUTION
  meta-agent evolve start           # Start evolution process
  meta-agent evolve status          # Show current progress
  meta-agent evolve pause           # Pause evolution
  meta-agent evolve resume          # Resume evolution
  meta-agent evolve stop            # Stop evolution

STATE
  meta-agent state show             # Display current state
  meta-agent state history          # View generation history
  meta-agent state diff             # Compare generations

BUILD & DEPLOY
  meta-agent build                  # Build specialist agent
  meta-agent deploy                 # Deploy to runtime

SANDBOX
  meta-agent sandbox test           # Test sandbox configuration
  meta-agent sandbox list           # List active sandboxes
```

### 12.3 Interactive Mode

When running without arguments, the CLI enters interactive mode:

```
┌─────────────────────────────────────────────────────────────┐
│                    META-AGENT REPL                          │
│                                                             │
│  > init                                                    │
│  > harness show                                            │
│  > evolve start --job senior-engineer.md                   │
│  > state show                                               │
│  > help                                                    │
│  > quit                                                    │
└─────────────────────────────────────────────────────────────┘
```

### 12.4 Output Formats

CLI supports multiple output formats:

| Format | Use Case |
|--------|----------|
| human | Default, colored terminal output |
| json | Machine-readable for scripting |
| yaml | Configuration export |

### 12.5 Error Handling

CLI provides helpful error messages:

```
Error: Harness validation failed

  Missing required field: topology.flow
  At: line 45, column 3
  
  Run 'meta-agent harness validate' for details
```

---

## 13. User Workflows

### 13.1 Create Specialist Agent Workflow

```
┌─────────────────────────────────────────────────────────────┐
│          WORKFLOW: CREATE SPECIALIST AGENT                   │
│                                                             │
│  1. User writes job description                            │
│     └─ file: job.md                                         │
│                                                             │
│  2. Generate task library                                  │
│     └─ meta-agent tasks generate job.md                     │
│     └─ System crawls web, creates task_library/             │
│                                                             │
│  3. Review capabilities detected                            │
│     └─ meta-agent tasks list                                │
│                                                             │
│  4. Set constitutional limits (optional)                   │
│     └─ Edit constitution.md                                │
│                                                             │
│  5. Start evolution                                         │
│     └─ meta-agent evolve start --job job.md                 │
│                                                             │
│  6. Monitor progress                                         │
│     └─ meta-agent evolve status                            │
│     └─ meta-agent state history                            │
│                                                             │
│  7. Evolution completes (or user stops)                     │
│                                                             │
│  8. Build specialist                                         │
│     └─ meta-agent build --output ./my-agent                │
│                                                             │
│  9. Deploy                                                  │
│     └─ docker run my-agent                                   │
└─────────────────────────────────────────────────────────────┘
```

### 13.2 Resume Evolution Workflow

```
┌─────────────────────────────────────────────────────────────┐
│              WORKFLOW: RESUME EVOLUTION                      │
│                                                             │
│  1. Check current state                                     │
│     └─ meta-agent state show                                │
│                                                             │
│  2. Pause or stop if running                                │
│     └─ meta-agent evolve pause                              │
│                                                             │
│  3. Review evolution history                                │
│     └─ meta-agent state history                             │
│     └─ meta-agent state diff --from 10 --to 15             │
│                                                             │
│  4. Add more tasks if needed                                │
│     └─ meta-agent tasks generate additional-tasks.md       │
│                                                             │
│  5. Resume evolution                                         │
│     └─ meta-agent evolve resume                              │
└─────────────────────────────────────────────────────────────┘
```

### 13.3 Rollback Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                 WORKFLOW: ROLLBACK                           │
│                                                             │
│  1. Detect problem (regression, errors)                     │
│                                                             │
│  2. View history to find working generation                 │
│     └─ meta-agent state history                            │
│                                                             │
│  3. Compare current to working state                         │
│     └─ meta-agent state diff --from 10 --to 15             │
│                                                             │
│  4. Rollback to working generation                           │
│     └─ git checkout evolution/gen-10                       │
│                                                             │
│  5. Resume evolution from working state                     │
│     └─ meta-agent evolve resume                             │
└─────────────────────────────────────────────────────────────┘
```

### 13.4 Build and Deploy Workflow

```
┌─────────────────────────────────────────────────────────────┐
│            WORKFLOW: BUILD AND DEPLOY                        │
│                                                             │
│  1. Ensure evolution completed successfully               │
│     └─ meta-agent state show                                │
│                                                             │
│  2. Build specialist package                                │
│     └─ meta-agent build --output ./specialist              │
│                                                             │
│  3. Review output                                           │
│     └─ Contains harness, configs, prompts                  │
│                                                             │
│  4. Deploy locally                                           │
│     └─ cd specialist && docker build -t specialist          │
│     └─ docker run specialist                                │
│                                                             │
│  5. Test deployed agent                                      │
│     └─ docker run specialist "debug this error: ..."       │
└─────────────────────────────────────────────────────────────┘
```

---

## 14. Component Interactions

### 14.1 Initialization Sequence

```
┌─────────────────────────────────────────────────────────────┐
│              INITIALIZATION SEQUENCE                         │
│                                                             │
│  1. CLI parses command and arguments                        │
│                                                             │
│  2. StateManager.loadState()                               │
│     └─ Load current.json                                    │
│                                                             │
│  3. ConstitutionParser.load()                               │
│     └─ Parse constitution.md                               │
│     └─ Validate constitutional rules                        │
│                                                             │
│  4. HarnessCompiler.load()                                  │
│     └─ Parse harness.yaml                                   │
│     └─ Validate structure                                   │
│                                                             │
│  5. TaskLibrary.load()                                      │
│     └─ Load task_library/index.json                         │
│                                                             │
│  6. SandboxManager.initialize()                             │
│     └─ Prepare sandbox pool                                │
│                                                             │
│  7. Ready for user commands                                  │
└─────────────────────────────────────────────────────────────┘
```

### 14.2 Evolution Start Sequence

```
┌─────────────────────────────────────────────────────────────┐
│              EVOLUTION START SEQUENCE                        │
│                                                             │
│  1. User runs: meta-agent evolve start                     │
│                                                             │
│  2. StateManager.startEvolution()                          │
│     └─ Update status to 'running'                          │
│     └─ Record started_at                                   │
│                                                             │
│  3. HarnessCompiler.compile()                               │
│     └─ Parse and validate harness                          │
│     └─ Build execution graph                                │
│                                                             │
│  4. Council.initialize()                                    │
│     └─ Create Analyzer, Proposer, Validator, Synthesizer   │
│                                                             │
│  5. Begin evolution loop                                    │
│     └─ Run first generation                                │
└─────────────────────────────────────────────────────────────┘
```

### 14.3 Council Decision Sequence

```
┌─────────────────────────────────────────────────────────────┐
│              COUNCIL DECISION SEQUENCE                       │
│                                                             │
│  1. Benchmark results available                             │
│                                                             │
│  2. ANALYZER examines failures                             │
│     └─ Identifies weak components                            │
│     └─ Outputs: Weakness Report                            │
│                                                             │
│  3. PROPOSER generates changes                              │
│     └─ Based on Weakness Report                             │
│     └─ Creates Candidate Patches                           │
│                                                             │
│  4. Council votes on candidates                             │
│                                                             │
│  5. VALIDATOR tests approved candidates                     │
│     └─ Spawns test harness subagent                         │
│     └─ Runs on benchmark subset                             │
│     └─ Returns: Validation Results                         │
│                                                             │
│  6. SYNTHESIZER merges decisions                           │
│     └─ Selects final changes                                 │
│     └─ Outputs: Final Change Set                           │
│                                                             │
│  7. MAIN AGENT applies changes                               │
│     └─ Modify harness files                                 │
│     └─ StateManager.recordChange()                         │
│     └─ Git commit                                           │
└─────────────────────────────────────────────────────────────┘
```

### 14.4 Change Validation Sequence

```
┌─────────────────────────────────────────────────────────────┐
│              CHANGE VALIDATION SEQUENCE                      │
│                                                             │
│  1. Proposed change received                                │
│                                                             │
│  2. CONSTITUTIONAL VALIDATION                               │
│     └─ CheckSafetyBoundaries()                             │
│     └─ If violation → REJECT                                │
│                                                             │
│  3. SYNTAX VALIDATION                                       │
│     └─ Parse YAML                                           │
│     └─ Validate against schema                              │
│     └─ If invalid → REJECT                                  │
│                                                             │
│  4. FUNCTIONAL VALIDATION                                    │
│     └─ SandboxManager.createSandbox()                       │
│     └─ Spawn test harness subagent                          │
│     └─ Run on benchmark subset                              │
│     └─ Compare to baseline                                  │
│     └─ If improvement < threshold → REJECT                 │
│                                                             │
│  5. APPROVED                                                │
│     └─ Apply to main harness                                 │
└─────────────────────────────────────────────────────────────┘
```

---

## 15. Data Flow Diagrams

### 15.1 Task Flow

```
USER INPUT
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│                    ROUTER                                    │
│  Determines task type (coding, debugging, etc.)            │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    PLANNER                                   │
│  Decomposes task into subtasks                             │
│  Creates execution plan                                     │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    EXECUTOR                                   │
│  Executes subtasks using tools                              │
│  Calls subagents as needed                                  │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    VERIFIER                                  │
│  Validates output against criteria                          │
│  Triggers retry if failed                                   │
└─────────────────────┬───────────────────────────────────────┘
                      │
            ┌─────────┴─────────┐
            │                   │
            ▼                   ▼
         PASSED               FAILED
            │                   │
            ▼                   ▼
        OUTPUT              RETRY (if retries < limit)
                                         │
                                         ▼
                                     PLANNER
```

### 15.2 Evolution Flow

```
TASK LIBRARY
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│                 BENCHMARK RUNNER                             │
│  Executes current harness on all tasks                      │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    SCORE CALCULATOR                          │
│  Computes overall score from metrics                        │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    COUNCIL                                  │
│  Analyzes → Proposes → Validates → Synthesizes             │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                  HARNESS MODIFIER                            │
│  Applies approved changes to harness                        │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                  STATE MANAGER                               │
│  Records changes, creates git snapshots                     │
└─────────────────────┬───────────────────────────────────────┘
                      │
            ┌─────────┴─────────┐
            │                   │
            ▼                   ▼
      THRESHOLD MET      MORE GENERATIONS
            │                   │
            ▼                   ▼
        COMPLETE          NEXT GENERATION
```

### 15.3 Validation Flow

```
PROPOSED CHANGE
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│              CONSTITUTIONAL CHECK                            │
│  Violates safety boundary?                                  │
└─────────────────────┬───────────────────────────────────────┘
           ┌──────────┴──────────┐
           │                     │
          NO                    YES
           │                     │
           ▼                     ▼
      ┌─────────┐           ┌─────────┐
      │ SYNTAX  │           │ REJECT  │
      │ CHECK   │           │         │
      └────┬────┘           └─────────┘
           │
      ┌────┴────┐
      │         │
     NO        YES
      │         │
      ▼         ▼
  ┌───────┐ ┌─────────┐
  │ VALID │ │ FUNCTIONAL│
  │       │ │ TEST     │
  └───────┘ └────┬────┘
                 │
            ┌────┴────┐
            │         │
           NO        YES
            │         │
            ▼         ▼
        ┌───────┐  ┌─────────┐
        │REJECT │  │ APPROVE │
        └───────┘  └─────────┘
```

---

## 16. Edge Cases and Error Handling

### 16.1 Task Library Empty

**Scenario**: No tasks in library when evolution starts

**Handling**:
```
1. Block evolution start
2. Display error: "Task library empty. Generate tasks first."
3. Suggest: meta-agent tasks generate <job-file>
```

### 16.2 All Tasks Fail

**Scenario**: Current harness scores 0% on all tasks

**Handling**:
```
1. Analyze failure patterns
2. Identify common failure mode
3. If fundamental issue → suggest harness reset
4. If specific issue → target fix via council
```

### 16.3 Council Deadlock

**Scenario**: Council cannot reach decision threshold

**Handling**:
```
1. Main agent reviews disagreement
2. Main agent may:
   a. Accept majority decision
   b. Veto with documented reasoning
   c. Escalate to human review
3. Log incident for future improvement
```

### 16.4 Validation Timeout

**Scenario**: Validation exceeds timeout threshold

**Handling**:
```
1. Kill sandbox process
2. Mark validation as TIMEOUT
3. Reject proposed change
4. Log to failure_memory/
5. Alert: "Validation timed out. Consider simplifying change."
```

### 16.5 Harness Parse Error

**Scenario**: Proposed change breaks YAML syntax

**Handling**:
```
1. Catch parse error
2. Display specific error location
3. Reject proposed change
4. Do not apply partial changes
```

### 16.6 Sandbox Unavailable

**Scenario**: No sandbox resources available

**Handling**:
```
1. Queue validation request
2. Wait for available sandbox
3. If timeout → use in-process fallback (risky changes only)
4. Alert if consistently unavailable
```

### 16.7 Git Conflict

**Scenario**: Manual changes conflict with evolution changes

**Handling**:
```
1. Detect conflict on evolution commit
2. Display conflict details
3. Options:
   a. Accept evolution changes (discard manual)
   b. Accept manual changes (discard evolution)
   c. Manual merge
4. Resolve before continuing
```

### 16.8 Constitutional Violation Attempted

**Scenario**: Proposed change violates safety boundary

**Handling**:
```
1. Catch during constitutional validation
2. Display which boundary is violated
3. REJECT immediately (no partial application)
4. Log attempt to audit log
5. Alert: "Change violates constitutional rule: [rule]"
```

### 16.9 Memory Exhaustion

**Scenario**: Agent uses excessive memory

**Handling**:
```
1. Monitor memory usage
2. If exceeds limit → terminate execution
3. Mark task as FAILED (memory)
4. Log incident
5. If pattern → suggest optimization in memory config
```

### 16.10 Infinite Loop Detection

**Scenario**: Same harness repeating without improvement

**Handling**:
```
1. Track harness content hashes
2. If same hash appears 3+ times → HALT
3. Display: "Loop detected: harness not improving"
4. Suggest: manual intervention or harness reset
```

---

## Appendix: Glossary

| Term | Definition |
|------|------------|
| **Agent** | A specialized AI capable of performing tasks |
| **Benchmark** | A test task that evaluates agent capability |
| **Candidate** | A proposed harness modification |
| **Compiler** | Runtime component that interprets harness |
| **Constitution** | Universal rules governing the system |
| **Council** | Multi-agent system for self-improvement |
| **Evolution** | Iterative self-improvement of the harness |
| **Generation** | One iteration of the evolution loop |
| **Harness** | Declarative blueprint for agent behavior |
| **Specialist** | Final evolved agent for a job description |
| **Subagent** | A spawned agent for specific tasks |
| **Task Library** | Collection of benchmark tasks |
| **Validation** | Testing proposed changes before applying |

---

*Document Version: 1.0*
*Last Updated: 2024-05-16*