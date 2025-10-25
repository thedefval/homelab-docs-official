# 🚀 Quickstart Guide

Get your gamified homelab documentation system up and running in 5 minutes!

## Step 1: Clone and Install

```bash
# Clone the repository
git clone https://github.com/yourusername/homelab-docs.git
cd homelab-docs

# Run the installer
chmod +x scripts/install.sh
./scripts/install.sh
```

The installer will:
- ✅ Check system requirements
- ✅ Set up directory structure
- ✅ Install CLI tools
- ✅ Configure Git hooks
- ✅ Guide you through GitHub authentication
- ✅ Initialize progress tracking

## Step 2: Configure Your PATH

Add `~/.local/bin` to your PATH if it's not already there:

```bash
# For Bash users
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For Zsh users
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Step 3: Create Your First Capture

```bash
# During your next lab session
labquick "CCNA" "Configure OSPF Single Area"

# This will:
# 1. Create a new markdown file with a template
# 2. Open it in your editor
# 3. Award +10 XP when you commit it
```

## Step 4: Add Screenshots (Optional)

```bash
# After taking screenshots during your lab
labscreen "CCNA" "2025-10-24"

# This will organize screenshots from ~/Pictures
```

## Step 5: Push to GitHub

```bash
# Backup your work to GitHub
git push

# Your documentation and progress are now backed up!
```

## Daily Workflow

### During Lab Work (5 minutes)

```bash
labquick "TRACK" "What You're Working On"
# Document as you go
git add captures/
git commit -m "Quick capture: [description]"
git push
```

### Weekly Review (30 minutes)

```bash
labrefine
# Select a capture to polish
# Choose: reference, tutorial, or deep-dive
git add refined/
git commit -m "Refined: [description]"
git push
```

### Anytime

```bash
# Check your progress
labprogress

# Or view the dashboard directly
cat ~/homelab-docs/progress/dashboard.md
```

## XP Cheat Sheet

| Action | XP | Time |
|--------|----|---------| 
| Quick Capture | +10 | 5 min |
| Screenshot | +5 each | Instant |
| Document Failure | +20 | 2 min |
| Refine to Reference | +30 | 15 min |
| Refine to Tutorial | +50 | 30 min |
| Refine to Deep-Dive | +100 | 60 min |
| 7-Day Streak | +50 | Daily |

## Certification Tracks

Organize your work by track:

```bash
labquick "CCNA" "Topic"      # CCNA certification study
labquick "CCIE" "Topic"      # CCIE certification study
labquick "AWS" "Topic"       # AWS certification study
labquick "HamRadio" "Topic"  # Ham Radio certification study
labquick "Projects" "Topic"  # Personal projects
```

## Commands Reference

```bash
labquick [TRACK] [TITLE]     # Create quick capture
labrefine                    # Interactive refinement wizard
labscreen [TRACK] [DATE]     # Organize screenshots
labprogress                  # View progress dashboard
```

## Troubleshooting

### Commands not found?

```bash
# Make sure ~/.local/bin is in your PATH
echo $PATH | grep .local/bin

# If not, add it:
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Git push fails?

```bash
# Test SSH connection
ssh -T git@github.com

# Should see: "Hi username! You've successfully authenticated..."

# If not, add your SSH key:
ssh-add ~/.ssh/id_ed25519

# Or reconfigure remote:
git remote set-url origin git@github.com:yourusername/homelab-docs.git
```

### XP not calculating?

```bash
# Check if hooks are installed
ls -la ~/homelab-docs/.git/hooks/post-commit

# If missing, reinstall:
cp ~/homelab-docs/git-hooks/* ~/homelab-docs/.git/hooks/
chmod +x ~/homelab-docs/.git/hooks/*
```

## Next Steps

1. Read the full [README.md](README.md) for detailed documentation
2. Explore the [templates](templates/) directory
3. Customize the system to your workflow
4. Start documenting and leveling up! 🚀

## Tips for Success

- **Document during labs, not after** - Even quick notes are valuable
- **Commit frequently** - Every commit earns XP
- **Refine weekly** - Set aside 30 minutes for polish
- **Use streaks** - The 7-day bonus is powerful motivation
- **Share your work** - Tutorials help others and showcase your skills

---

**Ready? Let's level up!** 🎮
