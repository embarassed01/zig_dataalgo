const std = @import("std");

/// 链表节点
pub fn ListNode(comptime T: type) type {
    return struct {
        const Self = @This();

        val: T = 0,
        next: ?*Self = null,

        // Initialize a list node with specific value
        pub fn init(self: *Self, x: i32) void {
            self.val = x;
            self.next = null;
        }
    };
}

/// 将数组 反序列化为 链表
pub fn arrToLinkedList(comptime T: type, mem_allocator: std.mem.Allocator, arr: []T) !?*ListNode(T) {
    var dum = try mem_allocator.create(ListNode(T));
    dum.init(0);  // 头指针是哨兵，没有实际内容
    var head = dum;
    for (arr) |val| {
        var tmp = try mem_allocator.create(ListNode(T));
        tmp.init(val);
        head.next = tmp;
        head = head.next.?;
    }
    return dum.next;
}

