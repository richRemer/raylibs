const raylib = @import("raylib.zig");
const KeyMap = @This();

move_down: c_int,
move_left: c_int,
move_right: c_int,
move_up: c_int,
quit: c_int,

pub const default: KeyMap = .{
    .move_down = raylib.KEY_DOWN,
    .move_left = raylib.KEY_LEFT,
    .move_right = raylib.KEY_RIGHT,
    .move_up = raylib.KEY_UP,
    .quit = raylib.KEY_Q,
};
