const c = @import("objc");

const NS = @import("foundation.zig");
const MTL = @import("metal.zig");

pub const Size = NS.Size;

pub const Layer = opaque {
    pub fn new() *Layer {
        return c.msgSend(*Layer, Layer, "layer", .{});
    }

    pub fn setDevice(self: *Layer, device: *anyopaque) void {
        c.msgSend(void, self, "setDevice:", .{device});
    }

    pub fn setDrawableSize(self: *Layer, size: Size) void {
        c.msgSend(void, self, "setDrawableSize:", .{size});
    }
};

pub const MetalLayer = opaque {
    pub fn super(self: *MetalLayer) *Layer {
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

    pub fn setDrawableSize(self: *MetalLayer, size: Size) void {
        c.msgSend(void, self, "setDrawableSize:", .{size});
    }
};

pub const MetalDrawable = MTL.Drawable;
