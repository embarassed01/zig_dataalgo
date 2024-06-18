const std = @import("std");
pub const ListUtil = @import("ListNode.zig");
pub const ListNode = ListUtil.ListNode;

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

/// 打印链表
pub fn printLinkedList(comptime T: type, node: ?*ListNode(T)) !void {
    if (node == null) return;
    var list = std.ArrayList(T).init(std.heap.page_allocator);
    defer list.deinit();
    var head = node;
    while (head != null) {
        try list.append(head.?.val);
        head = head.?.next;
    }
    for (list.items, 0..) |value, i| {
        std.debug.print("{}{s}", .{
            value, if (i == list.items.len - 1) "\n" else "->"
        });
    }
}

/// 打印列表
pub fn printList(comptime T: type, list: std.ArrayList(T)) void {
    std.debug.print("[", .{});
    if (list.items.len > 0) {
        for (list.items, 0..) |value, i| {
            std.debug.print("{}{s}", .{
                value, if (i == list.items.len - 1) "]" else ", "
            });
        }
    } else {
        std.debug.print("]", .{});
    }
}
