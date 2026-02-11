# Quick Reference Guide

[← Back to Documentation Index](./README.md)

---

## ⚡ Most Common Commands

| Command | Purpose | Use Case |
|---------|---------|----------|
| `/bmad-help` | Get personalized guidance | Anytime you're unsure |
| `/bmad-bmm-quick-spec` | Create tech spec | Bug fixes, small features |
| `/bmad-bmm-quick-dev` | Rapid development | Implement from spec |
| `/bmad-bmm-code-review` | Quality validation | After implementation |
| `/bmad-bmm-create-prd` | Product requirements | New product planning |
| `/bmad-bmm-create-architecture` | Technical design | After PRD, before stories |
| `/bmad-bmm-sprint-planning` | Initialize sprint | Start implementation |
| `/bmad-bmm-dev-story` | Implement story | Core dev loop |
| `/bmad-party-mode` | Multi-agent discussion | Complex decisions |
| `/bmad-brainstorming` | Creative ideation | Early exploration |

---

## 📋 Commands by Purpose

### 🆘 Help & Guidance
```bash
/bmad-help                                    # Context-aware guidance
/bmad-help <your question>                    # Specific question
/bmad-bmm-sprint-status                       # Check sprint progress
```

### 🎯 Analysis & Discovery
```bash
/bmad-brainstorming                           # Creative techniques
/bmad-bmm-create-product-brief                # Define MVP scope
/bmad-bmm-market-research                     # Market analysis
/bmad-bmm-domain-research                     # Industry expertise
/bmad-bmm-technical-research                  # Tech feasibility
/bmad-bmm-document-project                    # Analyze existing code
/bmad-bmm-generate-project-context            # Create project-context.md
```

### 📝 Planning
```bash
/bmad-bmm-create-prd                          # Requirements document
/bmad-bmm-validate-prd                        # Validate PRD
/bmad-bmm-edit-prd                            # Improve PRD
/bmad-bmm-create-ux-design                    # UX planning
```

### 🏗️ Architecture & Design
```bash
/bmad-bmm-create-architecture                 # Technical decisions
/bmad-bmm-create-epics-and-stories            # Break into stories
/bmad-bmm-check-implementation-readiness      # Validate alignment
```

### 💻 Implementation
```bash
/bmad-bmm-sprint-planning                     # Initialize sprint
/bmad-bmm-create-story                        # Prepare story
/bmad-bmm-dev-story                           # Implement story
/bmad-bmm-code-review                         # Quality check
/bmad-bmm-correct-course                      # Navigate changes
/bmad-bmm-retrospective                       # Review epic
```

### ⚡ Quick Flow
```bash
/bmad-bmm-quick-spec                          # Spec with questions
/bmad-bmm-quick-dev                           # Rapid implementation
/bmad-bmm-code-review                         # Quality validation
```

### 🧪 Testing (Quinn - Built-in)
```bash
/bmad-bmm-qa-automate                         # Generate tests
```

### 🧪 Testing (TEA - Enterprise)
```bash
/bmad_tea_teach-me-testing                    # 7-session academy
/bmad_tea_framework                           # Test framework
/bmad_tea_ci                                  # CI/CD pipeline
/bmad_tea_test-design                         # Risk-based planning
/bmad_tea_atdd                                # TDD red phase
/bmad_tea_automate                            # Expand coverage
/bmad_tea_test-review                         # Quality audit
/bmad_tea_nfr-assess                          # Non-functional reqs
/bmad_tea_trace                               # Traceability matrix
```

### 🎮 Game Development
```bash
/bmad-gds-brainstorm-game                     # Game brainstorming
/bmad-gds-game-brief                          # Game vision
/bmad-gds-gdd                                 # Game design doc
/bmad-gds-narrative                           # Story design
/bmad-gds-game-architecture                   # Game tech design
/bmad-gds-sprint-planning                     # Game sprint
/bmad-gds-create-story                        # Prepare story
/bmad-gds-dev-story                           # Implement
/bmad-gds-code-review                         # Game review (60fps)
/bmad-gds-test-automate                       # Game tests
/bmad-gds-playtest-plan                       # Playtesting
/bmad-gds-performance-test                    # Performance strategy
```

### 💡 Creative Intelligence
```bash
/bmad-cis-innovation-strategy                 # Business innovation
/bmad-cis-design-thinking                     # Human-centered design
/bmad-cis-problem-solving                     # Systematic solving
/bmad-cis-storytelling                        # Narrative development
/bmad-cis-brainstorming                       # CIS brainstorming
```

