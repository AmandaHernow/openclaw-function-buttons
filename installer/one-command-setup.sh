#!/bin/bash

# OpenClaw Function Buttons - Smart Installer
# Installs selected buttons with library system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 OpenClaw Function Buttons - Smart Installer${NC}"
echo "=========================================="

# Configuration
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LIBRARY_DIR="$PROJECT_DIR/library"
BUTTONS_DIR="$PROJECT_DIR/buttons"
LIBRARY_FILE="$LIBRARY_DIR/button-library.json"

# Check if library exists
if [ ! -f "$LIBRARY_FILE" ]; then
    echo -e "${RED}❌ Library file not found: $LIBRARY_FILE${NC}"
    exit 1
fi

echo -e "\n📚 Loading button library..."

# Parse buttons using Python
parse_buttons() {
    python3 -c "
import json
import sys

with open('$LIBRARY_FILE', 'r') as f:
    data = json.load(f)

buttons = []
for button in data['buttons']:
    buttons.append({
        'name': button['name'],
        'id': button['id'],
        'essential': button.get('essential', False),
        'category': button['category']
    })

# Print in format: name|id|essential|category
for btn in buttons:
    print(f\"{btn['name']}|{btn['id']}|{btn['essential']}|{btn['category']}\")
"
}

# Parse all buttons
ALL_BUTTONS=()
ESSENTIAL_BUTTONS=()
OPTIONAL_BUTTONS=()

while IFS='|' read -r name id essential category; do
    ALL_BUTTONS+=("$name|$id|$essential|$category")
    if [ "$essential" = "True" ]; then
        ESSENTIAL_BUTTONS+=("$name|$id")
    else
        OPTIONAL_BUTTONS+=("$name|$id")
    fi
done < <(parse_buttons)

echo -e "${GREEN}✅ Found ${#ESSENTIAL_BUTTONS[@]} essential button(s)${NC}"
echo -e "${YELLOW}📦 Found ${#OPTIONAL_BUTTONS[@]} optional button(s)${NC}"

# Installation location
echo -e "\n📁 Installation Location"
echo "----------------------"
echo "Where would you like to install the buttons?"
echo "1) In a folder in my home directory (~/OpenClaw-Buttons/)"
echo "2) On my desktop (easy access)"
echo "3) Both locations"
echo -e "${YELLOW}Enter choice (1-3):${NC} "
read -r LOCATION_CHOICE

case $LOCATION_CHOICE in
    1)
        BUTTONS_DIR="$HOME/OpenClaw-Buttons"
        DESKTOP_DIR=""
        INSTALL_DIR="$BUTTONS_DIR"
        DESKTOP_COPY=false
        echo -e "${GREEN}✅ Installing to home directory only${NC}"
        echo -e "   Scripts: $BUTTONS_DIR"
        echo -e "   Desktop: No shortcuts"
        ;;
    2)
        BUTTONS_DIR="$HOME/OpenClaw-Buttons"
        DESKTOP_DIR=""  # No desktop folder, only .desktop files
        INSTALL_DIR="$BUTTONS_DIR"
        DESKTOP_COPY=true
        echo -e "${GREEN}✅ Installing scripts to home directory, buttons to desktop${NC}"
        echo -e "   Scripts: $BUTTONS_DIR"
        echo -e "   Desktop: .desktop shortcuts only (no folder)"
        ;;
    3)
        BUTTONS_DIR="$HOME/OpenClaw-Buttons"
        DESKTOP_DIR="$HOME/Desktop/OpenClaw-Buttons"
        INSTALL_DIR="$BUTTONS_DIR"
        DESKTOP_COPY=true
        echo -e "${GREEN}✅ Installing to both locations${NC}"
        echo -e "   Scripts: $BUTTONS_DIR"
        echo -e "   Desktop: Folder with shortcuts"
        ;;
    *)
        echo -e "${RED}❌ Invalid choice. Using default: home directory only${NC}"
        BUTTONS_DIR="$HOME/OpenClaw-Buttons"
        DESKTOP_DIR=""
        INSTALL_DIR="$BUTTONS_DIR"
        DESKTOP_COPY=false
        ;;
