const raylib = @import("raylib.zig");
const Agent = @import("Agent.zig");
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
    raylib.BeginMode2D(this.getSceneCamera());
    raylib.DrawPixel(this.agent.x, this.agent.y, this.theme.agent);
    raylib.EndMode2D();
}

fn drawUI(this: *const App) void {
    if (this.show_pointer) {
        raylib.DrawCircleV(this.pointer, 4, this.theme.pointer);
    }
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
