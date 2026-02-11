# Context Window Mapping Guide

[← Back to Documentation Index](./README.md)

---

## 🎯 The Golden Rule

**One Workflow = One Fresh Context**

NOT one phase = one context. Each **individual workflow** should run in its own fresh context window for optimal results.

---

## 🤔 Why Fresh Contexts Matter

### Benefits of Fresh Contexts
- ✅ **Clean instructions** - No leftover agent personas or workflow rules
- ✅ **Better AI focus** - AI reads the specific workflow file fresh each time
- ✅ **Reduced errors** - Less chance of mixing requirements from different workflows
- ✅ **Optimal performance** - Shorter context = faster, cheaper responses
- ✅ **Easier debugging** - Clear separation if something goes wrong

### What Happens Without Fresh Contexts
- ⚠️ AI might mix instructions from different workflows
- ⚠️ Previous workflow's agent persona might interfere
- ⚠️ Context becomes very long and expensive
- ⚠️ Responses might become less focused
- ⚠️ Harder to troubleshoot issues

---

## 📋 Full Planning Path - Complete Context Map

Here's the **exact** context split for the Full Planning workflow (Software Projects):

### Phase 1: Analysis (Optional)

```bash
# ════════════════════════════════════════════════════════════
# CONTEXT 1: Brainstorming
# ════════════════════════════════════════════════════════════
/bmad-brainstorming
# Complete the brainstorming session
# Agent: Mary (Business Analyst)
# Output: _bmad-output/brainstorming/brainstorming-session-{date}.md
# Review the output
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 2: Product Brief
# ════════════════════════════════════════════════════════════
/bmad-bmm-create-product-brief
# Work through guided discovery with Mary
# Define problem, users, MVP scope
# Output: _bmad-output/planning-artifacts/product-brief.md
# Review the brief
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 3: Market Research (Optional)
# ════════════════════════════════════════════════════════════
/bmad-bmm-market-research
# Conduct market analysis with Mary
# Output: _bmad-output/planning-artifacts/research/market-research.md
# Review findings
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 4: Domain Research (Optional)
# ════════════════════════════════════════════════════════════
/bmad-bmm-domain-research
# Industry deep dive with Mary
# Output: _bmad-output/planning-artifacts/research/domain-research.md
# Review findings
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 5: Technical Research (Optional)
# ════════════════════════════════════════════════════════════
/bmad-bmm-technical-research
# Technical feasibility exploration with Mary
# Output: _bmad-output/planning-artifacts/research/technical-research.md
# Review findings
# ✅ CLOSE CONTEXT
```

### Phase 2: Planning (Required)

```bash
# ════════════════════════════════════════════════════════════
# CONTEXT 6: PRD Creation ⚠️ REQUIRED
# ════════════════════════════════════════════════════════════
/bmad-bmm-create-prd
# Expert-led PRD creation with John (PM)
# Answer questions about requirements, users, success metrics
# Output: _bmad-output/planning-artifacts/prd.md
# Review the PRD thoroughly
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 7: PRD Validation (Optional, use DIFFERENT LLM!)
# ════════════════════════════════════════════════════════════
# 💡 TIP: If you used Claude for PRD, use GPT-4 for validation
/bmad-bmm-validate-prd
# Get unbiased validation from John (PM)
# Output: _bmad-output/planning-artifacts/prd-validation-report.md
# Review findings and fix issues if needed
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 8: Edit PRD (If validation found issues)
# ════════════════════════════════════════════════════════════
/bmad-bmm-edit-prd
# Work with John to improve PRD
# Output: Updated prd.md
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 9: UX Design (Optional, recommended for UI projects)
# ════════════════════════════════════════════════════════════
/bmad-bmm-create-ux-design
# Plan UX with Sally (UX Designer)
# Output: _bmad-output/planning-artifacts/ux-design.md
# Review UX specifications
# ✅ CLOSE CONTEXT
```

### Phase 3: Solutioning (Required)

```bash
# ════════════════════════════════════════════════════════════
# CONTEXT 10: Architecture ⚠️ REQUIRED
# ════════════════════════════════════════════════════════════
/bmad-bmm-create-architecture
# Technical decisions with Winston (Architect)
# Document system design, tech stack, patterns
# Output: _bmad-output/planning-artifacts/architecture.md
# Review architecture decisions
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 11: Epics & Stories ⚠️ REQUIRED
# ════════════════════════════════════════════════════════════
/bmad-bmm-create-epics-and-stories
# Break down work with John (PM)
# Output: _bmad-output/planning-artifacts/epics/epic-*.md files
# Review all epics and stories
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 12: Implementation Readiness Check ⚠️ REQUIRED
# ════════════════════════════════════════════════════════════
/bmad-bmm-check-implementation-readiness
# Validate alignment with Winston (Architect)
# Ensures PRD, Architecture, and Stories are cohesive
# Output: _bmad-output/planning-artifacts/readiness-report.md
# Fix any issues found before proceeding
# ✅ CLOSE CONTEXT
```

### Phase 4: Implementation (Required)

