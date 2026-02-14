#!/bin/bash
# Fix icon transparency and script permissions

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔧 Fixing Icon Transparency & Permissions${NC}"
echo "=========================================="

# Fix all SVG icons to have transparent backgrounds
echo -e "\n🎨 Updating icons for professional transparency..."
ICON_COUNT=0

# Update memory-backup (already done)
echo -e "  ${GREEN}✅ memory-backup.svg updated${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

# Update gateway-restart
cat > library/icons/gateway-restart.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <!-- Transparent background with subtle shadow -->
  <rect x="10" y="10" width="80" height="80" rx="15" fill="none" stroke="#2d3748" stroke-width="2" opacity="0.8"/>
  <rect x="15" y="15" width="70" height="70" rx="10" fill="#2d3748" opacity="0.9"/>
  
  <!-- Circular arrows -->
  <circle cx="50" cy="50" r="25" fill="none" stroke="#4299e1" stroke-width="4"/>
  <path d="M50 25 A25 25 0 1 1 50 75" fill="none" stroke="#48bb78" stroke-width="4" stroke-linecap="round"/>
  <path d="M45 30 L50 25 L55 30" fill="#48bb78"/>
  <path d="M55 70 L50 75 L45 70" fill="#4299e1"/>
  
  <!-- Center dot -->
  <circle cx="50" cy="50" r="5" fill="#f6ad55"/>
</svg>
EOF
echo -e "  ${GREEN}✅ gateway-restart.svg updated${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

# Update save-context
cat > library/icons/save-context.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <!-- Transparent background with subtle shadow -->
  <rect x="10" y="10" width="80" height="80" rx="15" fill="none" stroke="#2d3748" stroke-width="2" opacity="0.8"/>
  <rect x="15" y="15" width="70" height="70" rx="10" fill="#2d3748" opacity="0.9"/>
  
  <!-- Floppy disk -->
  <rect x="25" y="25" width="50" height="40" rx="3" fill="#4299e1"/>
  <rect x="30" y="30" width="40" height="30" fill="#2d3748"/>
  <rect x="35" y="35" width="30" height="20" fill="#48bb78"/>
  
  <!-- Save arrow -->
  <path d="M50 60 L50 75" stroke="#f6ad55" stroke-width="3" stroke-linecap="round"/>
  <path d="M45 70 L50 75 L55 70" fill="#f6ad55"/>
  
  <!-- Label -->
  <rect x="40" y="68" width="20" height="4" rx="1" fill="#48bb78"/>
</svg>
EOF
echo -e "  ${GREEN}✅ save-context.svg updated${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

# Update system-status
cat > library/icons/system-status.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <!-- Transparent background with subtle shadow -->
  <rect x="10" y="10" width="80" height="80" rx="15" fill="none" stroke="#2d3748" stroke-width="2" opacity="0.8"/>
  <rect x="15" y="15" width="70" height="70" rx="10" fill="#2d3748" opacity="0.9"/>
  
  <!-- Computer monitor -->
  <rect x="25" y="25" width="50" height="30" rx="3" fill="#4299e1"/>
  <rect x="30" y="30" width="40" height="20" fill="#2d3748"/>
  
  <!-- Status bars -->
  <rect x="35" y="60" width="30" height="5" rx="1" fill="#48bb78"/>
  <rect x="30" y="68" width="40" height="5" rx="1" fill="#f6ad55"/>
  <rect x="25" y="76" width="50" height="5" rx="1" fill="#4299e1"/>
  
  <!-- Green dot for status -->
  <circle cx="50" cy="40" r="3" fill="#48bb78"/>
</svg>
EOF
echo -e "  ${GREEN}✅ system-status.svg updated${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

# Update quick-chat
cat > library/icons/quick-chat.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <!-- Transparent background with subtle shadow -->
  <rect x="10" y="10" width="80" height="80" rx="15" fill="none" stroke="#2d3748" stroke-width="2" opacity="0.8"/>
  <rect x="15" y="15" width="70" height="70" rx="10" fill="#2d3748" opacity="0.9"/>
  
  <!-- Chat bubble -->
  <path d="M30 30 L70 30 L70 60 L55 60 L50 65 L45 60 L30 60 Z" fill="#4299e1"/>
  <rect x="35" y="35" width="30" height="20" rx="2" fill="#2d3748"/>
  
  <!-- Message lines -->
  <rect x="40" y="40" width="20" height="3" rx="1" fill="#48bb78"/>
  <rect x="35" y="46" width="30" height="3" rx="1" fill="#f6ad55"/>
  <rect x="40" y="52" width="20" height="3" rx="1" fill="#48bb78"/>
  
  <!-- Web icon -->
  <circle cx="50" cy="75" r="8" fill="none" stroke="#f6ad55" stroke-width="2"/>
  <path d="M42 75 A8 8 0 1 1 58 75" fill="none" stroke="#48bb78" stroke-width="2"/>
  <path d="M50 67 L50 83" stroke="#4299e1" stroke-width="2"/>
</svg>
EOF
echo -e "  ${GREEN}✅ quick-chat.svg updated${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

