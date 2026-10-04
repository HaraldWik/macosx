const std = @import("std");
const c = @import("objc");
const NS = @import("foundation.zig");

pub const StorageMode = enum(c_ulong) {
    shared,
    managed,
    private,
    memoryless,
};

pub const CPUCacheMode = enum(c_ulong) {
    default_cache,
    write_combined,
};

pub const HazardTrackingMode = enum(c_ulong) {
    default,
    untracked,
    tracked,
};

pub const Heap = opaque {
    pub const Type = enum(c_ulong) {
        automatic,
        placement,
        sparse,
    };

    pub fn super(self: *Heap) *Allocation {
        return @ptrCast(self);
    }

    pub fn @"type"(self: *Heap) Type {
        return c.msgSend(Type, self, "type", .{});
    }

    pub fn size(self: *Heap) usize {
        return c.msgSend(usize, self, "size", .{});
    }

    pub fn usedSize(self: *Heap) usize {
        return c.msgSend(usize, self, "usedSize", .{});
    }

    pub fn currentAllocatedSize(self: *Heap) usize {
        return c.msgSend(usize, self, "currentAllocatedSize", .{});
    }

    pub fn maxAvailableSize(self: *Heap, alignment: usize) usize {
        return c.msgSend(usize, self, "maxAvailableSizeWithAlignment:", .{alignment});
    }

    pub fn device(self: *Heap) *Device {
        return c.msgSend(*Device, self, "device", .{});
    }

    pub fn label(self: *Heap) ?*NS.String {
        return c.msgSend(?*NS.String, self, "label", .{});
    }

    pub fn setLabel(self: *Heap, label_: ?*NS.String) void {
        c.msgSend(void, self, "setLabel:", .{label_});
    }

    pub fn resourceOptions(self: *Heap) Resource.Options {
        return c.msgSend(Resource.Options, self, "resourceOptions", .{});
    }

    pub fn storageMode(self: *Heap) StorageMode {
        return c.msgSend(StorageMode, self, "storageMode", .{});
    }

    pub fn cpuCacheMode(self: *Heap) CPUCacheMode {
        return c.msgSend(CPUCacheMode, self, "cpuCacheMode", .{});
    }

    pub fn hazardTrackingMode(self: *Heap) HazardTrackingMode {
        return c.msgSend(HazardTrackingMode, self, "hazardTrackingMode", .{});
    }

    pub fn newBuffer(self: *Heap, length: usize, options: Resource.Options) ?*Buffer {
        return c.msgSend(?*Buffer, self, "newBufferWithLength:options:", .{ length, options });
    }

    pub fn newBufferAtOffset(self: *Heap, length: usize, options: Resource.Options, offset: usize) ?*Buffer {
        return c.msgSend(?*Buffer, self, "newBufferWithLength:options:offset:", .{ length, options, offset });
    }

    pub fn newTexture(self: *Heap, descriptor: *Texture.Descriptor) ?*Texture {
        return c.msgSend(?*Texture, self, "newTextureWithDescriptor:", .{descriptor});
    }

    pub fn newTextureAtOffset(self: *Heap, descriptor: *Texture.Descriptor, offset: usize) ?*Texture {
        return c.msgSend(?*Texture, self, "newTextureWithDescriptor:offset:", .{ descriptor, offset });
    }
};

pub const Allocation = opaque {
    pub fn super(self: *Allocation) *NS.Object {
        return @ptrCast(self);
    }

    pub fn size(self: *Allocation) usize {
        return c.msgSend(usize, self, "allocatedSize", .{});
    }
};

pub const PurgeableState = enum(c_ulong) {
    keep_current = 1,
    nonvolatile = 2,
    @"volatile" = 3,
    empty = 4,
};

