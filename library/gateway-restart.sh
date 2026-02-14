#!/bin/bash
# OpenClaw Function Button: Gateway Restart
# Simple one-click solution for gateway connectivity issues

echo "🔧 OpenClaw Gateway Restart"
echo "=========================="

# Check if running as root (needed for systemctl)
if [ "$EUID" -ne 0 ]; then 
  echo "⚠️  This button needs administrator privileges."
  echo "Please enter your password when prompted."
  
  # Restart gateway using sudo
  sudo systemctl restart openclaw-gateway-system
  
  if [ $? -eq 0 ]; then
    echo "✅ Gateway restart initiated!"
    echo "The OpenClaw gateway will be back online in a few seconds."
  else
    echo "❌ Failed to restart gateway. Please check system logs."
  fi
else
  # Already running as root
  systemctl restart openclaw-gateway-system
  
  if [ $? -eq 0 ]; then
    echo "✅ Gateway restart initiated!"
    echo "The OpenClaw gateway will be back online in a few seconds."
  else
    echo "❌ Failed to restart gateway. Please check system logs."
  fi
fi

echo ""
echo "💡 Tip: If issues persist, check:"
echo "   sudo systemctl status openclaw-gateway-system"
echo "   tail -f ~/.openclaw/logs/gateway.log"

# Keep terminal open for 5 seconds so user can read output
sleep 5