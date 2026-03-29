const raylib = @import("raylib.zig");
const Theme = @This();

agent: raylib.Color,
background: raylib.Color,
pointer: raylib.Color,

pub const default: Theme = .{
    .agent = raylib.BLUE,
    .background = raylib.RAYWHITE,
    .pointer = raylib.DARKGRAY,
};
