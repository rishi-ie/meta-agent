#!/bin/bash

# Meta Agent Launch Script
# All state stored locally in .pi folder

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/meta-agent-config"
PI_DIR="$SCRIPT_DIR/pi"
LOCAL_PI_DIR="$SCRIPT_DIR/.pi"

# Check if pi directory exists, clone if missing
if [ ! -d "$PI_DIR" ]; then
    echo "Cloning Pi Agent..."
    git clone https://github.com/earendil-works/pi.git "$PI_DIR"
    cd "$PI_DIR" && npm install && cd "$SCRIPT_DIR"
fi

# Check if pi-test.sh exists
if [ ! -f "$PI_DIR/pi-test.sh" ]; then
    echo "Error: pi-test.sh not found at $PI_DIR/pi-test.sh"
    exit 1
fi

# Create local .pi directory structure
mkdir -p "$LOCAL_PI_DIR/agent/sessions"
mkdir -p "$LOCAL_PI_DIR/agent/bin"
mkdir -p "$LOCAL_PI_DIR/agent/prompts"

# Copy local settings if they don't exist (or if source is newer)
if [ -f "$CONFIG_DIR/settings.json" ]; then
    if [ ! -f "$LOCAL_PI_DIR/agent/settings.json" ] || \
       [ "$CONFIG_DIR/settings.json" -nt "$LOCAL_PI_DIR/agent/settings.json" ]; then
        cp "$CONFIG_DIR/settings.json" "$LOCAL_PI_DIR/agent/settings.json"
    fi
fi

# Copy auth.json if it exists and local doesn't
if [ -f "$CONFIG_DIR/auth.json" ] && [ ! -f "$LOCAL_PI_DIR/agent/auth.json" ]; then
    cp "$CONFIG_DIR/auth.json" "$LOCAL_PI_DIR/agent/auth.json"
fi

# Set environment variables to use local folder
export PI_CODING_AGENT_DIR="$LOCAL_PI_DIR/agent"
export PI_CODING_AGENT_SESSION_DIR="$LOCAL_PI_DIR/agent/sessions"

# Add local bin to PATH (for fd, ripgrep, etc.)
export PATH="$LOCAL_PI_DIR/agent/bin:$PATH"

# Build the pi command
CMD="$PI_DIR/pi-test.sh"

# Load extensions
if [ -f "$CONFIG_DIR/config.json" ]; then
    while IFS= read -r ext; do
        if [ -n "$ext" ]; then
            CMD="$CMD -e \"$CONFIG_DIR/$ext\""
        fi
    done < <(jq -r '.extensions[]' "$CONFIG_DIR/config.json" 2>/dev/null)

    # Load skills (--skill flag)
    while IFS= read -r skill; do
        if [ -n "$skill" ]; then
            CMD="$CMD --skill \"$CONFIG_DIR/$skill\""
        fi
    done < <(jq -r '.skills[]' "$CONFIG_DIR/config.json" 2>/dev/null)

    # Load prompts (as extra system prompt)
    while IFS= read -r prompt; do
        if [ -n "$prompt" ]; then
            CMD="$CMD --append-system-prompt \"$CONFIG_DIR/$prompt\""
        fi
    done < <(jq -r '.prompts[]' "$CONFIG_DIR/config.json" 2>/dev/null)
fi

# Run the command
eval $CMD