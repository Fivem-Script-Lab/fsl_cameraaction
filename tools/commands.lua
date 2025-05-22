local cam_data_state = false
RegisterCommand('show_cam_data', function()
    cam_data_state = not cam_data_state
    SendNUIMessage({
        type = 'display',
        value = cam_data_state
    })
end, false)

RegisterKeyMapping("show_cam_data", 'show cam data', 'keyboard', 'x')

local active_nui = false
RegisterCommand('set_nui_active', function()
    active_nui = not active_nui
    SetNuiFocus(active_nui, active_nui)
    SetNuiFocusKeepInput(active_nui)
    FireEvent('nui', active_nui)
end, false)

RegisterKeyMapping("set_nui_active", 'set nui active', 'keyboard', 'z')

RegisterCommand("toggle_cam", function()
    StartHUD()
end, false)

RegisterKeyMapping("toggle_cam", "Toggle Camera HUD", "keyboard", "m")

RegisterCommand("toggle_cam_mode", function()
    SetCamMode(ScriptData.Cam_Mode + 1)
end, false)

RegisterKeyMapping("toggle_cam_mode", "toggle cam mode", "keyboard", "h")

RegisterCommand("enter_pressed", function()
    FireEvent('enter')
end, false)

RegisterKeyMapping("enter_pressed", "Enter Pressed", "keyboard", "return")

--- Camera Rotation And FOV controls

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