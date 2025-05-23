RegisterNUICallback('ready', function()
    local C_FLAGS_ELEMENTS = table.create(C_FLAG_MAX, 0)
    for name, value in pairs(C_FLAG_ENUM) do
        C_FLAGS_ELEMENTS[value] = {
            name = name
        }
    end
    SendNUIMessage({
        type = 'init',
        flags = {
            {
                title = 'C_FLAGS',
                elements = C_FLAGS_ELEMENTS
            }
        }
    })
end)

RegisterNUICallback('set_flag', function(data, cb)
    FireEvent("flag_set", C_FLAG_ENUM[data.flag], data.value, true)
end)

RegisterNUICallback('mouse_move', function(data, cb)
    ScriptData.Mouse_X = data.x
    ScriptData.Mouse_Y = data.y
end)