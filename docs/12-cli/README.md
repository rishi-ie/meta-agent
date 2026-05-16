# CLI Interface

The CLI provides the user-facing interface for interacting with the meta-agent system.

## Command Structure

```
meta-agent <command> <subcommand> [options] [arguments]
```

## Command Categories

### Initialization

```bash
meta-agent init [name]
```

Create a new meta-agent project.

### Harness Management

```bash
meta-agent harness show        # Display configuration
meta-agent harness validate    # Validate harness.yaml
```

### Constitution

```bash
meta-agent constitution show   # Display rules summary
meta-agent constitution validate # Check compliance
```

### Task Library

```bash
meta-agent tasks generate <file>  # Generate tasks from job description
meta-agent tasks list              # List available tasks
meta-agent tasks validate          # Validate task executability
```

### Evolution

```bash
meta-agent evolve start           # Start evolution process
meta-agent evolve status          # Show current progress
meta-agent evolve pause           # Pause evolution
meta-agent evolve resume          # Resume evolution
meta-agent evolve stop            # Stop evolution
```

### State

```bash
meta-agent state show            # Display current state
meta-agent state history         # View generation history
meta-agent state diff            # Compare generations
```

### Build & Deploy

```bash
meta-agent build                 # Build specialist agent
meta-agent deploy                 # Deploy to runtime
```

### Sandbox

```bash
meta-agent sandbox test          # Test sandbox configuration
meta-agent sandbox list          # List active sandboxes
```

## Interactive Mode

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

## Output Formats

| Format | Use Case |
|--------|----------|
| `human` | Default, colored terminal output |
| `json` | Machine-readable for scripting |
| `yaml` | Configuration export |

## Error Handling

CLI provides helpful error messages:

```
Error: Harness validation failed

  Missing required field: topology.flow
  At: line 45, column 3
  
  Run 'meta-agent harness validate' for details
```

## Common Workflows

### Create and Evolve

```bash
# 1. Write job description
echo "Senior Backend Engineer..." > job.md

# 2. Generate task library
meta-agent tasks generate job.md

# 3. Start evolution
meta-agent evolve start --job job.md

# 4. Monitor
meta-agent evolve status

# 5. When done, build
meta-agent build --output ./my-agent
```

### Resume Evolution

```bash
# Check state
meta-agent state show

# Pause if running
meta-agent evolve pause

# Review history
meta-agent state history

# Resume
meta-agent evolve resume
```

## Related Documentation

- [System Overview](../1-system-overview/README.md) — Architecture context
- [Workflows](../13-workflows/README.md) — Full user workflows