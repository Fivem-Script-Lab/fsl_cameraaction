---@type {string: function[]}
local listeners<const> = {}

function AttachListener(name, cb)
    listeners[name] = listeners[name] or {}
    listeners[name][#listeners[name]+1] = cb
end

function FireEvent(name, ...)
    print('FiredEvent: ' .. name)
    for _,cb in ipairs(listeners[name] or {}) do
        cb(...)
    end
end

function RemoveListener(name, ref)
    for key,cb in ipairs(listeners[name] or {}) do
        if cb == ref then
            table.remove(listeners[name], key)
            return true
        end
    end
    return false
end

--- Linear Interpolation
function Lerp(a, b, t)
    return a + (b - a) * t
end

--- if any of the values is in the array, returns true
---@param array any[]
---@param values any[]
---@return boolean
function Contains(array, values)
    for i=1, #array do
        for j=1, #values do
            if array[i] == values[j] then
                return true
            end
        end
    end
    return false
end

---@param designated any
---@param values any[]
---@return boolean
function IsOneOf(designated, values)
    for i=1, #values do
        if designated == values[i] then
            return true
        end
    end
    return false
end

--- @param min number
--- @param max number
--- @param current number
--- @param add number
--- @return number
function WithinRange(min, max, current, add)
    current += add
    if current > max then
        return min
    end
    if current < min then
        return max
    end
    return current
end

function DrawText3Ds(text, x, y, z)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 460
	
	SetTextScale(0.3, 0.3)
	SetTextFont(6)
	SetTextProportional(true)
	SetTextColour(255, 255, 255, 160)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0115, 0.02 + factor, 0.027, 28, 28, 28, 95)
end

function SetCamMode(mode, real_max, override)
    mode = mode or ScriptData.Cam_Mode
    if ScriptData.Active and (override or ScriptData.Cam_Mode ~= C_MODE_LOCK) then
        ScriptData.Cam_Mode = WithinRange(C_MODE_MIN, real_max and C_MODE_REAL_MAX or C_MODE_MAX, mode, 0)
        local isFreecam = IsOneOf(mode, C_MODE_FREECAM_INPUT)
        local previousFreecam = IsOneOf(
            WithinRange(C_MODE_MIN, real_max and C_MODE_REAL_MAX or C_MODE_MAX, mode, -1),
            C_MODE_FREECAM_INPUT
        )
        if isFreecam then
            if previousFreecam then
                return
            else
                StartFreecam(ScriptData.Cam_Handler, GetCamCoord(ScriptData.Cam_Handler), {
                    onupdate = function (handler)
                        local rot = GetCamRot(handler, C_ROT_ORDER)
                        ScriptData.Cam_Rot_X = rot.x
                        ScriptData.Cam_Rot_Y = rot.y
                        ScriptData.Cam_Rot_Z = rot.z
                    end
                })
            end
        elseif previousFreecam then
            SetFreecamActive(false, nil, nil, nil)
        end
    end
end