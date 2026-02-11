# Getting Started with BMad

[← Back to Documentation Index](./README.md)

---

## 🎯 What is BMad?

BMad is not a traditional AI tool that does thinking for you. It's a **facilitated workflow system** with specialized AI agents who guide you through structured processes to bring out your best thinking in partnership with AI.

### Key Principles
- **AI as Collaborator, Not Dictator** - Agents guide and facilitate, you make decisions
- **Scale-Domain-Adaptive** - Planning depth adjusts based on project complexity
- **Structured Workflows** - Grounded in agile best practices
- **Complete Lifecycle** - From brainstorming to deployment
- **Specialized Agents** - 28+ domain experts (PM, Architect, Developer, UX, and more)

---

## 📦 Your Installation

**✅ Complete Installation with All Modules**

| Module | Workflows | Purpose |
|--------|-----------|---------|
| **Core** | 7 | Essential BMad framework & utilities |
| **BMM** | 34+ | Full software development lifecycle |
| **GDS** | 60+ | Game development (Unity/Unreal/Godot) |
| **CIS** | 4+ | Innovation, creativity, design thinking |
| **TEA** | 9 | Enterprise testing & quality gates |
| **BMB** | 9 | Build custom agents/workflows/modules |

**Total:** 75+ workflows, 28 specialized agents

---

## 🚀 Your First Steps

### Step 1: Understand What You Want to Build

Ask yourself:
- **Is this a new project or existing codebase?**
- **How complex is it?** (Simple task vs complex product)
- **What type of project?** (Web app, game, API, mobile app, etc.)
- **Do I have clear requirements?** (Yes = Quick Flow, No = Full Planning)

### Step 2: Get Personalized Guidance

```bash
/bmad-help
```

BMad will analyze your situation and recommend the right workflow.

Or ask specific questions:
```bash
/bmad-help I want to build a SaaS application for project management
/bmad-help I have an existing React app and need to add a new feature
/bmad-help I'm starting a Unity game and need to plan it out
```

### Step 3: Start Your First Workflow

Based on your needs:

**For new software projects:**
```bash
/bmad-bmm-create-product-brief
```

**For existing codebases:**
```bash
/bmad-bmm-document-project
```

**For quick tasks/bug fixes:**
```bash
/bmad-bmm-quick-spec
```

**For game projects:**
```bash
/bmad-gds-game-brief
```

**For creative exploration:**
```bash
/bmad-brainstorming
```

---

## 🎓 Learning Path

### Week 1: Familiarization
- ✅ Run `/bmad-help` and explore recommendations
- ✅ Try a Quick Flow workflow (Spec → Dev → Review)
- ✅ Experiment with `/bmad-party-mode` to see multi-agent discussions
- ✅ Read through this documentation

### Week 2: First Full Project
- ✅ Pick a small project idea
- ✅ Go through Full Planning: Brief → PRD → Architecture → Stories
- ✅ Implement 2-3 stories using the implementation cycle
- ✅ Experience the complete lifecycle

### Week 3: Explore Specializations
- ✅ Try CIS workflows for creative thinking
- ✅ Use TEA if testing is important to your work
- ✅ Explore GDS if you work on games
- ✅ Load different agents and see their personalities

### Week 4: Master & Customize
- ✅ Combine workflows for your specific needs
- ✅ Try building a custom agent with BMB
- ✅ Optimize your personal workflow
- ✅ Share your experience with the community

---

## 🗺️ Common Starting Points

### Scenario 1: "I have a product idea but it's not fully formed"
**Path:** Innovation → Planning → Building

1. `/bmad-brainstorming` - Generate and explore ideas
2. `/bmad-bmm-create-product-brief` - Crystallize your concept
3. `/bmad-bmm-create-prd` - Full requirements
4. Continue with Full Planning path...

### Scenario 2: "I know exactly what I want to build"
**Path:** Quick Planning → Building

1. `/bmad-bmm-create-prd` - Document requirements
2. `/bmad-bmm-create-architecture` - Technical design
3. `/bmad-bmm-create-epics-and-stories` - Break into stories
4. `/bmad-bmm-sprint-planning` - Start implementation

### Scenario 3: "I need to add a feature to existing code"
**Path:** Document → Quick Flow

1. `/bmad-bmm-document-project` - Understand the codebase
2. `/bmad-bmm-quick-spec` - Plan the feature
3. `/bmad-bmm-quick-dev` - Implement it
4. `/bmad-bmm-code-review` - Validate quality

### Scenario 4: "I want to build a game"
**Path:** Game Development

1. `/bmad-gds-brainstorm-game` - Explore game concepts
2. `/bmad-gds-game-brief` - Define vision
3. `/bmad-gds-gdd` - Full game design document
4. `/bmad-gds-game-architecture` - Technical design
5. `/bmad-gds-sprint-planning` - Start production