pub const Resource = opaque {
    pub const Options = packed struct(u64) {
        cpu_cache_mode: u2 = 0,
        pad0: u2 = 0,
        storage_mode: u2 = 0,
        pad1: u2 = 0,
        hazard_tracking_mode: u2 = 0,
        pad2: u54 = 0,

        pub const cpu_cache_mode_default: Options = .{ .cpu_cache_mode = 0 };
        pub const cpu_cache_mode_write_combined: Options = .{ .cpu_cache_mode = 1 };
        pub const storage_mode_shared: Options = .{ .storage_mode = 0 };
        pub const storage_mode_managed: Options = .{ .storage_mode = 1 };
        pub const storage_mode_private: Options = .{ .storage_mode = 2 };
        pub const storage_mode_memoryless: Options = .{ .storage_mode = 3 };
        pub const hazard_tracking_mode_default: Options = .{ .hazard_tracking_mode = 0 };
        pub const hazard_tracking_mode_untracked: Options = .{ .hazard_tracking_mode = 1 };
        pub const hazard_tracking_mode_tracked: Options = .{ .hazard_tracking_mode = 2 };

        pub fn init(cpu_cache_mode: CPUCacheMode, storage_mode: StorageMode, hazard_tracking_mode: HazardTrackingMode) Options {
            return .{
                .cpu_cache_mode = @backingInt(cpu_cache_mode),
                .storage_mode = @backingInt(storage_mode),
                .hazard_tracking_mode = @backingInt(hazard_tracking_mode),
            };
        }
    };

    pub fn super(self: *Resource) *Allocation {
        return @ptrCast(self);
    }

    pub fn allocation(self: *Resource) *Allocation {
        return self.super();
    }

    pub fn size(self: *Resource) usize {
        return self.allocation().size();
    }

    pub fn device(self: *Resource) *Device {
        return c.msgSend(
            *Device,
            self,
            "device",
            .{},
        );
    }

    pub fn resourceOptions(self: *Resource) Resource.Options {
        return c.msgSend(
            Resource.Options,
            self,
            "resourceOptions",
            .{},
        );
    }

    pub fn heap(self: *Resource) ?*Heap {
        return c.msgSend(
            ?*Heap,
            self,
            "heap",
            .{},
        );
    }

    pub fn heapOffset(self: *Resource) usize {
        return c.msgSend(
            usize,
            self,
            "heapOffset",
            .{},
        );
    }

    pub fn gpuAddress(self: *Resource) u64 {
        return c.msgSend(
            u64,
            self,
            "gpuAddress",
            .{},
        );
    }

    pub fn label(self: *Resource) ?*NS.String {
        return c.msgSend(?*NS.String, self, "label", .{});
    }

    pub fn setLabel(self: *Resource, value: ?*NS.String) void {
        c.msgSend(void, self, "setLabel:", .{value});
    }

    pub fn setPurgeableState(
        self: *Resource,
        state: PurgeableState,
    ) PurgeableState {
        return c.msgSend(
            PurgeableState,
            self,
            "setPurgeableState:",
            .{state},
        );
    }

    pub fn makeAliasable(self: *Resource) void {
        c.msgSend(void, self, "makeAliasable", .{});
    }

    pub fn makeUnaliasable(self: *Resource) void {
        c.msgSend(void, self, "makeUnaliasable", .{});
    }

    pub fn isAliasable(self: *Resource) bool {
        return c.msgSend(bool, self, "isAliasable", .{});
    }
};

pub const Origin = extern struct {
    x: usize,
    y: usize,
    z: usize,
};

pub const Size = extern struct {
    width: usize,
    height: usize,
    depth: usize,
};

pub const Region = extern struct {
    origin: Origin,
    size: Size,
};

pub const Status = enum(u64) {
    notEnqueued = 0,
    enqueued = 1,
    committed = 2,
    scheduled = 3,
    completed = 4,
    @"error" = 5,
};

pub const PixelFormat = enum(c_ulong) {
    bgra8Unorm = 80,
    bgra8Unorm_srgb = 81,
};

