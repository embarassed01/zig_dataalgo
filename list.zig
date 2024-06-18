const std = @import("std");
const inc = @import("include");

pub fn main() !void {
    // 初始化列表
    var nums = std.ArrayList(i32).init(std.heap.page_allocator);
    // 延迟释放内存
    defer nums.deinit();
    try nums.appendSlice(&[_]i32{ 1, 3, 2, 5, 4 });
    std.debug.print("列表nums=", .{});
    inc.PrintUtil.printList(i32, nums);

    // 访问元素
    const num = nums.items[1];
    std.debug.print("\n访问索引1处的元素，得到num={}", .{ num });

    // 更新元素
    nums.items[1] = 0;
    std.debug.print("\n将索引1处的元素更新为0， 得到nums=", .{});
    inc.PrintUtil.printList(i32, nums);

    // 清空列表
    nums.clearRetainingCapacity();
    std.debug.print("\n清空列表后nums=", .{});
    inc.PrintUtil.printList(i32, nums);

    // 在尾部添加元素
    try nums.append(1);
    try nums.append(3);
    try nums.append(2);
    try nums.append(5);
    try nums.append(4);
    std.debug.print("\n添加元素后nums=", .{});
    inc.PrintUtil.printList(i32, nums);

    // 在中间插入元素
    try nums.insert(3, 6);
    std.debug.print("\n在索引3处插入数字6，得到nums=", .{});
    inc.PrintUtil.printList(i32, nums);

    // 删除元素
    _ = nums.orderedRemove(3);
    std.debug.print("\n删除索引3处的元素，得到nums=", .{});
    inc.PrintUtil.printList(i32, nums);

    // 通过索引遍历列表
    var count: i32 = 0;
    var i: usize = 0;
    while (i < nums.items.len) : (i += 1) {
        count += nums.items[i];
    }
    // 直接遍历列表元素
    count = 0;
    for (nums.items) |x| {
        count += x;
    }

    // 拼接两个列表
    var nums1 = std.ArrayList(i32).init(std.heap.page_allocator);
    defer nums1.deinit();
    try nums1.appendSlice(&[_]i32{ 6, 8, 7, 10, 9 });
    try nums.insertSlice(nums.items.len, nums1.items);
    std.debug.print("\n将列表nums1拼接到nums之后，得到nums=", .{});
    inc.PrintUtil.printList(i32, nums);

    // 排序列表
    std.mem.sort(i32, nums.items, {}, comptime std.sort.asc(i32));  // asc升序
    std.debug.print("\n排序列表后nums=", .{});
    inc.PrintUtil.printList(i32, nums);

    _ = try std.io.getStdIn().reader().readByte();
}