### Scenario 5: "I need to solve a complex business problem"
**Path:** Creative Intelligence

1. `/bmad-cis-problem-solving` - Systematic analysis
2. `/bmad-cis-innovation-strategy` - Explore opportunities
3. `/bmad-cis-design-thinking` - Human-centered approach
4. Then transition to planning/building

---

## 💡 Key Concepts

### Workflows vs Agents

**Workflows** are structured processes:
- Have a `/bmad-` command
- Guide you step-by-step
- Produce specific artifacts
- Example: `/bmad-bmm-create-prd`

**Agents** are specialized personas:
- Loaded with `/agent-name`
- Have conversations with you
- Bring expertise and personality
- Example: Load `/pm` to talk with John (Product Manager)

### Phases

BMad organizes work into phases:

1. **Analysis** - Research, exploration, problem definition
2. **Planning** - Requirements, scope, design
3. **Solutioning** - Architecture, technical decisions, stories
4. **Implementation** - Building, testing, deploying

Not every project needs all phases!

### Artifacts

Everything BMad creates goes to `_bmad-output/`:
- `planning-artifacts/` - PRDs, architecture, epics/stories
- `implementation-artifacts/` - Sprint plans, stories, retrospectives
- `test-artifacts/` - Test plans, frameworks, reports
- `bmb-creations/` - Custom agents/workflows you build

These become the **single source of truth** for your project.

---

## ⚡ Quick Wins

### Get Immediate Value

**Generate a project context file (5 minutes):**
```bash
/bmad-bmm-generate-project-context
```
Creates an AI-optimized summary of your codebase for better AI assistance.

**Quick code review (10 minutes):**
```bash
/bmad-bmm-code-review
```
Adversarial review that finds issues you might have missed.

**Brainstorm solutions (15 minutes):**
```bash
/bmad-brainstorming
```
Structured creative session with proven techniques.

**Document existing code (20 minutes):**
```bash
/bmad-bmm-document-project
```
Analyze and document your existing project.

---

## 🎯 Success Tips

### Do's ✅
- **Run workflows in fresh contexts** - One workflow per context window
- **Read agent responses carefully** - They guide you through each step
- **Save artifacts** - Review outputs before moving to next step
- **Ask questions** - Agents are there to help clarify
- **Use validation workflows** - Especially with different LLMs
- **Follow the process** - Trust the structure, it's battle-tested

### Don'ts ❌
- **Don't skip required workflows** - They build on each other
- **Don't rush through conversations** - Thoughtful input = better output
- **Don't edit `_bmad/` directly** - Use BMB workflows to customize
- **Don't mix workflows in same context** - Keep them separate
- **Don't ignore validation reports** - They catch important issues
- **Don't use Full Planning for simple tasks** - Quick Flow exists for a reason

---

## 🆘 Common Questions

### "Which path should I use?"
- **Complex/unclear requirements?** → Full Planning Path
- **Simple/clear requirements?** → Quick Flow Path
- **Game project?** → Game Dev Studio (GDS) workflows
- **Not sure?** → Run `/bmad-help` and describe your situation

### "Do I need to use every workflow?"
No! Only required workflows (marked ⚠️ **REQUIRED**) are mandatory. Optional workflows add value but aren't essential.

### "Can I skip phases?"
- **For new complex projects:** Don't skip Planning or Solutioning phases
- **For bug fixes/small changes:** Use Quick Flow (skips formal phases)
- **For existing projects:** Document first, then choose your path

### "How long does this take?"
- **Quick Flow:** 30 minutes - 2 hours
- **Full Planning (small project):** 4-8 hours spread across days
- **Full Planning (complex project):** 2-4 days for planning, then ongoing implementation
- **Game projects:** Varies widely, but worth the investment

### "What if I make a mistake?"
- Use `/bmad-bmm-correct-course` to navigate changes
- Workflows can be re-run if needed
- Validation workflows catch issues early
- BMad is forgiving - iterate as needed!

---

## 📚 Next Steps

Now that you understand the basics:

1. **Choose your path** → [Workflows Guide](./WORKFLOWS-GUIDE.md)
2. **Meet your agents** → [Agents Reference](./AGENTS-REFERENCE.md)
3. **Learn best practices** → [Best Practices & Tips](./BEST-PRACTICES.md)
4. **Understand contexts** → [Context Mapping Guide](./CONTEXT-MAPPING.md)
5. **Get a command reference** → [Quick Reference](./QUICK-REFERENCE.md)

Or just dive in:
```bash
/bmad-help what should I do to start a new web application?
```

**Welcome to BMad! Let's build something amazing together. 🚀**

[← Back to Documentation Index](./README.md)
