#!/bin/bash

# Swift Code Analysis Script for Claude Code
# Usage: ./swift_analyze.sh [file.swift] or ./swift_analyze.sh (for all Swift files)

set -e

PROJECT_ROOT="/Users/vignesh/Developer/LoanCraft"
cd "$PROJECT_ROOT"

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Swift Code Analysis${NC}"
echo "================================"

# Function to analyze a single Swift file
analyze_file() {
    local file="$1"
    echo -e "\n${BLUE}Analyzing: $file${NC}"

    # Basic syntax check
    if swiftc -typecheck "$file" 2>/tmp/swift_errors.txt; then
        echo -e "${GREEN}✅ Syntax OK${NC}"
    else
        echo -e "${RED}❌ Syntax Errors:${NC}"
        cat /tmp/swift_errors.txt
    fi

    # Check for common issues with swift-format if available
    if command -v swift-format >/dev/null 2>&1; then
        echo -e "${YELLOW}📝 Format suggestions:${NC}"
        swift-format --mode diff "$file" || echo "No format changes needed"
    fi

    # Static analysis warnings
    echo -e "${YELLOW}⚠️  Potential issues:${NC}"

    # Check for force unwraps
    if grep -n "!" "$file" | grep -v "//" | grep -v "func\|var\|let.*=" >/dev/null 2>&1; then
        echo -e "${YELLOW}  - Force unwraps found (consider using optional binding):${NC}"
        grep -n "!" "$file" | grep -v "//" | grep -v "func\|var\|let.*=" | head -3
    fi

    # Check for force casts
    if grep -n " as! " "$file" >/dev/null 2>&1; then
        echo -e "${YELLOW}  - Force casts found (consider using 'as?'):${NC}"
        grep -n " as! " "$file" | head -3
    fi

    # Check for TODO/FIXME
    if grep -n -i "todo\|fixme" "$file" >/dev/null 2>&1; then
        echo -e "${YELLOW}  - TODO/FIXME comments:${NC}"
        grep -n -i "todo\|fixme" "$file"
    fi

    # Check for print statements (might be debug code)
    if grep -n "print(" "$file" | grep -v "//" >/dev/null 2>&1; then
        echo -e "${YELLOW}  - Print statements found (debug code?):${NC}"
        grep -n "print(" "$file" | grep -v "//" | head -3
    fi
}

# If specific file provided, analyze it
if [ $# -eq 1 ]; then
    if [ -f "$1" ]; then
        analyze_file "$1"
    else
        echo -e "${RED}Error: File '$1' not found${NC}"
        exit 1
    fi
else
    # Find and analyze all Swift files in the project
    echo "Scanning for Swift files..."
    find . -name "*.swift" -not -path "./DerivedData/*" -not -path "./.build/*" | while read -r file; do
        analyze_file "$file"
    done
fi

echo -e "\n${GREEN}Analysis complete!${NC}"
