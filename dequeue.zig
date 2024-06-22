const std = @import("std");
const inc = @import("include");

pub fn main() !void {
    const L = std.DoublyLinkedList(i32);
    var dequeue = L{};

    var node1 = L.Node{ .data = 2 };
    var node2 = L.Node{ .data = 5 };
    var node3 = L.Node{ .data = 4 };
    var node4 = L.Node{ .data = 3 };
    var node5 = L.Node{ .data = 1 };
    dequeue.append(&node1);
    dequeue.append(&node2);
    dequeue.append(&node3);
    dequeue.append(&node4);
    dequeue.append(&node5);
    std.debug.print("双向队列dequeue=", .{});
    inc.PrintUtil.printQueue(i32, dequeue);

    const peek_first = dequeue.first.?.data;
    std.debug.print("\n队首元素peek_first={}", .{peek_first});
    const peek_last = dequeue.last.?.data;
    std.debug.print("\n队尾元素peek_last={}", .{peek_last});

    const pop_first = dequeue.popFirst().?.data;
    std.debug.print("\n队首出队元素pop_first={}, 队首出队后dequeue=", .{pop_first});
    inc.PrintUtil.printQueue(i32, dequeue);
    const pop_last = dequeue.pop().?.data;
    std.debug.print("\n队尾出队元素pop_last={}, 队尾出队后dequeue=", .{pop_last});
    inc.PrintUtil.printQueue(i32, dequeue);

    const size = dequeue.len;
    std.debug.print("\n双向队列长度size={}", .{size});

    const is_empty = if (dequeue.len == 0) true else false;
    std.debug.print("\n双向队列是否为空={}", .{is_empty});

    _ = try std.io.getStdIn().reader().readByte();
}