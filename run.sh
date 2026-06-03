#!/bin/bash

# Meta Agent Launch Script
# Runs Pi Agent with Meta Agent configurations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/meta-agent-config"
PI_DIR="$SCRIPT_DIR/pi"

# Check if pi directory exists
if [ ! -d "$PI_DIR" ]; then
    echo "Error: pi directory not found at $PI_DIR"
    echo "Please clone Pi Agent into the 'pi' folder:"
    echo "  git clone https://github.com/earendil-works/pi.git pi"
    exit 1
fi

# Check if pi-test.sh exists
if [ ! -f "$PI_DIR/pi-test.sh" ]; then
    echo "Error: pi-test.sh not found at $PI_DIR/pi-test.sh"
    exit 1
fi

# Check if config.json exists
if [ ! -f "$CONFIG_DIR/config.json" ]; then
    echo "Error: config.json not found at $CONFIG_DIR/config.json"
    exit 1
fi

# Build the pi command
CMD="$PI_DIR/pi-test.sh"

# Load extensions
while IFS= read -r ext; do
    if [ -n "$ext" ]; then
        CMD="$CMD -e \"$CONFIG_DIR/$ext\""
    fi
done < <(jq -r '.extensions[]' "$CONFIG_DIR/config.json" 2>/dev/null)

# Load skills
while IFS= read -r skill; do
    if [ -n "$skill" ]; then
        CMD="$CMD --skill \"$CONFIG_DIR/$skill\""
    fi
done < <(jq -r '.skills[]' "$CONFIG_DIR/config.json" 2>/dev/null)

# Load prompts (as extra system prompt)
while IFS= read -r prompt; do
    if [ -n "$prompt" ]; then
        CMD="$CMD --prompt \"$CONFIG_DIR/$prompt\""
    fi
done < <(jq -r '.prompts[]' "$CONFIG_DIR/config.json" 2>/dev/null)

# Run the command
eval $CMD