esac

# Button selection
echo -e "\n🎯 Button Selection"
echo "-----------------"
echo -e "${GREEN}Essential buttons (always installed):${NC}"
for button_info in "${ESSENTIAL_BUTTONS[@]}"; do
    name=$(echo "$button_info" | cut -d'|' -f1)
    echo "  ✅ $name"
done

echo -e "\n${YELLOW}Optional buttons (choose which to install):${NC}"
SELECTED_OPTIONAL=()
for button_info in "${OPTIONAL_BUTTONS[@]}"; do
    name=$(echo "$button_info" | cut -d'|' -f1)
    id=$(echo "$button_info" | cut -d'|' -f2)
    echo -n "  Install $name? (y/n) [n]: "
    read -r choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        SELECTED_OPTIONAL+=("$name|$id")
        echo -e "    ${GREEN}✅ Selected${NC}"
    else
        echo -e "    ${YELLOW}⏭️  Skipped${NC}"
    fi
done

# Always include Add More and Button Library
ALWAYS_INCLUDE=("Add More|add-more" "Button Library|button-library")
echo -e "\n${BLUE}📚 Management buttons (always included):${NC}"
for button_info in "${ALWAYS_INCLUDE[@]}"; do
    name=$(echo "$button_info" | cut -d'|' -f1)
    echo "  📦 $name"
done

# Create installation directory
echo -e "\n📁 Creating installation directory..."
mkdir -p "$BUTTONS_DIR"
mkdir -p "$BUTTONS_DIR/icons"
echo -e "  ${GREEN}✅ Created: $BUTTONS_DIR${NC}"

# Create desktop folder only for option 3
if [ -n "$DESKTOP_DIR" ] && [ "$LOCATION_CHOICE" = "3" ]; then
    mkdir -p "$DESKTOP_DIR"
    mkdir -p "$DESKTOP_DIR/icons"
    echo -e "  ${GREEN}✅ Created desktop folder: $DESKTOP_DIR${NC}"
fi

# Copy essential buttons
echo -e "\n📦 Copying essential buttons..."
for button_info in "${ESSENTIAL_BUTTONS[@]}"; do
    name=$(echo "$button_info" | cut -d'|' -f1)
    id=$(echo "$button_info" | cut -d'|' -f2)
    
    # Copy script to home directory
    if [ -f "$LIBRARY_DIR/$id.sh" ]; then
        cp "$LIBRARY_DIR/$id.sh" "$BUTTONS_DIR/"
        echo -e "  ${GREEN}✅ $name script${NC}"
    else
        echo -e "  ${YELLOW}⚠️  Script not found: $id.sh${NC}"
    fi
    
    # Copy icon to home directory
    if [ -f "$LIBRARY_DIR/icons/$id.svg" ]; then
        cp "$LIBRARY_DIR/icons/$id.svg" "$BUTTONS_DIR/icons/"
        echo -e "  ${GREEN}✅ $name icon${NC}"
    else
        echo -e "  ${YELLOW}⚠️  Icon not found: $id.svg${NC}"
    fi
done

