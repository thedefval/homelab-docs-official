# Refined Directory

This directory contains **polished, high-quality documentation** refined from your quick captures.

## Purpose

Refined documents are created during weekly review sessions when you have time to:
- Add proper explanations
- Include screenshots and diagrams
- Write for an audience (yourself or others)
- Create portfolio-quality content

## Structure

```
refined/
├── reference/    # Personal reference docs (+30 XP)
├── tutorial/     # Step-by-step tutorials (+50 XP)
└── deepdive/     # Technical deep-dives (+100 XP)
```

## Document Types

### Reference Documents (+30 XP)

**Purpose**: Personal knowledge base - documentation for future-you

**Use when**:
- You need to remember how to do something
- Creating a "cheat sheet" for yourself
- Documenting configuration patterns
- Building a searchable knowledge base

**Example topics**:
- "OSPF Configuration Quick Reference"
- "AWS VPC Setup Checklist"
- "Authentik Provider Configuration"

### Tutorial Documents (+50 XP)

**Purpose**: Teaching others - step-by-step guides for beginners

**Use when**:
- Writing for your blog
- Helping others learn
- Creating training materials
- Building your public portfolio

**Example topics**:
- "How to Configure OSPF on Cisco Routers"
- "AWS Lambda Deployment from Scratch"
- "Setting Up Authentik for Home Lab SSO"

### Deep-Dive Documents (+100 XP)

**Purpose**: Technical expertise - portfolio-quality analysis

**Use when**:
- Showcasing technical depth
- Analyzing complex systems
- Creating thought leadership content
- Demonstrating expertise to potential employers

**Example topics**:
- "OSPF Convergence Analysis in Hub-and-Spoke Networks"
- "AWS Lambda Cold Start Optimization: A Deep Dive"
- "Security Architecture of Authentik vs Keycloak"

## Creating Refined Documents

Use the interactive refinement wizard:

```bash
labrefine
```

This will:
1. Show you your recent quick captures
2. Ask which one to refine
3. Ask what type (reference/tutorial/deepdive)
4. Open the appropriate template
5. Award XP when you commit

## File Naming Convention

Refined documents inherit the capture filename and add a type suffix:

```
original-capture-title-reference.md
original-capture-title-tutorial.md
original-capture-title-deepdive.md
```

## Embedding Screenshots

All refined documents should include screenshots:

```markdown
![Configuration Screen](../../screenshots/ccna/2025-10-24/ospf-config.png)
*Figure 1: OSPF area configuration*
```

The `../../` path works from the `refined/[type]/` subdirectory.

## Weekly Workflow

1. **Pick 1-2 captures** from the previous week
2. **Choose refinement type** based on your goal
3. **Spend 15-60 minutes** polishing
4. **Commit and push** to earn XP and back up to GitHub

## Quality Guidelines

### Reference Documents
- Clear and concise
- Well-organized
- Includes verification commands
- Lists common pitfalls

### Tutorials
- Assumes beginner knowledge
- Explains *why*, not just *how*
- Includes expected output
- Has troubleshooting section
- Uses conversational tone

### Deep-Dives
- Demonstrates expertise
- Includes technical analysis
- Cites sources and RFCs
- Has performance data
- Portfolio-quality writing

---

**Remember**: Refinement is where you earn the big XP! Set aside dedicated time each week.
