#!/bin/bash
# OpenClaw Function Buttons: Settings Manager
# Configure button behavior and system settings

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}⚙️  OpenClaw Function Buttons Settings Manager${NC}"
echo "=============================================="

# Configuration
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_FILE="$HOME/.config/openclaw-buttons/config.json"
DEFAULT_CONFIG='{
  "current_channel": "stable",
  "auto_update": false,
  "gateway_command": "system",
  "hidden_buttons": [],
  "installation_path": "",
  "desktop_shortcuts": true
}'

# Load or create config
load_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        mkdir -p "$(dirname "$CONFIG_FILE")"
        echo "$DEFAULT_CONFIG" > "$CONFIG_FILE"
    fi
    cat "$CONFIG_FILE"
}

# Save config
save_config() {
    echo "$1" > "$CONFIG_FILE"
}

# Gateway command configuration
configure_gateway() {
    echo -e "\n🌐 Gateway Command Configuration"
    echo "----------------------------"
    
    CURRENT_CONFIG=$(load_config)
    CURRENT_CMD=$(echo "$CURRENT_CONFIG" | jq -r '.gateway_command // "system"')
    
    echo "Current gateway command: ${GREEN}$CURRENT_CMD${NC}"
    echo ""
    echo "Available options:"
    echo "1) system - Use system service (sudo systemctl restart openclaw-gateway-system)"
    echo "   ✅ Recommended - Uses systemd, most reliable"
    echo "2) user   - Use user command (openclaw gateway restart)"
    echo "   ⚠️  May create conflicts with system service"
    echo "3) custom - Enter custom command"
    echo -e "${YELLOW}Enter choice (1-3):${NC} "
    read -r CHOICE
    
    NEW_CMD="$CURRENT_CMD"
    case $CHOICE in
        1)
            NEW_CMD="system"
            echo -e "${GREEN}✅ Using system service gateway command${NC}"
            ;;
        2)
            NEW_CMD="user"
            echo -e "${YELLOW}⚠️  Using user gateway command${NC}"
            echo "   Note: This may conflict with system service"
            ;;
        3)
            echo -e "${YELLOW}Enter custom gateway restart command:${NC} "
            read -r CUSTOM_CMD
            NEW_CMD="$CUSTOM_CMD"
            echo -e "${GREEN}✅ Custom command set${NC}"
            ;;
        *)
            echo -e "${RED}❌ Invalid choice, keeping current setting${NC}"
            return
            ;;
    esac
    
    # Update config
    UPDATED_CONFIG=$(echo "$CURRENT_CONFIG" | jq --arg cmd "$NEW_CMD" '.gateway_command = $cmd')
    save_config "$UPDATED_CONFIG"
    
    echo -e "\n${GREEN}✅ Gateway command updated${NC}"
    echo "   New command: $NEW_CMD"
}

