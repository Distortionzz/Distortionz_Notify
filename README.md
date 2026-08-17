# Distortionz Notify

> Branded notification provider for FiveM — configurable types, durations, custom titles, a validated server API, and the clean glassy NUI used across the Distortionz stack.

![FiveM](https://img.shields.io/badge/FiveM-cerulean-yellow?style=flat-square&labelColor=181b20)
![Standalone](https://img.shields.io/badge/Standalone-no%20dependencies-brightgreen?style=flat-square&labelColor=181b20)
![License](https://img.shields.io/badge/License-MIT-brightgreen?style=flat-square)
![Version](https://img.shields.io/github/v/release/Distortionzz/Distortionz_Notify?style=flat-square&color=d4aa62&label=version)

---

## Overview

The notification provider every other distortionz script uses. Premium NUI with status sounds, configurable types, and a validated server-side notify API. Fully standalone — no framework required, works identically on Qbox, QBCore, ESX, and vMenu servers.

## Features

- 7 status types — primary, success, error, warning, info, cash, police
- Custom status sounds per type
- Configurable duration, title, and per-type styling
- Server-side notify API — single player, broadcast, or a list of players
- Client-side export
- All server input validated and clamped before it reaches the NUI
- HTML-escaped output, so a notification string can never inject markup
- Premium glassy NUI with slide-in animation, capped at 5 on screen

## Dependencies

None. This resource is fully standalone.

## Installation

```cfg
ensure distortionz_notify
```

Make sure this loads **before** any other distortionz_* script that calls its export.

## API

```lua
-- Client
exports.distortionz_notify:Notify(message, type, duration, title, sound)

-- Server — returns true if delivered
exports.distortionz_notify:Notify(playerSrc, message, type, duration, title, sound)

-- Server — every connected player
exports.distortionz_notify:NotifyAll(message, type, duration, title, sound)

-- Server — a list of players, returns how many were delivered
exports.distortionz_notify:NotifyMany({ 1, 4, 7 }, message, type, duration, title, sound)

-- Type: 'primary' | 'success' | 'error' | 'warning' | 'info' | 'cash' | 'police'
-- 'inform' is accepted as an alias for 'info'.
```

### Server-side validation

Every server call is normalised before it is sent:

| Field | Rule |
|---|---|
| `playerSrc` | Must be a currently connected player, else the call returns `false` |
| `message` | Truncated to `Config.Server.maxMessageLength` (200) on a UTF-8 boundary |
| `title` | Truncated to `Config.Server.maxTitleLength` (64) |
| `duration` | Clamped to 1000–30000 ms |
| `type` | Unknown types fall back to `Config.Notify.defaultType` |

## Testing

```
/testnotify          -- client, cycles every type
/testnotifynosound   -- client, silent
/testnotifyserver    -- server export; from console it broadcasts to everyone
```

`/testnotifyserver` is ACE-restricted in-game:

```cfg
add_ace group.admin command.testnotifyserver allow
```

## Configuration

See [`config.lua`](config.lua) for sound enable, default duration, default title, per-type sounds, and the server-side limits.

## Credits

- **Author:** Distortionz

## License

MIT — see [LICENSE](LICENSE).
