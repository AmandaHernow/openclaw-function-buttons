#!/bin/bash
# OpenClaw Function Button: Gateway Restart
# Restart OpenClaw gateway service using configured command

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔄 OpenClaw Gateway Restart${NC}"
echo "=========================="

# Load configuration
CONFIG_FILE="$HOME/.config/openclaw-buttons/config.json"
if [ -f "$CONFIG_FILE" ]; then
    GATEWAY_CMD=$(jq -r '.gateway_command // "system"' "$CONFIG_FILE")
else
    GATEWAY_CMD="system"
fi

echo -e "🔧 Using command: ${YELLOW}$GATEWAY_CMD${NC}"

# Execute based on configured command
case "$GATEWAY_CMD" in
    "system")
        echo -e "\n🌐 Restarting system gateway service..."
        
        # Check if service exists
        if ! systemctl list-unit-files | grep -q openclaw-gateway-system; then
            echo -e "${RED}❌ System gateway service not found${NC}"
            echo ""
            echo "🔧 The system service may not be installed."
            echo "   Check OpenClaw documentation for installation instructions."
            exit 1
        fi
        
        # Restart service
        echo "🔄 Executing: sudo systemctl restart openclaw-gateway-system"
        sudo systemctl restart openclaw-gateway-system
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Gateway restarted successfully!${NC}"
            echo ""
            echo "💡 The gateway should be back online in a few seconds."
            echo "   If you're using webchat, refresh the page."
        else
            echo -e "${RED}❌ Failed to restart gateway${NC}"
            echo ""
            echo "🔧 Troubleshooting:"
            echo "   1. Check sudo permissions"
            echo "   2. Check service status: systemctl status openclaw-gateway-system"
            echo "   3. Check for errors: journalctl -u openclaw-gateway-system"
        fi
        ;;
    
    "user")
        echo -e "\n👤 Restarting user gateway..."
        
        # Check if openclaw command exists
        if ! command -v openclaw >/dev/null 2>&1; then
            echo -e "${RED}❌ OpenClaw CLI not found${NC}"
            echo ""
            echo "🔧 Install OpenClaw CLI first:"
            echo "   npm install -g openclaw"
            exit 1
        fi
        
        # Restart user gateway
        echo "🔄 Executing: openclaw gateway restart"
        openclaw gateway restart
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ User gateway restarted!${NC}"
            echo ""
            echo "⚠️  Note: User gateway may conflict with system service"
            echo "   Use Settings Manager to change gateway command if needed"
        else
            echo -e "${RED}❌ Failed to restart user gateway${NC}"
        fi
        ;;
    
    *)
        echo -e "\n🔧 Executing custom command: ${YELLOW}$GATEWAY_CMD${NC}"
        
        # Execute custom command
        eval "$GATEWAY_CMD"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Custom command executed successfully!${NC}"
        else
            echo -e "${RED}❌ Custom command failed${NC}"
            echo ""
            echo "🔧 Check your custom command in Settings Manager"
        fi
        ;;
esac

# Show current gateway status
echo -e "\n📊 Current Gateway Status:"
if pgrep -f "openclaw" >/dev/null; then
    echo -e "${GREEN}✅ OpenClaw processes are running${NC}"
    pgrep -f "openclaw" | while read pid; do
        echo "   PID $pid: $(ps -p $pid -o cmd= | head -1)"
    done
else
    echo -e "${YELLOW}⚠️  No OpenClaw processes found${NC}"
fi

# Keep terminal open for 5 seconds so user can read output
sleep 5