```bash
# ════════════════════════════════════════════════════════════
# CONTEXT 13: Sprint Planning ⚠️ REQUIRED
# ════════════════════════════════════════════════════════════
/bmad-bmm-sprint-planning
# Initialize sprint with Bob (Scrum Master)
# Output: _bmad-output/implementation-artifacts/sprint-status.yaml
# Review sprint plan
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 14: Check Sprint Status (Anytime)
# ════════════════════════════════════════════════════════════
/bmad-bmm-sprint-status
# Get status summary and next action from Bob
# Can run in same context as other queries, or fresh
# ✅ CLOSE CONTEXT (or continue with questions)

# ════════════════════════════════════════════════════════════
# CONTEXT 15: Story 1 - Complete Cycle (SAME CONTEXT)
# ════════════════════════════════════════════════════════════
/bmad-bmm-create-story
# Bob prepares the first ready-for-dev story
# Output: _bmad-output/implementation-artifacts/stories/epic-X/story-Y.md

/bmad-bmm-dev-story
# Amelia (Developer) implements the story
# Creates code, writes tests, updates story file

/bmad-bmm-code-review
# Amelia performs adversarial review
# Finds 3-10 issues minimum
# Output: Review findings in story file

# Fix any issues found
# Re-run /bmad-bmm-dev-story if needed

# ✅ CLOSE CONTEXT when story is complete

# ════════════════════════════════════════════════════════════
# CONTEXT 16: Story 2 - Complete Cycle (NEW CONTEXT!)
# ════════════════════════════════════════════════════════════
/bmad-bmm-create-story
/bmad-bmm-dev-story
/bmad-bmm-code-review
# Same pattern, fresh context
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 17: Story 3 - Complete Cycle (NEW CONTEXT!)
# ════════════════════════════════════════════════════════════
/bmad-bmm-create-story
/bmad-bmm-dev-story
/bmad-bmm-code-review
# ✅ CLOSE CONTEXT

# ... Repeat for each story ...

# ════════════════════════════════════════════════════════════
# CONTEXT N: Retrospective (After Epic Complete)
# ════════════════════════════════════════════════════════════
/bmad-bmm-retrospective
# Review with Bob (Scrum Master)
# Extract lessons learned
# Output: _bmad-output/implementation-artifacts/retrospectives/
# ✅ CLOSE CONTEXT
```

**Total Contexts for Full Planning:**
- **Planning Phase:** ~12 contexts (if you do all optional workflows)
- **Implementation Phase:** 1 context per story + 1 for retrospective
- **Example:** For a project with 20 stories across 4 epics = ~12 + 20 + 4 = **36 contexts**

---

## ⚡ Quick Flow Path - Context Map

Much simpler! Perfect for bug fixes, small features, clear scope:

```bash
# ════════════════════════════════════════════════════════════
# CONTEXT 1: Quick Spec
# ════════════════════════════════════════════════════════════
/bmad-bmm-quick-spec
# Barry (Quick Flow Solo Dev) analyzes codebase
# Produces implementation-ready tech-spec with stories
# Output: _bmad-output/planning-artifacts/tech-specs/
# Review the spec
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 2: Quick Dev (Can be SAME context for small tasks)
# ════════════════════════════════════════════════════════════
/bmad-bmm-quick-dev
# Barry implements from spec or direct instructions
# Writes code, tests, documentation
# ✅ CLOSE CONTEXT (or continue to review)

# ════════════════════════════════════════════════════════════
# CONTEXT 3: Code Review
# ════════════════════════════════════════════════════════════
/bmad-bmm-code-review
# Amelia finds 3-10 issues
# Fix issues as needed
# ✅ CLOSE CONTEXT
```

**Alternative for tiny tasks:**
All three workflows CAN run in same context if the task is very small (< 100 lines of code).

**Total Contexts for Quick Flow:** 1-3 contexts

---

## 🎮 Game Development Path - Context Map

```bash
# ════════════════════════════════════════════════════════════
# CONTEXT 1: Brainstorm Game (Optional)
# ════════════════════════════════════════════════════════════
/bmad-gds-brainstorm-game
# Game-specific brainstorming with Samus (Game Designer)
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 2: Game Brief
# ════════════════════════════════════════════════════════════
/bmad-gds-game-brief
# Define game vision with Samus
# Output: _bmad-output/planning-artifacts/game-brief.md
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 3: Game Design Document (GDD)
# ════════════════════════════════════════════════════════════
/bmad-gds-gdd
# Comprehensive GDD with Samus
# Output: _bmad-output/planning-artifacts/gdd.md
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 4: Narrative Design (Optional, for story-driven games)
# ════════════════════════════════════════════════════════════
/bmad-gds-narrative
# Story structure with Samus
# Output: _bmad-output/planning-artifacts/narrative-design.md
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 5: Game Architecture ⚠️ REQUIRED
# ════════════════════════════════════════════════════════════
/bmad-gds-game-architecture
# Technical design with Cloud Dragonborn (Game Architect)
# Output: _bmad-output/planning-artifacts/game-architecture.md
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 6: Sprint Planning ⚠️ REQUIRED
# ════════════════════════════════════════════════════════════
/bmad-gds-sprint-planning
# Initialize with Max (Game Scrum Master)
# Output: _bmad-output/implementation-artifacts/sprint-status.yaml
# ✅ CLOSE CONTEXT

# ════════════════════════════════════════════════════════════
# CONTEXT 7+: Story Cycles (1 per story)
# ════════════════════════════════════════════════════════════
/bmad-gds-create-story
/bmad-gds-dev-story
/bmad-gds-code-review
# Link Freeman (Game Dev) implements
# ✅ CLOSE CONTEXT, new context for next story
```

