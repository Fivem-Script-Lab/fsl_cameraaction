--C_MODE_* uses 0-based indexing as it is not represented as a table

-- Constants used by the script as default values
C_IMG_ENCODING = "jpg"
C_IMG_QUALITY = 0.50

C_ROT_ORDER = 2
C_ROT_X_MIN = -180.0
C_ROT_X_MAX = 180.0
C_ROT_Y_MIN = -180.0
C_ROT_Y_MAX = 180.0
C_ROT_Z_MIN = -180.0
C_ROT_Z_MAX = 180.0
C_FOV_MIN = 10
C_FOV_MAX = 120

C_SELECT_MOUSE_BASE_TOLERANCE = 0.05
C_SELECT_MOUSE_BASE_TOLERANCE_SCALE = 0.02

C_CAM_DEFAULT_FOV = 90.0

C_EVENTS_ENUM = {
    C_EVENT_START = 'start',
    C_EVENT_NUI_STATE = 'nui_state',
    C_EVENT_FLAG_STATE = 'flag_state',
    C_EVENT_SELECT_STATE = 'select_state',
    C_EVENT_MOUSE_ON_CAMERA = 'mouse_on_camera',
    C_EVENT_MOUSE_OFF_CAMERA = 'mouse_off_camera',
    C_EVENT_KEY_ENTER_PRESSED = 'enter_pressed'
}

C_FLAG_MIN = 1
C_FLAG_MAX = 7
C_FLAG_DRAW_PATH = 1
C_FLAG_DRAW_PATH_2D = 2
C_FLAG_DRAW_JOINTS = 3
C_FLAG_DRAW_DIRECTION = 4
C_FLAG_DRAW_DIRECTION_2D = 5
C_FLAG_DRAW_METADATA = 6
C_FLAG_SELECT_MOUSE = 7

C_FLAG_ENUM = {
    C_FLAG_DRAW_PATH = 1,
    C_FLAG_DRAW_PATH_2D = 2,
    C_FLAG_DRAW_JOINTS = 3,
    C_FLAG_DRAW_DIRECTION = 4,
    C_FLAG_DRAW_DIRECTION_2D = 5,
    C_FLAG_DRAW_METADATA = 6,
    C_FLAG_SELECT_MOUSE = 7
}

C_FLAG_DRAW_ENUM = {
    C_FLAG_DRAW_PATH,
    C_FLAG_DRAW_JOINTS,
    C_FLAG_DRAW_PATH_2D,
    C_FLAG_DRAW_DIRECTION,
    C_FLAG_DRAW_DIRECTION_2D,
    C_FLAG_DRAW_METADATA
}

C_MODE_MIN = 0 -- kept as internal variable
C_MODE_MAX = 2 -- C_MODE_LOCK should not be able to be overwritten by user
C_MODE_REAL_MAX = 3 -- max mode available for the script that is not set by the user
C_MODE_KEYBOARD = 0
C_MODE_FREECAM = 1
C_MODE_KEYBOARD_FREECAM = 2
C_MODE_LOCK = 3

-- modes that use the keyboard
C_MODE_KEYBOARD_INPUT = {
    C_MODE_KEYBOARD,
    C_MODE_KEYBOARD_FREECAM
}

-- modes that use the freecam
C_MODE_FREECAM_INPUT = {
    C_MODE_FREECAM,
    C_MODE_KEYBOARD_FREECAM
}

-- default zero vector
C_ZERO_VEC3 = vec3(0.0, 0.0, 0.0)

C_EASE_GROUP_IN = {
    "EaseInQuad",
    "EaseInCubic",
    "EaseInSine",
    "EaseInBack",
    "EaseInQuart",
    "EaseInQuint",
    "EaseInExpo",
    "EaseInCirc"
}

C_EASE_GROUP_OUT = {
    "EaseOutQuad",
    "EaseOutCubic",
    "EaseOutSine",
    "EaseOutBack",
    "EaseOutQuart",
    "EaseOutQuint",
    "EaseOutExpo",
    "EaseOutCirc",
    "EaseOutElastic",
    "EaseOutBounce"
}

C_EASE_GROUP_IN_OUT = {
    "EaseInOutQuad",
    "EaseInOutCubic",
    "EaseInOutSine",
    "EaseInOutBack",
    "EaseInOutQuart",
    "EaseInOutQuint",
    "EaseInOutExpo",
    "EaseInOutCirc"
}

C_EASE_GROUP_OTHER = {
    "EaseLinear"
}

C_EASE_ENUM = {
    C_EASE_LINEAR = 1,
    C_EASE_IN_QUAD = 2,
    C_EASE_OUT_QUAD = 3,
    C_EASE_IN_OUT_QUAD = 4,
    C_EASE_IN_CUBIC = 5,
    C_EASE_OUT_CUBIC = 6,
    C_EASE_IN_OUT_CUBIC = 7,
    C_EASE_IN_SINE = 8,
    C_EASE_OUT_SINE = 9,
    C_EASE_IN_OUT_SINE = 10,
    C_EASE_IN_BACK = 11,
    C_EASE_OUT_BACK = 12,
    C_EASE_IN_OUT_BACK = 13,
    C_EASE_IN_QUART = 14,
    C_EASE_OUT_QUART = 15,
    C_EASE_IN_OUT_QUART = 16,
    C_EASE_IN_QUINT = 17,
    C_EASE_OUT_QUINT = 18,
    C_EASE_IN_OUT_QUINT = 19,
    C_EASE_IN_EXPO = 20,
    C_EASE_OUT_EXPO = 21,
    C_EASE_IN_OUT_EXPO = 22,
    C_EASE_IN_CIRC = 23,
    C_EASE_OUT_CIRC = 24,
    C_EASE_IN_OUT_CIRC = 25,
    C_EASE_OUT_ELASTIC = 26,
    C_EASE_OUT_BOUNCE = 27
}

C_EASE_GROUP_FUNCTIONS_NAMES = {
    "EaseLinear",
    "EaseInQuad",
    "EaseOutQuad",
    "EaseInOutQuad",
    "EaseInCubic",
    "EaseOutCubic",
    "EaseInOutCubic",
    "EaseInSine",
    "EaseOutSine",
    "EaseInOutSine",
    "EaseInBack",
    "EaseOutBack",
    "EaseInOutBack",
    "EaseInQuart",
    "EaseOutQuart",
    "EaseInOutQuart",
    "EaseInQuint",
    "EaseOutQuint",
    "EaseInOutQuint",
    "EaseInExpo",
    "EaseOutExpo",
    "EaseInOutExpo",
    "EaseInCirc",
    "EaseOutCirc",
    "EaseInOutCirc",
    "EaseOutElastic",
    "EaseOutBounce"
}

C_EASE_GROUP_FUNCTIONS = {
    EaseLinear,
    EaseInQuad,
    EaseOutQuad,
    EaseInOutQuad,
    EaseInCubic,
    EaseOutCubic,
    EaseInOutCubic,
    EaseInSine,
    EaseOutSine,
    EaseInOutSine,
    EaseInBack,
    EaseOutBack,
    EaseInOutBack,
    EaseInQuart,
    EaseOutQuart,
    EaseInOutQuart,
    EaseInQuint,
    EaseOutQuint,
    EaseInOutQuint,
    EaseInExpo,
    EaseOutExpo,
    EaseInOutExpo,
    EaseInCirc,
    EaseOutCirc,
    EaseInOutCirc,
    EaseOutElastic,
    EaseOutBounce
}

C_EASE_GROUP_SIZE = #C_EASE_GROUP_FUNCTIONS