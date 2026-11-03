# Flyer ID PWA

A digital copy of your UK CAA drone Flyer ID. It works offline once installed. Your details are kept in the phone's local storage and are never uploaded.

## Files
- `index.html`: the whole app (form, card, full-screen view, SVG import and export)
- `card-bg.jpg`: the card background taken from the official `flyer-id.svg`
- `sw.js`: the service worker that caches everything for offline use. Bump `VERSION` after you change any file.
- `manifest.webmanifest` and `icons/`: what the phone needs to install the app

## Run locally
    python3 -m http.server 8765 -d flyer-id-pwa

## Put it on your phone
A service worker only works over HTTPS, so host the folder somewhere static, for example GitHub Pages, Netlify Drop or Cloudflare Pages. Then:
- **iPhone (Safari):** open the URL, tap Share, then Add to Home Screen
- **Android (Chrome):** open the URL, tap ⋮, then Install app

Open it once while you're online. After that it works with no signal.

## Using it
- Type in the details from your official Flyer ID, or use **Import the official SVG file** to fill them in automatically.
- Tap the card to show it full screen. It turns to landscape and keeps the screen awake where the phone allows it.
- A banner warns you when the ID has less than 60 days left, and again once it has expired.
