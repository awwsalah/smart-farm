# Beeralay App

**Beeralay** is an offline-first Flutter mobile app for Somali farmers. It helps users browse farming products, read local articles and news, check weather, and place marketplace orders — all with a Somali (Af-Soomaali) interface.

## Features

| Tab | Somali name | Description |
|-----|-------------|-------------|
| Home | Bogga Hore | Weather card, daily tips, popular products, support link |
| Resources | Khayraadka | Farming articles by category |
| News | Wararka | Local farming news |
| Marketplace | Suuqa | Product grid, cart, and order summary (phone/WhatsApp contact) |

### Offline-first

- Products, articles, news, and tips are stored locally in **SQLite**, seeded from bundled JSON on first launch.
- Images are bundled under `assets/images/`.
- Weather is the **only online feature** (Open-Meteo). Results are cached for offline viewing.

### Not included (by design)

- No login or user accounts
- No Firebase or cloud database
- No GPS / location permissions (weather uses preset Somali regions)

## Tech stack

- **Flutter** (Android + iOS)
- **provider** — state management
- **sqflite** — local database
- **http** — weather API only
- **flutter_animate** / **shimmer** — UI motion and loading states
- **url_launcher** — seller contact from order summary

## Project structure
