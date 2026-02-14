#!/bin/bash

# OpenClaw Function Buttons - Uninstaller
# Removes desktop buttons and installation files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🗑️  OpenClaw Function Buttons - Uninstaller${NC}"
echo "=========================================="

# Possible installation directories (in order of priority)
POSSIBLE_INSTALL_DIRS=(
    "$HOME/Desktop/OpenClaw-Buttons"      # Desktop installation
    "$HOME/OpenClaw-Buttons"              # Home directory installation
    "$HOME/.local/share/openclaw-buttons" # Legacy location
)

# Desktop files to remove (from user's Desktop)
DESKTOP_FILES=(
    "gateway-restart.desktop"
    "save-context.desktop"
    "OpenClaw-Emergency-Restart.desktop"   # Legacy emergency buttons
    "OpenClaw-Emergency-Shutdown.desktop"  # Legacy emergency buttons
)

echo -e "\n📋 Checking installation..."

# Find actual installation directory
INSTALL_DIR=""
for dir in "${POSSIBLE_INSTALL_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        INSTALL_DIR="$dir"
        echo -e "${GREEN}✅ Found installation directory: $INSTALL_DIR${NC}"
        break
    fi
done

if [ -z "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠️  No installation directory found${NC}"
    echo -e "${YELLOW}   The buttons may have been installed elsewhere or already removed.${NC}"
fi

# Remove desktop files from user's Desktop
echo -e "\n🗑️  Removing desktop buttons..."
REMOVED_COUNT=0
DESKTOP_PATH="$HOME/Desktop"

for file in "${DESKTOP_FILES[@]}"; do
    if [ -f "$DESKTOP_PATH/$file" ]; then
        rm -f "$DESKTOP_PATH/$file"
        echo -e "${GREEN}✅ Removed: $file${NC}"
        REMOVED_COUNT=$((REMOVED_COUNT + 1))
    else
        echo -e "${YELLOW}⚠️  Not found: $file${NC}"
    fi
done

# Remove installation directory
if [ -n "$INSTALL_DIR" ] && [ -d "$INSTALL_DIR" ]; then
    echo -e "\n🗑️  Removing installation files..."
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}✅ Removed installation directory: $INSTALL_DIR${NC}"
fi

# Update desktop database (for system-wide .desktop files)
echo -e "\n🔄 Updating desktop database..."
SYSTEM_DESKTOP_DIR="$HOME/.local/share/applications"
if command -v update-desktop-database >/dev/null 2>&1; then
    if [ -d "$SYSTEM_DESKTOP_DIR" ]; then
        # Remove any system .desktop files that might have been created
        for file in "${DESKTOP_FILES[@]}"; do
            if [ -f "$SYSTEM_DESKTOP_DIR/$file" ]; then
                rm -f "$SYSTEM_DESKTOP_DIR/$file"
                echo -e "${GREEN}✅ Removed system desktop file: $file${NC}"
            fi
        done
        update-desktop-database "$SYSTEM_DESKTOP_DIR"
        echo -e "${GREEN}✅ Updated desktop database${NC}"
    else
        echo -e "${YELLOW}⚠️  System desktop directory not found, skipping${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  update-desktop-database not found, skipping${NC}"
    echo -e "${YELLOW}   You may need to log out and back in for changes to take effect.${NC}"
fi

# Summary
echo -e "\n📊 Uninstall Summary"
echo "=================="
echo -e "${GREEN}✅ Removed $REMOVED_COUNT desktop button(s)${NC}"
if [ -n "$INSTALL_DIR" ] && [ -d "$INSTALL_DIR" ]; then
    echo -e "${RED}❌ Could not remove installation directory${NC}"
    echo -e "${YELLOW}   You may need to remove it manually:${NC}"
    echo -e "${YELLOW}   rm -rf $INSTALL_DIR${NC}"
else
    echo -e "${GREEN}✅ Removed all installation files${NC}"
fi

echo -e "\n🎉 Uninstallation complete!"
echo -e "${YELLOW}Note:${NC} You may need to refresh your desktop or log out/in to see changes."

# Check if buttons are still running
echo -e "\n🔍 Checking for running processes..."
if pgrep -f "gateway-restart\|save-context" >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Some button processes may still be running${NC}"
    echo -e "${YELLOW}   They will exit normally when you close their terminals.${NC}"
else
    echo -e "${GREEN}✅ No running button processes found${NC}"
fi

echo -e "\n${GREEN}✨ OpenClaw Function Buttons have been successfully uninstalled!${NC}"