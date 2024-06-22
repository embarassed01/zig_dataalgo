const std = @import("std");
const inc = @import("include");

/// 基于 环形数组 实现的队列
pub fn ArrayQueue(comptime T: type) type {
    return struct {
        const Self =@This();

        nums: []T = undefined,  // 用于存储队列元素的数组
        cap: usize = 0,  // 队列容量
        front: usize = 0,  // 队首指针，指向队首元素
        queSize: usize = 0, // 尾指针，指向队尾+1
        mem_arena: ?std.heap.ArenaAllocator = null, 
        mem_allocator: std.mem.Allocator = undefined,  // 内存分配器

        /// 构造方法（分配内存+初始化数组）
        pub fn init(self: *Self, allocator: std.mem.Allocator, cap: usize) !void {
            if (self.mem_arena == null) {
                self.mem_arena = std.heap.ArenaAllocator.init(allocator);
                self.mem_allocator = self.mem_arena.?.allocator();
            }
            self.cap = cap;
            self.nums = try self.mem_allocator.alloc(T, self.cap);
            @memset(self.nums, @as(T, 0));
        }

        /// 析构方法（释放内存）
        pub fn deinit(self: *Self) void {
            if (self.mem_arena == null) return;
            self.mem_arena.?.deinit();
        }

        /// 获取队列的容量
        pub fn capacity(self: *Self) usize {
            return self.cap;
        }

        /// 获取队列的长度
        pub fn size(self: *Self) usize {
            return self.queSize;
        }

        /// 判断队列是否为空
        pub fn isEmpty(self: *Self) bool {
            return self.queSize == 0;
        }

        /// 入队
        pub fn push(self: *Self, num: T) !void {
            if (self.size() == self.capacity()) {
                std.debug.print("队列已满\n", .{});
                return;
            }
            // 计算队尾指针，指向队尾索引+1
            // 通过取余操作实现rear越过数组尾部后回到头部
            const rear = (self.front + self.queSize) % self.capacity();
            // 在尾节点后添加num
            self.nums[rear] = num;
            self.queSize += 1;
        }

        /// 访问队首元素
        pub fn peek(self: *Self) T {
            if (self.isEmpty()) @panic("队列为空");
            return self.nums[self.front];
        }

        /// 出队
        pub fn pop(self: *Self) T {
            const num = self.peek();
            // 队首指针向后移动一位，若越过尾部，则返回到数组头部
            self.front = (self.front + 1) % self.capacity();
            self.queSize -= 1;
            return num;
        }

        /// 转换为数组
        pub fn toArray(self: *Self) ![]T {
            // 仅转换有效范围内的队列元素
            var res = try self.mem_allocator.alloc(T, self.size());
            @memset(res, @as(T, 0));
            var i: usize = 0;
            var j: usize = self.front;
            while (i < self.size()) : ({ i += 1; j += 1; }) {
                res[i] = self.nums[j % self.capacity()];
            }
            return res;
        }
    };
}

pub fn main() !void {
    // 初始化队列
    const capacity: usize = 10;
    var queue = ArrayQueue(i32){};
    try queue.init(std.heap.page_allocator, capacity);
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

    // 测试环形数组
    var i: i32 = 0;
    while (i < 10) : (i += 1) {
        try queue.push(i);
        _ = queue.pop();
        std.debug.print("\n第{}轮入队+出队后queue=", .{i});
        inc.PrintUtil.printArray(i32, try queue.toArray());
    }

    _ = try std.io.getStdIn().reader().readByte();    
}