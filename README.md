# OpenClaw Function Buttons

![Banner](banner.svg)

**One-click desktop buttons for OpenClaw - making AI assistance accessible to everyone**

## 🚀 Quick Start

### Installation (One Command!)

```bash
# Clone and install with one command
git clone https://github.com/AmandaHernow/openclaw-function-buttons.git
cd openclaw-function-buttons
./installer/one-command-setup.sh
```

The smart installer will guide you through:
1. **Installation location** - Choose where buttons are installed
2. **Button selection** - Pick which optional buttons to install
3. **Automatic setup** - Everything configured automatically

### Uninstallation

```bash
# Run the uninstaller
cd openclaw-function-buttons
./installer/uninstall.sh
```

## 📋 What You Get

### 🎯 Essential Buttons (Always Installed)
- **Gateway Restart** - Fix connection issues instantly
- **Save Context** - Save conversations to prevent memory loss
- **Add More** - Add new buttons from the library (plus sign icon)
- **Button Library** - Browse and manage available buttons

### 📦 Optional Buttons (Choose During Installation)
- **Memory Backup** - Create full backups of all memory files
- **System Status** - Check OpenClaw health and system status
- **Quick Chat** - Open webchat interface instantly
- **Cron Manager** - Manage and monitor scheduled tasks

## 🎯 Smart Features

### 🔧 Button Library System
- **Selective installation** - Choose only the buttons you need
- **Easy expansion** - Add more buttons anytime with "Add More"
- **Category organization** - Buttons grouped by function
- **Essential vs Optional** - Core functionality always available

### 📁 Flexible Installation
Choose where buttons are installed:
1. **Home directory** (`~/OpenClaw-Buttons/`) - Organized and out of sight
2. **Desktop** - Easy one-click access
3. **Both locations** - Best of both worlds

### 🖱️ One-Click Operation
1. **Double-click desktop button**
2. **Action executes automatically**
3. **Results shown in terminal**
4. **Close when done**

No commands to remember, no configuration needed.

## 🛠️ For Advanced Users

### Manual Button Management
```bash
# Run installer again to add more buttons
cd openclaw-function-buttons
./installer/one-command-setup.sh

# Check available buttons
./library/button-library.sh
```

### Creating Custom Buttons
1. Create script in `library/` directory
2. Design icon in `library/icons/`
3. Add entry to `library/button-library.json`
4. Run installer to add to your system

### Library Structure
```
library/
├── button-library.json      # Button catalog and metadata
├── *.sh                     # Button scripts
├── icons/*.svg             # Button icons
└── button-library.sh       # Library browser
```

## 📁 Project Structure

```
openclaw-function-buttons/
├── library/                    # Button library system
│   ├── button-library.json    # Button catalog
│   ├── *.sh                   # All button scripts
│   ├── icons/*.svg           # All button icons
│   └── button-library.sh     # Library browser
├── installer/                 # Installation system
│   ├── one-command-setup.sh  # Smart installer
│   └── uninstall.sh          # Complete removal
├── docs/                     # Documentation
│   └── PROJECT_PLAN.md       # Development roadmap
├── logo.svg                  # Project logo
├── banner.svg                # Project banner
└── README.md                 # This file
```

## 🚀 Planned Features

### Coming Soon
- **Button Template Creator** - Create custom buttons easily
- **One-Click Updates** - Update all buttons at once
- **Theme Support** - Different visual styles
- **More Button Types** - Expanded functionality

### Current Development Focus
- **Stability** - Reliable one-click operation
- **Simplicity** - Easy to understand and use
- **Expandability** - Easy to add new buttons
- **User Experience** - Intuitive and helpful

## 🤝 Contributing

Want to add more buttons? Here's how:

1. **Fork the repository**
2. **Create new button script** in `library/`
3. **Design icon** in `library/icons/`
4. **Add entry** to `library/button-library.json`
5. **Test with installer**
6. **Submit pull request**

Check `docs/PROJECT_PLAN.md` for planned features and ideas.

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## ⚠️ Requirements

- **OpenClaw** installed and configured
- **Linux desktop** with .desktop file support
- **Bash shell** available
- **Python 3** (for JSON parsing in installer)
- **Systemd** for service management

## 🔗 Links

- **OpenClaw Documentation**: https://docs.openclaw.ai
- **OpenClaw Community**: https://discord.com/invite/clawd
- **Report Issues**: GitHub Issues
- **Live Demo**: Try the installer!

---

**Made with ❤️ for the OpenClaw community**

*"Systems break. Memories are forever."*

*Simplify your OpenClaw workflow with smart one-click buttons*
