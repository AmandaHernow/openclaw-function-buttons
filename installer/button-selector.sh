#!/bin/bash
# Button selector helper for installer

LIBRARY_FILE="$1"

# Parse JSON file to extract buttons
parse_buttons() {
    local category="$1"
    local essential_only="$2"
    
    # Use python to parse JSON properly
    python3 -c "
import json
import sys

try:
    with open('$LIBRARY_FILE', 'r') as f:
        data = json.load(f)
    
    for button in data['buttons']:
        if button['category'] == '$category':
            if $essential_only and not button.get('essential', False):
                continue
            if not $essential_only and button.get('essential', False):
                continue
            
            print(f\"{button['name']}|{button['id']}\")
except Exception as e:
    print(f\"Error: {e}\", file=sys.stderr)
    sys.exit(1)
"
}

# Get essential buttons
get_essential_buttons() {
    parse_buttons "system" "True"
    parse_buttons "memory" "True"
    parse_buttons "communication" "True"
}

# Get optional buttons by category
get_optional_buttons() {
    local category="$1"
    parse_buttons "$category" "False"
}

# Test if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Essential buttons:"
    get_essential_buttons
    
    echo -e "\nOptional system buttons:"
    get_optional_buttons "system"
    
    echo -e "\nOptional memory buttons:"
    get_optional_buttons "memory"
    
    echo -e "\nOptional communication buttons:"
    get_optional_buttons "communication"
fi