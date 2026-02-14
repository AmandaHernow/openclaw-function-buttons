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

# Get installation directory
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/share/openclaw-buttons}"

# List of desktop files to remove
DESKTOP_FILES=(
    "openclaw-gateway-restart.desktop"
    "openclaw-save-context.desktop"
)

echo -e "\n📋 Checking installation..."

# Check if installed
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠️  Installation directory not found: $INSTALL_DIR${NC}"
    echo -e "${YELLOW}   The buttons may have been installed elsewhere or already removed.${NC}"
else
    echo -e "${GREEN}✅ Found installation directory: $INSTALL_DIR${NC}"
fi

# Remove desktop files
echo -e "\n🗑️  Removing desktop buttons..."
REMOVED_COUNT=0
DESKTOP_DIR="$HOME/.local/share/applications"

for file in "${DESKTOP_FILES[@]}"; do
    if [ -f "$DESKTOP_DIR/$file" ]; then
        rm -f "$DESKTOP_DIR/$file"
        echo -e "${GREEN}✅ Removed: $file${NC}"
        REMOVED_COUNT=$((REMOVED_COUNT + 1))
    else
        echo -e "${YELLOW}⚠️  Not found: $file${NC}"
    fi
done

# Remove installation directory
if [ -d "$INSTALL_DIR" ]; then
    echo -e "\n🗑️  Removing installation files..."
    rm -rf "$INSTALL_DIR"
    echo -e "${GREEN}✅ Removed installation directory: $INSTALL_DIR${NC}"
fi

# Update desktop database
echo -e "\n🔄 Updating desktop database..."
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$DESKTOP_DIR"
    echo -e "${GREEN}✅ Updated desktop database${NC}"
else
    echo -e "${YELLOW}⚠️  update-desktop-database not found, skipping${NC}"
    echo -e "${YELLOW}   You may need to log out and back in for changes to take effect.${NC}"
fi

# Summary
echo -e "\n📊 Uninstall Summary"
echo "=================="
echo -e "${GREEN}✅ Removed $REMOVED_COUNT desktop button(s)${NC}"
if [ -d "$INSTALL_DIR" ]; then
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
if pgrep -f "openclaw-buttons" >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Some button processes may still be running${NC}"
    echo -e "${YELLOW}   They will exit normally when you close their terminals.${NC}"
else
    echo -e "${GREEN}✅ No running button processes found${NC}"
fi

echo -e "\n${GREEN}✨ OpenClaw Function Buttons have been successfully uninstalled!${NC}"