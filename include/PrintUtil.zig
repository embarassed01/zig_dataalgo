const std = @import("std");

/// 打印数组
pub fn printArray(comptime T: type, nums: []T) void {
    std.debug.print("[", .{});
    if (nums.len > 0) {
        for (nums, 0..) |num, j| {
            std.debug.print("{}{s}", .{num, if (j == nums.len-1) "]" else ", "});
        }
    } else {
        std.debug.print("]", .{});
    }
}
