# Screenshots Directory

This directory contains all screenshots organized by track and date.

## Purpose

Screenshots provide visual context for your documentation:
- Show configuration screens
- Capture error messages
- Display command output
- Illustrate network topologies
- Document before/after states

## Structure

```
screenshots/
├── [track]/              # CCNA, CCIE, AWS, hamradio, projects
│   └── [YYYY-MM-DD]/    # Date of lab session
│       ├── screenshot-01.png
│       ├── screenshot-02.png
│       └── screenshot-index.md  # Auto-generated index
└── thumbnails/          # Generated thumbnails (future feature)
```

## Taking Screenshots

### Recommended Tool: Flameshot (Linux)

Install:
```bash
sudo pacman -S flameshot  # CachyOS/Arch
sudo apt install flameshot # Ubuntu/Debian
```

Features:
- Draw arrows and boxes
- Add text annotations
- Blur sensitive information
- Quick copy to clipboard
- Save to file

**Set keyboard shortcut** (usually Print Screen) to launch Flameshot.

### Default Save Location

Flameshot saves to `~/Pictures` by default.

## Organizing Screenshots

After a lab session:

```bash
labscreen "CCNA" "2025-10-24"
```

This will:
1. Move all `.png` files from `~/Pictures` to `screenshots/ccna/2025-10-24/`
2. Generate `screenshot-index.md` with image links
3. Award +5 XP per screenshot (max +50 XP per session)

## Screenshot Best Practices

### 1. Capture As You Go

Don't wait until the end of the lab - capture screenshots immediately when you:
- Configure something important
- Encounter an error
- See interesting output
- Complete a milestone

### 2. Annotate Immediately

Use Flameshot's annotation tools:
- **Arrows** - Point to important parts
- **Boxes** - Highlight sections
- **Text** - Add labels or notes
- **Blur** - Hide sensitive info (IPs, passwords, hostnames)

### 3. Use Descriptive Filenames

When saving, give screenshots meaningful names:
- ❌ `screenshot_2025-10-24_14-30-45.png`
- ✅ `ospf-neighbor-adjacency.png`
- ✅ `routing-table-after-config.png`
- ✅ `error-message-authentication-failure.png`

### 4. Organize Daily

Run `labscreen` after each lab session - don't let screenshots accumulate!

## Embedding in Documents

### In Quick Captures

Reference screenshots with relative paths:

```markdown
![OSPF Configuration](../../screenshots/ccna/2025-10-24/ospf-config.png)
```

### In Refined Documents

Same relative path from `refined/[type]/` directory:

```markdown
![Routing Table](../../screenshots/ccna/2025-10-24/routing-table.png)
*Figure 1: Routing table after OSPF configuration*
```

## Screenshot Security

### Never Capture

- Passwords or API keys
- Internal IP addresses (if public-facing docs)
- Hostnames that reveal company info
- Personal identifiable information (PII)

### Always Blur

Use Flameshot's blur tool on:
- IP addresses (unless example IPs)
- Hostnames
- Email addresses
- Any sensitive configuration

## XP Values

- **Taking screenshot**: +5 XP each
- **Maximum per session**: +50 XP (10 screenshots)
- **Automatic**: Awarded when you commit organized screenshots

## Tips

1. **One screenshot per concept** - Don't try to show everything in one image
2. **Show before/after** - Capture state before and after changes
3. **Include error messages** - Screenshots of errors help troubleshooting
4. **Use consistent naming** - Makes finding screenshots easier later
5. **Organize immediately** - Don't let `~/Pictures` get cluttered

## Screenshot Index

The `screenshot-index.md` file is auto-generated:

```markdown
# Screenshots - CCNA - 2025-10-24

Total: 8 images

- ![ospf-config.png](ospf-config.png)
- ![neighbor-adjacency.png](neighbor-adjacency.png)
- ![routing-table.png](routing-table.png)
...
```

This makes it easy to browse screenshots and copy image links.

---

**Remember**: Good screenshots make your documentation 10x more valuable!
