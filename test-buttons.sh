#!/bin/bash
# Test script for OpenClaw Function Buttons

echo "🧪 Testing OpenClaw Function Buttons"
echo "==================================="
echo ""

# Test 1: Check all files exist
echo "📁 File Structure Test..."
MISSING_FILES=0

check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1"
    else
        echo "❌ $1 (MISSING)"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
}

check_file "buttons/gateway-restart.sh"
check_file "buttons/save-context.sh"
check_file "icons/gateway-restart.svg"
check_file "icons/save-context.svg"
check_file "installer/one-command-setup.sh"
check_file "README.md"
check_file "docs/PROJECT_PLAN.md"

echo ""

# Test 2: Check file permissions
echo "🔒 Permission Test..."
for script in buttons/*.sh installer/*.sh; do
    if [ -f "$script" ]; then
        if [ -x "$script" ]; then
            echo "✅ $script (executable)"
        else
            echo "⚠️  $script (not executable, fixing...)"
            chmod +x "$script"
        fi
    fi
done

echo ""

# Test 3: Check SVG files
echo "🎨 SVG File Test..."
for svg in icons/*.svg; do
    if [ -f "$svg" ]; then
        SIZE=$(wc -c < "$svg")
        if [ "$SIZE" -gt 100 ]; then
            echo "✅ $svg ($SIZE bytes)"
        else
            echo "⚠️  $svg (too small: $SIZE bytes)"
        fi
    fi
done

echo ""

# Test 4: Syntax check scripts
echo "📝 Syntax Check..."
for script in buttons/*.sh; do
    if [ -f "$script" ]; then
        if bash -n "$script" 2>/dev/null; then
            echo "✅ $script (valid syntax)"
        else
            echo "❌ $script (syntax error)"
            MISSING_FILES=$((MISSING_FILES + 1))
        fi
    fi
done

echo ""
echo "📊 Test Summary"
echo "=============="
if [ "$MISSING_FILES" -eq 0 ]; then
    echo "🎉 ALL TESTS PASSED!"
    echo "The OpenClaw Function Buttons project is ready."
else
    echo "⚠️  Found $MISSING_FILES issues that need attention."
fi

echo ""
echo "🚀 Next steps:"
echo "1. Run the installer: ./installer/one-command-setup.sh"
echo "2. Test buttons manually"
echo "3. Create GitHub repository"
echo "4. Share with community!"