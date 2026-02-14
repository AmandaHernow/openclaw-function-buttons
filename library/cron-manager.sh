#!/bin/bash
# OpenClaw Function Button: Cron Manager
# Manage and monitor cron jobs

echo "⏰ OpenClaw Cron Manager"
echo "======================"

echo "🔍 Checking OpenClaw cron jobs..."

# Get OpenClaw cron jobs from system crontab
echo ""
echo "📋 System Cron Jobs:"
SYSTEM_CRON_COUNT=0
if [ -f /etc/crontab ]; then
    SYSTEM_CRON_COUNT=$(grep -c "openclaw" /etc/crontab)
    if [ "$SYSTEM_CRON_COUNT" -gt 0 ]; then
        echo "   ✅ $SYSTEM_CRON_COUNT OpenClaw job(s) in system crontab"
        grep "openclaw" /etc/crontab | while read -r line; do
            echo "      • $(echo "$line" | awk '{print $1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10}')"
        done
    else
        echo "   ℹ️  No OpenClaw jobs in system crontab"
    fi
fi

# Check user crontab
echo ""
echo "👤 User Cron Jobs:"
USER_CRON_COUNT=$(crontab -l 2>/dev/null | grep -c "openclaw")
if [ "$USER_CRON_COUNT" -gt 0 ]; then
    echo "   ✅ $USER_CRON_COUNT OpenClaw job(s) in user crontab"
    crontab -l 2>/dev/null | grep "openclaw" | while read -r line; do
        echo "      • $line"
    done
else
    echo "   ℹ️  No OpenClaw jobs in user crontab"
fi

# Check OpenClaw gateway cron jobs
echo ""
echo "🚀 OpenClaw Gateway Cron Jobs:"
if command -v openclaw >/dev/null 2>&1; then
    GATEWAY_CRON_COUNT=$(openclaw cron list 2>/dev/null | grep -c "enabled: true")
    if [ "$GATEWAY_CRON_COUNT" -gt 0 ]; then
        echo "   ✅ $GATEWAY_CRON_COUNT enabled gateway cron job(s)"
        openclaw cron list 2>/dev/null | grep -A2 "enabled: true" | while read -r line; do
            if echo "$line" | grep -q "name:"; then
                JOB_NAME=$(echo "$line" | cut -d: -f2- | xargs)
                echo "      • $JOB_NAME"
            fi
        done
    else
        echo "   ℹ️  No enabled gateway cron jobs"
    fi
else
    echo "   ⚠️  OpenClaw CLI not found"
fi

# Check running cron processes
echo ""
echo "🔄 Running Cron Processes:"
RUNNING_CRON=$(ps aux | grep -E "cron|crond" | grep -v grep | wc -l)
if [ "$RUNNING_CRON" -gt 0 ]; then
    echo "   ✅ Cron daemon is running ($RUNNING_CRON process(es))"
else
    echo "   ❌ Cron daemon is not running"
fi

echo ""
echo "💡 Cron Management Tips:"
echo "   1. To add a cron job: crontab -e"
echo "   2. To view your cron jobs: crontab -l"
echo "   3. To remove all cron jobs: crontab -r"
echo "   4. OpenClaw gateway jobs: openclaw cron list"

echo ""
echo "✨ Cron check complete!"
echo "   Your scheduled tasks are being managed."

# Keep terminal open for 5 seconds so user can read output
sleep 5