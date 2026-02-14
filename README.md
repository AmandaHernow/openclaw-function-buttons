# OpenClaw Function Buttons

![Banner](banner.svg)

**Professional one-click desktop buttons for OpenClaw - Enterprise-grade automation**

## 🚀 Quick Start

### Installation (One Command!)

```bash
# Clone and install with one command
git clone https://github.com/AmandaHernow/openclaw-function-buttons.git
cd openclaw-function-buttons
./installer/one-command-setup.sh
```

The professional installer will guide you through:
1. **Installation location** - Home directory, Desktop, or both
2. **Button selection** - Choose which optional buttons to install
3. **CLI installation** - Optional command-line interface
4. **Automatic configuration** - Everything set up automatically

### Command Line Interface

```bash
# After installation, use the CLI
openclaw_buttons update      # Check for updates
openclaw_buttons install     # Run installer again
openclaw_buttons settings    # Open Settings Manager
openclaw_buttons help        # Show help
```

## 📋 Professional Features

### 🎯 Channel System (Stable/Beta/Dev)
- **Stable Channel** - Tested, reliable releases for production
- **Beta Channel** - New features with testing, for adventurous users  
- **Dev Channel** - Latest changes, may be unstable, for developers
- **Easy switching** - Change channels anytime via Settings

### 🔧 Enterprise Configuration
- **Gateway Command Configuration** - Choose system vs user gateway
- **Button Visibility Management** - Show/hide buttons as needed
- **Installation Management** - View, change, or uninstall locations
- **Desktop Shortcuts Toggle** - Enable/disable desktop integration

### 🚀 Update System
- **Automatic update checks** - Stay current with latest features
- **One-click updates** - Update all buttons with single click
- **Channel-aware updates** - Get updates appropriate for your channel
- **Backup before update** - Automatic backups prevent data loss

### 📁 Professional Structure
```
openclaw-function-buttons/
├── library/                    # Complete button library
│   ├── button-library.json    # Button catalog with metadata
│   ├── *.sh                   # All button scripts
│   ├── icons/*.svg           # Professional SVG icons
│   └── button-library.sh     # Library browser
├── installer/                 # Professional installer
│   ├── one-command-setup.sh  # Smart interactive installer
│   └── uninstall.sh          # Complete removal
├── channels.json             # Channel configuration
├── openclaw_buttons          # CLI interface
├── VERSION                   # Version tracking
└── README.md                 # This documentation
```

## 🎯 Available Buttons

### Essential Buttons (Always Installed)
- **Gateway Restart** - Fix connection issues (configurable command)
- **Save Context** - Save conversations to prevent memory loss
- **Add More** - Add new buttons from library (plus icon)
- **Button Library** - Browse and manage available buttons

### Optional Buttons (Select During Installation)
- **Memory Backup** - Create full backups of all memory files
- **System Status** - Check OpenClaw health and system status
- **Quick Chat** - Open webchat interface instantly
- **Cron Manager** - Manage and monitor scheduled tasks
- **Update System** - Check for updates and manage channels
- **Settings Manager** - Configure all system settings

## ⚙️ Settings & Configuration

### Gateway Command Configuration
Choose how gateway restart works:
- **System Service** (Recommended) - `sudo systemctl restart openclaw-gateway-system`
- **User Command** - `openclaw gateway restart`
- **Custom Command** - Define your own restart command

### Button Visibility Management
- Show/hide individual buttons
- Warning when hiding management buttons
- Easy restoration of hidden buttons
- Terminal access always available

### Installation Management
- View current installation contents
- Change installation location
- Complete uninstallation
- Multiple installation support

## 🔄 Update System

### Automatic Updates
```bash
# Check for updates
openclaw_buttons update

# Or use the Update System button
# (Opens interactive update interface)
```

### Channel Management
```bash
# Change channel via CLI
openclaw_buttons settings

# Or edit ~/.config/openclaw-buttons/config.json
{
  "current_channel": "stable",
  "auto_update": false
}
```

## 🛠️ For System Administrators

### Deployment Options
1. **Standard Deployment** - Interactive installer for end users
2. **Silent Deployment** - Scripted installation for multiple systems
3. **Custom Configuration** - Pre-configured settings files
4. **Enterprise Integration** - Integrate with existing management systems

### Security Features
- **Configurable gateway commands** - Follow organizational policies
- **Controlled updates** - Channel-based update management
- **Backup system** - Automatic backups before updates
- **Permission management** - Proper sudo integration

### Monitoring & Maintenance
- **System status monitoring** - Built-in health checks
- **Update notifications** - Stay informed of available updates
- **Configuration backup** - Settings preserved during updates
- **Logging** - Operation logs for troubleshooting

## 📊 Version Information

**Program Name:** OpenClaw Function Buttons  
**Developed by:** Amanda Hernow & Cleo Nightshade  
**Version:** Beta 1.1 (Channel: Beta)  
**Last Updated:** 2026-02-14  
**Purpose:** Professional one-click desktop automation for OpenClaw  
**License:** MIT License

### Installation Instructions
```bash
git clone https://github.com/AmandaHernow/openclaw-function-buttons.git
cd openclaw-function-buttons
./installer/one-command-setup.sh
```

### Uninstall Instructions
```bash
cd openclaw-function-buttons
./installer/uninstall.sh
# or
openclaw_buttons uninstall
```

## 🧪 Testing & Quality Assurance

### Tested Configurations
- ✅ Kali Linux (Nightshade production environment)
- ✅ Systemd service integration
- ✅ Multiple installation locations
- ✅ Update system functionality
- ✅ Configuration persistence

### Safety Features
- **Gateway restart testing** - Uses correct system command by default
- **Backup before updates** - Prevents data loss
- **Error handling** - Comprehensive error messages
- **User confirmation** - Critical actions require confirmation

## 🤝 Contributing

### Development Workflow
1. **Fork repository** - Create your own copy
2. **Create feature branch** - `git checkout -b feature/new-button`
3. **Add to library** - Script + icon + metadata
4. **Test thoroughly** - Use test suite
5. **Submit pull request** - To appropriate channel

### Code Standards
- **Bash scripts** - Use `set -e` for error handling
- **JSON configuration** - Proper formatting and validation
- **SVG icons** - Consistent style and sizing
- **Documentation** - Keep README updated

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## ⚠️ System Requirements

- **OpenClaw** installed and configured
- **Linux desktop** with .desktop file support
- **Bash shell** available
- **Python 3** (for JSON parsing)
- **jq** (for JSON processing)
- **Systemd** (for service management)
- **curl** (for update checks)

## 🔗 Links & Resources

- **OpenClaw Documentation**: https://docs.openclaw.ai
- **OpenClaw Community**: https://discord.com/invite/clawd
- **GitHub Repository**: https://github.com/AmandaHernow/openclaw-function-buttons
- **Issue Tracker**: GitHub Issues
- **Release Channels**: Stable, Beta, Dev

---

**Professional automation for OpenClaw**

*"Systems break. Memories are forever. Automation is key."*

*Enterprise-grade one-click buttons for reliable AI assistance*
