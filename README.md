# Distortionz Notify

> Branded notification provider for Qbox/FiveM — configurable types, durations, custom titles, ox_lib fallback, and the clean glassy NUI used across the Distortionz stack.

![FiveM](https://img.shields.io/badge/FiveM-cerulean-yellow?style=flat-square&labelColor=181b20)
![Qbox](https://img.shields.io/badge/Qbox-required-red?style=flat-square&labelColor=dfb317)
![License](https://img.shields.io/badge/License-MIT-brightgreen?style=flat-square)
![Version](https://img.shields.io/github/v/release/Distortionzz/Distortionz_Notify?style=flat-square&color=d4aa62&label=version)

---

## Overview

The notification provider every other distortionz script uses. Premium NUI with status sounds, configurable types, and a server-side notify API. Falls back to `ox_lib.notify` when not present so other scripts remain functional.

## Features

- 6 status types — success, error, warning, info, cash, police
- Custom status sounds per type
- Configurable duration, title, position
- Server-side notify API (`exports.distortionz_notify:Notify(src, ...)`)
- Client-side export (`exports.distortionz_notify:Notify(message, type, duration, title)`)
- Premium glassy NUI with slide-in animation
- Used across the Distortionz ecosystem

## Dependencies

| Resource | Required | Purpose |
|---|---|---|
| `qbx_core` | yes | Player context |
| `ox_lib` | yes | Fallback notify |

## Installation

```cfg
ensure distortionz_notify
```

Make sure this loads **before** any other distortionz_* script that calls its export.

## API

```lua
-- Client
exports.distortionz_notify:Notify(message, type, duration, title)

-- Server
exports.distortionz_notify:Notify(playerSrc, message, type, duration, title)

-- Type values: 'success' | 'error' | 'warning' | 'info' | 'cash' | 'police'
```

## Configuration

See [`config.lua`](config.lua) for sound enable, default duration, default title, and per-type style overrides.

## Credits

- **Author:** Distortionz
- **Framework:** [Qbox Project](https://github.com/Qbox-project)

## License

MIT — see [LICENSE](LICENSE).
