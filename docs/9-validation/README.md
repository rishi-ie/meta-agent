# Validation Pipeline

Validation ensures that proposed changes are safe and effective before being applied to the main harness.

## Validation Stages

```
┌─────────────────────────────────────────────────────────────┐
│                  VALIDATION PIPELINE                        │
│                                                             │
│  ┌───────────────┐    ┌───────────────┐    ┌─────────────┐│
│  │ CONSTITUTIONAL│ → │  SYNTAX       │ → │  FUNCTIONAL ││
│  │ VALIDATION     │    │  VALIDATION   │    │  VALIDATION ││
│  │                │    │               │    │             ││
│  │ Check safety   │    │ Validate YAML  │    │ Test on     ││
│  │ boundaries     │    │ structure      │    │ benchmarks  ││
│  └───────────────┘    └───────────────┘    └─────────────┘│
└─────────────────────────────────────────────────────────────┘
```

## Stage 1: Constitutional Validation

Ensures proposed changes don't violate safety boundaries.

### Checks

- **Boundary check** — Does the change violate any Article II rule?
- **Scope check** — Is the change attempting to modify protected sections?
- **Authority check** — Does the proposing agent have permission?

### Violation Response

```
Violation detected → REJECT immediately
                    → Log to audit
                    → Alert user
```

## Stage 2: Syntax Validation

Ensures the harness is structurally valid.

### Checks

- **Schema validation** — All required fields present
- **Type validation** — All values have correct types
- **Reference validation** — All file paths exist
- **Enum validation** — All enum values are valid

## Stage 3: Functional Validation

Tests the harness in a sandbox.

### Process

1. **Subset testing** — Run on 10-20 benchmark tasks
2. **Baseline comparison** — Compare to current harness scores
3. **Improvement threshold** — Must improve by minimum percentage
4. **Regression check** — Must not degrade other metrics

## Validation Thresholds

Different change types require different thresholds:

| Change Type | Required Improvement |
|-------------|---------------------|
| Prompt edit | > 5% |
| Config param | No regression |
| New tool | > 10% |
| Topology | > 15% |
| Harness rewrite | > 20% |

## Failure Handling

If validation fails:

1. **Record failure** — Store in failure_memory/
2. **Analyze cause** — Identify why change failed
3. **Propose alternatives** — Generate alternative changes
4. **Loop prevention** — Track failures to avoid retrying same change

## Validation Result

```yaml
validation_result:
  valid: false
  stage: functional
  
  errors:
    - "Score regression: -3.2% (threshold: 0%)"
  
  warnings:
    - "Latency increased by 15%"
  
  metrics:
    baseline_score: 78.5
    candidate_score: 75.3
    improvement: -3.2%
    benchmark_count: 15
    passed_count: 12
    failed_count: 3
```

## Related Documentation

- [Constitution](../4-constitution/README.md) — Safety boundaries checked
- [Task Library](../5-task-library/README.md) — Benchmarks used for testing
- [Sandbox](../10-sandbox/README.md) — Where validation executes