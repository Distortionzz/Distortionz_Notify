local function GetDefaultTitle()
    if Config and Config.Notify and Config.Notify.defaultTitle then
        return Config.Notify.defaultTitle
    end

    return 'Distortionz'
end

local function GetDefaultType()
    if Config and Config.Notify and Config.Notify.defaultType then
        return Config.Notify.defaultType
    end

    return 'primary'
end

local function GetDefaultDuration()
    if Config and Config.Notify and Config.Notify.defaultDuration then
        return Config.Notify.defaultDuration
    end

    return 5000
end

local function IsAllowedType(notifyType)
    if not Config or not Config.Notify or not Config.Notify.allowedTypes then
        return notifyType == 'success'
            or notifyType == 'error'
            or notifyType == 'warning'
            or notifyType == 'info'
            or notifyType == 'primary'
            or notifyType == 'cash'
            or notifyType == 'police'
    end

    return Config.Notify.allowedTypes[notifyType] == true
end

local function NormalizeType(notifyType)
    notifyType = notifyType or GetDefaultType()

    if notifyType == 'inform' then
        notifyType = 'info'
    end

    if not IsAllowedType(notifyType) then
        notifyType = GetDefaultType()
    end

    return notifyType
end

local function PlayNotifySound(notifyType, soundEnabled)
    if soundEnabled == false then return end
    if not Config or not Config.Sound or not Config.Sound.enabled then return end

    notifyType = NormalizeType(notifyType)

    local soundData = Config.Sound.default

    if Config.Sound.useSoundPerType and Config.Sound.types and Config.Sound.types[notifyType] then
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
    duration = tonumber(duration) or GetDefaultDuration()
    title = title or GetDefaultTitle()

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