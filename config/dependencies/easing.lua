-- Linear
function EaseLinear(t)
    return t
end

-- Quadratic
function EaseInQuad(t)
    return t * t
end

function EaseOutQuad(t)
    return t * (2 - t)
end

function EaseInOutQuad(t)
    if t < 0.5 then
        return 2 * t * t
    else
        return 1 - (-2 * t + 2)^2 / 2
    end
end

-- Cubic
function EaseInCubic(t)
    return t * t * t
end

function EaseOutCubic(t)
    return 1 - (1 - t)^3
end

function EaseInOutCubic(t)
    if t < 0.5 then
        return 4 * t * t * t
    else
        return 1 - (-2 * t + 2)^3 / 2
    end
end

-- Sine
function EaseInSine(t)
    return 1 - math.cos((t * math.pi) / 2)
end

function EaseOutSine(t)
    return math.sin((t * math.pi) / 2)
end

function EaseInOutSine(t)
    return -(math.cos(math.pi * t) - 1) / 2
end

-- Back (with overshoot)
function EaseInBack(t)
    local c1 = 1.70158
    return c1 * t * t * t - c1 * t * t
end

function EaseOutBack(t)
    local c1 = 1.70158
    local c3 = c1 + 1
    return 1 + c3 * (t - 1)^3 + c1 * (t - 1)^2
end

function EaseInOutBack(t)
    local c1 = 1.70158
    local c2 = c1 * 1.525

    if t < 0.5 then
        return ((2 * t)^2 * ((c2 + 1) * 2 * t - c2)) / 2
    else
        return ((2 * t - 2)^2 * ((c2 + 1) * (t * 2 - 2) + c2) + 2) / 2
    end
end

-- Quart
function EaseInQuart(t)
    return t^4
end

function EaseOutQuart(t)
    return 1 - (1 - t)^4
end

function EaseInOutQuart(t)
    return t < 0.5 and 8 * t^4 or 1 - (-2 * t + 2)^4 / 2
end

function EaseInQuint(t)
    return t^5
end

function EaseOutQuint(t)
    return 1 - (1 - t)^5
end

function EaseInOutQuint(t)
    return t < 0.5 and 16 * t^5 or 1 - (-2 * t + 2)^5 / 2
end

-- Exponential
function EaseInExpo(t)
    return t == 0 and 0 or 2^(10 * t - 10)
end

function EaseOutExpo(t)
    return t == 1 and 1 or 1 - 2^(-10 * t)
end

function EaseInOutExpo(t)
    if t == 0 then return 0 end
    if t == 1 then return 1 end
    if t < 0.5 then
        return 2^(20 * t - 10) / 2
    else
        return (2 - 2^(-20 * t + 10)) / 2
    end
end

-- Circ
function EaseInCirc(t)
    return 1 - math.sqrt(1 - t * t)
end

function EaseOutCirc(t)
    return math.sqrt(1 - (t - 1)^2)
end

function EaseInOutCirc(t)
    if t < 0.5 then
        return (1 - math.sqrt(1 - (2 * t)^2)) / 2
    else
        return (math.sqrt(1 - (-2 * t + 2)^2) + 1) / 2
    end
end

-- Elastic
function EaseOutElastic(t)
    if t == 0 then return 0 end
    if t == 1 then return 1 end
    local c4 = (2 * math.pi) / 3
    return 2^(-10 * t) * math.sin((t * 10 - 0.75) * c4) + 1
end

-- Bounce
function EaseOutBounce(t)
    local n1, d1 = 7.5625, 2.75
    if t < 1 / d1 then
        return n1 * t * t
    elseif t < 2 / d1 then
        t = t - 1.5 / d1
        return n1 * t * t + 0.75
    elseif t < 2.5 / d1 then
        t = t - 2.25 / d1
        return n1 * t * t + 0.9375
    else
        t = t - 2.625 / d1
        return n1 * t * t + 0.984375
    end
end