pub const Texture = opaque {
    pub const Type = enum(usize) {
        type_1d = 0,
        type_1d_array = 1,
        type_2d = 2,
        type_2d_array = 3,
        type_2d_multisample = 4,
        type_cube = 5,
        type_cube_array = 6,
        type_3d = 7,
        type_2d_multisample_array = 8,
    };

    pub const Usage = packed struct(u64) {
        shader_read: bool = false,
        shader_write: bool = false,
        render_target: bool = false,
        pad0: bool = false,
        pixel_format_view: bool = false,
        shader_atomic: bool = false,
        pad1: u58 = 0,
    };

    pub const Descriptor = opaque {
        pub fn super(self: *Descriptor) *NS.Object {
            return @ptrCast(self);
        }

        pub fn new() *Descriptor {
            return c.msgSend(*Descriptor, c.objc_getClass("MTLTextureDescriptor"), "new", .{});
        }

        pub fn texture2DDescriptor(
            pixel_format: PixelFormat,
            width_: usize,
            height_: usize,
            mipmapped: bool,
        ) *Descriptor {
            return c.msgSend(
                *Descriptor,
                c.objc_getClass("MTLTextureDescriptor"),
                "texture2DDescriptorWithPixelFormat:width:height:mipmapped:",
                .{ pixel_format, width_, height_, mipmapped },
            );
        }

        pub fn textureCubeDescriptor(
            pixel_format: PixelFormat,
            size: usize,
            mipmapped: bool,
        ) *Descriptor {
            return c.msgSend(
                *Descriptor,
                c.objc_getClass("MTLTextureDescriptor"),
                "textureCubeDescriptorWithPixelFormat:size:mipmapped:",
                .{ pixel_format, size, mipmapped },
            );
        }

        pub fn pixelFormat(self: *Descriptor) PixelFormat {
            return c.msgSend(PixelFormat, self, "pixelFormat", .{});
        }

        pub fn setPixelFormat(self: *Descriptor, value: PixelFormat) void {
            c.msgSend(void, self, "setPixelFormat:", .{value});
        }

        pub fn @"type"(self: *Descriptor) Type {
            return c.msgSend(Type, self, "textureType", .{});
        }

        pub fn setTextureType(self: *Descriptor, value: Type) void {
            c.msgSend(void, self, "setTextureType:", .{value});
        }

        pub fn width(self: *Descriptor) usize {
            return c.msgSend(usize, self, "width", .{});
        }

        pub fn setWidth(self: *Descriptor, value: usize) void {
            c.msgSend(void, self, "setWidth:", .{value});
        }

        pub fn height(self: *Descriptor) usize {
            return c.msgSend(usize, self, "height", .{});
        }

        pub fn setHeight(self: *Descriptor, value: usize) void {
            c.msgSend(void, self, "setHeight:", .{value});
        }

        pub fn depth(self: *Descriptor) usize {
            return c.msgSend(usize, self, "depth", .{});
        }

        pub fn setDepth(self: *Descriptor, value: usize) void {
            c.msgSend(void, self, "setDepth:", .{value});
        }

        pub fn mipmapLevelCount(self: *Descriptor) usize {
            return c.msgSend(usize, self, "mipmapLevelCount", .{});
        }

        pub fn setMipmapLevelCount(self: *Descriptor, value: usize) void {
            c.msgSend(void, self, "setMipmapLevelCount:", .{value});
        }

        pub fn sampleCount(self: *Descriptor) usize {
            return c.msgSend(usize, self, "sampleCount", .{});
        }

        pub fn setSampleCount(self: *Descriptor, value: usize) void {
            c.msgSend(void, self, "setSampleCount:", .{value});
        }

        pub fn arrayLength(self: *Descriptor) usize {
            return c.msgSend(usize, self, "arrayLength", .{});
        }

        pub fn setArrayLength(self: *Descriptor, value: usize) void {
            c.msgSend(void, self, "setArrayLength:", .{value});
        }

        pub fn resourceOptions(self: *Descriptor) Resource.Options {
            return c.msgSend(Resource.Options, self, "resourceOptions", .{});
        }

        pub fn setResourceOptions(self: *Descriptor, value: Resource.Options) void {
            c.msgSend(void, self, "setResourceOptions:", .{value});
        }

        pub fn storageMode(self: *Descriptor) StorageMode {
            return c.msgSend(StorageMode, self, "storageMode", .{});
        }

        pub fn setStorageMode(self: *Descriptor, value: StorageMode) void {
            c.msgSend(void, self, "setStorageMode:", .{value});
        }

        pub fn cpuCacheMode(self: *Descriptor) CPUCacheMode {
            return c.msgSend(CPUCacheMode, self, "cpuCacheMode", .{});
        }

        pub fn setCpuCacheMode(self: *Descriptor, value: CPUCacheMode) void {
            c.msgSend(void, self, "setCpuCacheMode:", .{value});
        }

        pub fn hazardTrackingMode(self: *Descriptor) HazardTrackingMode {
            return c.msgSend(HazardTrackingMode, self, "hazardTrackingMode", .{});
        }

        pub fn setHazardTrackingMode(
            self: *Descriptor,
            value: HazardTrackingMode,
        ) void {
            c.msgSend(void, self, "setHazardTrackingMode:", .{value});
        }

        pub fn usage(self: *Descriptor) Usage {
            return c.msgSend(Usage, self, "usage", .{});
        }

        pub fn setUsage(self: *Descriptor, value: Usage) void {
            c.msgSend(void, self, "setUsage:", .{value});
        }

        pub fn allowGPUOptimizedContents(self: *Descriptor) bool {
            return c.msgSend(bool, self, "allowGPUOptimizedContents", .{});
        }

        pub fn setAllowGPUOptimizedContents(
            self: *Descriptor,
            value: bool,
        ) void {
            c.msgSend(void, self, "setAllowGPUOptimizedContents:", .{value});
        }
    };

    pub fn super(self: *Texture) *Resource {
        return @ptrCast(self);
    }

    pub fn @"type"(self: *Texture) Type {
        return c.msgSend(Type, self, "textureType", .{});
    }

    pub fn pixelFormat(self: *Texture) PixelFormat {
        return c.msgSend(PixelFormat, self, "pixelFormat", .{});
    }

    pub fn width(self: *Texture) usize {
        return c.msgSend(usize, self, "width", .{});
    }

    pub fn height(self: *Texture) usize {
        return c.msgSend(usize, self, "height", .{});
    }

    pub fn depth(self: *Texture) usize {
        return c.msgSend(usize, self, "depth", .{});
    }

    pub fn mipmapLevelCount(self: *Texture) usize {
        return c.msgSend(usize, self, "mipmapLevelCount", .{});
    }

    pub fn arrayLength(self: *Texture) usize {
        return c.msgSend(usize, self, "arrayLength", .{});
    }

    pub fn sampleCount(self: *Texture) usize {
        return c.msgSend(usize, self, "sampleCount", .{});
    }

    pub fn framebufferOnly(self: *Texture) bool {
        return c.msgSend(bool, self, "framebufferOnly", .{});
    }

    pub fn usage(self: *Texture) Usage {
        return c.msgSend(Usage, self, "usage", .{});
    }

    pub fn allowGPUOptimizedContents(self: *Texture) bool {
        return c.msgSend(bool, self, "allowGPUOptimizedContents", .{});
    }

    pub fn shareable(self: *Texture) bool {
        return c.msgSend(bool, self, "shareable", .{});
    }

    pub fn parentTexture(self: *Texture) ?*Texture {
        return c.msgSend(?*Texture, self, "parentTexture", .{});
    }

    pub fn parentRelativeLevel(self: *Texture) usize {
        return c.msgSend(usize, self, "parentRelativeLevel", .{});
    }

    pub fn parentRelativeSlice(self: *Texture) usize {
        return c.msgSend(usize, self, "parentRelativeSlice", .{});
    }

    pub fn buffer(self: *Texture) ?*Buffer {
        return c.msgSend(?*Buffer, self, "buffer", .{});
    }

    pub fn bufferOffset(self: *Texture) usize {
        return c.msgSend(usize, self, "bufferOffset", .{});
    }

    pub fn bufferBytesPerRow(self: *Texture) usize {
        return c.msgSend(usize, self, "bufferBytesPerRow", .{});
    }

    pub fn iosurface(self: *Texture) ?*anyopaque {
        return c.msgSend(?*anyopaque, self, "iosurface", .{});
    }

    pub fn iosurfacePlane(self: *Texture) usize {
        return c.msgSend(usize, self, "iosurfacePlane", .{});
    }

    pub fn rootResource(self: *Texture) *Resource {
        return c.msgSend(*Resource, self, "rootResource", .{});
    }

    pub fn isSparse(self: *Texture) bool {
        return c.msgSend(bool, self, "isSparse", .{});
    }

    pub fn firstMipmapInTail(self: *Texture) usize {
        return c.msgSend(usize, self, "firstMipmapInTail", .{});
    }

    pub fn tailSizeInBytes(self: *Texture) usize {
        return c.msgSend(usize, self, "tailSizeInBytes", .{});
    }
};