---

## 🧪 Special Cases & Exceptions

### Exception 1: Story Cycle Can Share Context

The **Create Story → Dev Story → Code Review** cycle CAN share a context:

```bash
# ONE CONTEXT for complete story
/bmad-bmm-create-story
/bmad-bmm-dev-story
/bmad-bmm-code-review
# Fix issues if needed, then close
```

**Why this works:**
- All three workflows are tightly related to ONE story
- Context flows naturally (prepare → implement → review)
- Fixes can be made immediately

**But:** Next story should be NEW context!

### Exception 2: Party Mode - Extended Conversation

```bash
# ONE CONTEXT, extended conversation
/bmad-party-mode
# Continue discussion as long as needed
# Multiple agents, one session
```

Party Mode is designed for lengthy multi-agent discussions.

### Exception 3: Loaded Agents - Multi-Turn OK

```bash
# ONE CONTEXT, multiple requests
/tech-writer
# "Write a document about authentication"
# "Now create a diagram for the login flow"
# "Validate the auth document"
# Continue as needed
```

When you load an agent directly, multi-turn conversations are fine.

### Exception 4: BMad Help - Anytime, Any Context

```bash
/bmad-help
```

Can be called in any context, even alongside other commands. It's a utility.

### Exception 5: Validation - Different LLM Strongly Recommended

```bash
# In Claude:
/bmad-bmm-create-prd
# Complete PRD

# Switch to GPT-4 or different LLM:
/bmad-bmm-validate-prd
# Get unbiased review
```

Validation workflows benefit from a different AI's perspective.

---

## 📊 Context Count Estimates

### Typical Software Project (Medium Complexity)

| Phase | Workflows | Contexts |
|-------|-----------|----------|
| Analysis | Brief + 1 research | 2 |
| Planning | PRD + Validate + UX | 3 |
| Solutioning | Architecture + Epics + Readiness | 3 |
| Implementation | Sprint Plan + 15 stories | 16 |
| **Total** | | **24** |

### Quick Fix or Small Feature

| Phase | Workflows | Contexts |
|-------|-----------|----------|
| Spec | Quick Spec | 1 |
| Implementation | Quick Dev + Review | 1-2 |
| **Total** | | **2-3** |

### Game Project (Indie Game)

| Phase | Workflows | Contexts |
|-------|-----------|----------|
| Preproduction | Brief + Brainstorm | 2 |
| Design | GDD + Narrative | 2 |
| Technical | Architecture + Test Setup | 2 |
| Production | Sprint Plan + 25 stories | 26 |
| **Total** | | **32** |

---

## 💡 Context Management Tips

### Tip 1: Label Your Context Windows

Use your IDE's tab naming or notes to track:
- "BMad: PRD Creation"
- "BMad: Story 3 - User Auth"
- "BMad: Architecture Review"

### Tip 2: Review Before Closing

Before closing a context:
1. ✅ Check that the workflow completed
2. ✅ Review the output artifact
3. ✅ Note any follow-up actions
4. ✅ Save important insights

### Tip 3: Use Different LLMs for Validation

Maximize validation value:
- **Creation:** Use your preferred LLM
- **Validation:** Switch to different LLM for fresh perspective
- Example: Claude for creation, GPT-4 for validation

### Tip 4: Keep Sprint Status Handy

```bash
/bmad-bmm-sprint-status
```

Run this anytime in a fresh context to check progress and get next actions.

### Tip 5: Don't Fear Fresh Contexts

**Fresh context = fresh thinking!**
- Workflows load exactly what they need
- Your artifacts persist in `_bmad-output/`
- Nothing is lost by closing contexts
- Quality improves with clean slates

---

## 🎯 Quick Decision Matrix

**Use SAME context if:**
- ✅ Story cycle (Create → Dev → Review)
- ✅ Quick Flow for tiny tasks
- ✅ Loaded agent multi-turn conversation
- ✅ Party Mode discussion
- ✅ BMad help queries

**Use NEW context if:**
- ✅ Different workflow
- ✅ Different story
- ✅ Different phase
- ✅ Validation workflow
- ✅ Any major workflow (PRD, Architecture, etc.)

**When in doubt?** **Fresh context!** It's the safer choice.

---

## 📚 Related Documentation

- [Workflows Guide](./WORKFLOWS-GUIDE.md) - Detailed workflow scenarios
- [Best Practices](./BEST-PRACTICES.md) - Proven strategies
- [Quick Reference](./QUICK-REFERENCE.md) - Command tables

---

[← Back to Documentation Index](./README.md)
