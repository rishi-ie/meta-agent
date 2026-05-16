# The Runtime Compiler

The runtime compiler interprets the harness and produces an executing agent. It reads the harness blueprint and builds an executable runtime from it.

## Compiler Pipeline

```
harness.yaml
     │
     ▼
┌─────────────────┐
│  PARSER          │  Validate YAML structure
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  RESOLVER        │  Resolve component paths
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  VALIDATOR      │  Constitutional compliance
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  COMPILER       │  Build execution graph
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  EXECUTOR       │  Run agent
└─────────────────┘
```

## Stage 1: Parser

Validates and parses the YAML into internal data structures.

### Responsibilities

- Schema validation — all required fields exist with correct types
- Enum validation — values are valid options
- Reference validation — referenced files exist

## Stage 2: Resolver

Loads all referenced components.

### Responsibilities

- Component files — loads prompts, configs, text files
- Directory validation — referenced directories exist
- Dependency graph — maps component relationships

## Stage 3: Validator

Checks constitutional compliance.

### Responsibilities

- Safety boundaries — no violations of constitutional rules
- Resource limits — all limits within allowed ranges
- Evolution rules — evolvable sections are not protected

## Stage 4: Compiler

Builds the execution graph from topology.

### Responsibilities

- Flow graph — converts topology into directed graph
- Routing map — condition to route lookup table
- Execution plan — sequential execution plan

### Execution Graph

```yaml
nodes:
  user_input:
    id: user_input
    type: input
    edges: [router]
  
  router:
    id: router
    type: routing
    edges: [planner, executor]
  
  planner:
    id: planner
    type: planning
    edges: [executor]
  
  executor:
    id: executor
    type: execution
    edges: [verifier]
  
  verifier:
    id: verifier
    type: validation
    edges: [output, planner]

edges:
  - from: user_input
    to: router
  - from: router
    to: planner
  - from: planner
    to: executor
  - from: executor
    to: verifier
  - from: verifier
    to: output
  - from: verifier
    to: planner

routing:
  debugging-flow: [router, planner, executor, verifier]
  deployment-flow: [router, executor, verifier]
  default-flow: [router, planner, executor, verifier]
```

## Stage 5: Executor

Runs the agent through the compiled graph.

### Responsibilities

- Component initialization — creates component instances
- Flow execution — processes input through the graph
- Result aggregation — collects and formats output

## Self-Modification Protocol

The compiler handles self-modification:

```
Council proposes harness modification
         │
         ▼
Test harness validates the modification
         │
         ▼
Compiler compiles new harness version
         │
         ▼
New harness replaces current harness
         │
         ▼
State manager records the change
         │
         ▼
Git commit created for rollback
```

## Version Management

The compiler tracks harness versions:

| Version | Description |
|---------|-------------|
| `v1-base` | Initial harness |
| `v2-planner-update` | After planner prompt change |
| `v3-topology` | After topology modification |

Each version is git-tagged for rollback capability.

## Related Documentation

- [Harness Model](../2-harness/README.md) — The blueprint being compiled
- [Constitution](../4-constitution/README.md) — Rules for validation
- [Evolution Engine](../6-evolution-engine/README.md) — Triggers recompilation