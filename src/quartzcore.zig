const c = @import("objc");

const MTL = @import("metal.zig");

pub const Layer = opaque {
    pub fn new() *Layer {
        return c.msgSend(*Layer, Layer, "layer", .{});
    }

    pub fn setDevice(self: *Layer, device: *anyopaque) void {
        c.msgSend(void, self, "setDevice:", .{device});
    }
};

pub const MetalLayer = opaque {
    pub fn toLayer(self: *MetalLayer) *Layer {
        return @ptrCast(self);
    }

    pub fn new() *MetalLayer {
        return c.msgSend(*MetalLayer, c.Class.get("CAMetalLayer") catch unreachable, "layer", .{});
    }

    pub fn setDevice(self: *MetalLayer, device: *MTL.Device) void {
        c.msgSend(void, self, "setDevice:", .{device});
    }

    pub fn setPixelFormat(self: *MetalLayer, format: MTL.PixelFormat) void {
        c.msgSend(
            void,
            self,
            "setPixelFormat:",
            .{format},
        );
    }

    pub fn setFramebufferOnly(self: *MetalLayer, value: bool) void {
        c.msgSend(void, self, "setFramebufferOnly:", .{value});
    }

    pub fn nextDrawable(self: *MetalLayer) ?*MTL.Drawable {
        return c.msgSend(?*MTL.Drawable, self, "nextDrawable", .{});
    }
};

pub const MetalDrawable = MTL.Drawable;
