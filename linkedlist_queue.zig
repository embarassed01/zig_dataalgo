const std = @import("std");
const inc = @import("include");

/// 基于链表实现的队列queue
pub fn LinkedListQueue(comptime T: type) type {
    return struct {
        const Self = @This();

        front: ?*inc.ListNode(T) = null, // 头节点
        rear: ?*inc.ListNode(T) = null, // 尾节点
        que_size: usize = 0, // 队列的长度
        mem_arena: ?std.heap.ArenaAllocator = null,
        mem_allocator: std.mem.Allocator = undefined, // 内存分配器

        /// 构造方法（分配内存+初始化队列）
        pub fn init(self: *Self, allocator: std.mem.Allocator) !void {
            if (self.mem_arena == null) {
                self.mem_arena = std.heap.ArenaAllocator.init(allocator);
                self.mem_allocator = self.mem_arena.?.allocator();
            }
            self.front = null;
            self.rear = null;
            self.que_size = 0;
        }

        /// 析构方法（释放内存）
        pub fn deinit(self: *Self) void {
            if (self.mem_arena == null) return;
            self.mem_arena.?.deinit();
        }

        /// 获取队列的长度
        pub fn size(self: *Self) usize {
            return self.que_size;
        }

        /// 判断队列是否为空
        pub fn isEmpty(self: *Self) bool {
            return self.size() == 0;
        }

        /// 访问队首元素
        pub fn peek(self: *Self) T {
            if (self.size() == 0) @panic("队列为空");
            return self.front.?.val;
        }

        /// 入队
        pub fn push(self: *Self, num: T) !void {
            // 在尾节点后添加num
            var node = try self.mem_allocator.create(inc.ListNode(T));
            node.init(num);
            // 如果队列为空，则令 头、尾节点都指向该节点
            if (self.front == null) {
                self.front = node;
                self.rear = node;
            } else { // 如果队列不为空，则将该节点添加到尾节点后
                self.rear.?.next = node;
                self.rear = node;
            }
            self.que_size += 1;
        }

        /// 出队
        pub fn pop(self: *Self) T {
            const num = self.peek();
            // 删除头节点
            self.front = self.front.?.next;
            self.que_size -= 1;
            return num;
        }

        /// 将链表转换为数组
        pub fn toArray(self: *Self) ![]T {
            var node = self.front;
            var res = try self.mem_allocator.alloc(T, self.size());
            @memset(res, @as(T, 0));
            var i: usize = 0;
            while (i < res.len) : (i += 1) {
                res[i] = node.?.val;
                node = node.?.next;
            }
            return res;
        }
    };
}

pub fn main() !void {
    // 初始化队列
    var queue = LinkedListQueue(i32){};
    try queue.init(std.heap.page_allocator);
    defer queue.deinit();

    // 元素入队
    try queue.push(1);
    try queue.push(3);
    try queue.push(2);
    try queue.push(5);
    try queue.push(4);
    std.debug.print("队列queue=", .{});
    inc.PrintUtil.printArray(i32, try queue.toArray());

    // 访问队首元素
    const peek = queue.peek();
    std.debug.print("\n队首元素peek={}", .{peek});

    // 元素出队
    const pop = queue.pop();
    std.debug.print("\n出队元素pop={}, 出队后queue=", .{pop});
    inc.PrintUtil.printArray(i32, try queue.toArray());

    // 获取队列的长度
    const size = queue.size();
    std.debug.print("\n队列长度size={}", .{size});

    // 判断队列是否为空
    const is_empty = queue.isEmpty();
    std.debug.print("\n队列是否为空={}", .{is_empty});

    _ = try std.io.getStdIn().reader().readByte();
}
