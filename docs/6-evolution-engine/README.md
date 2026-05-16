# Evolution Engine

The evolution engine is the core loop that drives self-improvement. It iteratively evaluates the current harness, proposes modifications, validates them, and applies improvements.

## Evolution Loop

```
┌─────────────────────────────────────────────────────────────┐
│                    EVOLUTION LOOP                            │
│                                                             │
│  while (score < threshold && generation < max):              │
│                                                             │
│    1. RUN BENCHMARK                                         │
│       Execute current harness on task library               │
│              │                                             │
│              ▼                                             │
│    2. COLLECT RESULTS                                       │
│       Gather scores, traces, failure data                  │
│              │                                             │
│              ▼                                             │
│    3. COUNCIL ANALYSIS                                      │
│       Analyze failures, identify weak areas                 │
│              │                                             │
│              ▼                                             │
│    4. PROPOSE CHANGES                                       │
│       Generate specific harness modifications              │
│              │                                             │
│              ▼                                             │
│    5. VALIDATE CHANGES                                      │
│       Test harness validates modifications                  │
│              │                                             │
│              ▼                                             │
│    6. APPLY CHANGES                                         │
│       If valid, modify harness                             │
│              │                                             │
│              ▼                                             │
│    7. RECORD STATE                                          │
│       Update state, create git snapshot                     │
│              │                                             │
│              ▼                                             │
│                      Next Generation                         │
└─────────────────────────────────────────────────────────────┘
```

## State Structure

```yaml
evolution_state:
  generation: 12
  best_score: 84.7
  best_generation: 10
  harness_version: v12-harness
  last_change: "prompts/planner.md updated"
  
  benchmark_scores:
    overall: 82.4
    task_success: 85.1
    reliability: 79.2
    efficiency: 78.5
  
  status: running
  started_at: "2024-05-16T10:00:00Z"
  updated_at: "2024-05-16T12:30:00Z"
```

## Score Calculation

The overall score is a weighted combination:

```
overall_score =
  (task_success × 0.5) +
  (reliability × 0.2) +
  (efficiency × 0.15) +
  (trace_quality × 0.1) +
  (judge_score × 0.05)
```

## Change Types

Evolution can modify different harness sections:

| Change Type | Risk Level | Validation Required |
|-------------|------------|---------------------|
| Prompt edits | Low | 5 benchmarks |
| Config parameter | Medium | 10 benchmarks |
| New tool | Medium | Integration test + 10 benchmarks |
| Topology change | High | Full benchmark suite |
| Harness rewrite | Critical | Full suite + edge cases |

### Change Status Flow

```
pending → approved → validated → applied
                  ↘ rejected
```

## Improvement Detection

The engine detects improvement patterns:

| Pattern | Detection | Action |
|---------|-----------|--------|
| `monotonic` | Score increases consistently | Continue evolution |
| `plateau` | Score stabilizes with fluctuations | Monitor closely |
| `declining` | Score decreases | Analyze cause |
| `oscillating` | Score fluctuates significantly | Review routing |

## Loop Prevention

The engine detects when the same harness is repeated:

- Track harness content hashes
- If same harness appears 3+ times → halt evolution
- Log incident to failure_memory
- Alert user to potential issue

## Early Termination

Evolution ends when any stop condition is met:

| Condition | Trigger |
|-----------|---------| 
| Quality threshold met | All metrics ≥ threshold |
| Generation limit | 50 generations (configurable) |
| Plateau detected | No improvement for 5 generations |
| User halt | Manual stop |
| Safety violation | Constitutional boundary crossed |

## Generation Tracking

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
      result: applied
  council_votes:
    - role: analyzer
      decision: approve
    - role: proposer
      decision: approve
    - role: validator
      decision: approve
```

## Related Documentation

- [Council Governance](../7-council/README.md) — Decision-making in evolution
- [Validation Pipeline](../9-validation/README.md) — How changes are tested
- [State Management](../11-state-management/README.md) — Tracking evolution progress