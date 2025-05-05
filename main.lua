-- dev

--- @class Overload
--- @field params string[]
--- @field cb function

--- @type {string: Overload[]}
local overloaded_functions<const> = {}
--- @type {string: function}
local overloaded_references<const> = {}
local _type = type

---@param name string
---@param params string[]
---@param cb function
function Overload(name, params, cb)
    if _G[name] then
        if not overloaded_functions[name] then
            overloaded_functions[name] = {}
            overloaded_references[name] = _G[name]
            _G[name] = function(...)
                local args = {...}
                local ref = overloaded_functions[name]
                for key, value in ipairs(args) do
                    local pass = true
                    local index
                    for i=1, #ref do
                        if _type(value) ~= ref[i].params[key] then
                            pass = false
                            break
                        end
                        index = i
                    end
                    if pass then
                        overloaded_references[name](ref[index].cb(...))
                    end
                end
            end
        end
        overloaded_functions[name][#overloaded_functions[name] + 1] = {
            params = params,
            cb = cb
        }
    end
end

---@type {string: function[]}
local listeners<const> = {}

function AttachListener(name, cb)
    listeners[name] = listeners[name] or {}
    listeners[name][#listeners[name]+1] = cb
end

function FireEvent(name, ...)
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

--- Camera Creation

--- @class CamData
--- @field coords vector3
--- @field rot vector3|nil order of rot -> 2
--- @field fov number|nil
--- @field handler number|nil
local CamData = {}

-- Constants
C_IMG_ENCODING = "jpg"
C_IMG_QUALITY = 0.50

C_ROT_ORDER = 2
C_ROT_X_MIN = -180.0
C_ROT_X_MAX = 180.0
C_ROT_Y_MIN = -180.0
C_ROT_Y_MAX = 180.0
C_ROT_Z_MIN = -180.0
C_ROT_Z_MAX = 180.0
C_FOV_MIN = 10
C_FOV_MAX = 120

C_CAM_DEFAULT_FOV = 90.0

C_MODE_MIN = 0
C_MODE_MAX = 2 -- C_MODE_LOCK should not be able to be overwritten by user
C_MODE_REAL_MAX = 3
C_MODE_KEYBOARD = 0
C_MODE_FREECAM = 1
C_MODE_KEYBOARD_FREECAM = 2
C_MODE_LOCK = 3

C_MODE_KEYBOARD_INPUT = {
    C_MODE_KEYBOARD,
    C_MODE_KEYBOARD_FREECAM
}

C_ZERO_VEC3 = vec3(0.0, 0.0, 0.0)

ScriptData = {
    Active = false, -- active HUD
    -- camera handler
    Cam_Handler = 0,
    -- states of input
    Rot_X = 0,
    Rot_Y = 0,
    Rot_Z = 0,
    Fov = 0,
    -- amount of rotation applied
    Rot_X_Value = 1,
    Rot_Y_Value = 1,
    Rot_Z_Value = 1,
    -- current cam data
    Cam_Rot_X = 0.0,
    Cam_Rot_Y = 0.0,
    Cam_Rot_Z = 0.0,
    Cam_Fov = 90.0,
    -- current cam mode; 0-manual rotation; 1-free roam; 2-manual rotation+free roam
    Cam_Mode = 0
}
local ScriptData = ScriptData

--- if any of the values is in the array, returns true
---@param array any[]
---@param values any[]
---@return boolean
local function contains(array, values)
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
local function isOneOf(designated, values)
    for i=1, #values do
        if designated == values[i] then
            return true
        end
    end
    return false
end

---
--- @param min number
--- @param max number
--- @param current number
--- @param add number
--- @return number
local function withinRange(min, max, current, add)
    current += add
    if current > max then
        return min
    end
    if current < min then
        return max
    end
    return current
end

---@param data CamData
---@return CamData
function CreateCamera(data)
    local x,y,z = table.unpack(data.coords)
    local rot_x,rot_y,rot_z = table.unpack(data.rot or C_ZERO_VEC3)
    local fov = data.fov or C_CAM_DEFAULT_FOV

    local camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, rot_x, rot_y, rot_z, fov, false, C_ROT_ORDER)
    local cam_data = {
        handler = camera,
        coords = data.coords,
        fov = fov,
        rot = data.rot
    }
    return cam_data
