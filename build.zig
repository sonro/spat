const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_module = b.addModule("spat", .{
        .root_source_file = b.path("src/spat.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "spat",
        .root_source_file = b.path("src/spat.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib);

    const tests = b.addTest(.{
        .root_source_file = b.path("tests/tests.zig"),
        .name = "test",
        .target = target,
        .optimize = optimize,
    });
    tests.root_module.addImport("spat", lib_module);
    b.installArtifact(tests);
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    const lib_check = b.addStaticLibrary(.{
        .name = "lib_check",
        .root_source_file = b.path("src/spat.zig"),
        .target = target,
        .optimize = optimize,
    });
    const test_check = b.addTest(.{
        .root_source_file = b.path("tests/tests.zig"),
        .name = "test",
        .target = target,
        .optimize = optimize,
    });
    test_check.root_module.addImport("spat", lib_module);
    const check = b.step("check", "Check compilation");
    check.dependOn(&lib_check.step);
    check.dependOn(&test_check.step);
}
