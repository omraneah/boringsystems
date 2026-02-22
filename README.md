# Boring Systems

Personal site for Ahmed Omrane — engineering leadership case files and frameworks.

Built with [Astro](https://astro.build). Deployed on [Vercel](https://vercel.com).

## Commands

| Command           | Action                                      |
| :---------------- | :------------------------------------------ |
| `npm install`     | Install dependencies                        |
| `npm run dev`     | Start local dev server at `localhost:4321`  |
| `npm run build`   | Build production site to `./dist/`          |
| `npm run preview` | Preview build locally before deploying      |

## Deployment

Deployments are done manually via CLI (no auto-deploy from GitHub):

```sh
npx vercel --prod
```

## Color Palette

All colors are defined as CSS custom properties in `src/styles/global.css`.

| Variable        | Hex       | Usage                                      |
| :-------------- | :-------- | :----------------------------------------- |
| `--bg`          | `#0a0a0a` | Page background                            |
| `--bg-elevated` | `#111111` | Cards, code blocks                         |
| `--border`      | `#1e1e1e` | Dividers, borders, footer separators       |
| `--text`        | `#e8e6e1` | Primary text                               |
| `--text-muted`  | `#6b6b6b` | Secondary text (nav links, meta, footer)   |
| `--accent`      | `#c8a96e` | Links, highlights, card hover borders      |
| `--accent-dim`  | `#8a7248` | Card left border (default state)           |

To change the color scheme, update these variables in `src/styles/global.css`. Make sure all seven values are consistent with each other — changing the background requires revisiting all other tokens.
