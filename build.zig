const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const group_name_path = .{
        .{ .name = "array", .path = "array.zig" },
        .{ .name = "linked_list", .path = "linked_list.zig" },
        .{ .name = "list", .path = "list.zig"},
        .{ .name = "my_list", .path = "my_list.zig" },
        .{ .name = "linkedlist_stack", .path = "linkedlist_stack.zig" },
        .{ .name = "array_stack", .path = "array_stack.zig" },
        .{ .name = "linkedlist_queue", .path = "linkedlist_queue.zig" },
        .{ .name = "array_queue", .path = "array_queue.zig" },
        .{ .name = "queue", .path = "queue.zig" },
        .{ .name = "dequeue", .path = "dequeue.zig" },
        .{ .name = "linkedlist_deque", .path = "linkedlist_deque.zig" },
        .{ .name = "hash_map", .path = "hash_map.zig" },
        .{ .name = "array_hash_map", .path = "array_hash_map.zig" },
        .{ .name = "binary_tree", .path = "binary_tree.zig" },
        .{ .name = "binary_tree_bfs", .path = "binary_tree_bfs.zig" },
        .{ .name = "binary_tree_dfs", .path = "binary_tree_dfs.zig" },
        .{ .name = "binary_search_tree", .path = "binary_search_tree.zig" },
        .{ .name = "avl_tree", .path = "avl_tree.zig" },
        .{ .name = "heap", .path = "heap.zig" },
        .{ .name = "my_heap", .path = "my_heap.zig" },
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
