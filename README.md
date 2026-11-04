# Lumina

Flutter UI for the Lumina home, journal, and insights screens. Data is local. A Dio client is registered and ready, and no screen calls it yet.

## Run

```bash
flutter pub get
flutter run
```

The app opens on Home. Pass `showSplashOnLaunch: true` to `LuminaApp` to start on the splash route instead.

```bash
flutter test
```

New images under `assets/images/` need a full restart. Hot reload does not pick them up.

## Layout

```
lib/
  core/          theme, routes, constants, GetIt, Dio client
  features/
    home/        data, domain, presentation
    journal/
    insights/
    goals/       presentation only (Coming soon)
    shell/       bottom navigation
    splash/
```

Each feature with real data uses the same three layers:

- **domain** — entities, repository contracts, use cases
- **data** — models, local sources, repository implementations
- **presentation** — Bloc, pages, widgets

## Screens

| Route | Screen |
| --- | --- |
| `/splash` | Brand intro. Not the default launch route. |
| `/home` | Greeting, zodiac timer, horoscope, numerology, journal cover |
| `/goals` | Coming soon |
| `/journal` | Cover flip, month filter, entries |
| `/insights` | Period tabs, destiny, horoscope, lucky stats |

`go_router` keeps a separate stack for each tab. An unknown path shows the not-found page.

## State

`GetIt` owns the process-wide repositories, use cases, and `ApiService`. Each tab route creates its own Bloc and closes it with the route.

- `HomeBloc` — profile and home horoscope
- `JournalBloc` — selected month and entries
- `InsightsBloc` — selected period and insights content

Home greeting uses **Saniya**. Insights uses **Gilli Gaurav Singh**. Those names come from the designs.

## API

`lib/core/network/api_service.dart` wraps Dio. It supports GET, POST, PUT, PATCH, DELETE, and multipart POST, PUT, and PATCH. Interceptors cover auth (when a token reader is supplied), debug logging, and `ApiException`.

Set the host in `AppConstants.apiBaseUrl` before calling `getIt<ApiService>()`.
