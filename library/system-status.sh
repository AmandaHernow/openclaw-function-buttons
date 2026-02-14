#!/bin/bash
# OpenClaw Function Button: System Status
# Check OpenClaw system status and health

echo "📊 OpenClaw System Status"
echo "========================"

echo "🔍 Checking OpenClaw status..."

# Check if OpenClaw is running
if pgrep -f "openclaw" >/dev/null 2>&1; then
    echo "✅ OpenClaw is running"
    
    # Get gateway status
    echo ""
    echo "🌐 Gateway Status:"
    if systemctl is-active --quiet openclaw-gateway-system; then
        echo "   ✅ System gateway service is active"
    else
        echo "   ❌ System gateway service is not running"
    fi
    
    # Check for user gateway conflicts
    USER_GATEWAY_PID=$(pgrep -f "openclaw gateway" | head -1)
    if [ -n "$USER_GATEWAY_PID" ]; then
        echo "   ⚠️  User gateway detected (PID: $USER_GATEWAY_PID)"
        echo "      This may conflict with system service"
    fi
else
    echo "❌ OpenClaw is not running"
fi

# Check workspace
echo ""
echo "📁 Workspace Status:"
WORKSPACE_DIR="$HOME/.openclaw/workspace"
if [ -d "$WORKSPACE_DIR" ]; then
    echo "   ✅ Workspace directory exists: $WORKSPACE_DIR"
    
    # Check memory files
    TODAY_MEMORY="$WORKSPACE_DIR/memory/$(date +%Y-%m-%d).md"
    if [ -f "$TODAY_MEMORY" ]; then
        MEMORY_SIZE=$(wc -l < "$TODAY_MEMORY")
        echo "   📝 Today's memory: $MEMORY_SIZE lines"
    else
        echo "   ⚠️  Today's memory file not found"
    fi
    
    if [ -f "$WORKSPACE_DIR/MEMORY.md" ]; then
        LONG_MEMORY_SIZE=$(wc -l < "$WORKSPACE_DIR/MEMORY.md")
        echo "   🧠 Long-term memory: $LONG_MEMORY_SIZE lines"
    fi
else
    echo "   ❌ Workspace directory not found"
fi

# Check cron jobs
echo ""
echo "⏰ Cron Jobs:"
CRON_COUNT=$(crontab -l 2>/dev/null | grep -c "openclaw")
if [ "$CRON_COUNT" -gt 0 ]; then
    echo "   ✅ $CRON_COUNT OpenClaw cron job(s) found"
else
    echo "   ℹ️  No OpenClaw cron jobs found"
fi

# System resources
echo ""
echo "💻 System Resources:"
echo "   CPU Load: $(uptime | awk -F'load average:' '{print $2}')"
echo "   Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
echo "   Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 " used)"}')"

echo ""
echo "✨ System check complete!"
echo "   All systems are operational."

# Keep terminal open for 5 seconds so user can read output
sleep 5