pub const Drawable = opaque {
    pub fn present(self: *Drawable) void {
        c.msgSend(void, self, "present", .{});
    }

    pub fn presentAtTime(self: *Drawable, time: f64) void {
        c.msgSend(void, self, "presentAtTime:", .{time});
    }

    pub fn presentAfterMinimumDuration(self: *Drawable, duration: f64) void {
        c.msgSend(void, self, "presentAfterMinimumDuration:", .{duration});
    }

    pub fn presentAtTimeOnCommandBuffer(self: *Drawable, command_buffer: *CommandBuffer) void {
        c.msgSend(void, self, "present", .{command_buffer});
    }

    pub fn texture(self: *Drawable) *Texture {
        return c.msgSend(*Texture, self, "texture", .{});
    }

    pub fn presentedTime(self: *Drawable) f64 {
        return c.msgSend(f64, self, "presentedTime", .{});
    }
};

pub const Device = opaque {
    pub const NewError = error{
        MissingDefaultDevice,
    };

    extern "Metal" fn MTLCreateSystemDefaultDevice() ?*Device;

    pub fn new() NewError!*Device {
        return MTLCreateSystemDefaultDevice() orelse error.MissingDefaultDevice;
    }

    pub fn newCommandQueue(self: *Device) CommandQueue.NewError!*CommandQueue {
        return c.msgSend(?*CommandQueue, self, "newCommandQueue", .{}) orelse error.CreateCommandQueue;
    }

    pub fn newLibraryWithFileSlice(self: *Device, path: [*:0]const u8) Library.NewError!*Library {
        const string: *NS.String = .fromSlice(path);
        defer string.release();
        return self.newLibraryWithFile(string);
    }

    pub fn newLibraryWithFile(self: *Device, path: *NS.String) Library.NewError!*Library {
        var ns_error: ?*NS.Error = null;

        const library = c.msgSend(?*Library, self, "newLibraryWithFile:error:", .{ path, &ns_error }) orelse error.CreateLibrary;
        if (ns_error) |err| std.log.err("{s}", .{err.localizedDescription().utf8()});
        return library;
    }

    pub fn newDefaultLibrary(self: *Device) ?*Library {
        return c.msgSend(?*Library, self, "newDefaultLibrary", .{});
    }

    pub fn newCommandBuffer(self: *Device) CommandBuffer.NewError!*CommandBuffer {
        return c.msgSend(?*CommandBuffer, self, "newCommandBuffer", .{}) orelse error.CreateCommandBuffer;
    }

    pub fn newBuffer(self: *Device, length: usize, options: Resource.Options) Buffer.NewError!*Buffer {
        return c.msgSend(?*Buffer, self, "newBufferWithLength:options:", .{ length, options }) orelse error.AllocateBuffer;
    }

    pub fn newBufferWithBytes(self: *Device, bytes: *const anyopaque, length: usize, options: Resource.Options) Buffer.NewError!*Buffer {
        return c.msgSend(?*Buffer, self, "newBufferWithBytes:length:options:", .{ bytes, length, options }) orelse error.AllocateBuffer;
    }

    pub fn newRenderPipelineState(self: *Device, descriptor: *RenderPipelineDescriptor) RenderPipelineState.NewError!*RenderPipelineState {
        return c.msgSend(?*RenderPipelineState, self, "newRenderPipelineStateWithDescriptor:error:", .{ descriptor, null }) orelse error.CreateRenderPipelineState;
    }

    pub fn name(self: *Device) ?*NS.String {
        return c.msgSend(?*NS.String, self, "name", .{});
    }

    pub fn maxThreadsPerThreadgroup(self: *Device) Size {
        return c.msgSend(Size, self, "maxThreadsPerThreadgroup", .{});
    }
};