### 🛠️ Build Custom Components
```bash
/bmad_bmb_create_agent                        # New agent
/bmad_bmb_edit_agent                          # Edit agent
/bmad_bmb_validate_agent                      # Validate agent
/bmad_bmb_create_workflow                     # New workflow
/bmad_bmb_edit_workflow                       # Edit workflow
/bmad_bmb_validate_workflow                   # Validate workflow
/bmad_bmb_create_module                       # New module
/bmad_bmb_edit_module                         # Edit module
/bmad_bmb_validate_module                     # Validate module
```

### 📚 Documentation & Utilities
```bash
/tech-writer                                  # Load Paige (Tech Writer)
# Then ask: "Write document about X"
# Or: "Validate document at path/to/doc.md"
# Or: "Create diagram for X"

/bmad-party-mode                              # Multi-agent discussion
/bmad-index-docs                              # Create doc index
/bmad-shard-doc                               # Split large docs
/bmad-editorial-review-prose                  # Prose review
/bmad-editorial-review-structure              # Structure review
/bmad-review-adversarial-general              # Critical review
```

---

## 🎯 Quick Decision Flow

```
Need help or unsure?
└─> /bmad-help

New complex project?
├─> Full Planning Path
│   └─> /bmad-bmm-create-prd → ... → /bmad-bmm-sprint-planning
└─> Quick & Clear?
    └─> Quick Flow Path
        └─> /bmad-bmm-quick-spec → /bmad-bmm-quick-dev → /bmad-bmm-code-review

Game project?
└─> /bmad-gds-game-brief → /bmad-gds-gdd → /bmad-gds-game-architecture

Existing codebase?
└─> /bmad-bmm-document-project → Choose path above

Creative exploration?
└─> /bmad-brainstorming or CIS workflows

Need tests?
├─> Quick: /bmad-bmm-qa-automate
└─> Enterprise: TEA workflows
```

---

## 📊 Workflow Comparison Tables

### Full Planning vs Quick Flow

| Aspect | Full Planning | Quick Flow |
|--------|---------------|------------|
| **Time** | 4-8 hours (planning) | 30 min - 2 hours |
| **Complexity** | Complex, unclear requirements | Simple, clear requirements |
| **Artifacts** | PRD, Architecture, Epics, Stories | Tech Spec only |
| **Team Size** | Multiple people | Solo or small team |
| **Use For** | New products, major features | Bug fixes, small features |
| **Flexibility** | High - can adapt as you learn | Low - assumes clarity |
| **Validation** | Multiple checkpoints | Single review |
| **Best When** | Requirements evolving | Requirements fixed |

### Quinn (BMM QA) vs TEA (Test Architect)

| Aspect | Quinn (Built-in) | TEA (Module) |
|--------|------------------|--------------|
| **Complexity** | Simple | Enterprise-grade |
| **Setup** | None (always available) | Separate install |
| **Workflows** | 1 (`qa-automate`) | 9 (full lifecycle) |
| **Approach** | Generate tests fast | Risk-based strategy |
| **Best For** | Standard projects | Compliance, critical systems |
| **Planning** | Minimal | Comprehensive test design |
| **Quality Gates** | No | Yes (PASS/FAIL decisions) |
| **Learning Curve** | Easy | Advanced |
| **Traceability** | No | Yes (requirements mapping) |

### Software (BMM) vs Game (GDS) Workflows

| Aspect | BMM (Software) | GDS (Game) |
|--------|----------------|------------|
| **Planning Doc** | PRD | GDD (Game Design Doc) |
| **Architect** | Winston | Cloud Dragonborn |
| **Developer** | Amelia | Link Freeman |
| **Focus** | Features, users | Gameplay, feel |
| **Review** | Code quality | 60fps, performance |
| **Testing** | Quinn or TEA | GLaDOS (Game QA) |
| **Special** | UX Design | Narrative Design |
| **Platforms** | Web, mobile, API | Unity, Unreal, Godot |

---

## 🗂️ Project Structure Reference