end

---@param handler any
---@return CamData
function GetCameraDataFromHandler(handler)
    local cam_data = {
        coords = GetCamCoord(handler),
        rot = GetCamRot(handler, C_ROT_ORDER),
        fov = GetCamFov(handler),
        handler = handler
    }

    return cam_data
end

function StartHUD()
    if ScriptData.Active then
        print("DestroyedCam")
        DestroyCam(ScriptData.Cam_Handler, true)
        RenderScriptCams(false, false, 0, false, false)
        ScriptData.Active = false
        return
    end
    ScriptData.Active = true
    CreateThread(function()
        local script_data = ScriptData
        script_data.Cam_Handler = CreateCamera({
            coords = GetEntityCoords(PlayerPedId())
        }).handler
        SetCamActive(script_data.Cam_Handler, true)
        RenderScriptCams(true, true, 500, false, true)
        local changed = false
        while script_data.Active do
            Wait(0)
            SetEntityLocallyInvisible(PlayerPedId(),true)
            if script_data.Cam_Mode ~= C_MODE_LOCK then
                if (isOneOf(script_data.Cam_Mode, C_MODE_KEYBOARD_INPUT)) then
                    if script_data.Rot_X == 1 then
                        script_data.Cam_Rot_X = withinRange(C_ROT_X_MIN, C_ROT_X_MAX, ScriptData.Cam_Rot_X, ScriptData.Rot_X_Value)
                        changed = true
                    elseif script_data.Rot_X == 2 then
                        script_data.Cam_Rot_X = withinRange(C_ROT_X_MIN, C_ROT_X_MAX, ScriptData.Cam_Rot_X, -ScriptData.Rot_X_Value)
                        changed = true
                    end
                    if script_data.Rot_Y == 1 then
                        script_data.Cam_Rot_Y = withinRange(C_ROT_Y_MIN, C_ROT_Y_MAX, ScriptData.Cam_Rot_Y, ScriptData.Rot_Y_Value)
                        changed = true
                    elseif script_data.Rot_Y == 2 then
                        script_data.Cam_Rot_Y = withinRange(C_ROT_Y_MIN, C_ROT_Y_MAX, ScriptData.Cam_Rot_Y, -ScriptData.Rot_Y_Value)
                        changed = true
                    end
                    if script_data.Rot_Z == 1 then
                        script_data.Cam_Rot_Z = withinRange(C_ROT_Z_MIN, C_ROT_Z_MAX, ScriptData.Cam_Rot_Z, ScriptData.Rot_Z_Value)
                        changed = true
                    elseif script_data.Rot_Z == 2 then
                        script_data.Cam_Rot_Z = withinRange(C_ROT_Z_MIN, C_ROT_Z_MAX, ScriptData.Cam_Rot_Z, -ScriptData.Rot_Z_Value)
                        changed = true
                    end
                    if changed then
                        if script_data.Cam_Mode == C_MODE_KEYBOARD_FREECAM then
                            SetFreecamRotation(script_data.Cam_Rot_X, script_data.Cam_Rot_Y, script_data.Cam_Rot_Z)
                        else
                            SetCamRot(script_data.Cam_Handler, script_data.Cam_Rot_X, script_data.Cam_Rot_Y, script_data.Cam_Rot_Z, C_ROT_ORDER)
                        end
                        changed = false
                    end
                end
                local fov_changed = false
                if script_data.Fov == 1 then
                    script_data.Cam_Fov = withinRange(C_FOV_MIN, C_FOV_MAX, script_data.Cam_Fov, 1)
                    fov_changed = true
                elseif script_data.Fov == 2 then
                    script_data.Cam_Fov = withinRange(C_FOV_MIN, C_FOV_MAX, script_data.Cam_Fov, -1)
                    fov_changed = true
                end
                if fov_changed then
                    SetCamFov(script_data.Cam_Handler, script_data.Cam_Fov)
                end
            end
        end
    end)
end

RegisterCommand("toggle_cam", function()
    StartHUD()
end, false)

