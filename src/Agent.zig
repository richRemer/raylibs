const std = @import("std");
const Direction = @import("core.zig").Direction;
const Agent = @This();

x: c_int = 0,
y: c_int = 0,
face: Direction = .none,
speed: u4 = 0,
