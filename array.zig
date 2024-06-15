const std = @import("std");
const inc = @import("include");

/// 随机访问元素
pub fn randomAccess(nums: []i32) i32 {
    // 在[0, nums.len)中随机抽取一个整数
    const randomIndex = std.crypto.random.intRangeLessThan(usize, 0, nums.len);
    const randomNum = nums[randomIndex];
    return randomNum;
}

/// 扩展数组长度
pub fn extend(mem_allocator: std.mem.Allocator, nums: []i32, enlarge: usize) ![]i32 {
    // 初始化一个扩展长度后的数组
    const res = try mem_allocator.alloc(i32, nums.len + enlarge);
    @memset(res, 0);
    std.mem.copyBackwards(i32, res, nums);
    return res;
}

/// 在数组索引index处插入元素num
pub fn insert(nums: []i32, num: i32, index: usize) void {
    // 把索引index以及之后的所有元素向后移动一位
    var i = nums.len - 1;
    while (i > index) : (i -= 1) {
        nums[i] = nums[i - 1];
    }
    nums[index] = num;
}

/// 删除索引index处的元素
pub fn remove(nums: []i32, index: usize) void {
    // 把索引index之后的所有元素向前移动一位
    var i = index;
    while (i < nums.len - 1) : (i += 1) {
        nums[i] = nums[i + 1];
    }
}

/// 遍历数组
pub fn traverse(nums: []i32) void {
    var count: i32 = 0;
    // 通过 索引 遍历数组
    var i: usize = 0;
    while (i < nums.len) : (i += 1) {
        count += nums[i];
    }
    count = 0;
    // 直接遍历数组元素
    for (nums) |num| {
        count += num;
    }
}

/// 在数组中查找指定元素
pub fn find(nums: []i32, target: i32) i32 {
    for (nums, 0..) |num, i| {
        if (num == target) return @intCast(i);
    }
    return -1;
}

pub fn main() !void {
    // 初始化内存分配器
    var mem_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer mem_arena.deinit();
    const mem_allocator = mem_arena.allocator();

    // 初始化数组
    var arr = [_]i32{ 0 } ** 5;
    std.debug.print("数组arr=", .{});
    inc.PrintUtil.printArray(i32, &arr);

    var array = [_]i32{ 1, 3, 2, 5, 4 };
    var known_at_runtime_zero: usize = undefined;
    known_at_runtime_zero = 0;
    var nums = array[known_at_runtime_zero..];
    std.debug.print("\n数组nums=", .{});
    inc.PrintUtil.printArray(i32, nums);

    // 随机访问
    const randomNum = randomAccess(nums);
    std.debug.print("\n在nums中获取随机元素{}", .{randomNum});

    // 长度扩展
    nums = try extend(mem_allocator, nums, 3);
    std.debug.print("\n将数组长度扩展至8, 得到nums=", .{});
    inc.PrintUtil.printArray(i32, nums);

    // 插入元素
    insert(nums, 6, 3);
    std.debug.print("\n在索引3处插入数字6,得到nums=", .{});
    inc.PrintUtil.printArray(i32, nums);

    // 删除元素
    remove(nums, 2);
    std.debug.print("\n删除索引2处的元素,得到nums=", .{});
    inc.PrintUtil.printArray(i32, nums);

    // 遍历数组
    traverse(nums);

    // 查找元素
    const index = find(nums, 3);
    std.debug.print("\n在nums中查找元素3,得到索引={}", .{index});
    _ = try std.io.getStdIn().reader().readByte();
}