pub const CommandQueue = opaque {
    pub const NewError = error{CreateCommandQueue};

    pub fn commandBuffer(self: *CommandQueue) ?*CommandBuffer {
        return c.msgSend(?*CommandBuffer, self, "commandBuffer", .{});
    }

    pub fn commandBufferWithUnretainedReferences(self: *CommandQueue) *CommandBuffer {
        return c.msgSend(*CommandBuffer, self, "commandBufferWithUnretainedReferences", .{});
    }

    pub fn insertDebugCaptureBoundary(self: *CommandQueue) void {
        c.msgSend(void, self, "insertDebugCaptureBoundary", .{});
    }

    pub fn label(self: *CommandQueue) ?*NS.String {
        return c.msgSend(?*NS.String, self, "label", .{});
    }

    pub fn setLabel(self: *CommandQueue, label_: ?*NS.String) void {
        c.msgSend(void, self, "setLabel:", .{label_});
    }

    pub fn device(self: *CommandQueue) *Device {
        return c.msgSend(*Device, self, "device", .{});
    }

    pub fn maxCommandBufferCount(self: *CommandQueue) usize {
        return c.msgSend(usize, self, "maxCommandBufferCount", .{});
    }
};

pub const CommandBuffer = opaque {
    pub const NewError = error{CreateCommandBuffer};

    pub fn release(self: *CommandBuffer) void {
        c.msgSend(void, self, "release", .{});
    }

    pub fn commandQueue(self: *CommandBuffer) *CommandQueue {
        return c.msgSend(*CommandQueue, self, "commandQueue", .{});
    }

    pub fn enqueue(self: *CommandBuffer) void {
        c.msgSend(void, self, "enqueue", .{});
    }

    pub fn commit(self: *CommandBuffer) void {
        c.msgSend(void, self, "commit", .{});
    }

    pub fn waitUntilScheduled(self: *CommandBuffer) void {
        c.msgSend(void, self, "waitUntilScheduled", .{});
    }

    pub fn waitUntilCompleted(self: *CommandBuffer) void {
        c.msgSend(void, self, "waitUntilCompleted", .{});
    }

    pub fn present(self: *CommandBuffer, drawable: *Drawable) void {
        c.msgSend(void, self, "presentDrawable:", .{drawable});
    }

    pub fn presentAtTime(self: *CommandBuffer, drawable: *Drawable, time: f64) void {
        c.msgSend(void, self, "presentDrawable:atTime:", .{ drawable, time });
    }

    pub fn presentAfterMinimumDuration(self: *CommandBuffer, drawable: *Drawable, duration: f64) void {
        c.msgSend(void, self, "presentDrawable:afterMinimumDuration:", .{ drawable, duration });
    }

    pub fn renderCommandEncoder(self: *CommandBuffer, descriptor: *RenderPassDescriptor) *RenderCommandEncoder {
        return c.msgSend(*RenderCommandEncoder, self, "renderCommandEncoderWithDescriptor:", .{descriptor});
    }

    pub fn status(self: *CommandBuffer) Status {
        return c.msgSend(Status, self, "status", .{});
    }

    pub fn @"error"(self: *CommandBuffer) ?*NS.Error {
        return c.msgSend(?*NS.Error, self, "error", .{});
    }

    pub fn label(self: *CommandBuffer) ?[*:0]const u8 {
        return c.msgSend(?[*:0]const u8, self, "label", .{});
    }

    pub fn setLabel(self: *CommandBuffer, label_: ?[*:0]const u8) void {
        c.msgSend(void, self, "setLabel:", .{label_});
    }

    pub fn retainReferences(self: *CommandBuffer) bool {
        return c.msgSend(bool, self, "retainedReferences", .{});
    }

    pub fn setRetainReferences(self: *CommandBuffer, value: bool) void {
        c.msgSend(void, self, "setRetainedReferences:", .{value});
    }

    pub fn waitUntilCompletedWithTimeout(self: *CommandBuffer, timeout: f64) void {
        c.msgSend(void, self, "waitUntilCompletedWithTimeout:", .{timeout});
    }
};

pub const Library = opaque {
    pub const NewError = error{CreateLibrary};
    pub const NewFunctionError = error{MissingFunction};

    pub fn newFunctionWithNameSlice(self: *Library, name: [*:0]const u8) NewFunctionError!*Function {
        const string: *NS.String = .fromSlice(name);
        defer string.release();
        return self.newFunctionWithName(string);
    }

    pub fn newFunctionWithName(self: *Library, name: *NS.String) NewFunctionError!*Function {
        return c.msgSend(?*Function, self, "newFunctionWithName:", .{name}) orelse error.MissingFunction;
    }

    pub fn label(self: *Library) ?*NS.String {
        return c.msgSend(?*NS.String, self, "label", .{});
    }

    pub fn setLabel(self: *Library, label_: ?*NS.String) void {
        c.msgSend(void, self, "setLabel:", .{label_});
    }
};

pub const Function = opaque {};

pub const Buffer = opaque {
    pub const NewError = error{AllocateBuffer};

    pub fn release(self: *Buffer) void {
        c.msgSend(void, self, "release", .{});
    }

    pub fn contents(self: *Buffer) ?*anyopaque {
        return c.msgSend(?*anyopaque, self, "contents", .{});
    }

    pub fn length(self: *Buffer) usize {
        return c.msgSend(usize, self, "length", .{});
    }

    pub fn device(self: *Buffer) *Device {
        return c.msgSend(*Device, self, "device", .{});
    }

    pub fn label(self: *Buffer) ?*NS.String {
        return c.msgSend(?*NS.String, self, "label", .{});
    }

    pub fn setLabel(self: *Buffer, label_: ?*NS.String) void {
        c.msgSend(void, self, "setLabel:", .{label_});
    }

    pub fn didModifyRange(self: *Buffer, location: usize, length_: usize) void {
        const range: NS.Range = .{
            .location = location,
            .length = length_,
        };

        c.msgSend(void, self, "didModifyRange:", .{range});
    }
};