```
Cmpe492/
│
├── _bmad/                              # ⚠️ Don't edit directly!
│   ├── _config/                        # Configuration
│   ├── _memory/                        # Agent memory
│   ├── core/                           # Core module
│   ├── bmm/                            # BMad Method
│   ├── bmb/                            # BMad Builder
│   ├── cis/                            # Creative Intelligence
│   ├── gds/                            # Game Dev Studio
│   └── tea/                            # Test Architect
│
├── _bmad-output/                       # ✅ Generated artifacts
│   ├── planning-artifacts/
│   │   ├── product-brief.md
│   │   ├── prd.md
│   │   ├── architecture.md
│   │   ├── ux-design.md
│   │   ├── epics/
│   │   │   ├── epic-01-user-auth.md
│   │   │   ├── epic-02-dashboard.md
│   │   │   └── ...
│   │   └── research/
│   │
│   ├── implementation-artifacts/
│   │   ├── sprint-status.yaml
│   │   ├── stories/
│   │   │   ├── epic-01/
│   │   │   │   ├── story-001.md
│   │   │   │   ├── story-002.md
│   │   │   │   └── ...
│   │   │   └── ...
│   │   └── retrospectives/
│   │
│   ├── test-artifacts/
│   │   ├── test-design/
│   │   ├── test-reviews/
│   │   ├── traceability/
│   │   └── framework/
│   │
│   └── bmb-creations/
│       ├── agents/
│       ├── workflows/
│       └── modules/
│
├── docs/
│   ├── bmad/                           # This documentation
│   └── [your project docs]
│
└── [your source code]
```

---

## 🚨 Troubleshooting Quick Guide

| Problem | Solution |
|---------|----------|
| "Not sure which workflow to use" | Run `/bmad-help` with description |
| "Workflow seems too complex" | Try Quick Flow instead |
| "Need to make major changes" | Use `/bmad-bmm-correct-course` |
| "Want multiple perspectives" | Use `/bmad-party-mode` |
| "Validation found issues" | Use edit workflows or re-run |
| "Context too long/slow" | Start fresh context |
| "Agent personality wrong" | Close context, start fresh |
| "Can't find output" | Check `_bmad-output/` folders |
| "Documentation unclear" | Load `/tech-writer` for help |
| "Tests failing" | Use `/bmad-bmm-code-review` |

---

## 💡 Pro Tips

### Tip 1: Always Review Outputs
After each workflow, check `_bmad-output/` and read the generated artifact before proceeding.

### Tip 2: Use Validation Workflows
Especially with a different LLM:
- Claude for creation → GPT-4 for validation
- Gets unbiased feedback

### Tip 3: Fresh Context = Fresh Thinking
One workflow per context window for best results.

### Tip 4: Don't Skip Required Workflows
They build on each other. Skipping causes issues later.

### Tip 5: Party Mode for Tough Decisions
When stuck on architecture, trade-offs, or complex decisions, bring agents together.

### Tip 6: Sprint Status is Your Friend
```bash
/bmad-bmm-sprint-status
```
Run anytime to check progress and get next actions.

### Tip 7: Quick Flow Isn't Always Faster
If requirements are unclear, Quick Flow wastes time. Use Full Planning for complex work.

### Tip 8: Document Brownfield First
Before adding features to existing code:
```bash
/bmad-bmm-document-project
/bmad-bmm-generate-project-context
```

### Tip 9: Test Early (If Critical)
For critical systems, use TEA workflows during Solutioning phase (Phase 3), not just Implementation (Phase 4).

### Tip 10: Retrospectives Matter
Run `/bmad-bmm-retrospective` after each epic. Extract lessons, improve process.

---

## 🎓 Context Window Cheat Sheet

| Scenario | Context Strategy |
|----------|------------------|
| Each major workflow | **New context** |
| Story cycle (Create→Dev→Review) | **Same context OK** |
| Next story | **New context** |
| Validation workflows | **New context + different LLM** |
| `/bmad-help` queries | **Any context** |
| Party Mode | **Same context (extended)** |
| Loaded agents (Tech Writer) | **Same context (multi-turn)** |
| Quick Flow (tiny tasks) | **Same context OK** |

---

## 📞 Getting More Help

### In-App
```bash
/bmad-help
/bmad-help <your specific question>
```

### Documentation
- [Getting Started](./GETTING-STARTED.md) - First steps
- [Workflows Guide](./WORKFLOWS-GUIDE.md) - Detailed scenarios
- [Agents Reference](./AGENTS-REFERENCE.md) - Meet the agents
- [Best Practices](./BEST-PRACTICES.md) - Proven strategies
- [Context Mapping](./CONTEXT-MAPPING.md) - Context window guide

### Community
- **Discord** - Real-time help
- **GitHub Issues** - Bug reports
- **Documentation** - [bmad.dev](https://bmad.dev)

---

[← Back to Documentation Index](./README.md)
