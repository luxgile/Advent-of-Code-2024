const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    build_day(b, target, "01", "src/day_01.zig");
    build_day(b, target, "02", "src/day_02.zig");
    build_day(b, target, "03", "src/day_03.zig");
}

fn build_day(b: *std.Build, target: std.Build.ResolvedTarget, cmd: []const u8, src: []const u8) void {
    var exe = b.addExecutable(.{ .name = cmd, .root_source_file = b.path(src), .target = target });
    exe.root_module.addImport("mvzr", b.dependency("mvzr", .{}).module("mvzr"));

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step(cmd, "");
    run_step.dependOn(&run_cmd.step);
}
