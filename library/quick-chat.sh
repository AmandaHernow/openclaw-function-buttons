#!/bin/bash
# OpenClaw Function Button: Quick Chat
# Open a quick chat window with OpenClaw

echo "💬 OpenClaw Quick Chat"
echo "====================="

echo "Opening chat interface..."

# Check if webchat is available
WEBCHAT_URL="http://localhost:18789/webchat"
if curl -s --head "$WEBCHAT_URL" | head -n 1 | grep "200" > /dev/null; then
    echo "✅ Webchat is available at: $WEBCHAT_URL"
    echo ""
    echo "🌐 Opening browser..."
    
    # Try to open in default browser
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$WEBCHAT_URL" &
        echo "   Browser opened successfully!"
    elif command -v gnome-open >/dev/null 2>&1; then
        gnome-open "$WEBCHAT_URL" &
        echo "   Browser opened successfully!"
    else
        echo "   ⚠️  Could not detect default browser"
        echo "   Please open manually: $WEBCHAT_URL"
    fi
else
    echo "❌ Webchat is not available"
    echo ""
    echo "🔧 Troubleshooting steps:"
    echo "   1. Check if OpenClaw gateway is running:"
    echo "      systemctl status openclaw-gateway-system"
    echo "   2. Try restarting the gateway:"
    echo "      sudo systemctl restart openclaw-gateway-system"
    echo "   3. Check if port 18789 is in use:"
    echo "      sudo netstat -tlnp | grep 18789"
fi

echo ""
echo "💡 Quick tips:"
echo "   • Type your message and press Enter to send"
echo "   • Use /help for available commands"
echo "   • The chat will stay open in your browser"

# Keep terminal open for 5 seconds so user can read output
sleep 5