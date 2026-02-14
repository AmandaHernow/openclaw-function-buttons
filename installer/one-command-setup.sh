#!/bin/bash
# OpenClaw Function Buttons - One Command Setup
# Makes OpenClaw easy for everyone!

echo "🎯 OpenClaw Function Buttons Setup"
echo "================================="
echo ""
echo "This will install helpful desktop buttons for OpenClaw."
echo "Perfect for beginners, still powerful for experts!"
echo ""

# Check if OpenClaw is installed
if ! command -v openclaw &> /dev/null; then
    echo "❌ OpenClaw is not installed."
    echo "Please install OpenClaw first: https://docs.openclaw.ai"
    exit 1
fi

echo "✅ OpenClaw is installed!"

# Ask user where to place buttons
echo ""
echo "📁 Where would you like the buttons?"
echo "1) In a folder in my home directory (~/OpenClaw-Buttons/)"
echo "2) Directly on my desktop (requires desktop environment)"
echo "3) Both locations"
echo ""
read -p "Choose option (1-3): " LOCATION_CHOICE

BUTTONS_DIR="$HOME/OpenClaw-Buttons"
DESKTOP_DIR="$HOME/Desktop/OpenClaw-Buttons"

case $LOCATION_CHOICE in
    1)
        echo "📂 Creating buttons in: $BUTTONS_DIR"
        mkdir -p "$BUTTONS_DIR"
        INSTALL_DIR="$BUTTONS_DIR"
        ;;
    2)
        echo "🖥️  Creating buttons on desktop: $DESKTOP_DIR"
        mkdir -p "$DESKTOP_DIR"
        INSTALL_DIR="$DESKTOP_DIR"
        ;;
    3)
        echo "📂🖥️  Creating buttons in both locations"
        mkdir -p "$BUTTONS_DIR"
        mkdir -p "$DESKTOP_DIR"
        INSTALL_DIR="$BUTTONS_DIR"
        ;;
    *)
        echo "⚠️  Invalid choice. Using default: $BUTTONS_DIR"
        mkdir -p "$BUTTONS_DIR"
        INSTALL_DIR="$BUTTONS_DIR"
        ;;
esac

# Copy button scripts
echo ""
echo "🔧 Installing button scripts..."
cp buttons/*.sh "$INSTALL_DIR/" 2>/dev/null

# Copy icons
echo "🎨 Installing icons..."
mkdir -p "$INSTALL_DIR/icons"
cp icons/*.svg "$INSTALL_DIR/icons/" 2>/dev/null

# Create desktop files for GUI integration
echo "🖱️  Creating desktop shortcuts..."
for button in "$INSTALL_DIR"/*.sh; do
    if [ -f "$button" ]; then
        BUTTON_NAME=$(basename "$button" .sh)
        DESKTOP_FILE="$INSTALL_DIR/$BUTTON_NAME.desktop"
        
        cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=OpenClaw: ${BUTTON_NAME//-/ }
Comment=One-click ${BUTTON_NAME//-/ } for OpenClaw
Exec=bash -c "cd '$INSTALL_DIR' && './$BUTTON_NAME.sh'; exec bash"
Icon=$INSTALL_DIR/icons/$BUTTON_NAME.svg
Terminal=true
Categories=Utility;
EOF
        
        chmod +x "$DESKTOP_FILE"
    fi
done

# If user chose desktop location, also copy .desktop files to actual desktop
if [ "$LOCATION_CHOICE" = "2" ] || [ "$LOCATION_CHOICE" = "3" ]; then
    echo "📋 Copying shortcuts to desktop..."
    cp "$INSTALL_DIR"/*.desktop "$HOME/Desktop/" 2>/dev/null
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📚 What was installed:"
echo "   - Gateway Restart button (fix connection issues)"
echo "   - Save Context button (prevent memory loss)"
echo "   - Beautiful custom icons"
echo "   - Desktop shortcuts (if chosen)"
echo ""
echo "🚀 How to use:"
echo "   1. Double-click any .desktop file on your desktop"
echo "   2. Or run: bash ~/OpenClaw-Buttons/gateway-restart.sh"
echo ""
echo "💡 For advanced users: All scripts are in $INSTALL_DIR"
echo "   You can modify them or create your own buttons!"
echo ""
echo "🔗 Learn more: https://github.com/yourusername/OpenClaw-Function-Buttons"
echo ""
echo "Press Enter to finish..."
read