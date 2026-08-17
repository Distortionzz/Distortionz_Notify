-- =====================================================================
--  Distortionz Notify — server API
--  Every value that reaches a client's NUI is validated and clamped here.
--  Callers are trusted resources, but a buggy caller must not be able to
--  push an unbounded string or a 10-minute notification into the UI.
-- =====================================================================

local CLIENT_EVENT = 'distortionz_notify:client:notify'

local DEFAULTS = {
    maxMessageLength = 200,
    maxTitleLength   = 64,
    minDuration      = 1000,
    maxDuration      = 30000
}

-- ─── Helpers ────────────────────────────────────────────────────────

local function GetLimit(key)
    local limits = Config and Config.Server
    return limits and tonumber(limits[key]) or DEFAULTS[key]
end

--- Cuts a string to a byte length without slicing a UTF-8 sequence in half,
--- which would otherwise render as a replacement glyph in the NUI.
local function Truncate(text, maxLength)
    if #text <= maxLength then return text end

    local cut = maxLength

    while cut > 0 do
        local nextByte = text:byte(cut + 1)

        if not nextByte or nextByte < 0x80 or nextByte >= 0xC0 then
            break
        end

        cut = cut - 1
    end

    return text:sub(1, cut)
end

local function IsAllowedType(notifyType)
    local allowed = Config and Config.Notify and Config.Notify.allowedTypes

    if not allowed then
        return notifyType == 'success'
            or notifyType == 'error'
            or notifyType == 'warning'
            or notifyType == 'info'
            or notifyType == 'primary'
            or notifyType == 'cash'
            or notifyType == 'police'
    end

    return allowed[notifyType] == true
end

local function NormalizeType(notifyType)
    local fallback = Config and Config.Notify and Config.Notify.defaultType or 'primary'

    if notifyType == 'inform' then
        notifyType = 'info'
    end

    if type(notifyType) ~= 'string' or not IsAllowedType(notifyType) then
        return fallback
    end

    return notifyType
end

local function NormalizeDuration(duration)
    local value = tonumber(duration)

    if not value then
        return Config and Config.Notify and Config.Notify.defaultDuration or 5000
    end

    local min, max = GetLimit('minDuration'), GetLimit('maxDuration')

    if value < min then return min end
    if value > max then return max end

    return value
end

local function BuildPayload(message, notifyType, duration, title, soundEnabled)
    if message == nil then return nil end

    local defaultTitle = Config and Config.Notify and Config.Notify.defaultTitle or 'Distortionz'

    return {
        message  = Truncate(tostring(message), GetLimit('maxMessageLength')),
        title    = Truncate(tostring(title or defaultTitle), GetLimit('maxTitleLength')),
        type     = NormalizeType(notifyType),
        duration = NormalizeDuration(duration),
        sound    = soundEnabled ~= false
    }
end

--- A player id is only usable if that slot is actually occupied. GetPlayerName
--- returns nil for a disconnected or never-connected id, which also guards
--- against a caller passing a citizenid or a stale source.
local function ResolveTarget(playerSrc)
    local src = tonumber(playerSrc)

    if not src or src <= 0 then return nil end
    if not GetPlayerName(src) then return nil end

    return src
end

-- ─── Public API ─────────────────────────────────────────────────────

--- Notify a single player.
--- @return boolean delivered
local function Notify(playerSrc, message, notifyType, duration, title, soundEnabled)
    local src = ResolveTarget(playerSrc)
    if not src then return false end

    local payload = BuildPayload(message, notifyType, duration, title, soundEnabled)
    if not payload then return false end

    TriggerClientEvent(CLIENT_EVENT, src, payload)

    return true
end

--- Notify every connected player.
local function NotifyAll(message, notifyType, duration, title, soundEnabled)
    local payload = BuildPayload(message, notifyType, duration, title, soundEnabled)
    if not payload then return false end

    TriggerClientEvent(CLIENT_EVENT, -1, payload)

    return true
end

--- Notify a list of players. Builds the payload once and reuses it, so a
--- 30-player police alert costs one validation pass, not thirty.
--- @return number delivered count
local function NotifyMany(targets, message, notifyType, duration, title, soundEnabled)
    if type(targets) ~= 'table' then return 0 end

    local payload = BuildPayload(message, notifyType, duration, title, soundEnabled)
    if not payload then return 0 end

    local delivered = 0

    for i = 1, #targets do
        local src = ResolveTarget(targets[i])

        if src then
            TriggerClientEvent(CLIENT_EVENT, src, payload)
            delivered = delivered + 1
        end
    end

    return delivered
end

exports('Notify', Notify)
exports('NotifyAll', NotifyAll)
exports('NotifyMany', NotifyMany)

-- ─── Admin test command ─────────────────────────────────────────────
-- Registered as restricted, so FiveM gates it behind the
-- `command.testnotifyserver` ACE for players. Console is always allowed.

RegisterCommand('testnotifyserver', function(source)
    if source == 0 then
        NotifyAll('Server-wide test notification.', 'info', 5000, 'Distortionz Notify')
        print(('^5[%s]^7 ^2Broadcast test notification sent.^7'):format(GetCurrentResourceName()))
        return
    end

    Notify(source, 'Server export is working.', 'success', 5000, 'Distortionz Notify')
end, true)

CreateThread(function()
    Wait(1000)
    print(('^5[%s]^7 ^2v%s loaded — maxMessage=%d maxDuration=%dms^7'):format(
        GetCurrentResourceName(),
        Config.CurrentVersion,
        GetLimit('maxMessageLength'),
        GetLimit('maxDuration')
    ))
end)
