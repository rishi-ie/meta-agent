# Meta Agent

> Digital Employee Framework for Pi Agent

Transform Pi Agent into a **digital employee factory**. Create specialized assistants with constitution, persona, skills, and extensions.

---

## What is Meta Agent?

Meta Agent is a framework that sits on top of Pi Agent. It provides:

- **Extensions** — Model router, memory, context manager, persona
- **Skills** — Constitution and persona templates
- **Employees** — Pre-configured digital employee definitions

```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │ Constitution│  │   Persona   │  │   Skills    │          │
│  │   (Skill)   │  │   (Skill)   │  │  (Domain)   │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
│                                                             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐             │
│  │   Model    │  │   Memory   │  │  Context    │             │
│  │   Router   │  │  Extension │  │  Manager    │             │
│  └────────────┘  └────────────┘  └────────────┘             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Start

### 1. Run with Extensions

```bash
pi -e ./extensions/model-router.ts \
   -e ./extensions/memory.ts \
   -e ./extensions/context-manager.ts \
   -e ./extensions/persona.ts
```

### 2. Run with Skills

```bash
pi --skill ./skills/constitutions/medical/00-CONSTITUTION-medical.md \
   --skill ./skills/personas/medical/10-PERSONA-medical.md
```

### 3. Run Complete Employee

```bash
pi -e ./extensions/model-router.ts \
   -e ./extensions/memory.ts \
   -e ./extensions/context-manager.ts \
   -e ./extensions/persona.ts \
   --skill ./skills/constitutions/medical/00-CONSTITUTION-medical.md \
   --skill ./skills/personas/medical/10-PERSONA-medical.md
```

---

## Extensions

| Extension | Purpose |
|-----------|---------|
| `model-router` | Routes tasks to appropriate models |
| `memory` | Learns and persists facts across sessions |
| `context-manager` | Prevents context overflow |
| `persona` | Injects behavioral guidance |

### Commands

| Command | Description |
|---------|-------------|
| `/router-status` | Show model routing status |
| `/memory-show` | Display stored memories |
| `/memory-clear` | Clear all memories |
| `/context-status` | Show context usage |
| `/context-compact` | Manual compaction |
| `/persona-show` | Display persona config |

---

## Skills

### Constitution

Domain principles loaded as a skill:

```markdown
# Medical Assistant Constitution

## Core Principles
1. Patient safety first
2. Transparency about uncertainty
3. Privacy protection

## Boundaries
- DO NOT provide diagnoses
- DO NOT prescribe medications
```

### Persona

Communication style loaded as a skill:

```markdown
# Medical Assistant Persona

## Communication Style
- Clear and jargon-free
- Warm and empathetic
- Ask clarifying questions

## Tone
- Professional but approachable
```

### Skill Priority

Skills load by filename prefix:

```
00-CONSTITUTION-*  → Loaded first
10-PERSONA-*       → Loaded second
20-SKILL-*         → Loaded third
```

---

## Project Structure

```
meta-agent/
├── skills/
│   ├── constitutions/
│   │   ├── 00-CONSTITUTION-template.md
│   │   └── [domain]/
│   │       └── 00-CONSTITUTION-[domain].md
│   └── personas/
│       ├── 00-PERSONA-template.md
│       └── [domain]/
│           └── 10-PERSONA-[domain].md
│
├── employees/
│   └── [name]/
│       └── config.json
│
├── architecture.md     # Full documentation
└── README.md           # This file
```

---

## Creating an Employee

### 1. Create Constitution

`skills/constitutions/my-domain/00-CONSTITUTION-my-domain.md`:

```markdown
# My Employee Constitution

## Core Principles
1. [Principle 1]
2. [Principle 2]

## Boundaries
- DO NOT [prohibited action]
- DO [allowed action]
```

### 2. Create Persona

`skills/personas/my-domain/10-PERSONA-my-domain.md`:

```markdown
# My Employee Persona

## Communication Style
- [Style 1]
- [Style 2]

## Tone
- [Tone description]
```

### 3. Create Employee Config

`employees/my-employee/config.json`:

```json
{
  "name": "my-employee",
  "version": "1.0.0",
  "description": "My custom digital employee",
  
  "constitution": {
    "path": "skills/constitutions/my-domain/00-CONSTITUTION-my-domain.md"
  },
  
  "persona": {
    "path": "skills/personas/my-domain/10-PERSONA-my-domain.md"
  },
  
  "extensions": [
    "model-router",
    "memory",
    "context-manager",
    "persona"
  ]
}
```

### 4. Run

```bash
pi -e ./extensions/model-router.ts \
   -e ./extensions/memory.ts \
   -e ./extensions/context-manager.ts \
   -e ./extensions/persona.ts \
   --skill ./skills/constitutions/my-domain/00-CONSTITUTION-my-domain.md \
   --skill ./skills/personas/my-domain/10-PERSONA-my-domain.md
```

---

## Architecture

See [architecture.md](./architecture.md) for:
- Extension implementation guides
- Event system reference
- Memory system design
- Model routing algorithms
- Integration details

---

## License

MIT