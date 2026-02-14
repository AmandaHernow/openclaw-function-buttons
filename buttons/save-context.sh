#!/bin/bash
# OpenClaw Function Button: Save Context
# Save current conversation and memory to prevent loss between sessions

echo "💾 OpenClaw Save Context"
echo "======================="

WORKSPACE_DIR="$HOME/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE_DIR/backups/context-saves"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "📁 Workspace: $WORKSPACE_DIR"
echo "📦 Backup to: $BACKUP_DIR"
echo "🕐 Timestamp: $TIMESTAMP"

# Save memory files
echo "📝 Saving memory files..."
cp "$WORKSPACE_DIR/memory/$(date +%Y-%m-%d).md" "$BACKUP_DIR/memory_${TIMESTAMP}.md" 2>/dev/null
cp "$WORKSPACE_DIR/MEMORY.md" "$BACKUP_DIR/MEMORY_${TIMESTAMP}.md" 2>/dev/null

# Save important configuration
echo "⚙️  Saving configuration..."
cp "$WORKSPACE_DIR/openclaw.json" "$BACKUP_DIR/config_${TIMESTAMP}.json" 2>/dev/null

# Create a summary of current state
echo "📊 Creating session summary..."
{
  echo "# OpenClaw Context Save - $TIMESTAMP"
  echo ""
  echo "## System Information"
  echo "- Date: $(date)"
  echo "- User: $(whoami)"
  echo "- Hostname: $(hostname)"
  echo ""
  echo "## Memory Status"
  echo "- Today's memory file: $(ls -la "$WORKSPACE_DIR/memory/$(date +%Y-%m-%d).md" 2>/dev/null | awk '{print $5}') bytes"
  echo "- MEMORY.md size: $(ls -la "$WORKSPACE_DIR/MEMORY.md" 2>/dev/null | awk '{print $5}') bytes"
  echo ""
  echo "## Recent Activity"
  tail -10 "$WORKSPACE_DIR/memory/$(date +%Y-%m-%d).md" 2>/dev/null | sed 's/^/- /'
} > "$BACKUP_DIR/summary_${TIMESTAMP}.md"

echo ""
echo "✅ Context saved successfully!"
echo ""
echo "📁 Backup files created:"
ls -la "$BACKUP_DIR" | grep "$TIMESTAMP"
echo ""
echo "💡 Your conversation and memory are now safe."
echo "   If you lose connection, this context can be restored."

# Keep terminal open for 5 seconds so user can read output
sleep 5