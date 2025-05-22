local draw_flags = 0
local draw_flags_set = {}
local draw_flags_loop = false

local draw_path = false
local draw_joints = false
local draw_path_2d = false
local draw_direction = false
local draw_direction_2d = false
local draw_metadata_text = false

local select_mouse = false

AttachListener('flag_set', function(flag, value)
    if flag == C_FLAG_DRAW_PATH then
        draw_path = value
    elseif flag == C_FLAG_DRAW_JOINTS then
        draw_joints = value
    elseif flag == C_FLAG_DRAW_PATH_2D then
        draw_path_2d = value
    elseif flag == C_FLAG_DRAW_DIRECTION then
        draw_direction = value
    elseif flag == C_FLAG_DRAW_DIRECTION_2D then
        draw_direction_2d = value
    elseif flag == C_FLAG_DRAW_METADATA then
        draw_metadata_text = value
    elseif flag == C_FLAG_SELECT_MOUSE then
        select_mouse = value
    end
end)

AttachListener('flag_set', function(flag, value, is_nui)
    if not is_nui then
        SendNUIMessage({
            type = 'flag',
            value = value
        })
    end
    if not value and draw_flags_set[flag] then
        draw_flags -= 1
        draw_flags_set[flag] = false
    elseif value and not draw_flags_set[flag] then
        draw_flags += 1
        draw_flags_set[flag] = true
        if not draw_flags_loop then
            draw_flags_loop = true
            CreateThread(function()
                local cam_data = CamData
                local base_tolerance = 0.05
                local tolerance_scale = 0.01
                while draw_flags > 0 do
                    Wait(0)
                    for i=1, #cam_data do
                        local x1,y1,z1 = table.unpack(cam_data[i].coords)
                        local x2,y2,z2 = table.unpack(cam_data[cam_data[i].linked].coords)
                        local point1, px1, py1
                        local point2, px2, py2
                        local playerCoords

                        if draw_path_2d then
                            point1, px1, py1 = GetScreenCoordFromWorldCoord(x1, y1, z1)
                            point2, px2, py2 = GetScreenCoordFromWorldCoord(x2, y2, z2)
                            
                            if draw_path_2d and point1 and point2 then
                                DrawLine_2d(px1, py1, px2, py2, 0.001, 255, 0, 0, 150)
                            else
                                DrawLine(x1, y1, z1, x2, y2, z2, 255, 0, 0, 150)
                            end
                        elseif draw_path then
                            DrawLine(x1, y1, z1, x2, y2, z2, 255, 0, 0, 150)
                        end
                        if draw_joints then
                            if select_mouse then
                                if point2 == nil then
                                    point2, px2, py2 = GetScreenCoordFromWorldCoord(x2, y2, z2)
                                end
                                if playerCoords == nil then
                                    playerCoords = GetEntityCoords(PlayerPedId())
                                end
                                local dist = #(playerCoords - cam_data[i].coords)
                                local tolerance = base_tolerance * (dist * tolerance_scale)
                                if point2 and math.abs(ScriptData.Mouse_X - px2) < tolerance and math.abs(ScriptData.Mouse_Y - py2) < tolerance then
                                    DrawGlowSphere(x2, y2, z2, 1.0, 0, 255, 255, 0.5, false, true)
                                else
                                    DrawGlowSphere(x2, y2, z2, 1.0, 0, 255, 0, 0.5, false, true)
                                end
                            else
                                DrawGlowSphere(x2, y2, z2, 1.0, 0, 255, 0, 0.5, false, true)
                            end
                            -- DrawSphere(x2, y2, z2, 1.0, 0, 255, 0, 0.5)
                        end
                        if draw_direction_2d then
                            local newX = Lerp(x1, x2, 0.2)
                            local newY = Lerp(y1, y2, 0.2)
                            local newZ = Lerp(z1, z2, 0.2)
                            if point1 == nil then
                                point1, px1, py1 = GetScreenCoordFromWorldCoord(x1, y1, z1)
                            end
                            point2, px2, py2 = GetScreenCoordFromWorldCoord(newX, newY, newZ)
    
                            if draw_direction_2d and point1 and point2 then
                                DrawLine_2d(px1, py1, px2, py2, 0.001, 0, 0, 255, 255)
                            else
                                DrawLine(x1, y1, z1, newX, newY, newZ, 0, 0, 255, 255)
                            end
                        elseif draw_direction then
                            local newX = Lerp(x1, x2, 0.2)
                            local newY = Lerp(y1, y2, 0.2)
                            local newZ = Lerp(z1, z2, 0.2)
                            DrawLine(x1, y1, z1, newX, newY, newZ, 0, 0, 255, 255)
                        end
                        if draw_metadata_text then
                            if cam_data[i].metadata and cam_data[i].metadata.text then
                                local data = cam_data[i].metadata.text
                                DrawText3Ds(data, x1, y1, z1 + 1.0)
                            end
                        end
                    end
                end
                draw_flags_loop = false
            end)
        end
    end
end)