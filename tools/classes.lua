---@class Range
---@field start integer
---@field finish integer

---@param start integer
---@param finish integer
---@return Range
function Range(start, finish)
    return {start=start, finish=finish}
end

--- @class CamData
--- @field coords vector3
--- @field rot vector3|nil order of rot -> 2
--- @field fov number|nil
--- @field handler number|nil
--- @field img string|nil
--- @field linked integer|nil
--- @field metadata table|nil