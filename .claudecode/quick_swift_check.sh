#!/bin/bash

# Quick Swift syntax and style checker for Claude Code
# Usage: ./quick_swift_check.sh [file.swift]

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <swift_file>"
    exit 1
fi

file="$1"
if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found"
    exit 1
fi

echo "🔍 Quick Analysis: $file"
echo "=========================="

# Check for common Swift issues without full compilation
echo "⚠️  Potential Issues:"

# Force unwraps
if grep -n "!" "$file" | grep -v "//" | grep -v "^[[:space:]]*//\|func\|var\|let.*=\|import\|@\|#" >/dev/null 2>&1; then
    echo "  ⚡ Force unwraps found:"
    grep -n "!" "$file" | grep -v "//" | grep -v "^[[:space:]]*//\|func\|var\|let.*=\|import\|@\|#" | head -3
    echo "    → Consider using optional binding (if let, guard let)"
    echo ""
fi

# Force casts
if grep -n " as! " "$file" >/dev/null 2>&1; then
    echo "  ⚡ Force casts found:"
    grep -n " as! " "$file" | head -3
    echo "    → Consider using 'as?' for safe casting"
    echo ""
fi

# Print statements (potential debug code)
if grep -n "print(" "$file" | grep -v "//" >/dev/null 2>&1; then
    echo "  🐛 Print statements found:"
    grep -n "print(" "$file" | grep -v "//" | head -3
    echo "    → Consider removing debug prints"
    echo ""
fi

# TODO/FIXME comments
if grep -n -i "todo\|fixme" "$file" >/dev/null 2>&1; then
    echo "  📝 TODO/FIXME comments:"
    grep -n -i "todo\|fixme" "$file"
    echo ""
fi

# Common SwiftUI issues
if grep -q "SwiftUI" "$file"; then
    echo "  🎨 SwiftUI specific checks:"

    # Multiple @State in structs
    state_count=$(grep -c "@State" "$file" 2>/dev/null || echo 0)
    if [ "$state_count" -gt 5 ]; then
        echo "    ⚠️  High number of @State variables ($state_count) - consider @StateObject or @ObservedObject"
    fi

    # Body complexity
    body_lines=$(sed -n '/var body:/,/^[[:space:]]*}/p' "$file" | wc -l)
    if [ "$body_lines" -gt 50 ]; then
        echo "    ⚠️  Large body view ($body_lines lines) - consider extracting subviews"
    fi
fi

# Basic syntax patterns
echo "✅ Quick Syntax Check:"
if grep -q "struct.*View" "$file"; then
    echo "  ✓ SwiftUI View structure found"
fi
if grep -q "var body:" "$file"; then
    echo "  ✓ Body property found"
fi

# Check for balanced braces (basic)
open_braces=$(grep -o "{" "$file" | wc -l)
close_braces=$(grep -o "}" "$file" | wc -l)
if [ "$open_braces" -eq "$close_braces" ]; then
    echo "  ✓ Braces appear balanced ($open_braces pairs)"
else
    echo "  ❌ Brace mismatch: $open_braces open, $close_braces close"
fi

echo ""
echo "📊 File Stats:"
echo "  Lines: $(wc -l < "$file")"
echo "  Functions: $(grep -c "func " "$file")"
echo "  Properties: $(grep -c "var \|let " "$file")"

echo ""
echo "✅ Quick analysis complete!"
echo "💡 For full compilation check, use: xcodebuild -scheme YourScheme build"
