# Council Governance

The council is a multi-agent system that coordinates self-improvement. It distributes expertise across different aspects of the harness, preventing single-point-of-failure evolution.

## Council Roles

| Role | Responsibility | Output |
|------|---------------|--------|
| **Analyzer** | Examine failed traces, identify weak components | Weakness Report |
| **Proposer** | Generate harness modification proposals | Candidate Patches |
| **Validator** | Test proposed changes against benchmarks | Validation Results |
| **Synthesizer** | Merge council decisions, manage evolution strategy | Final Change Set |

## Communication Flow

```
ANALYZER
   │
   └─→ Weakness Report ──→ PROPOSER
                              │
                              └─→ Candidate Patches ──→ VALIDATOR
                                                        │
                                                        └─→ Validation Results ──→ SYNTHESIZER
                                                                            │
                                                                            └─→ Final Change Set ──→ MAIN AGENT
                                                                                                  │
                                                                                                  └─→ Apply Harness Change
```

## Decision Process

### 1. Proposal
Proposer generates candidate changes based on:
- Analyzer's weakness report
- Current benchmark failures
- Historical successful changes

### 2. Distribution
All council members receive the proposal with full context

### 3. Analysis
Each member analyzes from their specialized perspective

### 4. Vote
Members cast votes:
- `approve` — Change should proceed
- `reject` — Change should not proceed
- `abstain` — No strong opinion

### 5. Tally
Votes counted against threshold:
- Parameter changes: majority (50%+1)
- Structural changes: unanimous

### 6. Resolution
If threshold met, changes proceed to validation

## Voting Thresholds

| Change Type | Threshold | Rationale |
|-------------|-----------|-----------|
| Parameter changes | Simple majority | Fast iteration for low-risk changes |
| New component | 2/3 majority | Moderate risk, needs more agreement |
| Structural changes | Unanimous | High risk, requires full consensus |
| Constitutional | 80% + human | Safety-critical, needs human oversight |

## Specialization Rules

### Domain Specialization
- Council members may specialize in specific harness sections
- Examples: prompts specialist, tools specialist, memory specialist

### Cross-Domain Changes
- Changes affecting multiple domains require consent from affected specialists
- Proposer must demonstrate understanding of all affected areas

## Conflict Resolution

When council cannot reach agreement:

1. **Document disagreement**
   - Each member records their reasoning
   - Full context preserved for analysis

2. **Main agent review**
   - Main agent examines the disagreement
   - Considers all perspectives

3. **Veto possibility**
   - Main agent may veto with documented rationale
   - Veto recorded for future reference

4. **Human escalation**
   - Blocking minority may escalate to user
   - User makes final decision

## Council Memory

The council maintains shared memory:

- Past proposals and their outcomes
- Failed experiments and analysis
- Successful modifications that improved scores
- Patterns identified across generations

This memory informs future decisions.

## Related Documentation

- [Evolution Engine](../6-evolution-engine/README.md) — Where council operates
- [Constitution](../4-constitution/README.md) — Rules governing council decisions
- [Subagents](../8-subagents/README.md) — How council agents are spawned