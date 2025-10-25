#!/bin/bash

# Gamified Homelab Documentation System Installer
# Optimized for CachyOS and Linux systems
# Version: 1.0.0

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default installation directory
INSTALL_DIR="$HOME/homelab-docs"

# Print functions
print_header() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

# Check system requirements
check_requirements() {
    print_header "Checking System Requirements"
    
    local missing_deps=()
    
    # Check Git
    if command -v git &> /dev/null; then
        local git_version=$(git --version | awk '{print $3}')
        print_success "Git $git_version found"
    else
        missing_deps+=("git")
        print_error "Git not found"
    fi
    
    # Check Python
    if command -v python3 &> /dev/null; then
        local python_version=$(python3 --version | awk '{print $2}')
        print_success "Python $python_version found"
    else
        missing_deps+=("python3")
        print_error "Python 3 not found"
    fi
    
    # Check Bash version
    if [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
        print_success "Bash ${BASH_VERSION} found"
    else
        print_error "Bash 4.0+ required (found ${BASH_VERSION})"
        missing_deps+=("bash")
    fi
    
    # Check optional: Flameshot
    if command -v flameshot &> /dev/null; then
        print_success "Flameshot found (screenshot tool)"
    else
        print_warning "Flameshot not found (optional - for screenshots)"
        echo -e "  Install with: ${YELLOW}sudo pacman -S flameshot${NC}"
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo
        print_info "Install on CachyOS/Arch: sudo pacman -S ${missing_deps[*]}"
        print_info "Install on Ubuntu/Debian: sudo apt install ${missing_deps[*]}"
        exit 1
    fi
    
    echo
    print_success "All required dependencies found!"
    echo
}

# Create directory structure
create_directories() {
    print_header "Creating Directory Structure"
    
    mkdir -p "$INSTALL_DIR"/{captures,refined,screenshots,progress,templates,scripts,achievements,git-hooks}
    mkdir -p "$INSTALL_DIR"/captures/{ccna,ccie,aws,hamradio,projects}
    mkdir -p "$INSTALL_DIR"/refined/{reference,tutorial,deepdive}
    mkdir -p "$INSTALL_DIR"/screenshots/thumbnails
    
    print_success "Created directory structure at $INSTALL_DIR"
    echo
}

# Copy templates
setup_templates() {
    print_header "Setting Up Templates"
    
    # Quick Capture Template
    cat > "$INSTALL_DIR/templates/quick-capture.md" << 'EOF'
# [TITLE]

**Date**: [DATE]  
**Track**: [TRACK]  
**Duration**: [DURATION]  
**Status**: In Progress

---

## Objective

[What are you trying to accomplish?]

## Configuration Steps

### Step 1: [Description]

```bash
# Commands here
```

**Result**: [What happened]

### Step 2: [Description]

```bash
# Commands here
```

**Result**: [What happened]

## ⚠Troubleshooting

### Issue: [What didn't work]

**Error Message**:
```
[Paste error here]
```

**Root Cause**: [Why it failed]

**Solution**: [How you fixed it]

```bash
# Corrective commands
```

**Result**: Resolved

## Screenshots

[Add screenshot paths as you take them]

- `../../screenshots/[track]/[date]/screenshot-01.png` - [Description]

## References

- [Link to documentation]
- [Link to related captures]

## Next Steps

- [ ] [Task 1]
- [ ] [Task 2]

---

**Capture Status**: Quick Capture (+10 XP)
EOF

    # Reference Template
    cat > "$INSTALL_DIR/templates/refinement-reference.md" << 'EOF'
# [TITLE] - Reference Guide

**Track**: [TRACK]  
**Refined Date**: [DATE]  
**Original Capture**: [Link to quick capture]  
**Type**: Reference Document

---

## Overview

[1-2 sentence summary of what this document covers]

## Use Cases

When to use this guide:
- [Use case 1]
- [Use case 2]
- [Use case 3]

## Core Concepts

### Concept 1: [Name]

[Clear explanation with examples]

### Concept 2: [Name]

[Clear explanation with examples]

## Implementation

### Configuration Template

```bash
# Step 1: [Description]
[commands]

# Step 2: [Description]
[commands]
```

### Verification Commands

```bash
# Verify [aspect]
[command]

# Check [aspect]
[command]
```

## Visual Reference

![Configuration Example](../../screenshots/[track]/[date]/[filename].png)
*Figure 1: [Description]*

## Common Pitfalls

### Pitfall 1: [Issue]
**Problem**: [Description]  
**Solution**: [Fix]

### Pitfall 2: [Issue]
**Problem**: [Description]  
**Solution**: [Fix]

## Troubleshooting

| Symptom | Cause | Solution |
|---------|-------|----------|
| [Symptom] | [Cause] | [Solution] |

## Related Topics

- [Link to related reference doc]
- [Link to related tutorial]

## References

- [Official documentation]
- [RFCs, standards]
- [Related captures]

---

**Document Type**: Reference (+30 XP)  
**Last Updated**: [DATE]
EOF

    # Tutorial Template
    cat > "$INSTALL_DIR/templates/refinement-tutorial.md" << 'EOF'
# How to [ACCOMPLISH TASK]

**Track**: [TRACK]  
**Difficulty**: (Beginner/Intermediate/Advanced)
**Time to Complete**: [X] minutes  
**Type**: Tutorial

---

## What You'll Learn

By the end of this tutorial, you'll be able to:
- [Learning objective 1]
- [Learning objective 2]
- [Learning objective 3]

## Prerequisites

Before starting, make sure you have:
- [Prerequisite 1]
- [Prerequisite 2]
- [Prerequisite 3]

**Estimated Knowledge Level**: [Description]

## Overview

[2-3 sentences explaining what this tutorial covers and why it's useful]

## Step-by-Step Guide

### Step 1: [Action]

**What we're doing**: [Explanation of this step]

```bash
# Command with explanation
[command]
```

**Expected Output**:
```
[output]
```

**What this means**: [Explanation of the output]

### Step 2: [Action]

**What we're doing**: [Explanation]

```bash
[command]
```

**Expected Output**:
```
[output]
```

### Step 3: [Action]

[Continue pattern...]

## Visual Guide

![Step 1 Configuration](../../screenshots/[track]/[date]/step1.png)
*Figure 1: Configuring [aspect]*

![Step 2 Verification](../../screenshots/[track]/[date]/step2.png)
*Figure 2: Verifying [aspect]*

## Verification

Let's verify everything is working correctly:

```bash
# Test 1: [Description]
[command]

# Expected result: [description]
```

```bash
# Test 2: [Description]
[command]

# Expected result: [description]
```

## Troubleshooting

### Problem: [Common Issue]

**Symptoms**:
- [Symptom 1]
- [Symptom 2]

**Diagnosis**:
```bash
[diagnostic commands]
```

**Solution**:
```bash
[fix commands]
```

### Problem: [Another Common Issue]

[Repeat pattern...]

## Next Steps

Now that you've completed this tutorial, try:
- [Extension task 1]
- [Extension task 2]
- [Related tutorial link]

## Pro Tips

- **Tip 1**: [Helpful advice]
- **Tip 2**: [Best practice]
- **Tip 3**: [Optimization]

## Additional Resources

- [Official documentation link]
- [Related tutorial link]
- [Community resources]

---

**Document Type**: Tutorial (+50 XP)  
**Last Updated**: [DATE]  
**Tested On**: [Platform/Version]
EOF

    # Deep-Dive Template
    cat > "$INSTALL_DIR/templates/refinement-deepdive.md" << 'EOF'
# [TOPIC]: A Deep Dive

**Track**: [TRACK]  
**Type**: Deep-Dive
**Reading Time**: [X] minutes  
**Audience**: Advanced

---

## Executive Summary

[2-3 sentence summary suitable for executives/recruiters]

**Key Takeaways**:
- [Takeaway 1]
- [Takeaway 2]
- [Takeaway 3]

## Introduction

### Context and Motivation

[Why this topic matters - business value, technical significance]

### What This Document Covers

[Scope of the deep-dive]

### Prerequisites

Readers should be familiar with:
- [Prerequisite knowledge 1]
- [Prerequisite knowledge 2]

## Core Concepts

### Fundamental Theory

[In-depth explanation of underlying concepts]

#### Concept 1: [Name]

[Detailed explanation with technical depth]

**Technical Details**:
- [Detail 1]
- [Detail 2]

#### Concept 2: [Name]

[Continue pattern...]

### Architecture Overview

[System architecture, protocol flow, etc.]

```
[ASCII diagram or description]
```

## Technical Analysis

### Implementation Details

[Deep technical explanation]

```bash
# Example with detailed annotations
[command]
```

**Analysis**:
[Line-by-line breakdown of what's happening]

### Protocol Flow

[Detailed explanation of how things work under the hood]

```
1. [Step 1 with technical details]
2. [Step 2 with technical details]
```

### Edge Cases and Considerations

#### Edge Case 1: [Scenario]

**Situation**: [Description]  
**Behavior**: [What happens]  
**Reason**: [Technical explanation]

## Performance Analysis

### Benchmarks

[Performance data, comparisons, metrics]

| Configuration | Metric 1 | Metric 2 | Metric 3 |
|---------------|----------|----------|----------|
| [Config A] | [Value] | [Value] | [Value] |
| [Config B] | [Value] | [Value] | [Value] |

**Analysis**: [Interpretation of results]

### Optimization Strategies

[How to optimize for different scenarios]

## Security Considerations

### Attack Vectors

[Potential security issues]

### Mitigation Strategies

[How to secure the implementation]

### Compliance Implications

[Regulatory considerations, standards compliance]

## Visual Deep-Dive

![Architecture Diagram](../../screenshots/[track]/[date]/architecture.png)
*Figure 1: Complete architecture overview*

![Protocol Flow](../../screenshots/[track]/[date]/protocol-flow.png)
*Figure 2: Detailed protocol flow*

## 💼 Real-World Applications

### Use Case 1: [Industry/Scenario]

[How this is used in production environments]

### Use Case 2: [Industry/Scenario]

[Another real-world application]

## Lab Recreation

[Complete lab setup to reproduce the analysis]

### Environment Setup

```bash
[Setup commands with explanations]
```

### Testing Methodology

[How to test and verify behavior]

## Lessons Learned

### What Worked Well

[Positive findings]

### Challenges Encountered

[Problems and how they were solved]

### Recommendations

[Best practices derived from this analysis]

## Future Considerations

[Emerging trends, future developments in this area]

## References and Further Reading

### Standards and RFCs
- [RFC/Standard links]

### Research Papers
- [Academic references]

### Official Documentation
- [Vendor documentation]

### Related Deep-Dives
- [Links to your other deep-dive documents]

## Conclusion

[Summary of key findings and implications]

---

**Document Type**: Deep-Dive (+100 XP)  
**Research Date**: [DATE]  
**Last Updated**: [DATE]  
**Lab Environment**: [Platform/Version details]

**Author Notes**: [Personal insights, what you learned, future research directions]
EOF

    print_success "Created all documentation templates"
    echo
}

# Setup CLI tools
setup_cli_tools() {
    print_header "Setting Up CLI Tools"
    
    local bin_dir="$HOME/.local/bin"
    mkdir -p "$bin_dir"
    
    # labquick - Quick capture tool
    cat > "$bin_dir/labquick" << 'EOFSCRIPT'
#!/bin/bash

# Quick Capture Tool
# Usage: labquick "TRACK" "TITLE"

if [ $# -ne 2 ]; then
    echo "Usage: labquick \"TRACK\" \"TITLE\""
    echo "Example: labquick \"CCNA\" \"Configure OSPF Single Area\""
    exit 1
fi

TRACK=$(echo "$1" | tr '[:upper:]' '[:lower:]')
TITLE="$2"
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H-%M)
FILENAME="${DATE}_${TIME}_$(echo "$TITLE" | tr '[:upper:] ' '[:lower:]-').md"

DOCS_DIR="$HOME/homelab-docs"
CAPTURE_DIR="$DOCS_DIR/captures/$TRACK"

mkdir -p "$CAPTURE_DIR"

FILEPATH="$CAPTURE_DIR/$FILENAME"

# Create from template
sed -e "s/\[TITLE\]/$TITLE/g" \
    -e "s/\[DATE\]/$DATE/g" \
    -e "s/\[TRACK\]/${TRACK^^}/g" \
    -e "s/\[DURATION\]/[To be filled]/g" \
    "$DOCS_DIR/templates/quick-capture.md" > "$FILEPATH"

echo "✓ Created quick capture: $FILEPATH"

# Open in editor
${EDITOR:-nano} "$FILEPATH"

echo ""
echo "Next steps:"
echo "  1. Fill in your lab notes"
echo "  2. git add captures/"
echo "  3. git commit -m \"Quick capture: $TITLE\""
echo "  4. git push"
echo ""
echo "Reward: +10 XP (automatic on commit)"
EOFSCRIPT

    # labrefine - Refinement tool
    cat > "$bin_dir/labrefine" << 'EOFSCRIPT'
#!/bin/bash

# Refinement Tool - Interactive wizard

DOCS_DIR="$HOME/homelab-docs"
CAPTURE_DIR="$DOCS_DIR/captures"
REFINED_DIR="$DOCS_DIR/refined"

echo "═══════════════════════════════════════"
echo "  Lab Refinement Wizard"
echo "═══════════════════════════════════════"
echo ""

# List available captures
echo "Available captures:"
echo ""

find "$CAPTURE_DIR" -name "*.md" -type f -printf "%T@ %p\n" | \
    sort -rn | \
    head -20 | \
    cut -d' ' -f2- | \
    nl -w2 -s'. '

echo ""
read -p "Select capture number (or 0 to cancel): " capture_num

if [ "$capture_num" -eq 0 ] || [ -z "$capture_num" ]; then
    echo "Cancelled."
    exit 0
fi

SELECTED_FILE=$(find "$CAPTURE_DIR" -name "*.md" -type f -printf "%T@ %p\n" | \
    sort -rn | \
    head -20 | \
    cut -d' ' -f2- | \
    sed -n "${capture_num}p")

if [ -z "$SELECTED_FILE" ]; then
    echo "Invalid selection."
    exit 1
fi

echo ""
echo "Selected: $(basename "$SELECTED_FILE")"
echo ""
echo "Choose refinement type:"
echo "  1. Reference  - Personal documentation (+30 XP)"
echo "  2. Tutorial   - Step-by-step guide (+50 XP)"
echo "  3. Deep-Dive  - Portfolio-quality analysis (+100 XP)"
echo ""
read -p "Select type [1-3]: " refine_type

case $refine_type in
    1)
        TYPE="reference"
        TEMPLATE="refinement-reference.md"
        SUBDIR="reference"
        ;;
    2)
        TYPE="tutorial"
        TEMPLATE="refinement-tutorial.md"
        SUBDIR="tutorial"
        ;;
    3)
        TYPE="deepdive"
        TEMPLATE="refinement-deepdive.md"
        SUBDIR="deepdive"
        ;;
    *)
        echo "Invalid type."
        exit 1
        ;;
