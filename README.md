# 数据结构与算法-in-zig
## 数组实现
```bash
% zig build run_array
数组arr=[0, 0, 0, 0, 0]
数组nums=[1, 3, 2, 5, 4]
在nums中获取随机元素1
将数组长度扩展至8, 得到nums=[1, 3, 2, 5, 4, 0, 0, 0]
在索引3处插入数字6,得到nums=[1, 3, 2, 6, 5, 4, 0, 0]
删除索引2处的元素,得到nums=[1, 3, 6, 5, 4, 0, 0, 0]
在nums中查找元素3,得到索引=1
```

## 链表实现
```bash
% zig build run_linked_list
初始化的链表为1->3->2->5->4
插入节点后的链表1->0->3->2->5->4
删除节点后的链表为1->3->2->5->4
链表中索引3处的节点值=5
链表中值为2的节点索引=2
```

## 列表实现
```bash
 % zig build run_list
列表nums=[1, 3, 2, 5, 4]
访问索引1处的元素，得到num=3
将索引1处的元素更新为0， 得到nums=[1, 0, 2, 5, 4]
清空列表后nums=[]
添加元素后nums=[1, 3, 2, 5, 4]
在索引3处插入数字6，得到nums=[1, 3, 2, 6, 5, 4]
删除索引3处的元素，得到nums=[1, 3, 2, 5, 4]
将列表nums1拼接到nums之后，得到nums=[1, 3, 2, 5, 4, 6, 8, 7, 10, 9]
排序列表后nums=[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

### 自定义 列表
```bash
 % zig build run_my_list
列表nums=[1, 3, 2, 5, 4], 容量=5, 长度=5
在索引3处插入数字6, 得到nums=[1, 3, 2, 6, 5, 4]
删除索引3处的元素, 得到nums=[1, 3, 2, 5, 4]
访问索引1处的元素, 得到num=3
将索引1处的元素更新为0, 得到nums=[1, 0, 2, 5, 4]
扩容后的列表nums=[1, 0, 2, 5, 4, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 容量=20, 长度=15
```

## 栈实现
### 链表 栈
```bash
% zig build run_linkedlist_stack
栈stack=[1, 3, 2, 5, 4]
栈顶元素top=4
出栈元素pop=4, 出栈后stack=[1, 3, 2, 5]
栈的长度size=4
栈是否为空=false
```

### 数组 栈
```bash
% zig build run_array_stack
栈 stack = [1, 3, 2, 5, 4]
栈顶元素 peek = 4
出栈元素 pop = 4，出栈后 stack = [1, 3, 2, 5]
栈的长度 size = 4
栈是否为空 = false
```

## 队列实现
### 链表 队列
```bash
 % zig build run_linkedlist_queue
队列queue=[1, 3, 2, 5, 4]
队首元素peek=1
出队元素pop=1, 出队后queue=[3, 2, 5, 4]
队列长度size=4
队列是否为空=false
```

### 数组 队列
环形数组形式
```bash
 % zig build run_array_queue
队列queue=[1, 3, 2, 5, 4]
队首元素peek=1
出队元素pop=1, 出队后queue=[3, 2, 5, 4]
队列长度size=4
队列是否为空=false
第0轮入队+出队后queue=[2, 5, 4, 0]
第1轮入队+出队后queue=[5, 4, 0, 1]
第2轮入队+出队后queue=[4, 0, 1, 2]
第3轮入队+出队后queue=[0, 1, 2, 3]
第4轮入队+出队后queue=[1, 2, 3, 4]
第5轮入队+出队后queue=[2, 3, 4, 5]
第6轮入队+出队后queue=[3, 4, 5, 6]
第7轮入队+出队后queue=[4, 5, 6, 7]
第8轮入队+出队后queue=[5, 6, 7, 8]
第9轮入队+出队后queue=[6, 7, 8, 9]
```

### 内置实现队列
利用`std.DoublyLinkedList`
```bash
 % zig build run_queue
队列queue=[1, 3, 2, 5, 4]
队首元素peek=1
出队元素pop=1, 出队后queue=[3, 2, 5, 4]
队列长度size=4
队列是否为空=false
```
## 双向队列实现
### 内置实现双向队列
利用`DoublyLinkedList`
```bash
 % zig build run_dequeue
双向队列dequeue=[2, 5, 4, 3, 1]
队首元素peek_first=2
队尾元素peek_last=1
队首出队元素pop_first=2, 队首出队后dequeue=[5, 4, 3, 1]
队尾出队元素pop_last=1, 队尾出队后dequeue=[5, 4, 3]
双向队列长度size=3
双向队列是否为空=false
```

### 双向链表 实现 双向队列
```bash
 % zig build run_linkedlist_deque
双向队列deque=[3, 2, 5]
队首元素peek_first=3
队尾元素peek_last=5
元素4队尾入队后deque=[3, 2, 5, 4]
元素1队首入队后deque=[1, 3, 2, 5, 4]
队尾出队元素=4, 队尾出队后deque=[1, 3, 2, 5]
队首出队元素=1, 队首出队后deque=[3, 2, 5]
双向队列长度size=3
双向队列是否为空=false
```

## 哈希表实现
```bash
 % zig build run_hash_map
steps [17/27] zig build-exe my_list Debug native... LLVM Emit Object... 
添加完成后，哈希表为
Key->Value
15937->小啰
10583->小鸭
13276->小法
12836->小哈
16750->小算

输入学号15937, 查询到姓名小啰

删除10583后，哈希表为
Key->Value
15937->小啰
13276->小法
12836->小哈
16750->小算

遍历键值对Key->Value
15937->小啰
13276->小法
12836->小哈
16750->小算

单独遍历键Key
15937
13276
12836
16750

单独遍历值value
小啰
小法
小哈
小算
```
### 数组 简单实现 哈希表
```bash
 % zig build run_array_hash_map

添加完成后，哈希表为
Key -> Value
12836->小哈
15937->小啰
16750->小算
13276->小法
10583->小鸭

输入学号15937，查询到姓名小啰

删除10583后，哈希表
Key->Value
12836->小哈
15937->小啰
16750->小算
13276->小法

遍历键值对 Key->Value
12836->小哈
15937->小啰
16750->小算
13276->小法

单独遍历键Key
12836
15937
16750
13276

单独遍历值 Value
小哈
小啰
小算
小法
```



