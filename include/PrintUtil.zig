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

/// 打印队列
pub fn printQueue(comptime T: type, queue: std.DoublyLinkedList(T)) void {
    var node = queue.first;
    std.debug.print("[", .{});
    var i: i32 = 0;
    while (node != null) : (i += 1) {
        const data = node.?.data;
        std.debug.print("{}{s}", .{
            data, 
            if (i == queue.len - 1) "]" else ", "
        });
        node = node.?.next;
    }
}

/// 打印哈希表
pub fn printHashMap(comptime TKey: type, comptime TValue: type, map: std.AutoHashMap(TKey, TValue)) void {
    var it = map.iterator();
    while (it.next()) |kv| {
        const key = kv.key_ptr.*;
        const value = kv.value_ptr.*;
        std.debug.print("{}->{s}\n", .{key, value});
    }
}
