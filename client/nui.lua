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

    local C_EASE_GROUPS = table.create(C_EASE_GROUP_SIZE, 0)
    for index, name in ipairs(C_EASE_GROUP_FUNCTIONS_NAMES) do
        C_EASE_GROUPS[#C_EASE_GROUPS+1] = {
            name = name,
            value = index
        }
    end
    SendNUIMessage({
        type = 'init',
        select = {
            {
                title = 'C_EASE_GROUPS',
                elements = C_EASE_GROUPS
            }
        }
    })
end)

RegisterNUICallback('set_flag', function(data)
    FireEvent(C_EVENTS_ENUM.C_EVENT_FLAG_STATE, C_FLAG_ENUM[data.flag], data.value, true)
end)

RegisterNUICallback('set_select', function(data)
    FireEvent(C_EVENTS_ENUM.C_EVENT_SELECT_STATE, data.name, data.value)
end)

RegisterNUICallback('mouse_move', function(data)
    ScriptData.Mouse_X = data.x
    ScriptData.Mouse_Y = data.y
end)

RegisterNUICallback('click', function(data)
    ScriptData.Mouse_Left_Button = data.state
end)

RegisterNUICallback('exit', function()
    ExecuteCommand("set_nui_active")
end)

AttachListener(C_EVENTS_ENUM.C_EVENT_SELECT_STATE, function(group, value)
    print(group, value)
end)