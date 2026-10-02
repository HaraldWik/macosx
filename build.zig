const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const objc = b.addModule("objc", .{
        .root_source_file = b.path("src/objc.zig"),
        .target = target,
        .optimize = optimize,
    });

    _ = b.addModule("frameworks", .{
        .root_source_file = b.path("src/frameworks.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "objc", .module = objc },
        },
    });
}