AddEventHandler('onResourceStop', function (res)
    if res == GetCurrentResourceName() then
        if ScriptData.Cam_Handler ~= 0 then
            DestroyCam(ScriptData.Cam_Handler, false)
            RenderScriptCams(false, false, 0, false, false)
        end
    end
end)

RegisterKeyMapping("toggle_cam", "Toggle Camera HUD", "keyboard", "m")

--- X Axis

RegisterCommand("+cam_rot_x_p", function()
    ScriptData.Rot_X = 1
end, false)

RegisterCommand("-cam_rot_x_p", function()
    ScriptData.Rot_X = 0
end, false)

RegisterCommand("+cam_rot_x_l", function()
    ScriptData.Rot_X = 2
end, false)

RegisterCommand("-cam_rot_x_l", function()
    ScriptData.Rot_X = 0
end, false)

RegisterKeyMapping("+cam_rot_x_p", "Rotate Around X Axis", "keyboard", "i")
RegisterKeyMapping("+cam_rot_x_l", "Rotate Around X Axis", "keyboard", "k")

--- Y Axis

RegisterCommand("+cam_rot_y_p", function()
    ScriptData.Rot_Y = 1
end, false)

RegisterCommand("-cam_rot_y_p", function()
    ScriptData.Rot_Y = 0
end, false)

RegisterCommand("+cam_rot_y_l", function()
    ScriptData.Rot_Y = 2
end, false)

RegisterCommand("-cam_rot_y_l", function()
    ScriptData.Rot_Y = 0
end, false)

RegisterKeyMapping("+cam_rot_y_p", "Rotate Around Y Axis", "keyboard", "u")
RegisterKeyMapping("+cam_rot_y_l", "Rotate Around Y Axis", "keyboard", "o")

--- Z Axis

RegisterCommand("+cam_rot_z_p", function()
    ScriptData.Rot_Z = 1
end, false)

RegisterCommand("-cam_rot_z_p", function()
    ScriptData.Rot_Z = 0
end, false)

RegisterCommand("+cam_rot_z_l", function()
    ScriptData.Rot_Z = 2
end, false)

RegisterCommand("-cam_rot_z_l", function()
    ScriptData.Rot_Z = 0
end, false)

RegisterKeyMapping("+cam_rot_z_p", "Rotate Around Z Axis", "keyboard", "j")
RegisterKeyMapping("+cam_rot_z_l", "Rotate Around Z Axis", "keyboard", "l")

RegisterCommand("+cam_fov_up", function()
    ScriptData.Fov = 1
end, false)

RegisterCommand("-cam_fov_up", function()
    ScriptData.Fov = 0
end, false)

RegisterCommand("+cam_fov_down", function()
    ScriptData.Fov = 2
end, false)

RegisterCommand("-cam_fov_down", function()
    ScriptData.Fov = 0
end, false)

RegisterKeyMapping("+cam_fov_up", "Increase cam FOV", "MOUSE_WHEEL", "IOM_WHEEL_DOWN")
RegisterKeyMapping("+cam_fov_down", "Decrease cam FOV", "MOUSE_WHEEL", "IOM_WHEEL_UP")

function SetCamMode(mode, real_max, override)
    mode = mode or ScriptData.Cam_Mode
    if ScriptData.Active and (override or ScriptData.Cam_Mode ~= C_MODE_LOCK) then
        ScriptData.Cam_Mode = withinRange(C_MODE_MIN, real_max and C_MODE_REAL_MAX or C_MODE_MAX, mode, 0)
        local isFreecam = isOneOf(mode, {C_MODE_FREECAM, C_MODE_KEYBOARD_FREECAM})
        local previousFreecam = isOneOf(
            withinRange(C_MODE_MIN, real_max and C_MODE_REAL_MAX or C_MODE_MAX, mode, -1),
            {C_MODE_FREECAM, C_MODE_KEYBOARD_FREECAM}
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

RegisterCommand("toggle_cam_mode", function()
    SetCamMode(ScriptData.Cam_Mode + 1)
end, false)

RegisterKeyMapping("toggle_cam_mode", "toggle cam mode", "keyboard", "h")

RegisterCommand("enter_pressed", function()
    FireEvent('enter')
end, false)

RegisterKeyMapping("enter_pressed", "Enter Pressed", "keyboard", "return")