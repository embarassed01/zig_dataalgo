const std = @import("std");
const inc = @import("include");

pub fn main() !void {
    const L = std.DoublyLinkedList(i32);  // TailQueue已经被此替代！
    var queue = L{};

    var node1 = L.Node{ .data = 1 };
    var node2 = L.Node{ .data = 3 };
    var node3 = L.Node{ .data = 2 };
    var node4 = L.Node{ .data = 5 };
    var node5 = L.Node{ .data = 4 };
    queue.append(&node1);
    queue.append(&node2);
    queue.append(&node3);
    queue.append(&node4);
    queue.append(&node5);
    std.debug.print("队列queue=", .{});
    inc.PrintUtil.printQueue(i32, queue);

    // 访问队首元素
    const peek = queue.first.?.data;
    std.debug.print("\n队首元素peek={}", .{peek});

    // 元素出队
    const pop = queue.popFirst().?.data;
    std.debug.print("\n出队元素pop={}, 出队后queue=", .{pop});
    inc.PrintUtil.printQueue(i32, queue);

    const size = queue.len;
    std.debug.print("\n队列长度size={}", .{size});

    const is_empty = if (queue.len == 0) true else false;
    std.debug.print("\n队列是否为空={}", .{is_empty});

    _ = try std.io.getStdIn().reader().readByte();
}