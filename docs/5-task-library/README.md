# Task Library Generation

The task library is a collection of benchmark tasks that define what "success" looks like for the target role. It is the evaluation signal that drives evolution.

## Pre-Generation Requirement

**Task library generation must complete before evolution begins.** This is a constitutional requirement.

## Generation Workflow

```
Job Description
     │
     ▼
Web Agents Crawl Job Postings
     │
     ▼
Capability Extraction
     │
     ▼
LLM Generates Task Specifications
     │
     ▼
Task Validation
     │
     ▼
Task Library Stored
     │
     ▼
Evolution Begins
```

## Web Agent Data Sources

Web agents crawl real-world job postings to extract authentic task requirements:

| Source Type | Examples |
|------------|----------|
| Job boards | LinkedIn, Indeed, Glassdoor |
| Company career pages | Individual company job postings |
| Technical communities | Hacker News "Who Is Hiring", Stack Overflow |
| Open source repos | GitHub job requirements, CONTRIBUTING files |

## Capability Extraction

From job postings, the system extracts:

| Category | Description |
|----------|-------------|
| Technical skills | Languages, frameworks, tools |
| Domain knowledge | Industry-specific concepts |
| Process requirements | Workflow, methodology |
| Soft requirements | Communication, collaboration |

### Capability Profile

```yaml
capability_profile:
  technical:
    - python
    - kubernetes
    - aws
    - docker
  
  domain:
    - backend-systems
    - api-design
    - distributed-systems
  
  process:
    - code-review
    - testing
    - deployment-pipeline
  
  soft:
    - documentation
    - communication
    - debugging
```

## Task Format

Each task in the library follows a standard format:

```yaml
id: coding-001
category: coding
difficulty: medium
capabilities:
  - api-integration
  - error-handling
  - code-testing

description: |
  Implement a REST API endpoint that:
  - Accepts JSON payload with user email and preferences
  - Validates email format
  - Stores in mock database
  - Returns 201 with user ID

success_criteria:
  - endpoint exists at /api/users
  - accepts POST with valid JSON
  - validates email format
  - returns 201 status
  - response contains user_id

timeout_seconds: 60

metadata:
  source: "linkedin-job-12345"
  generated_at: "2024-05-16T00:00:00Z"
```

## Task Categories

| Category | Description | Examples |
|----------|-------------|-----------|
| `coding` | Implement features, write tests | "Implement REST endpoint", "Add authentication" |
| `debugging` | Fix errors, investigate issues | "Fix null pointer exception", "Debug memory leak" |
| `deployment` | Deploy applications, configure CI/CD | "Deploy to Kubernetes", "Setup GitHub Actions" |
| `research` | Find information, compare options | "Find best caching strategy", "Compare databases" |
| `communication` | Write docs, explain decisions | "Write API documentation", "Summarize findings" |

## Task Difficulty Distribution

A balanced task library includes:

| Difficulty | Percentage | Characteristics |
|------------|------------|-----------------|
| `easy` | 30% | Single-step tasks, well-defined requirements |
| `medium` | 50% | Multi-step tasks, some ambiguity |
| `hard` | 20% | Complex tasks, multiple valid approaches |

## Task Validation

Before tasks enter the library, they are validated:

| Check | Description |
|-------|-------------|
| Executable | Can be run in sandbox environment |
| Measurable | Has clear success/failure criteria |
| Reproducible | Same input produces same output |
| Relevant | Directly relates to job requirements |

## Task Library Structure

```
task_library/
├── index.json              # Manifest of all tasks
│
├── coding/
│   ├── task-001.md
│   ├── task-002.md
│   └── ...
│
├── debugging/
│   ├── task-001.md
│   └── ...
│
├── deployment/
│   └── ...
│
└── research/
    └── ...
```

## Generation Configuration

```yaml
generation:
  min_tasks_per_category: 50
  difficulty_distribution:
    easy: 0.30
    medium: 0.50
    hard: 0.20
  
  sources:
    - type: web_crawl
      priority: high
    - type: llm_generation
      priority: medium
  
  validation:
    require_executable: true
    require_measurable: true
    timeout_seconds: 300
```

## Related Documentation

- [Harness Model](../2-harness/README.md) — How the agent uses tasks
- [Evolution Engine](../6-evolution-engine/README.md) — How tasks drive evolution
- [Validation Pipeline](../9-validation/README.md) — How tasks are validated