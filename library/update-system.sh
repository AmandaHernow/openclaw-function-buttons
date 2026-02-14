#!/bin/bash
# OpenClaw Function Buttons: Update System
# Checks for updates and manages channels

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 OpenClaw Function Buttons Update System${NC}"
echo "=========================================="

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHANNELS_FILE="$PROJECT_DIR/channels.json"
CONFIG_FILE="$HOME/.config/openclaw-buttons/config.json"

# Load configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        CURRENT_CHANNEL=$(jq -r '.current_channel // "stable"' "$CONFIG_FILE")
        AUTO_UPDATE=$(jq -r '.auto_update // false' "$CONFIG_FILE")
    else
        CURRENT_CHANNEL="stable"
        AUTO_UPDATE=false
        mkdir -p "$(dirname "$CONFIG_FILE")"
        echo '{"current_channel": "stable", "auto_update": false}' > "$CONFIG_FILE"
    fi
}

# Get channel info
get_channel_info() {
    local channel="$1"
    jq -r --arg channel "$channel" '.channels[$channel] | "\(.name)|\(.description)|\(.update_url)|\(.recommended)"' "$CHANNELS_FILE"
}

# Check for updates
check_updates() {
    echo -e "\n🔍 Checking for updates..."
    
    load_config
    
    # Get current version
    if [ -f "$PROJECT_DIR/VERSION" ]; then
        CURRENT_VERSION=$(cat "$PROJECT_DIR/VERSION")
        echo -e "   Current version: ${GREEN}$CURRENT_VERSION${NC}"
    else
        echo -e "   ${YELLOW}⚠️  No version file found${NC}"
        CURRENT_VERSION="unknown"
    fi
    
    # Get channel info
    IFS='|' read -r CHANNEL_NAME CHANNEL_DESC UPDATE_URL IS_RECOMMENDED <<< "$(get_channel_info "$CURRENT_CHANNEL")"
    
    echo -e "   Channel: ${BLUE}$CHANNEL_NAME${NC} ($CURRENT_CHANNEL)"
    echo -e "   $CHANNEL_DESC"
    
    # Try to fetch latest version from GitHub
    echo -e "\n🌐 Checking GitHub for updates..."
    
    # Get latest release from GitHub API
    LATEST_VERSION=$(curl -s "https://api.github.com/repos/AmandaHernow/openclaw-function-buttons/releases/latest" | jq -r '.tag_name // .name' 2>/dev/null)
    
    if [ -n "$LATEST_VERSION" ] && [ "$LATEST_VERSION" != "null" ]; then
        echo -e "   Latest available: ${GREEN}$LATEST_VERSION${NC}"
        
        if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
            echo -e "\n${GREEN}🎉 Update available!${NC}"
            echo -e "   You can update to $LATEST_VERSION"
            return 0  # Update available
        else
            echo -e "\n${GREEN}✅ You're up to date!${NC}"
            return 1  # No update
        fi
    else
        echo -e "   ${YELLOW}⚠️  Could not check for updates${NC}"
        echo -e "   Check your internet connection"
        return 2  # Error
    fi
}

# Update the system
update_system() {
    echo -e "\n🚀 Starting update..."
    
    load_config
    
    # Get channel info
    IFS='|' read -r CHANNEL_NAME CHANNEL_DESC UPDATE_URL IS_RECOMMENDED <<< "$(get_channel_info "$CURRENT_CHANNEL")"
    
    echo -e "Updating from channel: ${BLUE}$CHANNEL_NAME${NC}"
    
    # Backup current installation
    echo -e "\n📦 Creating backup..."
    BACKUP_DIR="/tmp/openclaw-buttons-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp -r "$PROJECT_DIR/library" "$BACKUP_DIR/" 2>/dev/null || true
    cp -r "$PROJECT_DIR/installer" "$BACKUP_DIR/" 2>/dev/null || true
    echo -e "   Backup created: $BACKUP_DIR"
    
    # Update logic would go here
    # For now, just show what would happen
    echo -e "\n${YELLOW}⚠️  Update simulation${NC}"
    echo -e "   In a real update, this would:"
    echo -e "   1. Download latest files from GitHub"
    echo -e "   2. Replace library and installer files"
    echo -e "   3. Preserve user configuration"
    echo -e "   4. Restart any running processes"
    
    echo -e "\n${GREEN}✅ Update simulation complete${NC}"
    echo -e "   Real updates will be implemented soon!"
}

