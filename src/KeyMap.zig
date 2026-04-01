//! Configuration for key bindings.  Bind actions to raylib.KEY_NULL in order
//! to have no key for that action.

const raylib = @import("raylib.zig");
const KeyMap = @This();

move_down: c_int = raylib.KEY_NULL,
move_left: c_int = raylib.KEY_NULL,
move_right: c_int = raylib.KEY_NULL,
move_up: c_int = raylib.KEY_NULL,
quit: c_int = raylib.KEY_NULL,

pub const default: KeyMap = .{
    .move_down = raylib.KEY_DOWN,
    .move_left = raylib.KEY_LEFT,
    .move_right = raylib.KEY_RIGHT,
    .move_up = raylib.KEY_UP,
    .quit = raylib.KEY_Q,
};

pub const second: KeyMap = .{
    .move_down = raylib.KEY_S,
    .move_left = raylib.KEY_A,
    .move_right = raylib.KEY_D,
    .move_up = raylib.KEY_W,
};
