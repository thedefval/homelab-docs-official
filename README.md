# Gamified Homelab Documentation System

A lightweight, git-based documentation system that makes capturing and refining technical content engaging through gamification, XP tracking, and achievement badges.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Directory Structure](#directory-structure)
- [Daily Workflow](#daily-workflow)
- [CLI Commands](#cli-commands)
- [XP System & Achievements](#xp-system--achievements)
- [GitHub Integration](#github-integration)
- [Screenshot Workflow](#screenshot-workflow)
- [Troubleshooting](#troubleshooting)

## Overview

This system supports your certification studies (CCNA, CCIE, AWS CSA Pro, Ham Radio General & Extra) and personal projects (Authentik, Wazuh, etc.) with:

- **Quick Capture**: 5-minute note-taking during active labs
- **Refinement Process**: Polish raw notes into blog-ready content
- **Gamification**: XP, levels, achievements, and streaks
- **Visual Progress**: Track progress across certification tracks
- **Local-First**: All files stored locally, GitHub as backup
- **Automated**: Git hooks automatically calculate XP and update stats

## Quick Start

```bash
# Clone your repository
git clone git@github.com:yourusername/homelab-docs.git
cd homelab-docs

# Run the installer
chmod +x scripts/install.sh
./scripts/install.sh

# Create your first quick capture
./scripts/labquick.sh "CCNA" "Configure OSPF Single Area"

# View your progress
cat progress/dashboard.md
```

## System Requirements

- **OS**: Linux (tested on CachyOS, works on most distributions)
- **Required**:
  - Git 2.x+
  - Bash 4.0+
  - Python 3.8+ (for XP calculations)
- **Optional**:
  - Flameshot (screenshot tool with annotations)
  - GitHub account (for cloud backup)

## Installation

### Method 1: Automated Installation (Recommended)

```bash
# Download the installer
wget https://raw.githubusercontent.com/yourusername/homelab-docs/main/scripts/install.sh

# Make it executable
chmod +x install.sh

# Run installation
./install.sh
```

The installer will:
1. Verify system requirements
2. Set up directory structure
3. Install CLI tools to `~/.local/bin/`
4. Configure Git hooks for automatic XP tracking
5. Guide you through GitHub authentication setup
6. Create initial progress tracking files

### Method 2: Manual Installation

```bash
# Create directory structure
mkdir -p ~/homelab-docs/{captures,refined,screenshots,progress,templates,scripts,achievements}

# Clone this repository
git clone git@github.com:yourusername/homelab-docs.git ~/homelab-docs

# Copy scripts to local bin
cp ~/homelab-docs/scripts/*.sh ~/.local/bin/
chmod +x ~/.local/bin/{labquick,labrefine,labscreen,labprogress}.sh

# Set up Git hooks
cp ~/homelab-docs/git-hooks/* ~/homelab-docs/.git/hooks/
chmod +x ~/homelab-docs/.git/hooks/*

# Initialize progress tracking
cp ~/homelab-docs/templates/initial-* ~/homelab-docs/progress/
```

## Directory Structure

```
~/homelab-docs/
├── README.md                    # This file
├── .gitignore                   # Git ignore rules
├── captures/                    # Quick 5-minute captures
│   ├── ccna/
│   ├── ccie/
│   ├── aws/
│   ├── hamradio/
│   └── projects/
├── refined/                     # Polished documentation
│   ├── reference/              # Personal reference docs
│   ├── tutorial/               # Tutorial-style posts
│   └── deepdive/               # Technical deep-dives
├── screenshots/                 # Organized screenshots
│   ├── [track]/[yyyy-mm-dd]/
│   └── thumbnails/
├── progress/                    # Progress tracking
│   ├── xp-log.txt              # XP transaction log
│   ├── achievements.txt        # Unlocked achievements
│   ├── dashboard.md            # Visual progress dashboard
│   └── streak-tracker.txt      # Documentation streaks
├── templates/                   # Document templates
│   ├── quick-capture.md
│   ├── refinement-reference.md
│   ├── refinement-tutorial.md
│   └── refinement-deepdive.md
├── scripts/                     # CLI tools
│   ├── install.sh              # System installer
│   ├── labquick.sh             # Quick capture tool
│   ├── labrefine.sh            # Refinement tool
│   ├── labscreen.sh            # Screenshot organizer
│   └── labprogress.sh          # Progress viewer
├── git-hooks/                   # Git automation
│   ├── post-commit             # Auto XP calculation
│   └── pre-push                # Pre-push validation
└── achievements/                # Achievement definitions
    └── achievements.json
```

## Daily Workflow

### Phase 1: Quick Capture (During Labs)

**Time: ~5 minutes**

```bash
# Create a new quick capture
labquick "CCNA" "Configure OSPF Multi-Area"

# Edit the file (opens in $EDITOR)
# Document as you work - focus on commands and results
# Note what DIDN'T work in the troubleshooting section

# Commit when done
git add captures/
git commit -m "Quick capture: OSPF multi-area configuration"
git push
```

**Result**: +10 XP automatically added

### Phase 2: Screenshot Organization (As Needed)

```bash
# Take screenshots with Flameshot during lab work
# They're automatically saved to ~/Pictures

# After lab session, organize them
labscreen "CCNA" "2025-10-24"

# Script will:
# - Move screenshots from ~/Pictures to screenshots/ccna/2025-10-24/
# - Generate thumbnails
# - Create screenshot index
```

**Result**: +5 XP per screenshot (up to +50 XP per session)

### Phase 3: Weekly Refinement (Review Session)

**Time: 30-60 minutes weekly**

```bash
# Start refinement process
labrefine

# Choose a quick capture to refine
# Select refinement type: reference, tutorial, or deepdive

# Edit the refined document
# Add screenshots, improve explanations, add context

# Commit when done
git add refined/
git commit -m "Refined: OSPF configuration reference guide"
git push
```

**Result**: +30 XP (reference), +50 XP (tutorial), or +100 XP (deepdive)

### Phase 4: Track Progress

```bash
# View your dashboard anytime
labprogress

# Or directly view the markdown file
cat progress/dashboard.md
```

## CLI Commands

### `labquick [TRACK] [TITLE]`

Create a quick capture document during lab work.

```bash
# Examples
labquick "CCNA" "Configure EIGRP Named Mode"
labquick "AWS" "Deploy Lambda with API Gateway"
labquick "Projects" "Authentik LDAP Integration"
```

Creates a timestamped file in `captures/[track]/` with quick capture template pre-filled.

### `labrefine`

Interactive refinement wizard to polish quick captures.

```bash
labrefine

# Prompts you for:
# 1. Which capture to refine
# 2. Refinement type (reference/tutorial/deepdive)
# 3. Opens template in your editor
```

### `labscreen [TRACK] [DATE]`

Organize screenshots from ~/Pictures into the documentation system.

```bash
# Organize today's screenshots
labscreen "CCNA" "2025-10-24"

# Script will:
# - Move screenshots to screenshots/ccna/2025-10-24/
# - Generate thumbnails
# - Create screenshot index with image tags
```

### `labprogress`

Display your current progress dashboard.

```bash
labprogress

# Shows:
# - Current level and XP
# - Progress bars for each certification track
# - Recent achievements
# - Current streak
# - Weekly/monthly stats
```

## XP System & Achievements

### XP Values

| Action | XP | Notes |
|--------|----|-----------| 
| Quick Capture | +10 XP | 5-minute documentation during labs |
| Add Screenshot | +5 XP | Per screenshot (max 50 XP/session) |
| Document Failure | +20 XP | Troubleshooting section completed |
| Refine to Reference | +30 XP | Useful to future-you |
| Refine to Tutorial | +50 XP | Useful to others |
| Refine to Deep-Dive | +100 XP | Portfolio-quality piece |
| 7-Day Streak | +50 XP | Consistency bonus |
| Complete Cert Track | +200 XP | Major milestone |

### Leveling System

- **Level 1**: 0 XP - Novice
- **Level 2**: 100 XP - Apprentice
- **Level 3**: 250 XP - Journeyman
- **Level 4**: 500 XP - Expert
- **Level 5**: 1000 XP - Master
- **Level 6**: 2000 XP - Grandmaster
- **Level 7+**: +2000 XP per level

### Achievement Badges

Achievements are automatically unlocked and tracked in `progress/achievements.txt`:

**Documentation Achievements**:
- 🥉 **First Steps**: Create your first quick capture
- 📸 **Picture Perfect**: Add 50 screenshots
- 🔧 **Troubleshooter**: Document 20 failures and fixes
- 📚 **Librarian**: Create 25 reference documents
- 👨‍🏫 **Teacher**: Create 10 tutorial documents
- 🧙 **Deep Diver**: Create 5 deep-dive documents

**Consistency Achievements**:
- 🔥 **Hot Streak**: Maintain a 7-day streak
- 🌟 **Dedicated**: Maintain a 30-day streak
- 💎 **Legendary**: Maintain a 100-day streak

**Certification Achievements**:
- 🎓 **CCNA Scholar**: Complete 25 CCNA captures
- 🏆 **CCIE Candidate**: Complete 50 CCIE captures
- ☁️ **Cloud Architect**: Complete 30 AWS captures
- 📻 **Ham Operator**: Complete 20 Ham Radio captures

**Milestone Achievements**:
- 📈 **Level 5**: Reach Expert level
- 🚀 **Level 10**: Reach Legendary status
- 💯 **Centurion**: Create 100 documents total

## GitHub Integration

### Why GitHub?

- **Backup**: Automatic cloud backup of all documentation
- **Versioning**: Full history of all changes
- **Access**: View documentation from any device
- **Sharing**: Easy to share specific documents
- **Portfolio**: Public repositories showcase your expertise

### Authentication Setup

The system supports two authentication methods:

#### Option 1: SSH Keys (Recommended)

SSH keys are more secure and don't expire. The installer will guide you through setup, or follow these steps:

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Start the SSH agent
eval "$(ssh-agent -s)"

# Add your key to the agent
ssh-add ~/.ssh/id_ed25519

# Copy your public key
cat ~/.ssh/id_ed25519.pub
# Copy the output

# Add to GitHub:
# 1. Go to https://github.com/settings/keys
# 2. Click "New SSH key"
# 3. Paste your public key
# 4. Click "Add SSH key"

# Test the connection
ssh -T git@github.com
# Should see: "Hi username! You've successfully authenticated..."

# Configure your repository to use SSH
cd ~/homelab-docs
git remote set-url origin git@github.com:yourusername/homelab-docs.git
```

#### Option 2: Personal Access Token

Tokens work well but need to be renewed periodically.

```bash
# Create a token on GitHub:
# 1. Go to https://github.com/settings/tokens
# 2. Click "Generate new token (classic)"
# 3. Select scopes: repo (full control)
# 4. Click "Generate token"
# 5. Copy the token immediately (you won't see it again!)

# Configure git to use the token
git config --global credential.helper store

# Next time you push, enter:
# Username: your_github_username
# Password: paste_your_token_here

# The credentials will be stored in ~/.git-credentials
```

### Automatic Backup Workflow

Once GitHub is configured, every commit automatically backs up to GitHub:

```bash
# Make changes
labquick "CCNA" "Configure VLANs"

# Commit triggers post-commit hook
git commit -m "Quick capture: VLAN configuration"

# Post-commit hook:
# 1. Calculates XP earned
# 2. Updates progress files
# 3. Checks for achievements
# 4. Creates automatic commit for progress updates

# Push to GitHub (automatic backup)
git push

# Both your capture AND updated progress are now backed up!
```

### Repository Setup

```bash
# Create a new repository on GitHub
# https://github.com/new
# Name: homelab-docs
# Private or Public (your choice)
# Don't initialize with README

# Link your local repository
cd ~/homelab-docs
git remote add origin git@github.com:yourusername/homelab-docs.git

# Push everything to GitHub
git push -u origin main

# Future pushes are just:
git push
```

### Viewing Your Documentation Online

Your documentation is now available at:
```
https://github.com/yourusername/homelab-docs
```

Individual files can be viewed directly:
```
https://github.com/yourusername/homelab-docs/blob/main/refined/reference/ospf-configuration.md
```

## 📸 Screenshot Workflow

### Taking Screenshots

**Recommended: Flameshot** (Linux)

```bash
# Install Flameshot
sudo pacman -S flameshot  # CachyOS/Arch
sudo apt install flameshot  # Ubuntu/Debian

# Set keyboard shortcut (usually Print Screen)
# Flameshot saves to ~/Pictures by default

# Features:
# - Draw arrows, boxes, text
# - Blur sensitive info
# - Quick annotations
# - Copy to clipboard or save
```

### Organizing Screenshots

After a lab session:

```bash
# Organize screenshots for today's work
labscreen "CCNA" "2025-10-24"

# Script will:
# 1. Create screenshots/ccna/2025-10-24/
# 2. Move all screenshots from ~/Pictures
# 3. Generate thumbnails
# 4. Create screenshot-index.md with image links
```

### Embedding Screenshots

In your markdown documents:

```markdown
# Configuration Example

Here's the OSPF configuration:

![OSPF Configuration](../../screenshots/ccna/2025-10-24/ospf-config-01.png)

The routing table shows all routes:

![Routing Table](../../screenshots/ccna/2025-10-24/routing-table-01.png)
```

### Screenshot Best Practices

1. **Capture as you go**: Don't wait until the end
2. **Annotate immediately**: Add arrows, boxes, text while fresh
3. **Blur sensitive info**: Passwords, IPs, hostnames
4. **Descriptive filenames**: Flameshot allows custom names
5. **Organize daily**: Run `labscreen` after each session

## Troubleshooting

### Git Push Fails

**Problem**: `Permission denied (publickey)` when pushing to GitHub

**Solution**:
```bash
# Test SSH connection
ssh -T git@github.com

# If it fails, check your SSH key is added
ssh-add -l

# If no identities, add your key
ssh-add ~/.ssh/id_ed25519

# Verify remote URL uses SSH
git remote -v
# Should show: git@github.com:username/repo.git

# If it shows HTTPS, change it:
git remote set-url origin git@github.com:username/homelab-docs.git
```

### XP Not Calculating

**Problem**: XP doesn't update after commits

**Solution**:
```bash
# Check if Git hooks are installed
ls -la .git/hooks/post-commit

# If missing, reinstall hooks
cp git-hooks/* .git/hooks/
chmod +x .git/hooks/*

# Test manually
python3 scripts/calculate-xp.py
```

### CLI Commands Not Found

**Problem**: `labquick: command not found`

**Solution**:
```bash
# Check if ~/.local/bin is in PATH
echo $PATH | grep .local/bin

# If not, add to your shell config:

# For Fish Shell:
echo 'set -gx PATH $HOME/.local/bin $PATH' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish

# For Zsh:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For Bash:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify scripts are executable
ls -l ~/.local/bin/lab*
chmod +x ~/.local/bin/lab*
```

### Screenshots Not Organizing

**Problem**: `labscreen` doesn't move screenshots

**Solution**:
```bash
# Check if screenshots exist
ls ~/Pictures/*.png

# Check if target directory exists
ls screenshots/[track]/

# Run with verbose output
bash -x ~/.local/bin/labscreen.sh "CCNA" "2025-10-24"

# Verify Flameshot is saving to ~/Pictures
flameshot config
```

### Progress Dashboard Not Updating

**Problem**: Dashboard shows old data after commits

**Solution**:
```bash
# Manually regenerate dashboard
python3 scripts/calculate-xp.py

# Check XP log for recent entries
tail -20 progress/xp-log.txt

# Verify last commit was successful
git log -1

# Check if progress files are being committed
git status progress/
```

## Additional Resources

### Templates

All templates are in `templates/` directory:
- `quick-capture.md` - 5-minute capture template
- `refinement-reference.md` - Reference doc template
- `refinement-tutorial.md` - Tutorial template
- `refinement-deepdive.md` - Deep-dive template

### Scripts

All scripts are in `scripts/` directory:
- `install.sh` - Full system installer
- `labquick.sh` - Quick capture creation
- `labrefine.sh` - Refinement wizard
- `labscreen.sh` - Screenshot organizer
- `labprogress.sh` - Progress viewer
- `calculate-xp.py` - XP calculator (auto-run by Git hooks)

### Git Hooks

All hooks are in `git-hooks/` directory:
- `post-commit` - Runs after each commit to calculate XP
- `pre-push` - Optional validation before push

## Contributing

This is a personal documentation system, but feel free to:
- Fork the repository for your own use

## License

MIT License - Use this system however you want!

## Tips for Success

1. **Document immediately**: Capture during labs, not after
2. **Be consistent**: Even 5 minutes daily builds momentum
3. **Refine weekly**: Set aside dedicated refinement time
4. **Use streaks**: The 7-day bonus is powerful motivation
5. **Share your work**: Public tutorials help others and showcase your skills
6. **Track failures**: Your future self will thank you
7. **Trust the system**: Local-first means you never lose work

---

**Happy documenting! Level up your homelab and your career.**
