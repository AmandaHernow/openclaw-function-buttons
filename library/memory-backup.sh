#!/bin/bash
# OpenClaw Function Button: Memory Backup
# Create a full backup of all memory files

echo "💾 OpenClaw Memory Backup"
echo "========================"

WORKSPACE_DIR="$HOME/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE_DIR/backups/full-backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "📁 Workspace: $WORKSPACE_DIR"
echo "📦 Backup to: $BACKUP_DIR"
echo "🕐 Timestamp: $TIMESTAMP"

# Create backup archive
echo "📦 Creating backup archive..."
BACKUP_FILE="$BACKUP_DIR/full_backup_${TIMESTAMP}.tar.gz"

# Backup memory files
echo "📝 Backing up memory files..."
tar -czf "$BACKUP_FILE" \
  -C "$WORKSPACE_DIR" \
  memory/ \
  MEMORY.md \
  AGENTS.md \
  USER.md \
  SOUL.md \
  HEARTBEAT.md \
  2>/dev/null

# Check if backup was successful
if [ -f "$BACKUP_FILE" ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo ""
    echo "✅ Backup created successfully!"
    echo "📁 File: $BACKUP_FILE"
    echo "📊 Size: $BACKUP_SIZE"
    echo ""
    echo "💡 Your memories are safely backed up."
    echo "   This archive contains all memory files and can be restored if needed."
else
    echo ""
    echo "❌ Backup failed!"
    echo "   Please check if you have write permissions to: $BACKUP_DIR"
fi

# Keep terminal open for 5 seconds so user can read output
sleep 5