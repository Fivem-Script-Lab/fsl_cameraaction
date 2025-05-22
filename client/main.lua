--- Camera Creation

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
    Cam_Speed = 0.85,
    -- current cam mode; 0-manual rotation; 1-free roam; 2-manual rotation+free roam
    Cam_Mode = 0,
    Mouse_X = 0.0,
    Mouse_Y = 0.0
}
local ScriptData = ScriptData

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

local withinRange = WithinRange

function StartHUD()
    if ScriptData.Active then
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
        FireEvent('start')
        SetCamActive(script_data.Cam_Handler, true)
        RenderScriptCams(true, true, 500, false, true)
        local changed = false
        while script_data.Active do
            Wait(0)
            SetEntityLocallyInvisible(PlayerPedId())
            if script_data.Cam_Mode ~= C_MODE_LOCK then
                if (IsOneOf(script_data.Cam_Mode, C_MODE_KEYBOARD_INPUT)) then
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

AddEventHandler('onResourceStop', function (res)
    if res == GetCurrentResourceName() then
        if ScriptData.Cam_Handler ~= 0 then
            DestroyCam(ScriptData.Cam_Handler, false)
            RenderScriptCams(false, false, 0, false, false)
        end
    end
end)