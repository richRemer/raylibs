const std = @import("std");
const raylibs = @import("raylibs");
const log = std.log;

pub fn main() void {
    run() catch |err| {
        std.err("{t}", .{err});
        std.process.exit(1);
    };
}

fn run() !void {
    var app: raylibs.App = .init;

    app.agent.speed = 15;
    app.start();

    while (app.running) {
        app.update();
        app.draw();
    }
}
