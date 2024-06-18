const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const group_name_path = .{
        .{ .name = "array", .path = "array.zig" },
        .{ .name = "linked_list", .path = "linked_list.zig" },
        };
    inline for (group_name_path) |name_path| {
        const exe = b.addExecutable(.{
            .name = name_path.name,
            .root_source_file = b.path(name_path.path),
            .target = target,
            .optimize = optimize,
        });
        exe.root_module.addImport("include", b.addModule("", .{.root_source_file = b.path("include/include.zig")}));
        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| run_cmd.addArgs(args);
        const run_step = b.step("run_" ++ name_path.name, "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}
