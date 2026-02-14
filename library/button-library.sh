#!/bin/bash
# OpenClaw Function Button: Button Library
# Open the button library to manage and add buttons

echo "📚 OpenClaw Button Library"
echo "=========================="

LIBRARY_FILE="$HOME/.openclaw/workspace/projects/OpenClaw-Function-Buttons/library/button-library.json"

echo "🔍 Available buttons:"
echo ""

if [ -f "$LIBRARY_FILE" ]; then
    # Parse JSON and display buttons
    echo "📋 Button Catalog:"
    echo "----------------"
    
    # System buttons
    echo ""
    echo "🖥️  SYSTEM TOOLS:"
    grep -A5 '"category": "system"' "$LIBRARY_FILE" | while read -r line; do
        if echo "$line" | grep -q '"name":'; then
            NAME=$(echo "$line" | cut -d'"' -f4)
            if echo "$line" | grep -q '"essential": true'; then
                echo "   ✅ $NAME (Essential)"
            else
                echo "   📦 $NAME"
            fi
        fi
        if echo "$line" | grep -q '"description":'; then
            DESC=$(echo "$line" | cut -d'"' -f4)
            echo "      $DESC"
        fi
    done
    
    # Memory buttons
    echo ""
    echo "💾 MEMORY & BACKUP:"
    grep -A5 '"category": "memory"' "$LIBRARY_FILE" | while read -r line; do
        if echo "$line" | grep -q '"name":'; then
            NAME=$(echo "$line" | cut -d'"' -f4)
            if echo "$line" | grep -q '"essential": true'; then
                echo "   ✅ $NAME (Essential)"
            else
                echo "   📦 $NAME"
            fi
        fi
        if echo "$line" | grep -q '"description":'; then
            DESC=$(echo "$line" | cut -d'"' -f4)
            echo "      $DESC"
        fi
    done
    
    # Communication buttons
    echo ""
    echo "💬 COMMUNICATION:"
    grep -A5 '"category": "communication"' "$LIBRARY_FILE" | while read -r line; do
        if echo "$line" | grep -q '"name":'; then
            NAME=$(echo "$line" | cut -d'"' -f4)
            echo "   📦 $NAME"
        fi
        if echo "$line" | grep -q '"description":'; then
            DESC=$(echo "$line" | cut -d'"' -f4)
            echo "      $DESC"
        fi
    done
    
    echo ""
    echo "📊 Total buttons in library: $(grep -c '"name":' "$LIBRARY_FILE")"
else
    echo "❌ Library file not found: $LIBRARY_FILE"
    echo ""
    echo "🔧 Troubleshooting:"
    echo "   1. Make sure OpenClaw Function Buttons is installed"
    echo "   2. Check if the library directory exists"
    echo "   3. Run the installer again if needed"
fi

echo ""
echo "🚀 How to add more buttons:"
echo "   1. Run the installer again"
echo "   2. Select 'Add more buttons' option"
echo "   3. Choose which buttons to install"
echo ""
echo "💡 Essential buttons are automatically included"
echo "   Optional buttons can be added as needed"

# Keep terminal open for 5 seconds so user can read output
sleep 5