pub const RenderPipelineDescriptor = opaque {
    pub fn new() *RenderPipelineDescriptor {
        return c.msgSend(*RenderPipelineDescriptor, c.Class.get("MTLRenderPipelineDescriptor") catch unreachable, "new", .{});
    }

    pub fn reset(self: *RenderPipelineDescriptor) void {
        c.msgSend(void, self, "reset", .{});
    }

    pub fn label(self: *RenderPipelineDescriptor) ?*NS.String {
        return c.msgSend(?*NS.String, self, "label", .{});
    }

    pub fn setLabel(self: *RenderPipelineDescriptor, label_: ?*NS.String) void {
        c.msgSend(void, self, "setLabel:", .{label_});
    }

    pub fn vertexFunction(self: *RenderPipelineDescriptor) ?*Function {
        return c.msgSend(?*Function, self, "vertexFunction", .{});
    }

    pub fn setVertexFunction(self: *RenderPipelineDescriptor, function: ?*Function) void {
        c.msgSend(void, self, "setVertexFunction:", .{function});
    }

    pub fn fragmentFunction(self: *RenderPipelineDescriptor) ?*Function {
        return c.msgSend(?*Function, self, "fragmentFunction", .{});
    }

    pub fn setFragmentFunction(self: *RenderPipelineDescriptor, function: ?*Function) void {
        c.msgSend(void, self, "setFragmentFunction:", .{function});
    }

    pub fn vertexDescriptor(self: *RenderPipelineDescriptor) ?*VertexDescriptor {
        return c.msgSend(?*VertexDescriptor, self, "vertexDescriptor", .{});
    }

    pub fn setVertexDescriptor(self: *RenderPipelineDescriptor, descriptor: ?*VertexDescriptor) void {
        c.msgSend(void, self, "setVertexDescriptor:", .{descriptor});
    }

    pub fn rasterSampleCount(self: *RenderPipelineDescriptor) usize {
        return c.msgSend(usize, self, "rasterSampleCount", .{});
    }

    pub fn setRasterSampleCount(self: *RenderPipelineDescriptor, count: usize) void {
        c.msgSend(void, self, "setRasterSampleCount:", .{count});
    }

    pub fn depthAttachmentPixelFormat(self: *RenderPipelineDescriptor) PixelFormat {
        return c.msgSend(PixelFormat, self, "depthAttachmentPixelFormat", .{});
    }

    pub fn setDepthAttachmentPixelFormat(self: *RenderPipelineDescriptor, format: PixelFormat) void {
        c.msgSend(void, self, "setDepthAttachmentPixelFormat:", .{format});
    }

    pub fn stencilAttachmentPixelFormat(self: *RenderPipelineDescriptor) PixelFormat {
        return c.msgSend(PixelFormat, self, "stencilAttachmentPixelFormat", .{});
    }

    pub fn setStencilAttachmentPixelFormat(self: *RenderPipelineDescriptor, format: PixelFormat) void {
        c.msgSend(void, self, "setStencilAttachmentPixelFormat:", .{format});
    }

    pub fn setAlphaToCoverageEnabled(self: *RenderPipelineDescriptor, enabled: bool) void {
        c.msgSend(void, self, "setAlphaToCoverageEnabled:", .{enabled});
    }

    pub fn setAlphaToOneEnabled(self: *RenderPipelineDescriptor, enabled: bool) void {
        c.msgSend(void, self, "setAlphaToOneEnabled:", .{enabled});
    }

    pub fn setRasterizationEnabled(self: *RenderPipelineDescriptor, enabled: bool) void {
        c.msgSend(void, self, "setRasterizationEnabled:", .{enabled});
    }

    pub fn colorAttachments(self: *RenderPipelineDescriptor) *RenderPipelineColorAttachmentDescriptorArray {
        return c.msgSend(*RenderPipelineColorAttachmentDescriptorArray, self, "colorAttachments", .{});
    }
};

pub const RenderPipelineColorAttachmentDescriptorArray = opaque {
    pub fn objectAtIndexedSubscript(self: *RenderPipelineColorAttachmentDescriptorArray, index: usize) *RenderPipelineColorAttachmentDescriptor {
        return c.msgSend(*RenderPipelineColorAttachmentDescriptor, self, "objectAtIndexedSubscript:", .{index});
    }
};

pub const RenderPipelineColorAttachmentDescriptor = opaque {
    pub fn pixelFormat(self: *RenderPipelineColorAttachmentDescriptor) PixelFormat {
        return c.msgSend(PixelFormat, self, "pixelFormat", .{});
    }

    pub fn setPixelFormat(self: *RenderPipelineColorAttachmentDescriptor, format: PixelFormat) void {
        c.msgSend(void, self, "setPixelFormat:", .{format});
    }

    pub fn blendingEnabled(self: *RenderPipelineColorAttachmentDescriptor) bool {
        return c.msgSend(bool, self, "isBlendingEnabled", .{});
    }

    pub fn setBlendingEnabled(self: *RenderPipelineColorAttachmentDescriptor, enabled: bool) void {
        c.msgSend(void, self, "setBlendingEnabled:", .{enabled});
    }
};

