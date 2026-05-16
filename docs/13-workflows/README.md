# User Workflows

Detailed workflows for common user interactions with the meta-agent system.

## Create Specialist Agent Workflow

```
┌─────────────────────────────────────────────────────────────┐
│          WORKFLOW: CREATE SPECIALIST AGENT                 │
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

## Resume Evolution Workflow

```
┌─────────────────────────────────────────────────────────────┐
│              WORKFLOW: RESUME EVOLUTION                    │
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

## Rollback Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                 WORKFLOW: ROLLBACK                         │
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

## Build and Deploy Workflow

```
┌─────────────────────────────────────────────────────────────┐
│            WORKFLOW: BUILD AND DEPLOY                      │
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

## Add Tasks to Existing Library

```
┌─────────────────────────────────────────────────────────────┐
│            WORKFLOW: ADD TASKS                              │
│                                                             │
│  1. Create additional job requirements                       │
│     └─ echo "kubernetes, terraform" > new-reqs.md           │
│                                                             │
│  2. Generate additional tasks                               │
│     └─ meta-agent tasks generate new-reqs.md                │
│                                                             │
│  3. Review generated tasks                                   │
│     └─ meta-agent tasks list                                │
│                                                             │
│  4. Validate task executability                            │
│     └─ meta-agent tasks validate                            │
│                                                             │
│  5. Continue evolution with expanded library                 │
│     └─ meta-agent evolve resume                             │
└─────────────────────────────────────────────────────────────┘
```

## Modify Constitution

```
┌─────────────────────────────────────────────────────────────┐
│            WORKFLOW: MODIFY CONSTITUTION                   │
│                                                             │
│  1. Review current constitution                               │
│     └─ meta-agent constitution show                         │
│                                                             │
│  2. Edit constitution.md                                    │
│                                                             │
│  3. Validate changes                                        │
│     └─ meta-agent constitution validate                     │
│                                                             │
│  4. If approved, changes take effect                          │
│     └─ New safety boundaries apply                          │
│     └─ New decision thresholds apply                        │
└─────────────────────────────────────────────────────────────┘
```

## Related Documentation

- [CLI Interface](../12-cli/README.md) — Command reference
- [System Overview](../1-system-overview/README.md) — Architecture context