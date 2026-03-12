# HTML Presenter

A PowerPoint-style dual-screen presenter for HTML slide decks. Open in Chrome, load your deck, and present with speaker notes, timer, thumbnails, laser pointer, and synchronized animations on both screens.

**Zero dependencies. No server. No install. Just one HTML file.**

## Quick Start

1. Open `html_presenter.html` in Chrome
2. Drop an HTML slide deck onto the page (or click "browse")
3. Press **P** to enter dual-screen mode
4. Navigate with arrow keys or a USB clicker

## Features

| Feature | Description |
|---------|-------------|
| Dual-screen | Presenter view on laptop, audience display on projector |
| Current + next slide | See what's coming without the audience seeing it |
| Speaker notes | Pulled from `data-notes` attribute on each slide |
| Thumbnails | Horizontal strip at bottom, click to jump to any slide |
| Timer | Elapsed time, time on current slide, and wall clock |
| Annotations | Per-slide text notes, saved in localStorage across sessions |
| Laser pointer | Press **L** to toggle, move mouse over current slide to point |
| Interaction sync | Click Play/Pause/Reset in either window and the other stays in sync |
| Blackout | Press **B** to black out the projector screen |
| Resizable panels | Drag the divider between current slide and notes |
| Go-to-slide | Type a slide number and press Enter |
| Touch support | Swipe left/right on mobile or touchscreen |

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `→` `Space` `PageDown` | Next slide |
| `←` `PageUp` | Previous slide |
| `Home` / `End` | First / last slide |
| `F` | Fullscreen (non-Mac) / maximize (Mac) |
| `P` | Dual-screen presenter mode |
| `B` | Blackout (black screen on projector) |
| `L` | Toggle laser pointer (presenter only) |
| `G` | Focus go-to-slide input (presenter only) |
| `?` | Show shortcut help |
| `Escape` | Close help / exit fullscreen |

## Platform Handling

### macOS

Pressing **P** flips the windows: your current window becomes the presenter (notes, thumbnails, timer) and the audience display pops out as a separate window. Drag it to your projector and press **F** to maximize. This avoids native macOS fullscreen, which creates a separate Space and hides the other window.

For truly chromeless presenting (no address bar), use the shell script instead:

```bash
./present_dual.sh path/to/your_deck.html
```

This launches two Chrome `--app` windows with zero browser UI, synced via BroadcastChannel.

### Windows / Linux

Pressing **P** opens the presenter view as a popup. The main window stays as the audience display. Press **F** for native fullscreen on the projector.

## Slide Format

Decks should use `<section class="slide">` elements inside a scroll-snap container. For speaker notes, add `data-notes`:

```html
<main style="scroll-snap-type: y mandatory; overflow-y: scroll; height: 100vh;">

  <section class="slide" data-title="Introduction" data-notes="Introduce the team and project scope.">
    <h1>Welcome</h1>
    <p>Your content here</p>
  </section>

  <section class="slide" data-title="Demo" data-notes="Show the live dashboard.">
    <h2>Live Demo</h2>
    <iframe src="your_dashboard.html"></iframe>
  </section>

</main>
```

### What Gets Detected

The presenter auto-detects `<section class="slide">` elements. It also falls back to `<section>` or `<div>` elements with "slide" in their class name.

## Interaction Sync

Clicking any interactive element (Play, Pause, Reset, etc.) in either the main display or the presenter window automatically replays that click in the other window. This keeps Chart.js animations, D3 visualizations, and other JavaScript-driven content in sync across both screens.

Uses DOM selector matching for reliable targeting regardless of iframe size differences, with coordinate-based fallback.

## Presentation Template

`html_presentation_template.html` is a starter file for creating new decks. It includes 4 demo slides showing embedded apps, keyboard shortcuts, and the presenter workflow.

```bash
cp html_presentation_template.html my_talk.html
# Edit my_talk.html, add your slides
# Open in Chrome, press P for presenter view
```

## Files

| File | Description |
|------|-------------|
| `html_presenter.html` | The presenter app (open this in Chrome) |
| `html_presentation_template.html` | Starter template for new slide decks |
| `present_dual.sh` | macOS script for chromeless dual-screen presenting |

## Requirements

- Chrome (or any modern browser that supports `postMessage` and `BroadcastChannel`)
- No server, no Node.js, no npm, no build step

## License

MIT