# Button visibility management
manage_buttons() {
    echo -e "\n👁️  Button Visibility Management"
    echo "-----------------------------"
    
    CURRENT_CONFIG=$(load_config)
    HIDDEN_BUTTONS=$(echo "$CURRENT_CONFIG" | jq -r '.hidden_buttons[]' 2>/dev/null || echo "")
    
    # Get all buttons from library
    BUTTONS=()
    if [ -f "$PROJECT_DIR/library/button-library.json" ]; then
        while IFS='|' read -r name id; do
            BUTTONS+=("$name|$id")
        done < <(python3 -c "
import json
with open('$PROJECT_DIR/library/button-library.json', 'r') as f:
    data = json.load(f)
for button in data['buttons']:
    print(f\"{button['name']}|{button['id']}\")
")
    fi
    
    echo "Current hidden buttons:"
    if [ -z "$HIDDEN_BUTTONS" ]; then
        echo "   None (all buttons visible)"
    else
        for button in $HIDDEN_BUTTONS; do
            echo "   ❌ $button"
        done
    fi
    
    echo -e "\n${YELLOW}Toggle button visibility:${NC}"
    for button_info in "${BUTTONS[@]}"; do
        name=$(echo "$button_info" | cut -d'|' -f1)
        id=$(echo "$button_info" | cut -d'|' -f2)
        
        # Check if button is hidden
        HIDDEN=false
        for hidden in $HIDDEN_BUTTONS; do
            if [ "$hidden" = "$id" ]; then
                HIDDEN=true
                break
            fi
        done
        
        if [ "$HIDDEN" = true ]; then
            echo -n "  Show $name? (y/n) [n]: "
            read -r choice
            if [[ "$choice" =~ ^[Yy]$ ]]; then
                # Remove from hidden list
                UPDATED_HIDDEN=$(echo "$HIDDEN_BUTTONS" | grep -v "^$id$" || echo "")
                UPDATED_CONFIG=$(echo "$CURRENT_CONFIG" | jq --argjson hidden "[$(echo "$UPDATED_HIDDEN" | sed 's/^/"/;s/$/"/' | tr '\n' ',')]" '.hidden_buttons = $hidden')
                save_config "$UPDATED_CONFIG"
                echo -e "    ${GREEN}✅ Button will be shown${NC}"
            fi
        else
            echo -n "  Hide $name? (y/n) [n]: "
            read -r choice
            if [[ "$choice" =~ ^[Yy]$ ]]; then
                # Add to hidden list
                UPDATED_HIDDEN=$(echo -e "$HIDDEN_BUTTONS\n$id" | grep -v '^$' | sort -u)
                UPDATED_CONFIG=$(echo "$CURRENT_CONFIG" | jq --argjson hidden "[$(echo "$UPDATED_HIDDEN" | sed 's/^/"/;s/$/"/' | tr '\n' ',')]" '.hidden_buttons = $hidden')
                save_config "$UPDATED_CONFIG"
                echo -e "    ${GREEN}✅ Button will be hidden${NC}"
            fi
        fi
    done
    
    # Special warning for hiding management buttons
    echo -e "\n${YELLOW}⚠️  Important Notes:${NC}"
    echo "   • Hiding 'Button Library' may make it hard to restore visibility"
    echo "   • Hidden buttons won't appear in the library browser"
    echo "   • They can still be accessed via terminal if needed"
}

# Installation path management
manage_installation() {
    echo -e "\n📁 Installation Management"
    echo "-----------------------"
    
    CURRENT_CONFIG=$(load_config)
    CURRENT_PATH=$(echo "$CURRENT_CONFIG" | jq -r '.installation_path // ""')
    
    if [ -n "$CURRENT_PATH" ] && [ -d "$CURRENT_PATH" ]; then
        echo -e "Current installation: ${GREEN}$CURRENT_PATH${NC}"
        echo ""
        echo "Options:"
        echo "1) View installation contents"
        echo "2) Change installation path"
        echo "3) Uninstall from current location"
        echo -e "${YELLOW}Enter choice (1-3):${NC} "
        read -r CHOICE
        
        case $CHOICE in
            1)
                echo -e "\n📦 Installation contents:"
                ls -la "$CURRENT_PATH/"
                ;;
            2)
                echo -e "\n${YELLOW}Enter new installation path:${NC} "
                read -r NEW_PATH
                if [ -n "$NEW_PATH" ]; then
                    UPDATED_CONFIG=$(echo "$CURRENT_CONFIG" | jq --arg path "$NEW_PATH" '.installation_path = $path')
                    save_config "$UPDATED_CONFIG"
                    echo -e "${GREEN}✅ Installation path updated${NC}"
                fi
                ;;
            3)
                echo -e "\n${RED}⚠️  WARNING: Uninstallation${NC}"
                echo "This will remove all button files from:"
                echo "  $CURRENT_PATH"
                echo -n "Are you sure? (type 'yes' to confirm): "
                read -r CONFIRM
                if [ "$CONFIRM" = "yes" ]; then
                    rm -rf "$CURRENT_PATH"
                    UPDATED_CONFIG=$(echo "$CURRENT_CONFIG" | jq '.installation_path = ""')
                    save_config "$UPDATED_CONFIG"
                    echo -e "${GREEN}✅ Installation removed${NC}"
                else
                    echo -e "${YELLOW}Uninstallation cancelled${NC}"
                fi
                ;;
            *)
                echo -e "${RED}❌ Invalid choice${NC}"
                ;;
        esac
    else
        echo -e "${YELLOW}⚠️  No installation path configured${NC}"
        echo "Run the installer first to set up buttons"
    fi
}

