const std = @import("std");
const inc = @import("include");

/// 列表类
pub fn MyList(comptime T: type) type {
    return struct {
        const Self = @This();

        arr: []T = undefined,  // 数组（存储列表元素）
        arrCapacity: usize = 5,  // 列表容量
        numSize: usize = 0,  // 列表长度（当前元素数量）
        extendRatio: usize = 2,  // 每次列表扩容的倍数
        mem_arena: ?std.heap.ArenaAllocator = null,
        mem_allocator: std.mem.Allocator = undefined,  // 内存分配器

        /// 构造函数（分配内存+初始化列表）
        /// 
        /// note:
        pub fn init(self: *Self, allocator: std.mem.Allocator) !void {
            if (self.mem_arena == null) {
                self.mem_arena = std.heap.ArenaAllocator.init(allocator);
                self.mem_allocator = self.mem_arena.?.allocator();
            }
            self.arr = try self.mem_allocator.alloc(T, self.arrCapacity);
            @memset(self.arr, @as(T, 0));
        }

        /// 析构函数 
        pub fn deinit(self: *Self) void {
            if (self.mem_arena == null) return;
            self.mem_arena.?.deinit();
        }

        /// 获取列表长度（当前元素数量）
        pub fn size(self: *Self) usize {
            return self.numSize;
        }

        /// 获取列表容量
        pub fn capacity(self: *Self) usize {
            return self.arrCapacity;
        }

        /// 访问元素
        pub fn get(self: *Self, index: usize) T {
            if (index < 0 or index >= self.size()) @panic("索引越界");
            return self.arr[index];
        }

        /// 更新元素
        pub fn set(self: *Self, index: usize, num: T) void {
            if (index < 0 or index >= self.size()) @panic("索引越界");
            self.arr[index] = num;
        }

        /// 在尾部添加元素
        pub fn add(self: *Self, num: T) !void {
            // 元素数量超出容量时，触发扩容机制
            if (self.size() == self.capacity()) try self.extendCapacity();
            self.arr[self.size()] = num;
            self.numSize += 1;
        }

        /// 在中国插入元素
        pub fn insert(self: *Self, index: usize, num: T) !void {
            if (index < 0 or index >= self.size()) @panic("索引越界");
            if (self.size() == self.capacity()) try self.extendCapacity();
            // 将索引index以及之后的元素都向后移动一位
            var j = self.size() - 1;
            while (j >= index) : (j -= 1) {
                self.arr[j + 1] = self.arr[j];
            }
            self.arr[index] = num;
            self.numSize += 1;
        }

        /// 删除元素
        pub fn remove(self: *Self, index: usize) T {
            if (index < 0 or index >= self.size()) @panic("索引越界");
            const num = self.arr[index];
            // 将索引index之后的元素都向前移动一位
            var j = index;
            while (j < self.size() - 1) : (j += 1) {
                self.arr[j] = self.arr[j + 1];
            }
            self.numSize -= 1;
            return num;
        }

        /// 列表扩容
        pub fn extendCapacity(self: *Self) !void {
            const newCapacity = self.capacity() * self.extendRatio;
            const extend = try self.mem_allocator.alloc(T, newCapacity);
            @memset(extend, @as(T, 0));
            // 将原数组中的所有元素复制到新数组
            std.mem.copyForwards(T, extend, self.arr);
            self.arr = extend;
            // 更新列表容量
            self.arrCapacity = newCapacity;
        }

        /// 将列表转换为数组
        pub fn toArray(self: *Self) ![]T {
            // 仅转换有效长度范围内的列表元素
            const arr = try self.mem_allocator.alloc(T, self.size());
            @memset(arr, @as(T, 0));
            for (arr, 0..) |*num, i| {
                num.* = self.get(i);
            }
            return arr;
        }
    };
}

pub fn main() !void {
    // 初始化列表
    var nums = MyList(i32){};
    try nums.init(std.heap.page_allocator);
    defer nums.deinit();

    // 在尾部添加元素
    try nums.add(1);
    try nums.add(3);
    try nums.add(2);
    try nums.add(5);
    try nums.add(4);
    std.debug.print("列表nums=", .{});
    inc.PrintUtil.printArray(i32, try nums.toArray());
    std.debug.print(", 容量={}, 长度={}", .{
        nums.capacity(), nums.size()
    });

    // 在中间插入元素
    try nums.insert(3, 6);
    std.debug.print("\n在索引3处插入数字6, 得到nums=", .{});
    inc.PrintUtil.printArray(i32, try nums.toArray());

    // 删除元素
    _ = nums.remove(3);
    std.debug.print("\n删除索引3处的元素, 得到nums=", .{});
    inc.PrintUtil.printArray(i32, try nums.toArray());

    // 访问元素
    const num = nums.get(1);
    std.debug.print("\n访问索引1处的元素, 得到num={}", .{num});

    // 更新元素
    nums.set(1, 0);
    std.debug.print("\n将索引1处的元素更新为0, 得到nums=", .{});
    inc.PrintUtil.printArray(i32, try nums.toArray());

    // 测试扩容机制
    var i: i32 = 0;
    while (i < 10) : (i += 1) {
        // 在i=5时，列表长度将超出列表容量，此时触发扩容机制
        try nums.add(i);
    }
    std.debug.print("\n扩容后的列表nums=", .{});
    inc.PrintUtil.printArray(i32, try nums.toArray());
    std.debug.print(", 容量={}, 长度={}\n", .{
        nums.capacity(), nums.size()
    });
    
    _ = try std.io.getStdIn().reader().readByte();
}