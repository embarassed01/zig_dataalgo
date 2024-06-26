const std = @import("std");
const inc = @import("include");

/// AVL🌲
pub fn AVLTree(comptime T: type) type {
    return struct {
        const Self = @This();

        root: ?*inc.TreeNode(T) = null, // 根节点
        mem_arena: ?std.heap.ArenaAllocator = null,
        mem_allocator: std.mem.Allocator = undefined, // 内存分配器

        /// 构造方法
        pub fn init(self: *Self, allocator: std.mem.Allocator) void {
            if (self.mem_arena == null) {
                self.mem_arena = std.heap.ArenaAllocator.init(allocator);
                self.mem_allocator = self.mem_arena.?.allocator();
            }
        }

        /// 析构方法
        pub fn deinit(self: *Self) void {
            if (self.mem_arena == null) return;
            self.mem_arena.?.deinit();
        }

        // 获取节点高度
        fn height(self: *Self, node: ?*inc.TreeNode(T)) i32 {
            _ = self;
            // 空节点高度为-1，叶节点高度为0
            return if (node == null) -1 else node.?.height;
        }

        // 更新节点高度
        fn updateHeight(self: *Self, node: ?*inc.TreeNode(T)) void {
            // 节点高度等于最高子树高度+1
            node.?.height = @max(self.height(node.?.left), self.height(node.?.right)) + 1;
        }

        // 获取平衡因子
        fn balanceFactor(self: *Self, node: ?*inc.TreeNode(T)) i32 {
            // 空节点平衡因子为0
            if (node == null) return 0;
            // 节点平衡因子 = 左子树高度 - 右子树高度
            return self.height(node.?.left) - self.height(node.?.right);
        }

        // 右旋操作
        fn rightRotate(self: *Self, node: ?*inc.TreeNode(T)) ?*inc.TreeNode(T) {
            var child = node.?.left;
            const grandChild = child.?.right;
            // 以child为原点，将node向右旋转
            child.?.right = node;
            node.?.left = grandChild;
            // 更新节点高度
            self.updateHeight(node);
            self.updateHeight(child);
            // 返回旋转后子树的根节点
            return child;
        }

        // 左旋操作
        fn leftRotate(self: *Self, node: ?*inc.TreeNode(T)) ?*inc.TreeNode(T) {
            var child = node.?.right;
            const grandChild = child.?.left;
            // 以child为原点，将node向左旋转
            child.?.left = node;
            node.?.right = grandChild;
            // 更新节点高度
            self.updateHeight(node);
            self.updateHeight(child);
            // 返回旋转后子树的根节点
            return child;
        }

        // 执行旋转操作，使该子树重新恢复平衡
        fn rotate(self: *Self, node: ?*inc.TreeNode(T)) ?*inc.TreeNode(T) {
            // 获取节点node的平衡因子
            const balance_factor = self.balanceFactor(node);
            // 左偏树
            if (balance_factor > 1) {
                // 右旋
                if (self.balanceFactor(node.?.left) >= 0) {
                    return self.rightRotate(node);
                    // 先左旋后右旋
                } else {
                    node.?.left = self.leftRotate(node.?.left);
                    return self.rightRotate(node);
                }
            }
            // 右偏树
            if (balance_factor < -1) {
                // 左旋
                if (self.balanceFactor(node.?.right) <= 0) {
                    return self.leftRotate(node);
                    // 先右旋再左旋
                } else {
                    node.?.right = self.rightRotate(node.?.right);
                    return self.leftRotate(node);
                }
            }
            // 平衡树，无须旋转，直接返回
            return node;
        }

        // 插入节点
        fn insert(self: *Self, val: T) !void {
            self.root = (try self.insertHelper(self.root, val)).?;
        }

        // 递归插入节点（辅助方法）
        fn insertHelper(self: *Self, node_: ?*inc.TreeNode(T), val: T) !?*inc.TreeNode(T) {
            var node = node_;
            if (node == null) {
                var tmp_node = try self.mem_allocator.create(inc.TreeNode(T));
                tmp_node.init(val);
                return tmp_node;
            }
            // 查找插入位置并插入节点
            if (val < node.?.val) {
                node.?.left = try self.insertHelper(node.?.left, val);
            } else if (val > node.?.val) {
                node.?.right = try self.insertHelper(node.?.right, val);
            } else {
                return node; // 重复节点不插入，直接返回
            }
            self.updateHeight(node); // 更新节点高度
            // 执行旋转操作，使该子树重新恢复平衡
            node = self.rotate(node);
            // 返回子树的根节点
            return node;
        }

        // 删除节点
        fn remove(self: *Self, val: T) void {
            self.root = self.removeHelper(self.root, val).?;
        }

        // 递归删除节点（辅助方法）
        fn removeHelper(self: *Self, node_: ?*inc.TreeNode(T), val: T) ?*inc.TreeNode(T) {
            var node = node_;
            if (node == null) return null;
            // 查找节点并删除
            if (val < node.?.val) {
                node.?.left = self.removeHelper(node.?.left, val);
            } else if (val > node.?.val) {
                node.?.right = self.removeHelper(node.?.right, val);
            } else {
                if (node.?.left == null or node.?.right == null) {
                    const child = if (node.?.left != null) node.?.left else node.?.right;
                    // 子节点数量=0，直接返回
                    if (child == null) {
                        return null;
                        // 子节点数量=1，直接删除node
                    } else {
                        node = child;
                    }
                    // 子节点数量=2，则将中序遍历的下个节点删除，并用该节点替换当前节点
                } else {
                    var temp = node.?.right;
                    while (temp.?.left != null) {
                        temp = temp.?.left;
                    }
                    node.?.right = self.removeHelper(node.?.right, temp.?.val);
                    node.?.val = temp.?.val;
                }
            }
            self.updateHeight(node); // 更新节点高度
            // 执行旋转操作，使该子树重新恢复平衡
            node = self.rotate(node);
            // 返回子树的根节点
            return node;
        }

        // 查找节点
        fn search(self: *Self, val: T) ?*inc.TreeNode(T) {
            var cur = self.root;
            while (cur != null) {
                if (cur.?.val < val) {
                    cur = cur.?.right;
                } else if (cur.?.val > val) {
                    cur = cur.?.left;
                } else {
                    break;
                }
            }
            return cur;
        }
    };
}

