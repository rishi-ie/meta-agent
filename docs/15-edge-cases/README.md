# Edge Cases and Error Handling

How the system handles edge cases and errors.

## Task Library Empty

**Scenario**: No tasks in library when evolution starts

**Detection**: TaskLibrary.count() returns 0

**Handling**:
```
1. Block evolution start
2. Display error: "Task library empty. Generate tasks first."
3. Suggest: meta-agent tasks generate <job-file>
```

## All Tasks Fail

**Scenario**: Current harness scores 0% on all tasks

**Detection**: benchmark_results.every(r => r.success === false)

**Handling**:
```
1. Analyze failure patterns
2. Identify common failure mode
3. If fundamental issue → suggest harness reset
4. If specific issue → target fix via council
```

## Council Deadlock

**Scenario**: Council cannot reach decision threshold

**Detection**: votes.count < threshold for N rounds

**Handling**:
```
1. Main agent reviews disagreement
2. Main agent may:
   a. Accept majority decision
   b. Veto with documented reasoning
   c. Escalate to human review
3. Log incident for future improvement
```

## Validation Timeout

**Scenario**: Validation exceeds timeout threshold

**Detection**: validation_elapsed > timeout_limit

**Handling**:
```
1. Kill sandbox process
2. Mark validation as TIMEOUT
3. Reject proposed change
4. Log to failure_memory/
5. Alert: "Validation timed out. Consider simplifying change."
```

## Harness Parse Error

**Scenario**: Proposed change breaks YAML syntax

**Detection**: YAML.parse() throws SyntaxError

**Handling**:
```
1. Catch parse error
2. Display specific error location
3. Reject proposed change
4. Do not apply partial changes
```

## Sandbox Unavailable

**Scenario**: No sandbox resources available

**Detection**: sandbox_pool.available === 0 && queue.length > 0

**Handling**:
```
1. Queue validation request
2. Wait for available sandbox
3. If timeout → use in-process fallback (risky changes only)
4. Alert if consistently unavailable
```

## Git Conflict

**Scenario**: Manual changes conflict with evolution changes

**Detection**: git.merge() returns CONFLICT

**Handling**:
```
1. Detect conflict on evolution commit
2. Display conflict details
3. Options:
   a. Accept evolution changes (discard manual)
   b. Accept manual changes (discard evolution)
   c. Manual merge
4. Resolve before continuing
```

## Constitutional Violation Attempted

**Scenario**: Proposed change violates safety boundary

**Detection**: checkSafetyBoundaries() returns violations[]

**Handling**:
```
1. Catch during constitutional validation
2. Display which boundary is violated
3. REJECT immediately (no partial application)
4. Log attempt to audit log
5. Alert: "Change violates constitutional rule: [rule]"
```

## Memory Exhaustion

**Scenario**: Agent uses excessive memory

**Detection**: memory_usage > max_memory_mb

**Handling**:
```
1. Monitor memory usage continuously
2. If exceeds limit → terminate execution
3. Mark task as FAILED (memory)
4. Log incident
5. If pattern → suggest optimization in memory config
```

## Infinite Loop Detection

**Scenario**: Same harness repeating without improvement

**Detection**: harness_hash_seen_count[hash] >= 3

**Handling**:
```
1. Track harness content hashes
2. If same hash appears 3+ times → HALT
3. Display: "Loop detected: harness not improving"
4. Suggest: manual intervention or harness reset
```

## Sandbox Process Crash

**Scenario**: Sandbox process terminates unexpectedly

**Detection**: sandbox_process.exit_code !== 0

**Handling**:
```
1. Capture exit code and stderr
2. Mark sandbox as failed
3. Return error to parent
4. Log to failure_memory/
5. Alert: "Sandbox process crashed"
```

## Subagent Timeout

**Scenario**: Subagent exceeds idle timeout

**Detection**: subagent.idle_time > idle_timeout_seconds

**Handling**:
```
1. Send termination signal
2. Wait for graceful shutdown (5s)
3. Force kill if still running
4. Return partial results if available
5. Log timeout incident
```

## Task Timeout

**Scenario**: Task execution exceeds timeout

**Detection**: task_elapsed > task.timeout_seconds

**Handling**:
```
1. Send termination signal to executor
2. Mark task as TIMEOUT
3. Record partial trace if available
4. Log to failure_memory/
5. Continue to next task in benchmark
```

## Score Regression

**Scenario**: New harness scores lower than current

**Detection**: candidate_score < current_score - regression_threshold

**Handling**:
```
1. Reject proposed change
2. Log regression in failure_memory/
3. Analyze cause:
   a. Wrong change applied
   b. Validation insufficient
   c. Benchmark noise
4. Suggest adjustments for next proposal
```

## Related Documentation

- [Evolution Engine](../6-evolution-engine/README.md) — Loop control
- [Validation Pipeline](../9-validation/README.md) — Change testing
- [State Management](../11-state-management/README.md) — Failure tracking