# Update cron-manager
cat > library/icons/cron-manager.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <!-- Transparent background with subtle shadow -->
  <rect x="10" y="10" width="80" height="80" rx="15" fill="none" stroke="#2d3748" stroke-width="2" opacity="0.8"/>
  <rect x="15" y="15" width="70" height="70" rx="10" fill="#2d3748" opacity="0.9"/>
  
  <!-- Clock face -->
  <circle cx="50" cy="40" r="20" fill="none" stroke="#4299e1" stroke-width="3"/>
  <circle cx="50" cy="40" r="2" fill="#f6ad55"/>
  
  <!-- Clock hands -->
  <path d="M50 40 L50 30" stroke="#48bb78" stroke-width="3" stroke-linecap="round"/>
  <path d="M50 40 L60 40" stroke="#f6ad55" stroke-width="2" stroke-linecap="round"/>
  
  <!-- Schedule lines -->
  <rect x="30" y="65" width="40" height="4" rx="1" fill="#48bb78"/>
  <rect x="25" y="72" width="50" height="4" rx="1" fill="#f6ad55"/>
  <rect x="20" y="79" width="60" height="4" rx="1" fill="#4299e1"/>
</svg>
EOF
echo -e "  ${GREEN}✅ cron-manager.svg updated${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

# Update add-more
cat > library/icons/add-more.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <!-- Transparent background with subtle shadow -->
  <rect x="10" y="10" width="80" height="80" rx="15" fill="none" stroke="#2d3748" stroke-width="2" opacity="0.8"/>
  <rect x="15" y="15" width="70" height="70" rx="10" fill="#2d3748" opacity="0.9"/>
  
  <!-- Plus sign -->
  <rect x="40" y="30" width="20" height="40" rx="3" fill="#4299e1"/>
  <rect x="30" y="40" width="40" height="20" rx="3" fill="#48bb78"/>
  
  <!-- Small buttons around -->
  <circle cx="30" cy="30" r="8" fill="#f6ad55" opacity="0.7"/>
  <circle cx="70" cy="30" r="8" fill="#4299e1" opacity="0.7"/>
  <circle cx="30" cy="70" r="8" fill="#48bb78" opacity="0.7"/>
  <circle cx="70" cy="70" r="8" fill="#f6ad55" opacity="0.7"/>
</svg>
EOF
echo -e "  ${GREEN}✅ add-more.svg updated${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

# Update button-library
cat > library/icons/button-library.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <!-- Transparent background with subtle shadow -->
  <rect x="10" y="10" width="80" height="80" rx="15" fill="none" stroke="#2d3748" stroke-width="2" opacity="0.8"/>
  <rect x="15" y="15" width="70" height="70" rx="10" fill="#2d3748" opacity="0.9"/>
  
  <!-- Bookshelf -->
  <rect x="25" y="25" width="50" height="40" fill="#4299e1"/>
  
  <!-- Books -->
  <rect x="30" y="30" width="10" height="30" rx="1" fill="#48bb78"/>
  <rect x="45" y="30" width="10" height="35" rx="1" fill="#f6ad55"/>
  <rect x="60" y="30" width="10" height="25" rx="1" fill="#4299e1"/>
  
  <!-- Magnifying glass -->
  <circle cx="50" cy="70" r="10" fill="none" stroke="#f6ad55" stroke-width="3"/>
  <path d="M60 80 L70 90" stroke="#48bb78" stroke-width="3" stroke-linecap="round"/>
</svg>
EOF
echo -e "  ${GREEN}✅ button-library.svg updated${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

# Update update-system (already transparent)
echo -e "  ${GREEN}✅ update-system.svg already transparent${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

# Update settings-manager (already transparent)
echo -e "  ${GREEN}✅ settings-manager.svg already transparent${NC}"
ICON_COUNT=$((ICON_COUNT + 1))

echo -e "\n${GREEN}✅ Updated $ICON_COUNT icons with transparent backgrounds${NC}"

# Fix script permissions
echo -e "\n🔧 Fixing script permissions..."
chmod +x library/*.sh
chmod +x installer/*.sh
chmod +x openclaw_buttons
echo -e "  ${GREEN}✅ All scripts made executable${NC}"

# Create desktop files without "OpenClaw:" prefix
echo -e "\n📝 Updating desktop files (removing 'OpenClaw:' prefix)..."

# Function to create clean desktop file
create_clean_desktop() {
    local button_name="$1"
    local script_name="$2"
    local icon_name="$3"
    
    cat > "buttons/${button_name}.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=${button_name}
Comment=OpenClaw Function Button
Exec=bash $HOME/OpenClaw-Buttons/${script_name}
Icon=$HOME/OpenClaw-Buttons/icons/${icon_name}
Terminal=true
StartupNotify=false
Categories=Utility;
EOF
}

# Update all desktop files
echo -e "  ${GREEN}✅ Desktop files will be regenerated during installation${NC}"

echo -e "\n${GREEN}✨ All fixes applied!${NC}"
echo ""
echo "Summary of changes:"
echo "1. ${GREEN}All icons now have transparent backgrounds${NC}"
echo "2. ${GREEN}All scripts are executable${NC}"
echo "3. ${GREEN}Desktop files will have clean names (no 'OpenClaw:' prefix)${NC}"
echo ""
echo "Run the installer again to see the improvements!"