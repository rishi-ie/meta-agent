# Component Interactions

How components interact with each other during key operations.

## Initialization Sequence

```
┌─────────────────────────────────────────────────────────────┐
│              INITIALIZATION SEQUENCE                        │
│                                                             │
│  1. CLI parses command and arguments                        │
│                                                             │
│  2. StateManager.loadState()                               │
│     └─ Load current.json                                    │
│                                                             │
│  3. ConstitutionParser.load()                               │
│     └─ Parse constitution.md                               │
│     └─ Validate constitutional rules                        │
│                                                             │
│  4. HarnessCompiler.load()                                  │
│     └─ Parse harness.yaml                                   │
│     └─ Validate structure                                   │
│                                                             │
│  5. TaskLibrary.load()                                      │
│     └─ Load task_library/index.json                         │
│                                                             │
│  6. SandboxManager.initialize()                             │
│     └─ Prepare sandbox pool                                │
│                                                             │
│  7. Ready for user commands                                  │
└─────────────────────────────────────────────────────────────┘
```

## Evolution Start Sequence

```
┌─────────────────────────────────────────────────────────────┐
│              EVOLUTION START SEQUENCE                        │
│                                                             │
│  1. User runs: meta-agent evolve start                     │
│                                                             │
│  2. StateManager.startEvolution()                          │
│     └─ Update status to 'running'                          │
│     └─ Record started_at                                   │
│                                                             │
│  3. HarnessCompiler.compile()                               │
│     └─ Parse and validate harness                          │
│     └─ Build execution graph                                │
│                                                             │
│  4. Council.initialize()                                    │
│     └─ Create Analyzer, Proposer, Validator, Synthesizer      │
│                                                             │
│  5. Begin evolution loop                                    │
│     └─ Run first generation                                │
└─────────────────────────────────────────────────────────────┘
```

## Council Decision Sequence

```
┌─────────────────────────────────────────────────────────────┐
│              COUNCIL DECISION SEQUENCE                       │
│                                                             │
│  1. Benchmark results available                             │
│                                                             │
│  2. ANALYZER examines failures                             │
│     └─ Identifies weak components                            │
│     └─ Outputs: Weakness Report                            │
│                                                             │
│  3. PROPOSER generates changes                              │
│     └─ Based on Weakness Report                             │
│     └─ Creates Candidate Patches                           │
│                                                             │
│  4. Council votes on candidates                             │
│                                                             │
│  5. VALIDATOR tests approved candidates                     │
│     └─ Spawns test harness subagent                         │
│     └─ Runs on benchmark subset                             │
│     └─ Returns: Validation Results                         │
│                                                             │
│  6. SYNTHESIZER merges decisions                           │
│     └─ Selects final changes                                 │
│     └─ Outputs: Final Change Set                           │
│                                                             │
│  7. MAIN AGENT applies changes                               │
│     └─ Modify harness files                                 │
│     └─ StateManager.recordChange()                         │
│     └─ Git commit                                           │
└─────────────────────────────────────────────────────────────┘
```

## Change Validation Sequence

```
┌─────────────────────────────────────────────────────────────┐
│              CHANGE VALIDATION SEQUENCE                     │
│                                                             │
│  1. Proposed change received                                │
│                                                             │
│  2. CONSTITUTIONAL VALIDATION                               │
│     └─ CheckSafetyBoundaries()                             │
│     └─ If violation → REJECT                                │
│                                                             │
│  3. SYNTAX VALIDATION                                       │
│     └─ Parse YAML                                           │
│     └─ Validate against schema                              │
│     └─ If invalid → REJECT                                  │
│                                                             │
│  4. FUNCTIONAL VALIDATION                                    │
│     └─ SandboxManager.createSandbox()                       │
│     └─ Spawn test harness subagent                          │
│     └─ Run on benchmark subset                              │
│     └─ Compare to baseline                                  │
│     └─ If improvement < threshold → REJECT                 │
│                                                             │
│  5. APPROVED                                                │
│     └─ Apply to main harness                                 │
└─────────────────────────────────────────────────────────────┘
```

## Task Flow

```
USER INPUT
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│                    ROUTER                                    │
│  Determines task type (coding, debugging, etc.)            │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    PLANNER                                   │
│  Decomposes task into subtasks                             │
│  Creates execution plan                                     │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    EXECUTOR                                   │
│  Executes subtasks using tools                              │
│  Calls subagents as needed                                  │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    VERIFIER                                  │
│  Validates output against criteria                          │
│  Triggers retry if failed                                   │
└─────────────────────┬───────────────────────────────────────┘
                      │
            ┌─────────┴─────────┐
            │                   │
            ▼                   ▼
         PASSED               FAILED
            │                   │
            ▼                   ▼
        OUTPUT              RETRY (if retries < limit)
                                         │
                                         ▼
                                     PLANNER
```

## Evolution Flow

```
TASK LIBRARY
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│                 BENCHMARK RUNNER                             │
│  Executes current harness on all tasks                      │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    SCORE CALCULATOR                          │
│  Computes overall score from metrics                        │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    COUNCIL                                  │
│  Analyzes → Proposes → Validates → Synthesizes             │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                  HARNESS MODIFIER                            │
│  Applies approved changes to harness                        │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                  STATE MANAGER                               │
│  Records changes, creates git snapshots                     │
└─────────────────────┬───────────────────────────────────────┘
                      │
            ┌─────────┴─────────┐
            │                   │
            ▼                   ▼
      THRESHOLD MET      MORE GENERATIONS
            │                   │
            ▼                   ▼
        COMPLETE          NEXT GENERATION
```

## Related Documentation

- [System Overview](../1-system-overview/README.md) — High-level architecture
- [Evolution Engine](../6-evolution-engine/README.md) — Loop interactions
- [Council Governance](../7-council/README.md) — Decision flow