pub fn testInsert(comptime T: type, tree_: *AVLTree(T), val: T) !void {
    var tree = tree_;
    try tree.insert(val);
    std.debug.print("\n插入节点{}后，AVL树为\n", .{val});
    try inc.PrintUtil.printTree(tree.root, null, false);
}

pub fn testRemove(comptime T: type, tree_: *AVLTree(T), val: T) void {
    var tree = tree_;
    tree.remove(val);
    std.debug.print("\n删除节点 {} 后，AVL 树为\n", .{val});
    try inc.PrintUtil.printTree(tree.root, null, false);
}

pub fn main() !void {
    var avl_tree = AVLTree(i32){};
    avl_tree.init(std.heap.page_allocator);
    defer avl_tree.deinit();

    // 插入节点
    // 请关注插入节点后，AVL 树是如何保持平衡的
    try testInsert(i32, &avl_tree, 1);
    try testInsert(i32, &avl_tree, 2);
    try testInsert(i32, &avl_tree, 3);
    try testInsert(i32, &avl_tree, 4);
    try testInsert(i32, &avl_tree, 5);
    try testInsert(i32, &avl_tree, 8);
    try testInsert(i32, &avl_tree, 7);
    try testInsert(i32, &avl_tree, 9);
    try testInsert(i32, &avl_tree, 10);
    try testInsert(i32, &avl_tree, 6);

    // 插入重复节点
    try testInsert(i32, &avl_tree, 7);

    // 删除节点
    // 请关注删除节点后，AVL 树是如何保持平衡的
    testRemove(i32, &avl_tree, 8); // 删除度为 0 的节点
    testRemove(i32, &avl_tree, 5); // 删除度为 1 的节点
    testRemove(i32, &avl_tree, 4); // 删除度为 2 的节点

    // 查找节点
    const node = avl_tree.search(7).?;
    std.debug.print("\n查找到的节点对象为 {any}，节点值 = {}\n", .{ node, node.val });

    _ = try std.io.getStdIn().reader().readByte();
}
