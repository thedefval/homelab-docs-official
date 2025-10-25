# Captures Directory

This directory contains your **quick 5-minute captures** taken during active lab sessions.

## Purpose

Quick captures are for documenting what you're doing **as you work**. Don't worry about perfection - focus on:
- What commands you ran
- What worked
- What didn't work
- How you fixed issues

## Structure

```
captures/
├── ccna/          # CCNA certification labs
├── ccie/          # CCIE certification labs
├── aws/           # AWS certification labs
├── hamradio/      # Ham Radio certification study
└── projects/      # Personal projects (Authentik, Wazuh, etc.)
```

## Creating Captures

Use the CLI tool:

```bash
labquick "CCNA" "Configure OSPF Single Area"
```

This creates a timestamped file with the quick-capture template pre-filled.

## File Naming Convention

Files are automatically named:
```
YYYY-MM-DD_HH-MM_descriptive-title.md
```

Example: `2025-10-24_14-30_configure-ospf-single-area.md`

## XP Value

Each quick capture = **+10 XP**

## Tips

1. **Document as you go** - Don't wait until after the lab
2. **Note what fails** - Future-you will thank you (+20 XP bonus!)
3. **Add screenshots** - Reference them in your capture
4. **Commit frequently** - Every commit earns XP
5. **Don't overthink it** - Raw notes are fine, polish them later

## Weekly Review

During your weekly review session, use `labrefine` to select captures and polish them into:
- **Reference documents** (+30 XP)
- **Tutorials** (+50 XP)
- **Deep-dives** (+100 XP)

---

**Remember**: The goal is to capture knowledge quickly without disrupting your workflow. You'll refine it later!