pub const VertexDescriptor = opaque {};

pub const RenderPipelineState = opaque {
    pub const NewError = error{CreateRenderPipelineState};

    pub fn device(self: *RenderPipelineState) *Device {
        return c.msgSend(*Device, self, "device", .{});
    }

    pub fn label(self: *RenderPipelineState) ?*NS.String {
        return c.msgSend(?*NS.String, self, "label", .{});
    }

    pub fn setLabel(self: *RenderPipelineState, label_: ?*NS.String) void {
        c.msgSend(void, self, "setLabel:", .{label_});
    }

    pub fn maxTotalThreadsPerObjectThreadgroup(self: *RenderPipelineState) usize {
        return c.msgSend(usize, self, "maxTotalThreadsPerObjectThreadgroup", .{});
    }

    pub fn objectThreadExecutionWidth(self: *RenderPipelineState) usize {
        return c.msgSend(usize, self, "objectThreadExecutionWidth", .{});
    }

    pub fn maxTotalThreadsPerMeshThreadgroup(self: *RenderPipelineState) usize {
        return c.msgSend(usize, self, "maxTotalThreadsPerMeshThreadgroup", .{});
    }
};

pub const LoadAction = enum(u64) {
    dont_care = 0,
    load = 1,
    clear = 2,
};

pub const StoreAction = enum(u64) {
    dont_care = 0,
    store = 1,
};

pub const ClearColor = extern struct {
    red: f64,
    green: f64,
    blue: f64,
    alpha: f64,
};

pub const RenderPassColorAttachmentDescriptor = opaque {
    pub fn setTexture(self: *RenderPassColorAttachmentDescriptor, texture: *Texture) void {
        c.msgSend(void, self, "setTexture:", .{texture});
    }

    pub fn setLoadAction(self: *RenderPassColorAttachmentDescriptor, action: LoadAction) void {
        c.msgSend(void, self, "setLoadAction:", .{action});
    }

    pub fn setStoreAction(self: *RenderPassColorAttachmentDescriptor, action: StoreAction) void {
        c.msgSend(void, self, "setStoreAction:", .{action});
    }

    pub fn setClearColor(self: *RenderPassColorAttachmentDescriptor, color: ClearColor) void {
        c.msgSend(void, self, "setClearColor:", .{color});
    }
};

pub const RenderPassColorAttachmentArray = opaque {
    pub fn objectAtIndexedSubscript(self: *RenderPassColorAttachmentArray, index: usize) *RenderPassColorAttachmentDescriptor {
        return c.msgSend(*RenderPassColorAttachmentDescriptor, self, "objectAtIndexedSubscript:", .{index});
    }
};

pub const RenderPassDescriptor = opaque {
    pub fn new() *RenderPassDescriptor {
        return c.msgSend(*RenderPassDescriptor, c.Class.get("MTLRenderPassDescriptor") catch unreachable, "renderPassDescriptor", .{});
    }

    pub fn colorAttachments(self: *RenderPassDescriptor) *RenderPassColorAttachmentArray {
        return c.msgSend(*RenderPassColorAttachmentArray, self, "colorAttachments", .{});
    }
};

pub const PrimitiveType = enum(u64) {
    point = 0,
    line = 1,
    line_strip = 2,
    triangle = 3,
    triangle_strip = 4,
};

pub const IndexType = enum(usize) {
    uint16 = 0,
    uint32 = 1,
};

pub const Winding = enum(usize) {
    clockwise = 0,
    counter_clockwise = 1,
};

pub const CullMode = enum(usize) {
    none = 0,
    front = 1,
    back = 2,
};

pub const TriangleFillMode = enum(usize) {
    fill = 0,
    lines = 1,
};

pub const Viewport = extern struct {
    origin_x: f64,
    origin_y: f64,
    width: f64,
    height: f64,
    znear: f64,
    zfar: f64,
};

pub const ScissorRect = extern struct {
    x: usize,
    y: usize,
    width: usize,
    height: usize,
};

