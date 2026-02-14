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
LIBRARY_DIR="$(dirname "$0")/../library"
BUTTONS_DIR="$(dirname "$0")/../buttons"
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
        DESKTOP_DIR="$HOME/Desktop/OpenClaw-Buttons"
        INSTALL_DIR="$BUTTONS_DIR"
        echo -e "${GREEN}✅ Installing to: $BUTTONS_DIR${NC}"
        ;;
    2)
        BUTTONS_DIR="$HOME/OpenClaw-Buttons"
        DESKTOP_DIR="$HOME/Desktop/OpenClaw-Buttons"
        INSTALL_DIR="$DESKTOP_DIR"
        echo -e "${GREEN}✅ Installing to desktop: $DESKTOP_DIR${NC}"
        ;;
    3)
        BUTTONS_DIR="$HOME/OpenClaw-Buttons"
        DESKTOP_DIR="$HOME/Desktop/OpenClaw-Buttons"
        INSTALL_DIR="$BUTTONS_DIR"
        echo -e "${GREEN}✅ Installing to both locations${NC}"
        ;;
    *)
        echo -e "${RED}❌ Invalid choice. Using default: home directory${NC}"
        BUTTONS_DIR="$HOME/OpenClaw-Buttons"
        DESKTOP_DIR="$HOME/Desktop/OpenClaw-Buttons"
        INSTALL_DIR="$BUTTONS_DIR"
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
mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/icons"

# Copy essential buttons
echo -e "\n📦 Copying essential buttons..."
for button_info in "${ESSENTIAL_BUTTONS[@]}"; do
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

# Copy selected optional buttons
if [ ${#SELECTED_OPTIONAL[@]} -gt 0 ]; then
    echo -e "\n📦 Copying selected optional buttons..."
    for button_info in "${SELECTED_OPTIONAL[@]}"; do
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

# Create desktop files
echo -e "\n🖱️ Creating desktop shortcuts..."
for button in "$INSTALL_DIR"/*.sh; do
    if [ -f "$button" ]; then
        BUTTON_NAME=$(basename "$button" .sh)
        DISPLAY_NAME=$(echo "$BUTTON_NAME" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/g')
        DESKTOP_FILE="$INSTALL_DIR/$BUTTON_NAME.desktop"
        
        cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=OpenClaw: $DISPLAY_NAME
Comment=One-click $DISPLAY_NAME for OpenClaw
Exec=bash -c "cd '$INSTALL_DIR' && './$BUTTON_NAME.sh'; exec bash"
Icon=$INSTALL_DIR/icons/$BUTTON_NAME.svg
Terminal=true
Categories=Utility;
EOF
        
        chmod +x "$DESKTOP_FILE"
        echo -e "  ${GREEN}✅ Created: $DISPLAY_NAME${NC}"
    fi
done

# If user chose desktop location, copy .desktop files to actual desktop
if [ "$LOCATION_CHOICE" = "2" ] || [ "$LOCATION_CHOICE" = "3" ]; then
    echo -e "\n📋 Copying shortcuts to desktop..."
    cp "$INSTALL_DIR"/*.desktop "$HOME/Desktop/" 2>/dev/null
    echo -e "${GREEN}✅ Desktop shortcuts created${NC}"
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