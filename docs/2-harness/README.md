# The Harness Model

A harness is a structured configuration that defines the complete cognitive architecture of an agent. It specifies what components exist, how they connect, what behaviors are possible, and what constraints apply.

The harness is the **single source of truth** for agent behavior. Changing the harness changes the agent.

## Folder Structure

```
harness/
├── harness.yaml        # Main configuration (the blueprint)
├── prompts/             # Prompt templates
│   ├── planner.md
│   ├── verifier.md
│   ├── router.md
│   └── executor.md
├── configs/             # Component configurations
│   ├── planner.yaml
│   ├── memory.yaml
│   └── tools.yaml
├── skills/              # Procedural knowledge
├── tools/               # Tool definitions
├── memory/              # Memory system
├── contexts/            # Context management
├── mcp/                 # Model Context Protocol servers
├── tui/                 # Terminal UI configurations
├── personalities/       # Behavioral modifiers
└── subagents/          # Subagent configurations
    ├── tester/
    │   └── harness.yaml
    └── deployed/
        └── harness.yaml
```

## Harness Sections

The harness is organized into sections:

| Section | Purpose |
|---------|---------|
| `meta` | Identity and versioning |
| `structure` | Component registry |
| `execution` | Model and timeout settings |
| `topology` | Execution flow and routing |
| `planning` | Task decomposition strategy |
| `verification` | Output validation rules |
| `memory` | Memory type and retrieval |
| `tools` | Available tool categories |
| `mcp` | Model Context Protocol integrations |
| `skills` | Procedural knowledge |
| `personality` | Behavioral modifiers |
| `subagents` | Subagent configurations |
| `tui` | Terminal UI settings |
| `safety` | Resource limits and safety rules |
| `evolution` | Evolution configuration |

## Meta Section

Identity information:

| Field | Purpose | Example |
|-------|---------|---------|
| `name` | Agent identifier | `senior-backend-engineer` |
| `version` | Harness version | `1.3.2` |
| `created` | Creation timestamp | `2024-05-16T00:00:00Z` |
| `last_evolved` | Last evolution timestamp | `2024-05-17T12:30:00Z` |
| `constitution_version` | Governing constitution | `1.0` |

## Structure Section

Defines all components:

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

  systems:
    - name: memory
      type: system-component
      path: memory/
```

### Component Types

| Type | Description |
|------|-------------|
| `agent-component` | Prompt-driven reasoning (planner, verifier, router, executor) |
| `system-component` | Infrastructure (memory, context, tools) |
| `capability` | Tool definitions and access |
| `integration` | External system connections (MCP servers) |
| `knowledge` | Procedural skills and knowledge bases |
| `presentation` | UI and output formatting |
| `behavior` | Personality and communication style |

## Execution Section

Base model and execution parameters:

```yaml
execution:
  model: gpt-4o                    # Base reasoning model
  code_model: gpt-4o               # Code-specific model
  max_retries: 3                  # Failed task retry limit
  timeout_ms: 30000               # Request timeout
  max_tokens_per_request: 32000
  parallel_subagents: true         # Allow parallel execution
  max_parallel_agents: 4           # Maximum concurrent subagents
  stream_output: true              # Enable streaming
```

## Topology Section

Execution flow — how data moves through components:

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

## Planning Section

Task decomposition behavior:

```yaml
planning:
  decomposition:
    enabled: true
    max_depth: 4                  # Maximum subtask nesting
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

## Verification Section

Output validation rules:

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

## Memory Section

Memory system configuration:

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

### Memory Types

| Type | Description |
|------|-------------|
| `semantic` | Vector-based similarity search |
| `episodic` | Event-based sequence memory |
| `hybrid` | Combines semantic and episodic |

## Tools Section

Available tool categories and permissions:

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

## Safety Section

Hard resource limits:

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

## Evolution Section

What can be modified during self-improvement:

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

## Self-Modification

The agent can modify its own harness based on evolution results. The process:

1. Council proposes modification
2. Test harness validates the change
3. If valid, harness is updated
4. State manager records the change
5. Git snapshot created for rollback

## Related Documentation

- [Runtime Compiler](../3-runtime-compiler/README.md) — How the harness is interpreted
- [Constitution](../4-constitution/README.md) — Rules governing harness modifications
- [Evolution Engine](../6-evolution-engine/README.md) — Self-improvement process