pub const RenderCommandEncoder = opaque {
    pub fn setRenderPipelineState(self: *RenderCommandEncoder, pipeline: *RenderPipelineState) void {
        c.msgSend(void, self, "setRenderPipelineState:", .{pipeline});
    }

    pub fn setVertexBuffer(self: *RenderCommandEncoder, buffer: ?*Buffer, offset: usize, index: usize) void {
        c.msgSend(void, self, "setVertexBuffer:offset:atIndex:", .{ buffer, offset, index });
    }

    pub fn setVertexBytes(self: *RenderCommandEncoder, bytes: *const anyopaque, length: usize, index: usize) void {
        c.msgSend(void, self, "setVertexBytes:length:atIndex:", .{ bytes, length, index });
    }

    pub fn setFragmentBuffer(self: *RenderCommandEncoder, buffer: ?*Buffer, offset: usize, index: usize) void {
        c.msgSend(void, self, "setFragmentBuffer:offset:atIndex:", .{ buffer, offset, index });
    }

    pub fn setFragmentBytes(self: *RenderCommandEncoder, bytes: *const anyopaque, length: usize, index: usize) void {
        c.msgSend(void, self, "setFragmentBytes:length:atIndex:", .{ bytes, length, index });
    }

    pub fn setVertexBufferOffset(self: *RenderCommandEncoder, offset: usize, index: usize) void {
        c.msgSend(void, self, "setVertexBufferOffset:atIndex:", .{ offset, index });
    }

    pub fn setFragmentBufferOffset(self: *RenderCommandEncoder, offset: usize, index: usize) void {
        c.msgSend(void, self, "setFragmentBufferOffset:atIndex:", .{ offset, index });
    }

    pub fn drawPrimitives(self: *RenderCommandEncoder, primitive: PrimitiveType, vertex_start: usize, vertex_count: usize) void {
        c.msgSend(void, self, "drawPrimitives:vertexStart:vertexCount:", .{ primitive, vertex_start, vertex_count });
    }

    pub fn drawIndexedPrimitives(
        self: *RenderCommandEncoder,
        primitive: PrimitiveType,
        index_count: usize,
        index_type: IndexType,
        index_buffer: *Buffer,
        index_buffer_offset: usize,
    ) void {
        c.msgSend(
            void,
            self,
            "drawIndexedPrimitives:indexCount:indexType:indexBuffer:indexBufferOffset:",
            .{
                primitive,
                index_count,
                index_type,
                index_buffer,
                index_buffer_offset,
            },
        );
    }
    pub fn setViewport(self: *RenderCommandEncoder, viewport: Viewport) void {
        c.msgSend(void, self, "setViewport:", .{viewport});
    }

    pub fn setScissorRect(self: *RenderCommandEncoder, rect: ScissorRect) void {
        c.msgSend(void, self, "setScissorRect:", .{rect});
    }

    pub fn setFrontFacingWinding(self: *RenderCommandEncoder, winding: Winding) void {
        c.msgSend(void, self, "setFrontFacingWinding:", .{winding});
    }

    pub fn setCullMode(self: *RenderCommandEncoder, mode: CullMode) void {
        c.msgSend(void, self, "setCullMode:", .{mode});
    }

    pub fn setTriangleFillMode(self: *RenderCommandEncoder, mode: TriangleFillMode) void {
        c.msgSend(void, self, "setTriangleFillMode:", .{mode});
    }

    pub fn setDepthStencilState(self: *RenderCommandEncoder, state: ?*DepthStencilState) void {
        c.msgSend(void, self, "setDepthStencilState:", .{state});
    }

    pub fn setDepthBias(self: *RenderCommandEncoder, depth_bias: f32, slope_scale: f32, clamp: f32) void {
        c.msgSend(void, self, "setDepthBias:slopeScale:clamp:", .{ depth_bias, slope_scale, clamp });
    }

    pub fn setStencilReferenceValue(self: *RenderCommandEncoder, value: u32) void {
        c.msgSend(void, self, "setStencilReferenceValue:", .{value});
    }

    pub fn setBlendColor(self: *RenderCommandEncoder, red: f32, green: f32, blue: f32, alpha: f32) void {
        c.msgSend(void, self, "setBlendColorRed:green:blue:alpha:", .{ red, green, blue, alpha });
    }

    pub fn setVisibilityResultMode(self: *RenderCommandEncoder, mode: VisibilityResultMode, offset: usize) void {
        c.msgSend(void, self, "setVisibilityResultMode:offset:", .{ mode, offset });
    }

    pub fn memoryBarrierWithScope(self: *RenderCommandEncoder, scope: BarrierScope) void {
        c.msgSend(void, self, "memoryBarrierWithScope:", .{scope});
    }

    pub fn memoryBarrierWithResources(self: *RenderCommandEncoder, resources: ?*NS.Array) void {
        c.msgSend(void, self, "memoryBarrierWithResources:", .{resources});
    }

    pub fn updateFence(self: *RenderCommandEncoder, fence: *Fence) void {
        c.msgSend(void, self, "updateFence:", .{fence});
    }

    pub fn waitForFence(self: *RenderCommandEncoder, fence: *Fence) void {
        c.msgSend(void, self, "waitForFence:", .{fence});
    }

    pub fn endEncoding(self: *RenderCommandEncoder) void {
        c.msgSend(void, self, "endEncoding", .{});
    }
};

pub const DepthStencilState = opaque {
    pub fn super(self: *DepthStencilState) *NS.Object {
        return @ptrCast(self);
    }
};

pub const BarrierScope = packed struct(u64) {
    buffers: bool = false,
    textures: bool = false,
    render_targets: bool = false,
    pad0: u61 = 0,
};

pub const VisibilityResultMode = enum(usize) {
    disabled = 0,
    boolean = 1,
    counting = 2,
};

pub const Fence = opaque {
    pub fn super(self: *Fence) *NS.Object {
        return @ptrCast(self);
    }

    pub fn device(self: *Fence) *Device {
        return c.msgSend(*Device, self, "device", .{});
    }

    pub fn label(self: *Fence) ?*NS.String {
        return c.msgSend(?*NS.String, self, "label", .{});
    }

    pub fn setLabel(self: *Fence, label_: ?*NS.String) void {
        c.msgSend(void, self, "setLabel:", .{label_});
    }
};
