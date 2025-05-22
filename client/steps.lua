local ScriptData = ScriptData

---@type CamData[]
CamData = {}

AttachListener('enter', function()
    if not ScriptData.Active then return end
    local previous_cam_mode = ScriptData.Cam_Mode
    SetCamMode(C_MODE_LOCK, true)
    local cam_handler = ScriptData.Cam_Handler

    local cam_coords = GetCamCoord(cam_handler)
    local cam_rot = GetCamRot(cam_handler, C_ROT_ORDER)
    local cam_fov = GetCamFov(cam_handler)

    exports['screenshot-basic']:requestScreenshot({
        encoding = C_IMG_ENCODING,
        quality = C_IMG_QUALITY,
    }, function(data)
        CamData[#CamData+1] = {
            coords = cam_coords,
            rot = cam_rot,
            fov = cam_fov,
            img = data,
            metadata = {
                easing = math.random(1, #C_EASE_GROUP_FUNCTIONS),
                text = "easing: EaseInOutSine"
            }
        }
        if #CamData-1 > 0 then
            CamData[#CamData - 1].linked = #CamData
        end
        CamData[#CamData].linked = 1
        SetCamMode(previous_cam_mode, nil, true)
    end)
end)

function StartPath()
    if #CamData == 0 then return end
    local previous_cam_mode = ScriptData.Cam_Mode
    SetCamMode(C_MODE_LOCK, true)
    RenderScriptCams(true, true, 2500, false, false)
    local cam_handler = ScriptData.Cam_Handler
    SetCamCoord(cam_handler, table.unpack(CamData[1].coords))
    SetCamRot(cam_handler, table.unpack(CamData[1].rot))
    for i=2, #CamData do
        local cd_previous = CamData[i-1]
        local cd_current = CamData[i]
        SmoothCamTransition(
            cd_previous.coords, cd_current.coords,
            cd_previous.rot, cd_current.rot,
            3000,
            cd_current.metadata and cd_current.metadata.easing or nil
        )
    end
    SetCamMode(previous_cam_mode, nil, true)
end

RegisterCommand("start_cam", function()
    StartPath()
end, false)

---@param startPos vector3
---@param endPos vector3
---@param startRot vector3
---@param endRot vector3
---@param duration integer
---@param easing_function_enum integer|nil
function SmoothCamTransition(startPos, endPos, startRot, endRot, duration, easing_function_enum)
    local startTime = GetGameTimer()
    local progress = 0.0
    
    while progress < 1.0 do
        Citizen.Wait(0)  -- Wait for the next frame
        
        local currentTime = GetGameTimer()
        progress = (currentTime - startTime) / duration
        local t = C_EASE_GROUP_FUNCTIONS[easing_function_enum or C_EASE_ENUM.C_EASE_LINEAR](progress)
        
        -- Interpolate position
        local newX = Lerp(startPos.x, endPos.x, t)
        local newY = Lerp(startPos.y, endPos.y, t)
        local newZ = Lerp(startPos.z, endPos.z, t)
        local newRX = Lerp(startRot.x, endRot.x, t)
        local newRY = Lerp(startRot.y, endRot.y, t)
        local newRZ = Lerp(startRot.z, endRot.z, t)
        
        -- Set camera position
        SetCamCoord(ScriptData.Cam_Handler, newX, newY, newZ)
        SetCamRot(ScriptData.Cam_Handler, newRX, newRY, newRZ, C_ROT_ORDER)
    end
end