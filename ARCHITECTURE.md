# System Architecture

Technical documentation for the Gamified Homelab Documentation System.

## Table of Contents

- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Data Flow](#data-flow)
- [XP Calculation](#xp-calculation)
- [Git Hooks](#git-hooks)
- [CLI Tools](#cli-tools)
- [Progress Tracking](#progress-tracking)
- [GitHub Integration](#github-integration)

## Overview

This system is a git-based documentation platform with gamification elements. It uses:
- **Markdown** for documents (portable, version-controlled, human-readable)
- **Git** for version control and history
- **Python** for XP calculation automation
- **Bash** for CLI tools and workflow automation
- **Git Hooks** for automatic XP tracking on commits

### Design Principles

1. **Local-First**: All data stored locally, GitHub is backup only
2. **Lightweight**: Minimal dependencies, fast operation
3. **Automated**: XP tracking happens automatically via Git hooks
4. **Flexible**: Easy to customize templates and XP values
5. **Portable**: Works on any Linux system with Git and Python

## Directory Structure

### Complete Layout

```
~/homelab-docs/
├── README.md                      # Main documentation
├── QUICKSTART.md                  # Getting started guide
├── CHANGELOG.md                   # Version history
├── ARCHITECTURE.md                # This file
├── LICENSE                        # MIT License
├── .gitignore                     # Git ignore rules
│
├── captures/                      # Quick captures (raw notes)
│   ├── README.md                  # Directory documentation
│   ├── ccna/                      # CCNA certification
│   ├── ccie/                      # CCIE certification
│   ├── aws/                       # AWS certification
│   ├── hamradio/                  # Ham Radio certification
│   └── projects/                  # Personal projects
│
├── refined/                       # Polished documentation
│   ├── README.md                  # Directory documentation
│   ├── reference/                 # Personal reference (+30 XP)
│   ├── tutorial/                  # Tutorials (+50 XP)
│   └── deepdive/                  # Deep-dives (+100 XP)
│
├── screenshots/                   # Visual documentation
│   ├── README.md                  # Directory documentation
│   ├── [track]/                   # Organized by track
│   │   └── [YYYY-MM-DD]/         # Organized by date
│   │       ├── *.png              # Screenshot files
│   │       └── screenshot-index.md # Auto-generated index
│   └── thumbnails/                # Future: auto-generated thumbnails
│
├── progress/                      # Progress tracking
│   ├── xp-log.txt                 # XP transaction log
│   ├── achievements.txt           # Unlocked achievements
│   ├── dashboard.md               # Visual progress dashboard
│   └── streak-tracker.txt         # Documentation streaks
│
├── templates/                     # Document templates
│   ├── quick-capture.md           # 5-minute capture template
│   ├── refinement-reference.md    # Reference doc template
│   ├── refinement-tutorial.md     # Tutorial template
│   └── refinement-deepdive.md     # Deep-dive template
│
├── scripts/                       # Automation scripts
│   ├── install.sh                 # System installer
│   ├── labquick.sh                # CLI: Quick capture (→ ~/.local/bin/)
│   ├── labrefine.sh               # CLI: Refinement wizard (→ ~/.local/bin/)
│   ├── labscreen.sh               # CLI: Screenshot organizer (→ ~/.local/bin/)
│   ├── labprogress.sh             # CLI: Progress viewer (→ ~/.local/bin/)
│   └── calculate-xp.py            # XP calculator (called by Git hook)
│
├── git-hooks/                     # Git automation
│   ├── post-commit                # Auto XP calculation
│   └── pre-push                   # (Optional) validation
│
└── achievements/                  # Achievement system
    └── achievements.json          # Achievement definitions
```

### File Relationships

```
User Action
    ↓
CLI Tool (bash script)
    ↓
Creates/Edits Markdown File
    ↓
User commits with git
    ↓
Git post-commit hook triggers
    ↓
Python XP calculator runs
    ↓
Updates progress/ files
    ↓
Auto-commits progress updates
    ↓
User pushes to GitHub (backup)
```

## Data Flow

### Quick Capture Workflow

```
1. User runs: labquick "CCNA" "Configure OSPF"
   ↓
2. Bash script:
   - Creates captures/ccna/YYYY-MM-DD_HH-MM_configure-ospf.md
   - Fills template with metadata
   - Opens in $EDITOR
   ↓
3. User documents during lab
   ↓
4. User commits:
   git add captures/
   git commit -m "Quick capture: OSPF"
   ↓
5. Post-commit hook runs:
   python3 scripts/calculate-xp.py
   ↓
6. XP Calculator:
   - Detects file in captures/
   - Awards +10 XP
   - Logs to progress/xp-log.txt
   - Updates progress/dashboard.md
   - Auto-commits progress updates
   ↓
7. User pushes:
   git push
   (Both capture and progress backed up to GitHub)
```

### Refinement Workflow

```
1. User runs: labrefine
   ↓
2. Interactive wizard:
   - Lists recent captures
   - User selects one
   - User chooses type (reference/tutorial/deepdive)
   ↓
3. Script creates:
   refined/[type]/original-capture-name-[type].md
   ↓
4. User edits and polishes
   ↓
5. User commits:
   git add refined/
   git commit -m "Refined: OSPF tutorial"
   ↓
6. Post-commit hook runs:
   - Detects file in refined/tutorial/
   - Awards +50 XP
   - Updates progress
   ↓
7. Push to GitHub (backup)
```

### Screenshot Workflow

```
1. User takes screenshots during lab
   (Flameshot saves to ~/Pictures)
   ↓
2. After lab, user runs:
   labscreen "CCNA" "2025-10-24"
   ↓
3. Script:
   - Moves *.png from ~/Pictures to screenshots/ccna/2025-10-24/
   - Generates screenshot-index.md
   ↓
4. User commits:
   git add screenshots/
   git commit -m "Screenshots: OSPF lab"
   ↓
5. Post-commit hook:
   - Counts screenshots
   - Awards +5 XP per screenshot (max +50 XP)
   - Updates progress
   ↓
6. Push to GitHub (backup)
```

## XP Calculation

### Python XP Calculator

Location: `scripts/calculate-xp.py`

#### How It Works

```python
1. Called by Git post-commit hook

2. Gets list of files in last commit:
   git diff-tree --no-commit-id --name-only -r HEAD

3. Analyzes each file:
   - captures/*.md → +10 XP (quick capture)
   - screenshots/*.png → +5 XP each (max 50)
   - refined/reference/*.md → +30 XP
   - refined/tutorial/*.md → +50 XP
   - refined/deepdive/*.md → +100 XP

4. Logs XP earned:
   Appends to progress/xp-log.txt

5. Updates dashboard:
   - Calculates total XP
   - Determines current level
   - Counts documents by type
   - Generates progress/dashboard.md

6. Returns (Git hook may auto-commit progress updates)
```

#### XP Log Format

```
[YYYY-MM-DD HH:MM:SS] XP: +10
  - +10 XP: Quick capture

[YYYY-MM-DD HH:MM:SS] XP: +50
  - +50 XP: Tutorial

[YYYY-MM-DD HH:MM:SS] XP: +15
  - +5 XP: Screenshot
  - +5 XP: Screenshot
  - +5 XP: Screenshot
```

#### Level Calculation

```python
LEVEL_THRESHOLDS = [
    0,      # Level 1
    100,    # Level 2
    250,    # Level 3
    500,    # Level 4
    1000,   # Level 5
    2000,   # Level 6
    4000,   # Level 7
    6000,   # Level 8
    8000,   # Level 9
    10000,  # Level 10
]

def get_level(total_xp):
    level = 1
    for threshold in LEVEL_THRESHOLDS:
        if total_xp >= threshold:
            level += 1
    return level - 1
```

## Git Hooks

### Post-Commit Hook

Location: `.git/hooks/post-commit`

```bash
#!/bin/bash

# Post-commit hook - Calculate XP and update progress

DOCS_DIR="$(git rev-parse --show-toplevel)"

# Run XP calculator
python3 "$DOCS_DIR/scripts/calculate-xp.py"

# Auto-commit progress updates
git add progress/ 2>/dev/null
if ! git diff --cached --quiet; then
    git commit --no-verify -m "Update progress tracking [auto]"
fi
```

#### Why Auto-Commit Progress?

- User commits documentation → XP calculated → Progress updated → Progress auto-committed
- This ensures progress is always in sync with documentation
- User sees a single logical commit in history
- `--no-verify` flag prevents infinite loop (skips hooks on auto-commit)

### Pre-Push Hook (Optional)

Could be used for:
- Validating markdown syntax
- Checking for sensitive data
- Enforcing naming conventions
- Requiring certain fields in captures

Currently not implemented, but hook file exists for future use.

## CLI Tools

All CLI tools are bash scripts installed to `~/.local/bin/`.

### labquick

**Purpose**: Create quick captures during labs

**Implementation**:
1. Validates arguments (track, title)
2. Creates timestamped filename
3. Copies template to captures/[track]/
4. Performs substitutions ([TITLE], [DATE], [TRACK])
5. Opens in $EDITOR (defaults to nano)
6. Prints next steps for user

**Why bash**: Simple text processing, file creation, editor launching

### labrefine

**Purpose**: Interactive refinement wizard

**Implementation**:
1. Lists recent captures (last 20, sorted by date)
2. User selects capture by number
3. User selects refinement type
4. Copies appropriate template
5. Opens in $EDITOR
6. Prints next steps

**Why bash**: File listing, user interaction, simple logic

### labscreen

**Purpose**: Organize screenshots from ~/Pictures

**Implementation**:
1. Validates arguments (track, date)
2. Creates target directory
3. Moves *.png files
4. Generates screenshot-index.md
5. Reports count and location

**Why bash**: File operations, pattern matching

### labprogress

**Purpose**: View progress dashboard

**Implementation**:
1. Checks if dashboard exists
2. Cats the dashboard file
3. (Simple wrapper for convenience)

**Why bash**: Single command wrapper

## Progress Tracking

### XP Log

**File**: `progress/xp-log.txt`

**Format**: Append-only transaction log

**Purpose**:
- Audit trail of all XP earned
- Calculate total XP by summing transactions
- Track XP over time

### Achievements

**File**: `progress/achievements.txt`

**Format**: Human-readable log

**Purpose**:
- Record when achievements unlocked
- Motivational element
- Track milestones

**Future**: Automatic unlocking based on criteria in `achievements/achievements.json`

### Dashboard

**File**: `progress/dashboard.md`

**Auto-generated**: Yes (by calculate-xp.py)

**Contents**:
- Current level and total XP
- Progress bar to next level
- Document counts by type
- Recent achievements
- Current streak
- Per-track statistics

**Purpose**: Single file to view overall progress

### Streak Tracker

**File**: `progress/streak-tracker.txt`

**Format**: Key-value pairs

**Contents**:
```
Current Streak: 7 days
Longest Streak: 14 days
Last Documentation: 2025-10-24
```

**Future**: Auto-update on each commit date

## GitHub Integration

### Authentication Methods

#### SSH Keys (Recommended)

```bash
# Generated by installer or manually:
ssh-keygen -t ed25519 -C "email@example.com"

# Added to GitHub:
https://github.com/settings/keys

# Repository configured with SSH remote:
git remote add origin git@github.com:user/homelab-docs.git

# Benefits:
# - Doesn't expire
# - More secure
# - No password prompts
```

#### Personal Access Token

```bash
# Created on GitHub:
https://github.com/settings/tokens

# Repository configured with HTTPS remote:
git remote add origin https://github.com/user/homelab-docs.git

# Credential helper stores token:
git config --global credential.helper store

# Benefits:
# - Simpler for beginners
# - Works through corporate firewalls
# - Can be scoped to specific permissions
```

### Backup Workflow

```
Local Changes
    ↓
git commit (auto-calculates XP, auto-commits progress)
    ↓
git push (manual - user control)
    ↓
GitHub Repository (cloud backup)
```

**Why manual push?**
- User control over when to backup
- Can batch multiple commits
- Avoids network errors during lab work
- Local-first philosophy

### Repository Structure on GitHub

```
github.com/user/homelab-docs/
├── All documentation files
├── All screenshots (can be large)
├── Progress tracking files
└── System files (templates, scripts)
```

**Private vs Public**:
- **Private**: Secure, personal notes, internal IPs okay
- **Public**: Portfolio, must scrub sensitive info, great for sharing

## Extensibility

### Adding New Tracks

```bash
# Create directory
mkdir -p captures/[new-track]

# Update labquick if needed (add to validation)

# Use normally
labquick "[new-track]" "Title"
```

### Customizing XP Values

Edit `scripts/calculate-xp.py`:

```python
XP_VALUES = {
    'quick_capture': 15,        # Changed from 10
    'refine_tutorial': 75,      # Changed from 50
    # ... etc
}
```

### Adding New Templates

```bash
# Create template
vim templates/my-custom-template.md

# Update labrefine to recognize it

# Or use directly with labquick
cp templates/my-custom-template.md captures/track/filename.md
```

### Custom Achievements

Edit `achievements/achievements.json`:

```json
{
  "custom": [
    {
      "id": "my_achievement",
      "name": "My Custom Achievement",
      "icon": "🎯",
      "description": "Did something cool",
      "requirement": "custom_condition"
    }
  ]
}
```

(Automatic unlocking not yet implemented - manual for now)

## Performance

### File Sizes

- Average markdown capture: 2-5 KB
- Average screenshot: 200-500 KB
- Progress files: <10 KB total
- Templates: <10 KB total

### Git Repository Growth

- 100 captures + screenshots: ~50 MB
- 1 year of active use: ~500 MB - 1 GB
- XP log grows linearly: ~50 bytes per commit

### Script Performance

- XP calculation: <100ms
- Dashboard generation: <200ms
- Git hooks total: <500ms added to commit time
- Negligible impact on workflow

## Security Considerations

### Sensitive Data

**Never commit**:
- Real passwords or API keys
- Internal company information
- Production IPs and hostnames (unless masked)
- Personal identifiable information

**Use .gitignore for**:
- .env files
- secrets/ directory
- Any files with real credentials

### Screenshot Sanitization

Always blur in Flameshot:
- IP addresses (unless RFC 1918)
- Hostnames
- Email addresses
- Any company-identifying information

### GitHub Authentication

- SSH keys are more secure than tokens
- Tokens should have minimal scopes
- Never commit credentials to repository
- Use `git config credential.helper store` to save credentials securely

## Troubleshooting

### Git Hooks Not Running

```bash
# Check if executable
ls -l .git/hooks/post-commit

# Should show: -rwxr-xr-x
# If not: chmod +x .git/hooks/post-commit

# Test manually
.git/hooks/post-commit
```

### XP Calculator Errors

```bash
# Run directly to see errors
python3 scripts/calculate-xp.py

# Check Python version
python3 --version
# Must be 3.8+

# Check if repository root found
git rev-parse --show-toplevel
```

### CLI Commands Not Found

```bash
# Check PATH
echo $PATH | grep .local/bin

# If missing, add to ~/.bashrc:
export PATH="$HOME/.local/bin:$PATH"

# Reload
source ~/.bashrc
```

## Development

### Testing XP Calculation

```bash
# Make test commits
echo "test" > test.txt
git add test.txt
git commit -m "Test commit"

# Check XP log
tail progress/xp-log.txt

# Check dashboard
cat progress/dashboard.md
```

### Debugging Git Hooks

```bash
# Add debug output to hook
echo "DEBUG: Hook started" >> /tmp/hook-debug.log

# Check /tmp/hook-debug.log after commit
```

### Future Enhancements

See [CHANGELOG.md](CHANGELOG.md) for roadmap.

Priority features:
1. Automatic streak tracking
2. Automatic achievement unlocking
3. Web-based dashboard viewer
4. Progress statistics and graphs
5. Mobile app for viewing

---

**This architecture enables**:
- ✅ Automatic gamification
- ✅ Local-first operation
- ✅ Git-based versioning
- ✅ Portable and extensible
- ✅ Minimal dependencies