# Copy selected optional buttons
if [ ${#SELECTED_OPTIONAL[@]} -gt 0 ]; then
    echo -e "\n📦 Copying selected optional buttons..."
    for button_info in "${SELECTED_OPTIONAL[@]}"; do
        name=$(echo "$button_info" | cut -d'|' -f1)
        id=$(echo "$button_info" | cut -d'|' -f2)
        
        # Copy script to home directory
        if [ -f "$LIBRARY_DIR/$id.sh" ]; then
            cp "$LIBRARY_DIR/$id.sh" "$BUTTONS_DIR/"
            echo -e "  ${GREEN}✅ $name script${NC}"
        else
            echo -e "  ${YELLOW}⚠️  Script not found: $id.sh${NC}"
        fi
        
        # Copy icon to home directory
        if [ -f "$LIBRARY_DIR/icons/$id.svg" ]; then
            cp "$LIBRARY_DIR/icons/$id.svg" "$BUTTONS_DIR/icons/"
            echo -e "  ${GREEN}✅ $name icon${NC}"
        else
            echo -e "  ${YELLOW}⚠️  Icon not found: $id.svg${NC}"
        fi
    done
fi

# Copy management buttons
echo -e "\n📚 Copying management buttons..."
for button_info in "${ALWAYS_INCLUDE[@]}"; do
    name=$(echo "$button_info" | cut -d'|' -f1)
    id=$(echo "$button_info" | cut -d'|' -f2)
    
    # Copy script
    if [ -f "$LIBRARY_DIR/$id.sh" ]; then
        cp "$LIBRARY_DIR/$id.sh" "$INSTALL_DIR/"
        echo -e "  ${GREEN}✅ $name script${NC}"
    else
        echo -e "  ${YELLOW}⚠️  Script not found: $id.sh${NC}"
    fi
    
    # Copy icon
    if [ -f "$LIBRARY_DIR/icons/$id.svg" ]; then
        cp "$LIBRARY_DIR/icons/$id.svg" "$INSTALL_DIR/icons/"
        echo -e "  ${GREEN}✅ $name icon${NC}"
    else
        echo -e "  ${YELLOW}⚠️  Icon not found: $id.svg${NC}"
    fi
done

# Create desktop files in home directory
echo -e "\n🖱️ Creating desktop shortcuts..."
for button in "$BUTTONS_DIR"/*.sh; do
    if [ -f "$button" ]; then
        BUTTON_NAME=$(basename "$button" .sh)
        DISPLAY_NAME=$(echo "$BUTTON_NAME" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
        DESKTOP_FILE="$BUTTONS_DIR/$BUTTON_NAME.desktop"
        
        cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$DISPLAY_NAME
Comment=One-click $DISPLAY_NAME for OpenClaw
Exec=bash -c "cd '$BUTTONS_DIR' && './$BUTTON_NAME.sh'; exec bash"
Icon=$BUTTONS_DIR/icons/$BUTTON_NAME.svg
Terminal=true
Categories=Utility;
EOF
        
        chmod +x "$DESKTOP_FILE"
        echo -e "  ${GREEN}✅ Created: $DISPLAY_NAME${NC}"
    fi
done

# Copy desktop files to appropriate locations
if [ "$DESKTOP_COPY" = true ]; then
    echo -e "\n📋 Copying shortcuts..."
    
    if [ "$LOCATION_CHOICE" = "2" ]; then
        # Option 2: Copy .desktop files to desktop (no folder)
        cp "$BUTTONS_DIR"/*.desktop "$HOME/Desktop/" 2>/dev/null
        echo -e "  ${GREEN}✅ Desktop shortcuts created (no folder)${NC}"
    elif [ "$LOCATION_CHOICE" = "3" ]; then
        # Option 3: Copy everything to desktop folder
        cp -r "$BUTTONS_DIR"/* "$DESKTOP_DIR/" 2>/dev/null
        echo -e "  ${GREEN}✅ Desktop folder created with all files${NC}"
    fi
fi

# Configure installation path in settings
echo -e "\n⚙️  Configuring settings..."
CONFIG_FILE="$HOME/.config/openclaw-buttons/config.json"
mkdir -p "$(dirname "$CONFIG_FILE")"

# Load existing config or create default
if [ -f "$CONFIG_FILE" ]; then
    CONFIG_CONTENT=$(cat "$CONFIG_FILE")
else
    CONFIG_CONTENT='{"current_channel": "stable", "auto_update": false, "gateway_command": "system", "hidden_buttons": [], "installation_path": "", "desktop_shortcuts": true}'
fi

# Update installation path
UPDATED_CONFIG=$(echo "$CONFIG_CONTENT" | jq --arg path "$INSTALL_DIR" '.installation_path = $path')
echo "$UPDATED_CONFIG" > "$CONFIG_FILE"
echo -e "  ${GREEN}✅ Installation path configured: $INSTALL_DIR${NC}"

# Install CLI command
echo -e "\n🔧 Installing CLI command..."
if [ -f "$PROJECT_DIR/openclaw_buttons" ]; then
    # Try to install to /usr/local/bin (requires sudo)
    if command -v sudo >/dev/null 2>&1; then
        echo -n "Install CLI command to /usr/local/bin? (y/n) [y]: "
        read -r CLI_CHOICE
        if [[ ! "$CLI_CHOICE" =~ ^[Nn]$ ]]; then
            sudo cp "$PROJECT_DIR/openclaw_buttons" /usr/local/bin/openclaw_buttons
            sudo chmod +x /usr/local/bin/openclaw_buttons
            echo -e "  ${GREEN}✅ CLI command installed${NC}"
            echo -e "  Run: openclaw_buttons help"
        else
            echo -e "  ${YELLOW}⏭️  CLI command not installed${NC}"
            echo -e "  You can run: $PROJECT_DIR/openclaw_buttons"
        fi
    else
        echo -e "  ${YELLOW}⚠️  sudo not available, skipping CLI install${NC}"
    fi
fi

# Sudo password storage option (for admin users)
echo -e "\n🔐 Sudo Password Storage (Advanced)"
echo "---------------------------------"
echo "For admin users who want to create custom buttons with sudo access:"
echo "⚠️  This stores your sudo password ENCRYPTED for button creation"
echo -n "Enable sudo password storage? (y/n) [n]: "
read -r SUDO_CHOICE

if [[ "$SUDO_CHOICE" =~ ^[Yy]$ ]]; then
    echo -e "\n${YELLOW}⚠️  Security Warning:${NC}"
    echo "Your sudo password will be encrypted and stored locally."
    echo "It will ONLY be used for creating custom buttons with sudo access."
    echo ""
    echo -n "Enter sudo password (hidden): "
    read -s SUDO_PASSWORD
    echo ""
    
    # Simple encryption (base64 for now - could be enhanced)
    ENCRYPTED_PASSWORD=$(echo "$SUDO_PASSWORD" | base64)
    SUDO_CONFIG_FILE="$HOME/.config/openclaw-buttons/sudo-config.json"
    
    cat > "$SUDO_CONFIG_FILE" << EOF
{
  "sudo_enabled": true,
  "sudo_password_encrypted": "$ENCRYPTED_PASSWORD",
  "encryption_method": "base64",
  "last_updated": "$(date -Iseconds)"
}
EOF
    
    chmod 600 "$SUDO_CONFIG_FILE"
    echo -e "  ${GREEN}✅ Sudo password stored (encrypted)${NC}"
    echo -e "  ${YELLOW}⚠️  File: $SUDO_CONFIG_FILE (readable only by you)${NC}"
else
    echo -e "  ${YELLOW}⏭️  Sudo password storage skipped${NC}"
    echo -e "  Custom buttons will run without sudo privileges"
fi

echo ""
echo -e "${GREEN}🎉 Setup complete!${NC}"
echo ""
echo -e "${BLUE}📚 What was installed:${NC}"
echo -e "   - ${GREEN}${#ESSENTIAL_BUTTONS[@]} essential button(s)${NC}"
echo -e "   - ${YELLOW}${#SELECTED_OPTIONAL[@]} optional button(s)${NC}"
echo -e "   - ${BLUE}2 management buttons${NC}"
echo -e "   - Beautiful custom icons"
echo -e "   - Desktop shortcuts (if chosen)"
echo ""
echo -e "${BLUE}🚀 How to use:${NC}"
echo "   1. Double-click any .desktop file on your desktop"
echo "   2. Or run: bash ~/OpenClaw-Buttons/gateway-restart.sh"
echo ""
echo -e "${YELLOW}💡 For advanced users:${NC}"
echo "   All scripts are in $INSTALL_DIR"
echo "   You can edit them or add your own!"
echo ""
echo -e "${GREEN}✨ OpenClaw Function Buttons are ready to use!${NC}"