local defaultTitle = 'Distortionz'
local defaultType = 'primary'
local defaultDuration = 5000

local allowedTypes = {
    success = true,
    error = true,
    warning = true,
    info = true,
    primary = true,
    cash = true,
    police = true
}

local Config = {}

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

local function NormalizeType(notifyType)
    notifyType = notifyType or defaultType

    if notifyType == 'inform' then
        notifyType = 'info'
    end

    if not allowedTypes[notifyType] then
        notifyType = defaultType
    end

    return notifyType
end

local function PlayNotifySound(notifyType, soundEnabled)
    if soundEnabled == false then return end
    if not Config.Sound.enabled then return end

    notifyType = NormalizeType(notifyType)

    local soundData = Config.Sound.default

    if Config.Sound.useSoundPerType and Config.Sound.types[notifyType] then
        soundData = Config.Sound.types[notifyType]
    end

    if not soundData or not soundData.soundName or not soundData.soundSet then return end

    PlaySoundFrontend(
        -1,
        soundData.soundName,
        soundData.soundSet,
        true
    )
end

local function Notify(message, notifyType, duration, title, soundEnabled)
    if not message then return end

    notifyType = NormalizeType(notifyType)
    duration = tonumber(duration) or defaultDuration
    title = title or defaultTitle

    PlayNotifySound(notifyType, soundEnabled)

    SendNUIMessage({
        action = 'notify',
        data = {
            title = title,
            message = tostring(message),
            type = notifyType,
            duration = duration
        }
    })
end

exports('Notify', Notify)

RegisterNetEvent('distortionz_notify:client:notify', function(data)
    if type(data) ~= 'table' then return end

    Notify(
        data.message or data.description or data.text,
        data.type or data.notifyType,
        data.duration,
        data.title,
        data.sound
    )
end)

RegisterCommand('testnotify', function()
    Notify('Primary Distortionz notification.', 'primary', 5000, 'Distortionz Notify')

    Wait(700)

    Notify('Action completed successfully.', 'success', 5000, 'Success')

    Wait(700)

    Notify('Something went wrong.', 'error', 5000, 'Error')

    Wait(700)

    Notify('Be careful with this action.', 'warning', 5000, 'Warning')

    Wait(700)

    Notify('This is an information message.', 'info', 5000, 'Information')

    Wait(700)

    Notify('You received $1,250.', 'cash', 5000, 'Payment Received')

    Wait(700)

    Notify('Suspicious activity reported nearby.', 'police', 5000, 'Dispatch')
end, false)

RegisterCommand('testnotifynosound', function()
    Notify('This notification has no sound.', 'primary', 5000, 'Silent Notify', false)
end, false)