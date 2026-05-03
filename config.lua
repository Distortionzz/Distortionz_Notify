Config = Config or {}

Config.Script = {
    name = 'Distortionz Notify',
    version = '1.0.3'
}

Config.VersionCheck = {
    enabled      = true,
    checkOnStart = true,
    url          = 'https://raw.githubusercontent.com/Distortionzz/Distortionz_Notify/main/version.json',
}
Config.CurrentVersion = '1.0.3'

Config.Notify = {
    defaultTitle = 'Distortionz',
    defaultType = 'primary',
    defaultDuration = 5000,

    allowedTypes = {
        success = true,
        error = true,
        warning = true,
        info = true,
        primary = true,
        cash = true,
        police = true
    }
}

Config.Sound = {
    enabled = true,

    -- Set this to false if you want one universal sound for every notification.
    useSoundPerType = true,

    default = {
        soundName = 'NAV_UP_DOWN',
        soundSet = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
    },

    types = {
        primary = {
            soundName = 'NAV_UP_DOWN',
            soundSet = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
        },

        success = {
            soundName = 'CHECKPOINT_PERFECT',
            soundSet = 'HUD_MINI_GAME_SOUNDSET'
        },

        error = {
            soundName = 'ERROR',
            soundSet = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
        },

        warning = {
            soundName = 'ATM_WINDOW',
            soundSet = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
        },

        info = {
            soundName = 'SELECT',
            soundSet = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
        },

        cash = {
            soundName = 'PICK_UP',
            soundSet = 'HUD_FRONTEND_DEFAULT_SOUNDSET'
        },

        police = {
            soundName = 'TIMER_STOP',
            soundSet = 'HUD_MINI_GAME_SOUNDSET'
        }
    }
}