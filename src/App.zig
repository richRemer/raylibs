const raylib = @import("raylib.zig");
const Agent = @import("Agent.zig");
const Coord = @import("Coord.zig");
const KeyMap = @import("KeyMap.zig");
const Theme = @import("Theme.zig");
const App = @This();

running: bool = false,
tick: usize = 0,
x: c_int = 0,
y: c_int = 0,
width: c_int,
height: c_int,
pointer: raylib.Vector2 = .{},
geometry: raylib.Rectangle = .{},
agent: Agent = .{},
zoom: f32 = 10.0,
show_pointer: bool = false,
theme: Theme = .default,
keys: KeyMap = .default,
blocks: [10]Coord = [_]Coord{Coord{ .x = 0, .y = 0 }} ** 10,
block_seek: usize = 0,
block_end: usize = 0,

pub const init: App = .{
    .width = 640,
    .height = 480,
};

pub fn draw(this: *App) void {
    raylib.BeginDrawing();
    raylib.ClearBackground(this.theme.background);

    this.tick += 1;
    this.drawScene();
    this.drawUI();

    raylib.EndDrawing();
}

pub fn start(this: *App) void {
    raylib.InitWindow(this.width, this.height, "Raylibs");
    raylib.SetTargetFPS(15);
    raylib.SetExitKey(this.keys.quit);

    this.running = true;
}

pub fn update(this: *App) void {
    if (raylib.WindowShouldClose()) {
        this.running = false;
    }

    this.geometry.width = @floatFromInt(raylib.GetScreenWidth());
    this.geometry.height = @floatFromInt(raylib.GetScreenHeight());

    this.updateInput();
    this.updateScene();
}

fn drawScene(this: *const App) void {
    const blocks = this.blocks[this.block_seek..this.block_end];

    raylib.BeginMode2D(this.getSceneCamera());
    for (blocks) |b| raylib.DrawPixel(b.x, b.y, this.theme.block);
    raylib.DrawPixel(this.agent.x, this.agent.y, this.theme.agent);
    raylib.EndMode2D();
}

fn drawUI(this: *const App) void {
    if (this.show_pointer) {
        raylib.DrawCircleV(this.pointer, 4, this.theme.pointer);
    }
}

fn dropBlock(this: *App, x: c_int, y: c_int) void {
    const max: usize = this.blocks.len;

    if (this.block_end == max) {
        const len = @min(this.block_end - this.block_seek, this.blocks.len - 1);
        @memmove(this.blocks[0..len], this.blocks[max - len ..]);
        this.block_seek = 0;
        this.block_end = len;
    }

    this.blocks[this.block_end] = .{ .x = x, .y = y };
    this.block_end += 1;
}

fn getSceneCamera(this: *const App) raylib.Camera2D {
    return .{
        .offset = .{
            .x = @floatFromInt(this.x + (this.width >> 1)),
            .y = @floatFromInt(this.y + (this.height >> 1)),
        },
        .zoom = this.zoom,
    };
}

fn updateInput(this: *App) void {
    this.pointer = raylib.GetMousePosition();

    // TODO: hide pointer when mouse is in titlebar
    this.show_pointer =
        raylib.IsWindowFocused() and
        raylib.CheckCollisionPointRec(this.pointer, this.geometry);

    while (true) {
        const key = raylib.GetKeyPressed();

        if (key == raylib.KEY_NULL) return;
        if (key == this.keys.drop_block) this.dropBlock(this.agent.x, this.agent.y);
        if (key == this.keys.move_up) this.agent.face = .up;
        if (key == this.keys.move_left) this.agent.face = .left;
        if (key == this.keys.move_right) this.agent.face = .right;
        if (key == this.keys.move_down) this.agent.face = .down;
    }
}

fn updateScene(this: *App) void {
    const agent_ticks = 16 - @as(usize, @intCast(this.agent.speed));

    if (@mod(this.tick, agent_ticks) == 0) {
        switch (this.agent.face) {
            .up => this.agent.y -= 1,
            .left => this.agent.x -= 1,
            .right => this.agent.x += 1,
            .down => this.agent.y += 1,
            else => {},
        }

        this.agent.face = .none;
    }
}
