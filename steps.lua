local ScriptData = ScriptData
local cam_data<const> = {}

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
        cam_data[#cam_data+1] = {
            coords = cam_coords,
            rot = cam_rot,
            fov = cam_fov,
            img = data
        }
        SetCamMode(previous_cam_mode, nil, true)
    end)
end)