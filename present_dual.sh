#!/bin/bash
# present_dual.sh — Mac dual-screen presenter with no browser chrome
#
# Opens two chromeless Chrome --app windows:
#   1. Presenter (laptop)  — notes, thumbnails, timer, controls
#   2. Display  (projector) — slides only, no Chrome UI
#
# Both windows sync navigation, blackout, laser, and click events
# via BroadcastChannel. Press F in the display window to maximize
# (fills screen with zero Chrome UI, no macOS Spaces conflict).
#
# Usage:
#   ./present_dual.sh <deck.html>
#   ./present_dual.sh                  (opens macOS file picker)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PRESENTER_HTML="$SCRIPT_DIR/html_presenter.html"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

if [ ! -x "$CHROME" ]; then
  echo "Error: Google Chrome not found at $CHROME"
  exit 1
fi

if [ ! -f "$PRESENTER_HTML" ]; then
  echo "Error: html_presenter.html not found at $PRESENTER_HTML"
  exit 1
fi

FILE="$1"

if [ -n "$FILE" ]; then
  # Resolve to absolute path
  [[ "$FILE" != /* ]] && FILE="$(cd "$(dirname "$FILE")" && pwd)/$(basename "$FILE")"

  if [ ! -f "$FILE" ]; then
    echo "Error: File not found: $FILE"
    exit 1
  fi
else
  # No argument — open a file picker via AppleScript
  FILE=$(osascript -e 'POSIX path of (choose file of type {"html","htm"} with prompt "Select an HTML slide deck")')
  if [ -z "$FILE" ]; then
    echo "No file selected."
    exit 0
  fi
fi

DECK_URL="file://$FILE"
BASE_URL="file://$PRESENTER_HTML"

echo "Opening dual-screen presenter..."
echo "  Deck:      $FILE"
echo "  Presenter: laptop screen (notes, thumbnails, timer)"
echo "  Display:   drag to projector, press F to maximize"

# Force a separate Chrome instance so --allow-file-access-from-files is respected
# (flags are ignored when added to an already-running Chrome process).
# Uses a dedicated profile dir so annotations/localStorage persist between sessions.
PROFILE_DIR="$HOME/.html-presenter-profile"
CHROME_FLAGS="--user-data-dir=$PROFILE_DIR --allow-file-access-from-files --no-first-run --no-default-browser-check"

# Launch display window first (audience sees slides)
"$CHROME" $CHROME_FLAGS --app="$BASE_URL?mode=display&deck=$DECK_URL" &

# Brief pause so Chrome registers the first window
sleep 1

# Launch presenter window (speaker sees notes + controls)
"$CHROME" $CHROME_FLAGS --app="$BASE_URL?mode=presenter&deck=$DECK_URL" &

echo ""
echo "Both windows launched. Drag the display window to your"
echo "external screen and press F to fill the screen."