esac

# Extract metadata from capture
TITLE=$(grep "^# " "$SELECTED_FILE" | head -1 | sed 's/^# //')
DATE=$(date +%Y-%m-%d)

# Create refined filename
REFINED_NAME=$(basename "$SELECTED_FILE" | sed "s/\.md$/-${TYPE}.md/")
REFINED_PATH="$REFINED_DIR/$SUBDIR/$REFINED_NAME"

# Copy template
cp "$DOCS_DIR/templates/$TEMPLATE" "$REFINED_PATH"

echo ""
echo "✓ Created refinement: $REFINED_PATH"
echo ""

# Open in editor
${EDITOR:-nano} "$REFINED_PATH"

echo ""
echo "Next steps:"
echo "  1. Polish your refined document"
echo "  2. git add refined/"
echo "  3. git commit -m \"Refined: $TITLE\""
echo "  4. git push"
echo ""
echo "Reward: XP added automatically on commit!"
EOFSCRIPT

    # labscreen - Screenshot organizer
    cat > "$bin_dir/labscreen" << 'EOFSCRIPT'
#!/bin/bash

# Screenshot Organizer
# Usage: labscreen "TRACK" "DATE"

if [ $# -ne 2 ]; then
    echo "Usage: labscreen \"TRACK\" \"DATE\""
    echo "Example: labscreen \"CCNA\" \"2025-10-24\""
    exit 1
fi

TRACK=$(echo "$1" | tr '[:upper:]' '[:lower:]')
DATE="$2"

DOCS_DIR="$HOME/homelab-docs"
SOURCE_DIR="$HOME/Pictures/Screenshots"
TARGET_DIR="$DOCS_DIR/screenshots/$TRACK/$DATE"

mkdir -p "$TARGET_DIR"

# Count screenshots
SCREENSHOT_COUNT=$(ls "$SOURCE_DIR"/*.png 2>/dev/null | wc -l)

if [ "$SCREENSHOT_COUNT" -eq 0 ]; then
    echo "No screenshots found in $SOURCE_DIR"
    exit 0
fi

echo "Found $SCREENSHOT_COUNT screenshots"
echo "Moving to $TARGET_DIR"

# Move screenshots
mv "$SOURCE_DIR"/*.png "$TARGET_DIR/" 2>/dev/null

# Create index
INDEX_FILE="$TARGET_DIR/screenshot-index.md"
cat > "$INDEX_FILE" << EOF
# Screenshots - $TRACK - $DATE

Total: $SCREENSHOT_COUNT images

EOF

# List screenshots
ls "$TARGET_DIR"/*.png | while read -r file; do
    filename=$(basename "$file")
    echo "- ![$filename]($filename)" >> "$INDEX_FILE"
done

echo "✓ Organized $SCREENSHOT_COUNT screenshots"
echo "✓ Created index: $INDEX_FILE"
echo ""
echo "Reward: +$((SCREENSHOT_COUNT > 10 ? 50 : SCREENSHOT_COUNT * 5)) XP (automatic on commit)"
EOFSCRIPT

    # labprogress - Progress viewer
    cat > "$bin_dir/labprogress" << 'EOFSCRIPT'
#!/bin/bash

# Progress Dashboard Viewer

DOCS_DIR="$HOME/homelab-docs"
DASHBOARD="$DOCS_DIR/progress/dashboard.md"

if [ ! -f "$DASHBOARD" ]; then
    echo "Dashboard not found. Run a git commit to generate it."
    exit 1
fi

cat "$DASHBOARD"
EOFSCRIPT

    # Make all scripts executable
    chmod +x "$bin_dir"/{labquick,labrefine,labscreen,labprogress}
    
    print_success "Installed CLI tools to $bin_dir"
    
    # Check if bin_dir is in PATH
    if [[ ":$PATH:" != *":$bin_dir:"* ]]; then
        print_warning "$bin_dir is not in your PATH"
        echo ""
        
        # Detect shell and provide appropriate instructions
        if [ -n "$FISH_VERSION" ] || ps -p $$ -o comm= | grep -q fish; then
            echo -e "${BLUE}Fish Shell Detected${NC}"
            echo -e "  Add this line to your ${YELLOW}~/.config/fish/config.fish${NC}:"
            echo -e "    ${GREEN}set -gx PATH \$HOME/.local/bin \$PATH${NC}"
            echo -e "  Then run: ${YELLOW}source ~/.config/fish/config.fish${NC}"
        elif [ -n "$ZSH_VERSION" ]; then
            echo -e "${BLUE}Zsh Detected${NC}"
            echo -e "  Add this line to your ${YELLOW}~/.zshrc${NC}:"
            echo -e "    ${GREEN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
            echo -e "  Then run: ${YELLOW}source ~/.zshrc${NC}"
        else
            echo -e "${BLUE}Bash Detected${NC}"
            echo -e "  Add this line to your ${YELLOW}~/.bashrc${NC}:"
            echo -e "    ${GREEN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
            echo -e "  Then run: ${YELLOW}source ~/.bashrc${NC}"
        fi
    fi
    
    echo
}

# Setup Git hooks
setup_git_hooks() {
    print_header "Setting Up Git Hooks"
    
    # Create XP calculator script
    cat > "$INSTALL_DIR/scripts/calculate-xp.py" << 'EOFPYTHON'
#!/usr/bin/env python3
"""
XP Calculator for Gamified Documentation System
Automatically calculates XP from git commits
"""

import os
import re
import json
from datetime import datetime, timedelta
from pathlib import Path

# XP values
XP_VALUES = {
    'quick_capture': 10,
    'screenshot': 5,
    'screenshot_max_per_session': 50,
    'documented_failure': 20,
    'refine_reference': 30,
    'refine_tutorial': 50,
    'refine_deepdive': 100,
    'streak_7_day': 50,
    'complete_track': 200,
}

# Level thresholds
LEVEL_THRESHOLDS = [0, 100, 250, 500, 1000, 2000, 4000, 6000, 8000, 10000]

class XPCalculator:
    def __init__(self, docs_dir):
        self.docs_dir = Path(docs_dir)
        self.xp_log = self.docs_dir / 'progress' / 'xp-log.txt'
        self.achievements = self.docs_dir / 'progress' / 'achievements.txt'
        self.streak_tracker = self.docs_dir / 'progress' / 'streak-tracker.txt'
        self.dashboard = self.docs_dir / 'progress' / 'dashboard.md'
        
        # Ensure progress directory exists
        (self.docs_dir / 'progress').mkdir(parents=True, exist_ok=True)
        
    def get_last_commit_files(self):
        """Get files from the last commit"""
        import subprocess
        
        try:
            result = subprocess.run(
                ['git', 'diff-tree', '--no-commit-id', '--name-only', '-r', 'HEAD'],
                cwd=self.docs_dir,
                capture_output=True,
                text=True,
                check=True
            )
            return result.stdout.strip().split('\n') if result.stdout.strip() else []
        except subprocess.CalledProcessError:
            return []
    
    def calculate_commit_xp(self, files):
        """Calculate XP from committed files"""
        xp_earned = 0
        reasons = []
        
        for file in files:
            # Quick captures
            if file.startswith('captures/'):
                xp_earned += XP_VALUES['quick_capture']
                reasons.append(f"+{XP_VALUES['quick_capture']} XP: Quick capture")
            
            # Screenshots
            elif file.startswith('screenshots/') and file.endswith('.png'):
                xp_earned += min(XP_VALUES['screenshot'], XP_VALUES['screenshot_max_per_session'])
                reasons.append(f"+{XP_VALUES['screenshot']} XP: Screenshot")
            
            # Refined documents
            elif file.startswith('refined/'):
                if 'reference' in file:
                    xp_earned += XP_VALUES['refine_reference']
                    reasons.append(f"+{XP_VALUES['refine_reference']} XP: Reference document")
                elif 'tutorial' in file:
                    xp_earned += XP_VALUES['refine_tutorial']
                    reasons.append(f"+{XP_VALUES['refine_tutorial']} XP: Tutorial")
                elif 'deepdive' in file:
                    xp_earned += XP_VALUES['refine_deepdive']
                    reasons.append(f"+{XP_VALUES['refine_deepdive']} XP: Deep-dive")
        
        return xp_earned, reasons
    
    def get_total_xp(self):
        """Read total XP from log"""
        if not self.xp_log.exists():
            return 0
        
        total = 0
        with open(self.xp_log, 'r') as f:
            for line in f:
                match = re.search(r'XP:\s*\+(\d+)', line)
                if match:
                    total += int(match.group(1))
        
        return total
    
    def get_level(self, total_xp):
        """Calculate level from total XP"""
        level = 1
        for threshold in LEVEL_THRESHOLDS:
            if total_xp >= threshold:
                level += 1
            else:
                break
        return level - 1
    
    def log_xp(self, xp, reasons):
        """Log XP to file"""
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        
        with open(self.xp_log, 'a') as f:
            f.write(f"\n[{timestamp}] XP: +{xp}\n")
            for reason in reasons:
                f.write(f"  - {reason}\n")
    
    def update_dashboard(self):
        """Generate progress dashboard"""
        total_xp = self.get_total_xp()
        level = self.get_level(total_xp)
        
        # Calculate XP for next level
        next_level_xp = LEVEL_THRESHOLDS[level] if level < len(LEVEL_THRESHOLDS) else LEVEL_THRESHOLDS[-1] + 2000
        xp_progress = total_xp - LEVEL_THRESHOLDS[level - 1] if level > 0 else total_xp
        xp_needed = next_level_xp - LEVEL_THRESHOLDS[level - 1] if level > 0 else next_level_xp
        
        progress_percent = (xp_progress / xp_needed * 100) if xp_needed > 0 else 100
        
        # Count documents
        captures = sum(1 for _ in (self.docs_dir / 'captures').rglob('*.md'))
        references = sum(1 for _ in (self.docs_dir / 'refined' / 'reference').glob('*.md')) if (self.docs_dir / 'refined' / 'reference').exists() else 0
        tutorials = sum(1 for _ in (self.docs_dir / 'refined' / 'tutorial').glob('*.md')) if (self.docs_dir / 'refined' / 'tutorial').exists() else 0
        deepdives = sum(1 for _ in (self.docs_dir / 'refined' / 'deepdive').glob('*.md')) if (self.docs_dir / 'refined' / 'deepdive').exists() else 0
        
        dashboard_content = f"""# Homelab Documentation Progress

**Last Updated**: {datetime.now().strftime('%Y-%m-%d %H:%M')}

---

## Current Stats

**Level**: {level} | **Total XP**: {total_xp:,}

Progress to Level {level + 1}:
```
[{'=' * int(progress_percent / 2)}{' ' * (50 - int(progress_percent / 2))}] {progress_percent:.1f}%
```
**XP**: {xp_progress}/{xp_needed} (+{total_xp - LEVEL_THRESHOLDS[level - 1] if level > 0 else total_xp} from Level {level})

---

## Documentation Count

- **Quick Captures**: {captures}
- **Reference Docs**: {references}
- **Tutorials**: {tutorials}
- **Deep-Dives**: {deepdives}
- **Total Documents**: {captures + references + tutorials + deepdives}

---

## Certification Tracks

"""
        
        # Track progress per certification
        tracks = ['ccna', 'ccie', 'aws', 'hamradio', 'projects']
        for track in tracks:
            track_dir = self.docs_dir / 'captures' / track
            if track_dir.exists():
                count = sum(1 for _ in track_dir.glob('*.md'))
                dashboard_content += f"### {track.upper()}\n"
                dashboard_content += f"Documents: {count}\n\n"
        
        dashboard_content += """---

## Recent Achievements

"""
        
        # Show recent achievements
        if self.achievements.exists():
            with open(self.achievements, 'r') as f:
                recent = f.readlines()[-5:]
                if recent:
                    for achievement in recent:
                        dashboard_content += f"- {achievement}"
                else:
                    dashboard_content += "No achievements yet. Keep documenting!\n"
        else:
            dashboard_content += "No achievements yet. Keep documenting!\n"
        
        dashboard_content += """
---

## Streak

"""
        
        # Check streak
        if self.streak_tracker.exists():
            with open(self.streak_tracker, 'r') as f:
                content = f.read()
                dashboard_content += content if content else "No active streak. Start documenting!\n"
        else:
            dashboard_content += "No active streak. Start documenting!\n"
        
        dashboard_content += """
---

**Next Milestone**: Level """ + str(level + 1) + f""" ({next_level_xp - total_xp:,} XP needed)

Keep documenting!
"""
        
        with open(self.dashboard, 'w') as f:
            f.write(dashboard_content)
    
    def process_commit(self):
        """Main process - calculate and log XP from last commit"""
        files = self.get_last_commit_files()
        
        if not files:
            return
        
        xp, reasons = self.calculate_commit_xp(files)
        
        if xp > 0:
            self.log_xp(xp, reasons)
            print(f"✓ Earned {xp} XP!")
            for reason in reasons:
                print(f"  {reason}")
        
        self.update_dashboard()
        print(f"✓ Updated progress dashboard")

if __name__ == '__main__':
    docs_dir = os.path.expanduser('~/homelab-docs')
    calculator = XPCalculator(docs_dir)
    calculator.process_commit()
EOFPYTHON

    chmod +x "$INSTALL_DIR/scripts/calculate-xp.py"
    
    # Create post-commit hook
    cat > "$INSTALL_DIR/git-hooks/post-commit" << 'EOFHOOK'
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
EOFHOOK

    chmod +x "$INSTALL_DIR/git-hooks/post-commit"
    
    # Copy hooks to .git/hooks
    if [ -d "$INSTALL_DIR/.git" ]; then
        cp "$INSTALL_DIR/git-hooks/post-commit" "$INSTALL_DIR/.git/hooks/"
        print_success "Git hooks installed and activated"
    else
        print_warning "Git not initialized yet - hooks will be installed after git init"
    fi
    
    echo
}

# Initialize Git repository
init_git_repo() {
    print_header "Initializing Git Repository"
    
    cd "$INSTALL_DIR"
    
    if [ ! -d ".git" ]; then
        # Check git user configuration
        git_name=$(git config --global user.name 2>/dev/null)
        git_email=$(git config --global user.email 2>/dev/null)
        
        if [ -z "$git_name" ] || [ -z "$git_email" ]; then
            print_warning "Git user configuration not found"
            echo ""
            echo -e "${YELLOW}Please configure git before continuing:${NC}"
            echo ""
            read -p "Enter your name: " input_name
            read -p "Enter your email: " input_email
            
            git config --global user.name "$input_name"
            git config --global user.email "$input_email"
            print_success "Git user configured"
            echo ""
        fi
        
        # Set default branch to main
        git config --global init.defaultBranch main 2>/dev/null
        
        # Initialize repository
        git init
        print_success "Initialized Git repository"
        
        # Rename branch to main if needed (for older git versions)
        current_branch=$(git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ "$current_branch" = "master" ]; then
            git branch -m main
            print_success "Renamed default branch to 'main'"
        fi
        
        # Create .gitignore
        cat > ".gitignore" << 'EOF'
# OS files
.DS_Store
Thumbs.db

# Editor files
*.swp
*.swo
*~
.vscode/
.idea/

# Temporary files
*.tmp
*.bak

# Python cache
__pycache__/
*.pyc

# Secrets (if any)
.env
secrets/
EOF
        
        print_success "Created .gitignore"
        
        # Install hooks
        cp git-hooks/* .git/hooks/
        chmod +x .git/hooks/*
        print_success "Installed Git hooks"
        
        # Initial commit
        git add .
        git commit -m "Initial commit: Homelab documentation system setup"
        print_success "Created initial commit"
    else
        print_warning "Git repository already exists"
    fi
    
    echo
}

# GitHub authentication setup
setup_github_auth() {
    print_header "GitHub Authentication Setup"
    
    echo -e "${BLUE}This system backs up to GitHub automatically.${NC}"
    echo -e "You need to configure GitHub authentication to enable backups."
    echo ""
    echo "Choose authentication method:"
    echo "  1. SSH Keys (Recommended - doesn't expire)"
    echo "  2. Personal Access Token (Simpler, but expires)"
    echo "  3. Skip (configure later)"
    echo ""
    read -p "Select option [1-3]: " auth_choice
    
    case $auth_choice in
        1)
            setup_ssh_auth
            ;;
        2)
            setup_token_auth
            ;;
        3)
            print_info "Skipped GitHub setup. You can configure it later."
            echo -e "  See README.md section: ${YELLOW}GitHub Integration${NC}"
            ;;
        *)
            print_warning "Invalid choice. Skipping GitHub setup."
            ;;
    esac
    
    echo
}

setup_ssh_auth() {
    print_info "Setting up SSH authentication..."
    echo ""
    
    # Check if SSH key exists
    if [ -f "$HOME/.ssh/id_ed25519" ]; then
        print_success "SSH key found: $HOME/.ssh/id_ed25519"
        echo ""
        read -p "Use existing key? [Y/n]: " use_existing
        
        if [[ "$use_existing" =~ ^[Nn]$ ]]; then
            generate_ssh_key
        fi
    else
        generate_ssh_key
    fi
    
    # Ensure SSH agent is running and key is added
    echo ""
    print_info "Adding SSH key to agent..."
    
    # Start ssh-agent if not running
    if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" > /dev/null
        print_success "Started SSH agent"
    fi
    
    # Add key to agent (will prompt for passphrase if key has one)
    echo ""
    echo -e "${YELLOW}If your SSH key has a passphrase, you'll be prompted to enter it now:${NC}"
    ssh-add "$HOME/.ssh/id_ed25519"
    
    if [ $? -eq 0 ]; then
        print_success "SSH key added to agent"
    else
        print_error "Failed to add SSH key to agent"
        return 1
    fi
    
    # Display public key
    echo ""
    print_info "Your SSH public key:"
    echo -e "${GREEN}"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo -e "${NC}"
    
    echo ""
    print_info "GitHub Setup Steps:"
    echo "  1. Copy the key above (it's been copied to your clipboard if possible)"
    echo "  2. Go to: https://github.com/settings/keys"
    echo "  3. Click 'New SSH key'"
    echo "  4. Give it a title like 'Homelab Docs - CachyOS'"
    echo "  5. Paste your key and click 'Add SSH key'"
    echo ""
    read -p "Press Enter when you've added the key to GitHub..."
    
    # Test connection
    echo ""
    print_info "Testing GitHub connection..."
    
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        print_success "GitHub SSH authentication successful!"
        
        # Repository creation instructions
        echo ""
        print_info "Now you need to create a repository on GitHub:"
        echo "  1. Go to: https://github.com/new"
        echo "  2. Repository name: homelab-docs (or your choice)"
        echo "  3. Description: My gamified homelab documentation"
        echo "  4. Choose Private or Public"
        echo "  5. DO NOT initialize with README, .gitignore, or license"
        echo "  6. Click 'Create repository'"
        echo ""
        read -p "Press Enter when you've created the repository..."
        
        # Configure git remote
        echo ""
        read -p "Enter your GitHub username: " gh_username
        read -p "Enter repository name (default: homelab-docs): " repo_name
        repo_name=${repo_name:-homelab-docs}
        
        cd "$INSTALL_DIR"
        
        if ! git remote get-url origin &>/dev/null; then
            git remote add origin "git@github.com:${gh_username}/${repo_name}.git"
            print_success "GitHub remote configured"
            
            echo ""
            print_info "Repository linked successfully!"
            echo ""
            print_info "To push your documentation to GitHub:"
            echo -e "  ${GREEN}cd $INSTALL_DIR${NC}"
            echo -e "  ${GREEN}git push -u origin main${NC}"
            echo ""
            echo -e "${YELLOW}Note: Your SSH agent session will persist until you log out.${NC}"
            echo -e "${YELLOW}If you restart your terminal, run: ssh-add ~/.ssh/id_ed25519${NC}"
        else
            print_warning "Remote 'origin' already exists"
        fi
    else
        print_error "GitHub authentication failed"
        echo ""
        print_info "Troubleshooting steps:"
        echo "  1. Verify the key was added at: https://github.com/settings/keys"
        echo "  2. Check if your SSH key is loaded: ssh-add -l"
        echo "  3. If not loaded, add it: ssh-add ~/.ssh/id_ed25519"
        echo "  4. Test connection: ssh -T git@github.com"
    fi
}

generate_ssh_key() {
    echo ""
    read -p "Enter your email for the SSH key: " email
    
    echo ""
    print_info "Generating SSH key..."
    echo -e "${YELLOW}You'll be prompted to:"
    echo "  1. Choose a location (press Enter for default)"
    echo "  2. Enter a passphrase (optional but recommended)"
    echo "     - Empty passphrase = no password needed"
    echo "     - Set passphrase = more secure, but you'll need to enter it"
    echo -e "${NC}"
    
    ssh-keygen -t ed25519 -C "$email" -f "$HOME/.ssh/id_ed25519"
    
    print_success "Generated new SSH key"
}

setup_token_auth() {
    print_info "Setting up Personal Access Token authentication..."
    echo ""
    
    print_info "To create a token:"
    echo "  1. Go to: https://github.com/settings/tokens"
    echo "  2. Click 'Generate new token (classic)'"
    echo "  3. Select scope: 'repo' (full control)"
    echo "  4. Click 'Generate token'"
    echo "  5. Copy the token (you won't see it again!)"
    echo ""
    read -p "Press Enter when you have your token..."
    
    echo ""
    read -p "Enter your GitHub username: " gh_username
    read -p "Enter repository name (default: homelab-docs): " repo_name
    repo_name=${repo_name:-homelab-docs}
    
    cd "$INSTALL_DIR"
    
    if ! git remote get-url origin &>/dev/null; then
        git remote add origin "https://github.com/${gh_username}/${repo_name}.git"
        print_success "GitHub remote configured"
    else
        print_warning "Remote 'origin' already exists"
    fi
    
    # Configure credential helper
    git config --global credential.helper store
    
    print_success "Credential helper configured"
    echo ""
    print_info "On your next git push, enter:"
    echo "  Username: $gh_username"
    echo "  Password: [paste your token]"
    echo ""
    print_info "Credentials will be saved for future pushes"
}

# Initialize progress tracking
init_progress() {
    print_header "Initializing Progress Tracking"
    
    # Create initial XP log
    cat > "$INSTALL_DIR/progress/xp-log.txt" << EOF
# XP Transaction Log
# Automatically maintained by the system

[$(date '+%Y-%m-%d %H:%M:%S')] System initialized
EOF

    # Create achievements file
    cat > "$INSTALL_DIR/progress/achievements.txt" << EOF
# Achievement Log
# Unlocked achievements appear here

[$(date '+%Y-%m-%d')] 🎯 System Setup - Installed the gamified documentation system
EOF

    # Create streak tracker
    cat > "$INSTALL_DIR/progress/streak-tracker.txt" << EOF
Current Streak: 0 days
Longest Streak: 0 days
Last Documentation: $(date '+%Y-%m-%d')
EOF

    # Run initial dashboard generation
    python3 "$INSTALL_DIR/scripts/calculate-xp.py" 2>/dev/null || true
    
    print_success "Progress tracking initialized"
    echo
}

# Create example achievement definitions
create_achievements() {
    cat > "$INSTALL_DIR/achievements/achievements.json" << 'EOF'
{
  "documentation": [
    {
      "id": "first_steps",
      "name": "First Steps",
      "icon": "🥉",
      "description": "Create your first quick capture",
      "requirement": "captures >= 1"
    },
    {
      "id": "picture_perfect",
      "name": "Picture Perfect",
      "icon": "📸",
      "description": "Add 50 screenshots",
      "requirement": "screenshots >= 50"
    },
    {
      "id": "troubleshooter",
      "name": "Troubleshooter",
      "icon": "🔧",
      "description": "Document 20 failures and fixes",
      "requirement": "troubleshooting_logs >= 20"
    },
    {
      "id": "librarian",
      "name": "Librarian",
      "icon": "📚",
      "description": "Create 25 reference documents",
      "requirement": "references >= 25"
    },
    {
      "id": "teacher",
      "name": "Teacher",
      "icon": "👨‍🏫",
      "description": "Create 10 tutorial documents",
      "requirement": "tutorials >= 10"
    },
    {
      "id": "deep_diver",
      "name": "Deep Diver",
      "icon": "🧙",
      "description": "Create 5 deep-dive documents",
      "requirement": "deepdives >= 5"
    }
  ],
  "consistency": [
    {
      "id": "hot_streak",
      "name": "Hot Streak",
      "icon": "🔥",
      "description": "Maintain a 7-day streak",
      "requirement": "streak >= 7",
      "bonus_xp": 50
    },
    {
      "id": "dedicated",
      "name": "Dedicated",
      "icon": "🌟",
      "description": "Maintain a 30-day streak",
      "requirement": "streak >= 30",
      "bonus_xp": 150
    },
    {
      "id": "legendary",
      "name": "Legendary",
      "icon": "💎",
      "description": "Maintain a 100-day streak",
      "requirement": "streak >= 100",
      "bonus_xp": 500
    }
  ],
  "certification": [
    {
      "id": "ccna_scholar",
      "name": "CCNA Scholar",
      "icon": "🎓",
      "description": "Complete 25 CCNA captures",
      "requirement": "ccna_captures >= 25"
    },
    {
      "id": "ccie_candidate",
      "name": "CCIE Candidate",
      "icon": "🏆",
      "description": "Complete 50 CCIE captures",
      "requirement": "ccie_captures >= 50"
    },
    {
      "id": "cloud_architect",
      "name": "Cloud Architect",
      "icon": "☁️",
      "description": "Complete 30 AWS captures",
      "requirement": "aws_captures >= 30"
    },
    {
      "id": "ham_operator",
      "name": "Ham Operator",
      "icon": "📻",
      "description": "Complete 20 Ham Radio captures",
      "requirement": "hamradio_captures >= 20"
    }
  ],
  "milestones": [
    {
      "id": "level_5",
      "name": "Expert",
      "icon": "📈",
      "description": "Reach Level 5",
      "requirement": "level >= 5"
    },
    {
      "id": "level_10",
      "name": "Legendary Status",
      "icon": "🚀",
      "description": "Reach Level 10",
      "requirement": "level >= 10"
    },
    {
      "id": "centurion",
      "name": "Centurion",
      "icon": "💯",
      "description": "Create 100 documents total",
      "requirement": "total_documents >= 100"
    }
  ]
}
EOF
}

# Final setup message
show_completion_message() {
    print_header "Installation Complete! 🎉"
    
    echo -e "${GREEN}Your gamified homelab documentation system is ready!${NC}"
    echo ""
    echo -e "${BLUE}Installation Directory:${NC} $INSTALL_DIR"
    echo ""
    
    # Check if PATH needs configuration
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo -e "${YELLOW} Important: Add CLI tools to your PATH${NC}"
        echo ""
        
        # Detect shell and provide specific instructions
        if [ -n "$FISH_VERSION" ] || ps -p $$ -o comm= | grep -q fish; then
            echo -e "${BLUE}For Fish Shell:${NC}"
            echo -e "  ${GREEN}echo 'set -gx PATH \$HOME/.local/bin \$PATH' >> ~/.config/fish/config.fish${NC}"
            echo -e "  ${GREEN}source ~/.config/fish/config.fish${NC}"
        elif [ -n "$ZSH_VERSION" ]; then
            echo -e "${BLUE}For Zsh:${NC}"
            echo -e "  ${GREEN}echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc${NC}"
            echo -e "  ${GREEN}source ~/.zshrc${NC}"
        else
            echo -e "${BLUE}For Bash:${NC}"
            echo -e "  ${GREEN}echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc${NC}"
            echo -e "  ${GREEN}source ~/.bashrc${NC}"
        fi
        echo ""
    fi
    
    echo -e "${BLUE}Quick Start:${NC}"
    echo -e "  1. Create your first capture:"
    echo -e "     ${GREEN}labquick \"CCNA\" \"Your First Lab\"${NC}"
    echo ""
    echo -e "  2. View your progress:"
    echo -e "     ${GREEN}labprogress${NC}"
    echo ""
    echo -e "  3. Push to GitHub:"
    echo -e "     ${GREEN}cd $INSTALL_DIR && git push${NC}"
    echo ""
    echo -e "${BLUE}Available Commands:${NC}"
    echo -e "  ${GREEN}labquick${NC}    - Create quick capture (5 min)"
    echo -e "  ${GREEN}labrefine${NC}   - Polish your notes"
    echo -e "  ${GREEN}labscreen${NC}   - Organize screenshots"
    echo -e "  ${GREEN}labprogress${NC} - View your dashboard"
    echo ""
    echo -e "${BLUE}Documentation:${NC}"
    echo -e "  Full guide: ${GREEN}$INSTALL_DIR/README.md${NC}"
    echo ""
    echo -e "${YELLOW}Pro Tip:${NC} Document as you work. Even 5 minutes adds up!"
    echo ""
    print_info "Happy documenting!"
    echo ""
}

# Main installation flow
main() {
    echo ""
    print_header "Gamified Homelab Documentation System Installer"
    echo ""
    
    check_requirements
    create_directories
    setup_templates
    setup_cli_tools
    setup_git_hooks
    init_git_repo
    init_progress
    create_achievements
    setup_github_auth
    show_completion_message
}

# Run main installation
main