# Desktop shortcuts toggle
toggle_desktop_shortcuts() {
    CURRENT_CONFIG=$(load_config)
    CURRENT_SETTING=$(echo "$CURRENT_CONFIG" | jq -r '.desktop_shortcuts // true')
    
    if [ "$CURRENT_SETTING" = "true" ]; then
        echo -e "\n${YELLOW}Disable desktop shortcuts?${NC}"
        echo "Desktop shortcuts won't be created during installation"
        echo -n "Disable? (y/n) [n]: "
        read -r choice
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            UPDATED_CONFIG=$(echo "$CURRENT_CONFIG" | jq '.desktop_shortcuts = false')
            save_config "$UPDATED_CONFIG"
            echo -e "${GREEN}✅ Desktop shortcuts disabled${NC}"
        fi
    else
        echo -e "\n${YELLOW}Enable desktop shortcuts?${NC}"
        echo "Desktop shortcuts will be created during installation"
        echo -n "Enable? (y/n) [n]: "
        read -r choice
        if [[ "$choice" =~ ^[Yy]$ ]]; then
            UPDATED_CONFIG=$(echo "$CURRENT_CONFIG" | jq '.desktop_shortcuts = true')
            save_config "$UPDATED_CONFIG"
            echo -e "${GREEN}✅ Desktop shortcuts enabled${NC}"
        fi
    fi
}

# View all settings
view_settings() {
    CURRENT_CONFIG=$(load_config)
    
    echo -e "\n${BLUE}📊 Current Settings${NC}"
    echo "----------------"
    
    # Pretty print JSON
    echo "$CURRENT_CONFIG" | jq -r '
"Channel: \(.current_channel)",
"Auto-update: \(.auto_update)",
"Gateway command: \(.gateway_command)",
"Desktop shortcuts: \(.desktop_shortcuts)",
"Installation path: \(.installation_path // "Not configured")",
"Hidden buttons: \(if .hidden_buttons | length > 0 then .hidden_buttons | join(", ") else "None" end)"
'
}

# Main menu
main_menu() {
    while true; do
        echo -e "\n${BLUE}⚙️  Settings Menu${NC}"
        echo "-------------"
        echo "1) Configure gateway commands"
        echo "2) Manage button visibility"
        echo "3) Installation management"
        echo "4) Toggle desktop shortcuts"
        echo "5) View all settings"
        echo "6) Reset to defaults"
        echo "7) Exit"
        echo -e "${YELLOW}Enter choice (1-7):${NC} "
        read -r CHOICE
        
        case $CHOICE in
            1)
                configure_gateway
                ;;
            2)
                manage_buttons
                ;;
            3)
                manage_installation
                ;;
            4)
                toggle_desktop_shortcuts
                ;;
            5)
                view_settings
                ;;
            6)
                echo -e "\n${RED}⚠️  Reset to defaults?${NC}"
                echo "This will erase all custom settings"
                echo -n "Type 'reset' to confirm: "
                read -r CONFIRM
                if [ "$CONFIRM" = "reset" ]; then
                    save_config "$DEFAULT_CONFIG"
                    echo -e "${GREEN}✅ Settings reset to defaults${NC}"
                else
                    echo -e "${YELLOW}Reset cancelled${NC}"
                fi
                ;;
            7)
                echo -e "\n${GREEN}👋 Exiting settings manager${NC}"
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
        "gateway")
            configure_gateway
            ;;
        "visibility")
            manage_buttons
            ;;
        "install")
            manage_installation
            ;;
        "desktop")
            toggle_desktop_shortcuts
            ;;
        "view")
            view_settings
            ;;
        "reset")
            save_config "$DEFAULT_CONFIG"
            echo -e "${GREEN}✅ Settings reset to defaults${NC}"
            ;;
        *)
            echo "Usage: $0 [command]"
            echo "Commands:"
            echo "  gateway   - Configure gateway commands"
            echo "  visibility - Manage button visibility"
            echo "  install   - Installation management"
            echo "  desktop   - Toggle desktop shortcuts"
            echo "  view      - View all settings"
            echo "  reset     - Reset to defaults"
            echo ""
            echo "Without arguments: Interactive menu"
            exit 1
            ;;
    esac
fi

# Keep terminal open
sleep 3