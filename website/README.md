# iFun Quiz – Promotional website

Static landing page to promote the iFun Quiz app.

## Setup

1. **Logo (optional)**  
   Copy the app logo into this folder so it appears in the hero:
   ```bash
   cp ../assets/images/logo.png img/logo.png
   ```
   If `img/logo.png` is missing, the hero still shows the app name and tagline.

2. **Run locally**  
   Open `index.html` in a browser, or serve the folder with any static server, e.g.:
   ```bash
   python3 -m http.server 8080
   ```
   Then visit `http://localhost:8080` (serve from the `website` directory).

## Deploy

The `website` folder is static HTML/CSS/JS. You can deploy it to:

- **GitHub Pages** – push the repo and enable Pages from the `website` folder or from `/docs` if you move it to `docs`.
- **Netlify / Vercel** – set the project root to `website` and publish.
- Any other static hosting.

## Links used

- App Store: `https://apps.apple.com/app/ifunquiz/id6758495643`
- Web app: `https://carapacik.github.io/WordlyPlus/`
- Contact: carapacik@gmail.com
