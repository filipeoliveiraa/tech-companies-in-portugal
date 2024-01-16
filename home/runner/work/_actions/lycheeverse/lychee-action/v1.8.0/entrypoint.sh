#!/bin/bash

set -e

LYCHEE_VERSION="v0.13.0"

# Function to handle network errors
handle_network_error() {
  local url="$1"
  echo "Network error: $url"
  exit 1
}

# Function to handle 404 errors
handle_404_error() {
  local url="$1"
  echo "404 error: $url"
  exit 1
}

# Update lychee version
LYCHEE_URL="https://github.com/lycheeverse/lychee/releases/download/$LYCHEE_VERSION/lychee-$LYCHEE_VERSION-x86_64-unknown-linux-gnu.tar.gz"
curl -sLO "$LYCHEE_URL"
tar -xvzf "lychee-$LYCHEE_VERSION-x86_64-unknown-linux-gnu.tar.gz"
rm "lychee-$LYCHEE_VERSION-x86_64-unknown-linux-gnu.tar.gz"
install -t "$HOME/.local/bin" -D lychee
rm lychee
echo "$HOME/.local/bin" >> "$GITHUB_PATH"

# Process URLs
while IFS= read -r url; do
  if ! curl -s --head "$url" >/dev/null; then
    handle_network_error "$url"
  fi

  if ! curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "404"; then
    handle_404_error "$url"
  fi

  # Process the URL further
  # ...
done < "$INPUT_URLS_FILE"
