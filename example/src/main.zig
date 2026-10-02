const std = @import("std");
const c = @import("objc");
const NS = @import("frameworks").NS;
const CA = @import("frameworks").CA;

const View = struct {
    pub fn class() !*c.Class {
        const superclass: *c.Class = try .get("NSView");

        const cls: *c.Class = try .allocatePair(
            superclass,
            "View",
            0,
        );

        try cls.addMethod(.registerName("acceptsFirstResponder"), acceptsFirstResponder);
        try cls.addMethod(.registerName("keyDown:"), keyDown);
        try cls.addMethod(.registerName("keyUp:"), keyUp);
        try cls.addMethod(.registerName("flagsChanged:"), flagsChanged);
        try cls.addMethod(.registerName("mouseDown:"), mouseDown);
        try cls.addMethod(.registerName("mouseUp:"), mouseUp);
        try cls.addMethod(.registerName("rightMouseDown:"), rightMouseDown);
        try cls.addMethod(.registerName("rightMouseUp:"), rightMouseUp);
        try cls.addMethod(.registerName("mouseMoved:"), mouseMoved);
        try cls.addMethod(.registerName("mouseDragged:"), mouseDragged);
        try cls.addMethod(.registerName("scrollWheel:"), scrollWheel);

        cls.registerPair();

        return cls;
    }

    fn acceptsFirstResponder(_: *c.Object, _: *c.SEL) callconv(.c) bool {
        return true;
    }

    fn keyDown(_: *c.Object, _: *c.SEL, event: *NS.Event) callconv(.c) void {
        const key_code = c.msgSend(
            u16,
            event,
            "keyCode",
            .{},
        );

        const characters = c.msgSend(
            *NS.String,
            event,
            "characters",
            .{},
        );

        std.debug.print(
            "keyDown: keyCode={d}, utf8={s}\n",
            .{ key_code, characters.utf8() },
        );
    }

    fn keyUp(_: *c.Object, _: *c.SEL, event: *NS.Event) callconv(.c) void {
        const key_code = c.msgSend(
            u16,
            event,
            "keyCode",
            .{},
        );

        std.debug.print(
            "keyUp: keyCode={}\n",
            .{key_code},
        );
    }

    fn flagsChanged(_: *c.Object, _: *c.SEL, event: *NS.Event) callconv(.c) void {
        const key_code = c.msgSend(
            u16,
            event,
            "keyCode",
            .{},
        );

        const modifiers = c.msgSend(
            usize,
            event,
            "modifierFlags",
            .{},
        );

        std.debug.print(
            "flagsChanged: keyCode={} modifiers={}\n",
            .{ key_code, modifiers },
        );
    }

    fn mouseDown(_: *c.Object, _: *c.SEL, _: *NS.Event) callconv(.c) void {
        std.debug.print("mouseDown\n", .{});
    }

    fn mouseUp(_: *c.Object, _: *c.SEL, _: *NS.Event) callconv(.c) void {
        std.debug.print("mouseUp\n", .{});
    }

    fn rightMouseDown(_: *c.Object, _: *c.SEL, _: *NS.Event) callconv(.c) void {
        std.debug.print("rightMouseDown\n", .{});
    }

    fn rightMouseUp(_: *c.Object, _: *c.SEL, _: *NS.Event) callconv(.c) void {
        std.debug.print("rightMouseUp\n", .{});
    }

    fn mouseMoved(_: *c.Object, _: *c.SEL, event: *NS.Event) callconv(.c) void {
        const location = c.msgSend(
            NS.Point,
            event,
            "locationInWindow",
            .{},
        );

        const dx = c.msgSend(
            f64,
            event,
            "deltaX",
            .{},
        );

        const dy = c.msgSend(
            f64,
            event,
            "deltaY",
            .{},
        );

        std.debug.print(
            "mouseMoved: x={d} y={d} dx={d} dy={d}\n",
            .{
                location.x,
                location.y,
                dx,
                dy,
            },
        );
    }

    fn mouseDragged(_: *c.Object, _: *c.SEL, event: *NS.Event) callconv(.c) void {
        const location = c.msgSend(
            NS.Point,
            event,
            "locationInWindow",
            .{},
        );

        const dx = c.msgSend(
            f64,
            event,
            "deltaX",
            .{},
        );

        const dy = c.msgSend(
            f64,
            event,
            "deltaY",
            .{},
        );

        std.debug.print(
            "mouseDragged: x={d} y={d} dx={d} dy={d}\n",
            .{
                location.x,
                location.y,
                dx,
                dy,
            },
        );
    }

    fn scrollWheel(_: *c.Object, _: *c.SEL, event: *NS.Event) callconv(.c) void {
        const dx = c.msgSend(
            f64,
            event,
            "scrollingDeltaX",
            .{},
        );

        const dy = c.msgSend(
            f64,
            event,
            "scrollingDeltaY",
            .{},
        );

        std.debug.print(
            "scrollWheel: dx={d} dy={d}\n",
            .{ dx, dy },
        );
    }
};

pub const WindowDelegate = struct {
    running: bool = true,

    fn windowShouldClose(object: *c.Object, _: c.SEL, window: *NS.Window) callconv(.c) bool {
        _ = window;
        const self = object.getIndexedIvars(WindowDelegate);
        self.running = false;
        return true;
    }
};

pub fn main() !void {
    const app: *NS.Application = .shared();

    _ = app.setActivationPolicy(.regular);
    app.finishLaunching();

    const view_class = try View.class();

    const window: *NS.Window = .init(
        .alloc(),
        .{
            .origin = .{
                .x = 100,
                .y = 100,
            },
            .size = .{
                .width = 800,
                .height = 600,
            },
        },
        .{},
        .buffered,
        false,
    );

    window.setTitleSlice("Hello, world!");

    const window_delegate: NS.Window.Delegate = try .create(.{
        .@"windowShouldClose:" = WindowDelegate.windowShouldClose,
    }, WindowDelegate, .{});

    const view: *NS.View = c.msgSend(
        *NS.View,
        c.msgSend(
            *NS.View,
            view_class,
            "alloc",
            .{},
        ),
        "initWithFrame:",
        .{
            NS.Rect{
                .origin = .{
                    .x = 0,
                    .y = 0,
                },
                .size = .{
                    .width = 800,
                    .height = 600,
                },
            },
        },
    );

    window.setAcceptsMouseMovedEvents(true);
    window_delegate.setAsDelegate(window);

    window.setContentView(view);

    window.makeKeyAndOrderFront();
    _ = window.makeFirstResponder(@ptrCast(view));

    app.activateIgnoringOtherApps(true);

    const window_info = window_delegate.getUserdata(WindowDelegate);

    const metal_layer: *CA.MetalLayer = .new();

    view.setLayer(metal_layer.toLayer());

    while (window_info.running) {
        while (app.nextEventMatchingMask(.any, .distantPast(), NS.RunLoop.default.*, true)) |event| {
            app.sendEvent(event);
        }
    }
}
