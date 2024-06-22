const std = @import("std");
const inc = @import("include");

// 键值对
const Pair = struct {
    key: usize = undefined,
    val: []const u8 = undefined,

    pub fn init(key: usize, val: []const u8) Pair {
        return Pair{
            .key = key,
            .val = val,
        };
    }
};

/// 基于数组实现的哈希表
pub fn ArrayHashMap(comptime T: type) type {
    return struct {
        const Self = @This();

        bucket: ?std.ArrayList(?T) = null,
        mem_allocator: std.mem.Allocator = undefined,

        /// 构造方法
        pub fn init(self: *Self, allocator: std.mem.Allocator) !void {
            self.mem_allocator = allocator;
            // 初始化一个长度为100的🪣(数组)
            self.bucket = std.ArrayList(?T).init(self.mem_allocator);
            var i: i32 = 0;
            while (i < 100) : (i += 1) {
                try self.bucket.?.append(null);
            }
        }

        /// 析构方法
        pub fn deinit(self: *Self) void {
            if (self.bucket != null) self.bucket.?.deinit();
        }

        /// 哈希函数
        fn hashFunc(key: usize) usize {
            const index = key % 100;
            return index;
        }

        /// 查询操作
        pub fn get(self: *Self, key: usize) []const u8 {
            const index = hashFunc(key);
            const pair = self.bucket.?.items[index];
            return pair.?.val;
        }

        /// 添加操作
        pub fn put(self: *Self, key: usize, val: []const u8) !void {
            const pair = Pair.init(key, val);
            const index = hashFunc(key);
            self.bucket.?.items[index] = pair;
        }

        /// 删除操作
        pub fn remove(self: *Self, key: usize) !void {
            const index = hashFunc(key);
            // 置为null，代表删除
            self.bucket.?.items[index] = null;
        }

        // 获取所有键值对
        pub fn pairSet(self: *Self) !std.ArrayList(T) {
            var entry_set = std.ArrayList(T).init(self.mem_allocator);
            for (self.bucket.?.items) |item| {
                if (item == null) continue;
                try entry_set.append(item.?);
            }
            return entry_set;
        }

        /// 获取所有键
        pub fn keySet(self: *Self) !std.ArrayList(usize) {
            var key_set = std.ArrayList(usize).init(self.mem_allocator);
            for (self.bucket.?.items) |item| {
                if (item == null) continue;
                try key_set.append(item.?.key);
            }
            return key_set;
        }

        /// 获取所有值
        pub fn valueSet(self: *Self) !std.ArrayList([]const u8) {
            var value_set = std.ArrayList([]const u8).init(self.mem_allocator);
            for (self.bucket.?.items) |item| {
                if (item == null) continue;
                try value_set.append(item.?.val);
            }
            return value_set;
        }

        /// 打印哈希表
        pub fn print(self: *Self) !void {
            var entry_set = try self.pairSet();
            defer entry_set.deinit();
            for (entry_set.items) |item| {
                std.debug.print("{}->{s}\n", .{item.key, item.val});
            }
        }
    };
}

pub fn main() !void {
    var map = ArrayHashMap(Pair){};
    try map.init(std.heap.page_allocator);
    defer map.deinit();

    // 添加操作
    // 在哈希表中添加键值对 (key, value)
    try map.put(12836, "小哈");
    try map.put(15937, "小啰");
    try map.put(16750, "小算");
    try map.put(13276, "小法");
    try map.put(10583, "小鸭");
    std.debug.print("\n添加完成后，哈希表为\nKey -> Value\n", .{});
    try map.print();

    // 查询操作
    const name = map.get(15937);
    std.debug.print("\n输入学号15937，查询到姓名{s}\n", .{name});

    // 删除操作
    try map.remove(10583);
    std.debug.print("\n删除10583后，哈希表\nKey->Value\n", .{});
    try map.print();

    // 遍历哈希表
    std.debug.print("\n遍历键值对 Key->Value\n", .{});
    var entry_set = try map.pairSet();
    defer entry_set.deinit();
    for (entry_set.items) |kv| {
        std.debug.print("{}->{s}\n", .{kv.key, kv.val});
    }

    std.debug.print("\n单独遍历键Key\n", .{});
    var key_set = try map.keySet();
    defer key_set.deinit();
    for (key_set.items) |key| {
        std.debug.print("{}\n", .{key});
    }

    std.debug.print("\n单独遍历值 Value\n", .{});
    var value_set = try map.valueSet();
    defer value_set.deinit();
    for (value_set.items) |val| {
        std.debug.print("{s}\n", .{val});
    }

    _ = try std.io.getStdIn().reader().readByte();
}
