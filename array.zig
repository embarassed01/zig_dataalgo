const std = @import("std");
const inc = @import("include");

pub fn main() !void {
    var nums = [_]i32{ 1, 2, 3, 4 };
    inc.PrintUtil.printArray(i32, &nums);
    std.debug.print("\n", .{});
}