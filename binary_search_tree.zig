const std = @import("std");
const inc = @import("include");

/// 二叉搜索🌲
pub fn BinarySearchTree(comptime T: type) type {
    return struct {
        const Self = @This();

        root: ?*inc.TreeNode(T) = null,
        mem_arena: ?std.heap.ArenaAllocator = null,
        mem_allocator: std.mem.Allocator = undefined, // 内存分配器

        /// 构造方法
        pub fn init(self: *Self, allocator: std.mem.Allocator, nums: []T) !void {
            if (self.mem_arena == null) {
                self.mem_arena = std.heap.ArenaAllocator.init(allocator);
                self.mem_allocator = self.mem_arena.?.allocator();
            }
            std.mem.sort(T, nums, {}, comptime std.sort.asc(T)); // 升序排序数组
            self.root = try self.buildTree(nums, 0, nums.len - 1); // 构建二叉搜索树
        }

        /// 析构方法
        pub fn deinit(self: *Self) void {
            if (self.mem_arena == null) return;
            self.mem_arena.?.deinit();
        }

        // 构建二叉搜索树
        //  前提：数组已经是升序排列好的了！！
        fn buildTree(self: *Self, nums: []T, i: usize, j: usize) !?*inc.TreeNode(T) {
            if (i > j) return null;
            // 将数组中间节点作为根节点
            const mid = i + (j - i) / 2;
            const node = try self.mem_allocator.create(inc.TreeNode(T));
            node.init(nums[mid]);
            // 递归构建左子树和右子树
            if (mid >= 1) node.left = try self.buildTree(nums, i, mid - 1);
            node.right = try self.buildTree(nums, mid + 1, j);
            return node;
        }

        // 获取二叉树根节点
        fn getRoot(self: *Self) ?*inc.TreeNode(T) {
            return self.root;
        }

        // 查找节点
        fn search(self: *Self, num: T) ?*inc.TreeNode(T) {
            var cur = self.root;
            // 循环查找，越过叶节点后跳出
            while (cur != null) {
                // 目标节点在cur的右子树中
                if (cur.?.val < num) {
                    cur = cur.?.right;
                    // 目标节点在cur的左子树中
                } else if (cur.?.val > num) {
                    cur = cur.?.left;
                    // 找到目标节点，跳出循环
                } else {
                    break;
                }
            }
            return cur;
        }

        // 插入节点
        fn insert(self: *Self, num: T) !void {
            // 若树为空，则初始化根节点
            if (self.root == null) {
                self.root = try self.mem_allocator.create(inc.TreeNode(T));
                return;
            }
            var cur = self.root;
            var pre: ?*inc.TreeNode(T) = null;
            // 循环查找
            while (cur != null) {
                // 找到重复节点，直接返回
                if (cur.?.val == num) return;
                pre = cur;
                // 插入位置在cur的右子树中
                if (cur.?.val < num) {
                    cur = cur.?.right;
                    // 插入位置在cur的左子树中
                } else {
                    cur = cur.?.left;
                }
            }
            // 插入节点
            var node = try self.mem_allocator.create(inc.TreeNode(T));
            node.init(num);
            if (pre.?.val < num) {
                pre.?.right = node;
            } else {
                pre.?.left = node;
            }
        }

        // 删除节点
        fn remove(self: *Self, num: T) void {
            if (self.root == null) return;
            var cur = self.root;
            var pre: ?*inc.TreeNode(T) = null;
            while (cur != null) {
                if (cur.?.val == num) break;
                pre = cur;
                if (cur.?.val < num) {
                    cur = cur.?.right;
                } else {
                    cur = cur.?.left;
                }
            }
            // 若没有待删除节点，则直接返回
            if (cur == null) return;
            // 子节点数量=0 or 1
            if (cur.?.left == null or cur.?.right == null) {
                // 当子节点数量=0 / 1时，child=null/该子节点
                const child = if (cur.?.left != null) cur.?.left else cur.?.right;
                // 删除节点cur
                if (pre.?.left == cur) {
                    pre.?.left = child;
                } else {
                    pre.?.right = child;
                }
                // 子节点数量=2
            } else {
                // 获取中序遍历中cur的下一个节点
                var tmp = cur.?.right;
                while (tmp.?.left != null) {
                    tmp = tmp.?.left;
                }
                const tmp_val = tmp.?.val;
                // 递归删除节点tmp
                self.remove(tmp.?.val);
                // 用tmp覆盖cur
                cur.?.val = tmp_val;
            }
        }
    };
}

pub fn main() !void {
    var nums = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 };
    var bst = BinarySearchTree(i32){};
    try bst.init(std.heap.page_allocator, &nums);
    defer bst.deinit();
    std.debug.print("初始化二叉树\n", .{});
    try inc.PrintUtil.printTree(bst.getRoot(), null, false);

    // 查找节点
    const node = bst.search(7);
    std.debug.print("\n查找到的节点对象为{any}, 节点值={}\n", .{ node, node.?.val });

    // 插入节点
    try bst.insert(16);
    std.debug.print("\n插入节点16后，二叉树为\n", .{});
    try inc.PrintUtil.printTree(bst.getRoot(), null, false);

    // 删除节点
    bst.remove(1);
    std.debug.print("\n删除节点1后，二叉树为\n", .{});
    try inc.PrintUtil.printTree(bst.getRoot(), null, false);
    bst.remove(2);
    std.debug.print("\n删除节点2后，二叉树为\n", .{});
    try inc.PrintUtil.printTree(bst.getRoot(), null, false);
    bst.remove(4);
    std.debug.print("\n删除节点4后，二叉树为\n", .{});
    try inc.PrintUtil.printTree(bst.getRoot(), null, false);

    _ = try std.io.getStdIn().reader().readByte();
}