# Change channel
change_channel() {
    echo -e "\n📡 Channel Selection"
    echo "-----------------"
    
    echo "Available channels:"
    echo "1) Stable - Tested, reliable releases"
    echo "2) Beta - New features, some testing"
    echo "3) Dev - Latest changes, may be unstable"
    echo -e "${YELLOW}Enter choice (1-3):${NC} "
    read -r CHANNEL_CHOICE
    
    case $CHANNEL_CHOICE in
        1) NEW_CHANNEL="stable" ;;
        2) NEW_CHANNEL="beta" ;;
        3) NEW_CHANNEL="dev" ;;
        *)
            echo -e "${RED}❌ Invalid choice${NC}"
            return 1
            ;;
    esac
    
    # Update config
    load_config
    jq --arg channel "$NEW_CHANNEL" '.current_channel = $channel' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    
    IFS='|' read -r CHANNEL_NAME CHANNEL_DESC UPDATE_URL IS_RECOMMENDED <<< "$(get_channel_info "$NEW_CHANNEL")"
    
    echo -e "\n${GREEN}✅ Channel changed to: $CHANNEL_NAME${NC}"
    echo -e "   $CHANNEL_DESC"
    
    if [ "$IS_RECOMMENDED" = "false" ]; then
        echo -e "${YELLOW}⚠️  Note: This channel is not recommended for production use${NC}"
    fi
}

# Main menu
main_menu() {
    while true; do
        echo -e "\n${BLUE}📱 Update System Menu${NC}"
        echo "-----------------"
        echo "1) Check for updates"
        echo "2) Install updates"
        echo "3) Change channel"
        echo "4) View current settings"
        echo "5) Exit"
        echo -e "${YELLOW}Enter choice (1-5):${NC} "
        read -r CHOICE
        
        case $CHOICE in
            1)
                check_updates
                ;;
            2)
                update_system
                ;;
            3)
                change_channel
                ;;
            4)
                load_config
                IFS='|' read -r CHANNEL_NAME CHANNEL_DESC UPDATE_URL IS_RECOMMENDED <<< "$(get_channel_info "$CURRENT_CHANNEL")"
                echo -e "\n${BLUE}📊 Current Settings${NC}"
                echo "----------------"
                echo -e "Channel: ${GREEN}$CHANNEL_NAME${NC} ($CURRENT_CHANNEL)"
                echo -e "Description: $CHANNEL_DESC"
                echo -e "Auto-update: $AUTO_UPDATE"
                if [ -f "$PROJECT_DIR/VERSION" ]; then
                    echo -e "Version: $(cat "$PROJECT_DIR/VERSION")"
                fi
                ;;
            5)
                echo -e "\n${GREEN}👋 Exiting update system${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice${NC}"
                ;;
        esac
        
        echo -e "\n${YELLOW}Press Enter to continue...${NC}"
        read -r
    done
}

# Command line arguments
if [ $# -eq 0 ]; then
    main_menu
else
    case $1 in
        "check")
            check_updates
            ;;
        "update")
            update_system
            ;;
        "channel")
            if [ $# -eq 2 ]; then
                # Quick channel change
                load_config
                if jq -e ".channels[\"$2\"]" "$CHANNELS_FILE" >/dev/null 2>&1; then
                    jq --arg channel "$2" '.current_channel = $channel' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
                    echo -e "${GREEN}✅ Channel changed to: $2${NC}"
                else
                    echo -e "${RED}❌ Invalid channel: $2${NC}"
                    echo "Valid channels: stable, beta, dev"
                fi
            else
                change_channel
            fi
            ;;
        "settings")
            load_config
            IFS='|' read -r CHANNEL_NAME CHANNEL_DESC UPDATE_URL IS_RECOMMENDED <<< "$(get_channel_info "$CURRENT_CHANNEL")"
            echo -e "Channel: $CHANNEL_NAME ($CURRENT_CHANNEL)"
            echo -e "Auto-update: $AUTO_UPDATE"
            ;;
        *)
            echo "Usage: $0 [command]"
            echo "Commands:"
            echo "  check      - Check for updates"
            echo "  update     - Install updates"
            echo "  channel    - Change channel (interactive)"
            echo "  channel <name> - Quick channel change"
            echo "  settings   - Show current settings"
            echo ""
            echo "Without arguments: Interactive menu"
            exit 1
            ;;
    esac
fi

# Keep terminal open
sleep 3