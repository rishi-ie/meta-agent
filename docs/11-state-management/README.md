# State Management

State management tracks the evolution process, enabling progress monitoring, rollback capability, change history, and failure analysis.

## State Components

```
evolution/
├── current.json          # Current state
│
├── history/              # Generation snapshots
│   ├── gen-001.json
│   ├── gen-002.json
│   └── ...
│
├── candidates/           # Proposed but not applied changes
│   ├── candidate-001.json
│   └── ...
│
└── failure_memory/        # Failed experiments with analysis
    ├── failure-001.json
    └── ...
```

## Current State

```yaml
current:
  generation: 12
  best_score: 84.7
  best_generation: 10
  harness_version: v12-harness
  last_change: "prompts/planner.md: improved decomposition"
  
  benchmark_scores:
    overall: 82.4
    task_success: 85.1
    reliability: 79.2
    efficiency: 78.5
    categories:
      coding: 88.3
      debugging: 76.1
      deployment: 81.4
  
  status: running
  started_at: "2024-05-16T10:00:00Z"
  updated_at: "2024-05-16T12:30:00Z"
```

## Generation Snapshot

Each generation creates a snapshot:

```yaml
generation_snapshot:
  generation: 5
  timestamp: "2024-05-16T12:00:00Z"
  harness_snapshot: v5-harness
  
  scores:
    overall: 75.2
    task_success: 78.5
    reliability: 72.1
    efficiency: 70.0
  
  changes:
    - type: parameter
      target: prompts/planner.md
      description: "improved task decomposition"
      approved_by: [analyzer, proposer, validator]
      result: applied
  
  council_votes:
    - agent: analyzer-1
      role: analyzer
      decision: approve
      reasoning: "weakness addressed"
```

## Git Integration

State management integrates with git for version control:

| Action | Git Operation |
|--------|---------------|
| Every change | `git commit` |
| Major restructuring | `git branch` per generation |
| Rollback | `git checkout` specific branch |

This enables:
- Full change history
- Easy rollback to any generation
- Diff tracking
- Review capability

## Rollback Protocol

If a change causes problems:

```
1. Detect regression
   - Score drops significantly
   
2. Identify last working generation
   - Check history
   
3. Checkout git branch for that generation
   - `git checkout evolution/gen-10`
   
4. Restore harness to working state
   - Copy files from branch
   
5. Record rollback in state
   - Log incident
   
6. Analyze what caused the regression
   - Store in failure_memory
```

## Trend Analysis

State management includes trend analysis:

```
Calculation:
  - Compare last 5 generations' scores
  - Calculate average delta
  - Determine direction

Direction rules:
  - improving: delta > +2
  - declining: delta < -2
  - stable: delta between -2 and +2
```

## Loop Detection

State tracks harness content hashes to detect loops:

```
Detection:
  - Track content hash of each harness
  - Store in generation snapshot
  
Rule:
  - If same hash appears 3+ times → halt
  - Log incident to failure_memory
  - Alert user to potential issue
  
Purpose:
  - Prevent infinite loops
  - Catch non-improving evolution
```

## Related Documentation

- [Evolution Engine](../6-evolution-engine/README.md) — Updates state
- [Council Governance](../7-council/README.md) — Records decisions