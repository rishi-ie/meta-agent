# Sandbox Architecture

The sandbox provides isolated execution environments for running harnesses and benchmarks. It ensures that untrusted code cannot affect the host system, resources are bounded, and execution is reproducible.

## Sandbox Types

The sandbox adapts to the capability domain:

| Capability | Sandbox Type | Features |
|------------|--------------|----------|
| Coding | Terminal + Filesystem | Command execution, file read/write |
| Browser | Headless Browser | DOM interaction, navigation |
| Research | Internet Access | Web search, retrieval |
| Deployment | Docker-enabled | Container creation, deployment |

## Two-Tier Strategy

Different changes use different sandbox levels:

### Tier 1: In-Process Sandbox

```
Characteristics:
  - Fast iteration (~100ms)
  - For parameter changes (prompts, configs)
  - Timeout + memory guard
  - Within main process

Use when:
  - Changing prompts
  - Adjusting config parameters
  - Quick validation
```

### Tier 2: Subprocess Sandbox

```
Characteristics:
  - Isolated execution (~2-5s)
  - For structural changes (topology, new tools)
  - Kill switch, resource limits, stdout capture
  - Separate child process

Use when:
  - Adding new tools
  - Modifying topology
  - Testing harness rewrites
```

## Resource Limits

Every sandbox enforces resource constraints:

```yaml
limits:
  max_runtime_seconds: 600    # 10 minute max
  max_tool_calls: 100         # Max 100 tool invocations
  max_memory_mb: 2048         # 2GB memory limit
  max_tokens: 100000          # Max context size
```

## Isolation Layers

The sandbox provides multiple isolation layers:

| Layer | Description |
|-------|-------------|
| Process isolation | Subprocess runs in separate process |
| Filesystem jail | Only allowed directories accessible |
| Network restrictions | Only whitelisted endpoints reachable |
| Syscall filtering | Only allowed system calls permitted |
| Resource quotas | CPU, memory, time all bounded |

## Kill Switch

The sandbox includes a kill switch for runaway processes:

```
Monitoring:
  - Timeout tracking — elapsed time
  - Memory tracking — memory usage
  - Call counting — tool invocations

On limit exceeded:
  - Terminate process
  - Log incident
  - Return error to parent
  - Record to failure_memory
```

## Sandbox Manager

The sandbox manager orchestrates all sandboxes:

### Interface

```yaml
sandbox_manager:
  create_sandbox(type):
    # Create ephemeral sandbox
    # Returns sandbox handle
  
  run_in_sandbox(sandbox, harness, task):
    # Execute in sandbox
    # Returns result
  
  destroy_sandbox(sandbox):
    # Cleanup sandbox
  
  list_active_sandboxes():
    # List running sandboxes
```

## Related Documentation

- [Subagents](../8-subagents/README.md) — Execute in sandbox
- [Validation Pipeline](../9-validation/README.md) — Uses sandbox for testing
- [Constitution](../4-constitution/README.md) — Enforces resource limits