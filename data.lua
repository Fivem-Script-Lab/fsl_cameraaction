--- Camera Creation

--- @class CamData
--- @field coords vector3
--- @field rot vector3 order of rot -> 2
--- @field fov number|nil
--- @field handler number|nil
local CamData = {}

C_ROT_ORDER = 2
C_ROT_X_MIN = -90.0
C_ROT_X_MAX = 90.0
C_ROT_Y_MIN = -180.0
C_ROT_Y_MAX = 180.0
C_ROT_Z_MIN = 0.0
C_ROT_Z_MAX = 360.0

local ScriptData = {
    Active = false,
    Rot_X = 0,
    Rot_Y = 0,
    Rot_Z = 0,
    Rot_X_Value = 1,
    Rot_Y_Value = 1,
    Rot_Z_Value = 1,
    Cam_Rot_X = 0,
    Cam_Rot_Y = 0,
    Cam_Rot_Z = 0
}

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
    local rot_x,rot_y,rot_z = table.unpack(data.rot)
    local fov = data.fov or 90.0

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
    CreateThread(function()
        local script_data = ScriptData
        while script_data.Active do
            Wait(100)
            if script_data.Rot_X == 1 then
                script_data.Cam_Rot_X += withinRange(C_ROT_X_MIN, C_ROT_X_MAX, ScriptData.Cam_Rot_X, ScriptData.Rot_X_Value)
            elseif script_data.Rot_X == 2 then
                script_data.Cam_Rot_X += withinRange(C_ROT_X_MIN, C_ROT_X_MAX, ScriptData.Cam_Rot_X, -ScriptData.Rot_X_Value)
            end
            if script_data.Rot_Y == 1 then
                script_data.Cam_Rot_Y += withinRange(C_ROT_Y_MIN, C_ROT_Y_MAX, ScriptData.Cam_Rot_Y, ScriptData.Rot_Y_Value)
            elseif script_data.Rot_Y == 2 then
                script_data.Cam_Rot_Y += withinRange(C_ROT_Y_MIN, C_ROT_Y_MAX, ScriptData.Cam_Rot_Y, -ScriptData.Rot_Y_Value)
            end
            if script_data.Rot_Z == 1 then
                script_data.Cam_Rot_Z += withinRange(C_ROT_Z_MIN, C_ROT_Z_MAX, ScriptData.Cam_Rot_Z, ScriptData.Rot_Z_Value)
            elseif script_data.Rot_Z == 2 then
                script_data.Cam_Rot_Z += withinRange(C_ROT_Z_MIN, C_ROT_Z_MAX, ScriptData.Cam_Rot_Z, -ScriptData.Rot_Z_Value)
            end
        end
    end)
end

RegisterCommand("toggle_cam", function()
    ScriptData.Active = not ScriptData.Active
    if ScriptData.Active then
        StartHUD()
    end
end, false)

RegisterKeyMapping("toggle_cam", "Toggle Camera HUD", "keyboard", "i")

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

RegisterKeyMapping("+cam_rot_x_p", "Rotate Around X Axis", "keyboard", "u")
RegisterKeyMapping("+cam_rot_x_l", "Rotate Around X Axis", "keyboard", "i")

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

RegisterKeyMapping("+cam_rot_y_p", "Rotate Around Y Axis", "keyboard", "o")
RegisterKeyMapping("+cam_rot_y_l", "Rotate Around Y Axis", "keyboard", "p")

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

RegisterKeyMapping("+cam_rot_z_p", "Rotate Around Z Axis", "keyboard", "k")
RegisterKeyMapping("+cam_rot_z_l", "Rotate Around Z Axis", "keyboard", "l")