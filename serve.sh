#!/bin/bash
# Local development server script

cd "$(dirname "$0")"

BUNDLE_PATH="$HOME/.local/share/gem/ruby/3.2.0/bin/bundle"

echo "Starting Jekyll development server..."
echo "Access the site at: http://localhost:4000"
echo "Press Ctrl+C to stop"
echo ""

# Run Jekyll and filter out Sass deprecation warnings (they're from the theme)
$BUNDLE_PATH exec jekyll serve --host 0.0.0.0 --port 4000 --watch 2>&1 | \
  grep -v "DEPRECATION WARNING" | \
  grep -v "More info and automated" | \
  grep -v "sass-lang.com" | \
  grep -v "╷" | \
  grep -v "│" | \
  grep -v "╵" | \
  grep -v "minimal-mistakes" | \
  grep -v "root stylesheet" | \
  grep -v "repetitive deprecation" | \
  grep -v "Suggestion:" | \
  grep -v "color.channel" | \
  grep -v "color.mix"
