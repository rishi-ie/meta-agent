# Subagent System

Subagents are specialized agents that handle specific tasks within the system. They are spawned on demand, execute their task, and terminate.

## Subagent Types

| Type | Purpose | Harness |
|------|---------|---------|
| **Tester** | Validates harness changes | Evolving harness (candidate) |
| **Deployed** | Executes production tasks | Fixed harness |

## Tester Subagent

The tester subagent validates proposed harness changes.

### Workflow

```
1. Receive candidate harness configuration
         │
         ▼
2. Instantiate test harness
         │
         ▼
3. Execute on benchmark subset (10-20 tasks)
         │
         ▼
4. Collect metrics:
   - task success rate
   - latency
   - tool usage
   - error frequency
         │
         ▼
5. Compare to current harness baseline
         │
         ▼
6. Return validation result:
   - PASS: improvement > threshold
   - FAIL: regression or no improvement
```

## Deployed Subagent

The deployed subagent executes production tasks.

### Workflow

```
1. Receive task + context
         │
         ▼
2. Load fixed harness configuration
         │
         ▼
3. Execute task through compiled runtime
         │
         ▼
4. Return result to parent
         │
         ▼
5. Terminate
```

## Task Model

Subagents follow a simple task model:

### Input

```yaml
task:
  description: "Implement REST endpoint"
  context:
    - user_requirements
    - api_spec
  harness: harness.yaml

context:
  memory: [...]
  history: [...]
```

### Output

```yaml
result:
  success: true
  output: "..."
  trace: [...]
  metrics:
    latency_ms: 1234
    tokens_used: 500
    tools_called: 5
```

## Spawning Policy

```yaml
subagents:
  enabled: true

  spawn:
    auto_spawn: true          # Automatically spawn as needed
    max_concurrent: 4         # Maximum parallel subagents
    idle_timeout_seconds: 300 # Terminate after 5 min idle
```

## Lifecycle

```
SPAWN REQUEST
     │
     ▼
┌─────────────────────────────────────┐
│  CHECK POOL                          │
│  Is there an idle subagent?          │
│                                      │
│  YES ──→ REUSE IDLE SUBAGENT          │
│  NO  ──→ CREATE NEW SUBAGENT          │
└─────────────────────────────────────┘
     │
     ▼
EXECUTE TASK
     │
     ▼
┌─────────────────────────────────────┐
│  IDLE POOL                           │
│  Subagent waits for next task        │
│                                      │
│  TASK AVAILABLE ──→ EXECUTE          │
│  TIMEOUT ──→ TERMINATE              │
└─────────────────────────────────────┘
```

## Subagent Harness Configuration

Each subagent type has its own harness:

```
harness/
└── subagents/
    ├── tester/
    │   └── harness.yaml    # For validating changes
    └── deployed/
        └── harness.yaml    # For production tasks
```

## Related Documentation

- [Harness Model](../2-harness/README.md) — Subagent harness configuration
- [Validation Pipeline](../9-validation/README.md) — How tester subagents validate
- [Sandbox](../10-sandbox/README.md) — Where subagents execute