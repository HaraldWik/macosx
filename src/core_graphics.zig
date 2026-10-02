const c = @import("objc");

pub const Layer = opaque {
    pub fn new() *Layer {
        return c.msgSend(
            *Layer,
            Layer,
            .registerName("layer"),
            .{},
        );
    }

    pub fn setDevice(self: *Layer, device: *anyopaque) void {
        c.msgSend(
            void,
            self,
            .registerName("setDevice:"),
            .{device},
        );
    }
};

pub const MetalLayer = opaque {
    pub fn toLayer(self: *MetalLayer) *Layer {
        return @ptrCast(self);
    }

    pub fn new() *MetalLayer {
        return c.msgSend(*MetalLayer, c.Class.get("CAMetalLayer") catch unreachable, "layer", .{});
    }

    pub fn setDevice(self: *MetalLayer, device: *anyopaque) void {
        c.msgSend(void, self, "setDevice:", .{device});
    }
};
