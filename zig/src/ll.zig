const std = @import("std");
const assert = std.debug.assert;
const Param = std.builtin.Type.Fn.Param;

// Testing related
const expect = std.testing.expect;
const expectError = std.testing.expectError;
const expectEqual = std.testing.expectEqual;
const heap_alloc = std.heap.page_allocator;

pub const ListError = error {
    IndexOutOfBounds,
};

pub fn List(comptime T: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        head: ?*Node,
        tail: ?*Node,
        size: u32,

        pub const Node = struct {
            value: T,
            next: ?*Node,
        };

        // Functions go here
        pub fn init(allocator: std.mem.Allocator) Self {
            return Self {
                .head = null,
                .tail = null,
                .size = 0,
                .allocator = allocator,
            };
        }

        pub fn insertHead(self: *Self, value: T) !void {
            var node: *Node = try self.allocator.create(Node);

            // Setup the new node
            const current_head = self.head;
            node.value = value;
            node.next = current_head;

            // Update the head
            self.head = node;

            // Update tail
            if (self.tail == null) {
                self.tail = node;
            }

            self.size += 1;
        }

        pub fn removeHead(self: *Self) !?T {
            var value: ?T = null;
            var next_node: ?*Node = null;

            if (self.head) |current_head| {
                value = current_head.value;
                next_node = current_head.next orelse null;
                self.head = next_node;
                defer self.allocator.destroy(current_head);

                // Check if we have one node and destroy the tail if so
                if (self.tail != null and std.meta.eql(self.tail.?, current_head)) {
                    defer self.tail = null;
                    defer self.allocator.destroy(self.tail.?);
                }

                self.size -= 1;
            }

            return value;
        }

        pub fn get(self: *Self, index: u32) !?T {
            if (index < 0 or index >= self.size) {
                return ListError.IndexOutOfBounds;
            }

            var value: ?T = null;
            if (self.head) |current_head| {
                var node: *Node = current_head;
                var i: u32 = 0;

                while (i <= index) {
                    node = node.next.?;
                    i += 1;
                }

                value = node.value;
            }

            return value;
        }

        pub fn insertTail(self: *Self, value: T) !void {
            var node: *Node = try self.allocator.create(Node);

            if (self.tail) |current_tail| {
                current_tail.next = node;
            }

            node.value = value;
            self.tail = node;

            // Update head if there is only 1 node now
            if (self.head == null) {
                self.head = node;
            }

            self.size += 1;
        }

        pub fn removeTail(self: *Self) !?T {
            var value: ?T = null;

            if (self.tail) |current_tail| {
                var node: *Node = self.head.?;
                value = current_tail.value;

                defer self.allocator.destroy(current_tail);

                if (self.head == self.tail) {
                    self.head = null;
                    self.tail = null;
                } else {
                    while (node.next != null and node.next.? != current_tail) {
                        node = node.next.?;
                    }

                    self.tail = node;
                }

                self.size -= 1;
            }

            return value;
        }

    };
}

test "empty linked list" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    const list: List(u32) = List(u32).init(alloc);

    try expect(list.head == null);
    try expect(list.tail == null);
    try expect(list.size == 0);
}

test "insert head with one node" {
    const value: u32 = 1;

    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);
    try list.insertHead(value);

    try expect(list.size == 1);
    try expect(list.head != null);
    try expect(list.head.?.value == value);
    try expect(list.tail != null);
    try expect(list.tail.?.value == value);
}

test "insert head with many nodes" {
    const num_nodes: u32 = 1000;

    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    var i: u32 = 0;
    var value_array: [num_nodes]u32 = undefined;
    for (0..num_nodes) |_| {
        try list.insertHead(i);
        value_array[i] = i;
        i += 1;
    }

    try expect(list.size == num_nodes);
    try expect(list.head != null);
    try expect(list.head.?.value == value_array[num_nodes - 1]);
    try expect(list.tail != null);
    try expect(list.tail.?.value == value_array[0]);
}

test "remove head with no nodes" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    const value: ?u32 = try list.removeHead();

    try expect(value == null);
    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
}

test "remove head with one node" {
    const value: u32 = 1;

    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    try list.insertHead(value);
    var head_value: ?u32 = list.removeHead() catch null;

    try expect(head_value.? == value);
    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
}

test "remove head with many nodes" {
    const num_nodes: u32 = 1000;

    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    var i: u32 = 0;
    var value: ?u32 = null;
    var value_array: [num_nodes]?u32 = undefined;
    for (0..num_nodes) |_| {
        try list.insertHead(i);
        value = list.removeHead() catch null;
        value_array[i] = if (value) |val| val else null;
        i += 1;
    }

    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
    for (0..num_nodes) |j| {
        try expect(value_array[j].? == j);
    }
}

test "list of strings" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List([]const u8) = List([]const u8).init(alloc);

    try list.insertHead("string 1");
    try list.insertHead("string 2");
    try list.insertHead("string 3");

    try expect(list.size == 3);
    try expectEqual(list.head.?.value,  "string 3");
    try expectEqual(list.tail.?.value,  "string 1");
}

test "test insert tail with single node" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    try list.insertTail(42);

    try expect(list.size == 1);
    try expect(list.head != null);
    try expect(list.head.?.value == 42);
    try expect(list.tail != null);
    try expect(list.tail.?.value == 42);
}

test "test insert tail with multiple nodes" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    try list.insertTail(0);
    try list.insertTail(10);
    try list.insertTail(100);

    try expect(list.size == 3);
    try expect(list.head != null);
    try expect(list.head.?.value == 0);
    try expect(list.tail != null);
    try expect(list.tail.?.value == 100);
}

test "ensure get node uses an unsigned index" {
    const fn_type_info = @typeInfo(@TypeOf(List(void).get));
    const params: []const Param = fn_type_info.Fn.params;

    //@compileLog(fn_type_info);
    //@compileLog(params);
    //@compileLog(params[0].type);
    //@compileLog(params[1].type);
    //@compileLog(@TypeOf(*List(void)));
    //@compileLog(@TypeOf(u32));

    try expect(params.len == 2);
    try expect(params[0].type == *List(void));
    try expect(params[1].type == u32);
}

test "get node at index 0 of empty list" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    var value: ?u32 = list.get(0) catch null;

    try expect(value == null);
    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
}

test "get node at overflow index of list" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    try list.insertHead(0);
    try list.insertHead(1);
    try list.insertHead(2);

    var value: ?u32 = list.get(3) catch null;

    try expect(value == null);
    try expect(list.size == 3);
    try expect(list.head != null);
    try expect(list.head.?.value == 2);
    try expect(list.tail != null);
    try expect(list.tail.?.value == 0);
}

test "get node at index in middle of small list" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    try list.insertHead(0);
    try list.insertHead(1);
    try list.insertHead(2);

    var value: ?u32 = list.get(1) catch null;

    std.debug.print("value: {any}\n", .{ value });

    try expect(value != null);
    try expect(value.? == 1);
    try expect(list.size == 3);
    try expect(list.head != null);
    try expect(list.head.?.value == 2);
    try expect(list.tail != null);
    try expect(list.tail.?.value == 0);
}

test "get node at index in middle of large list" {
    const num_nodes: u32 = 1000;
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    for (0..num_nodes) |index| {
        try list.insertHead(@intCast(index));
    }

    var value: ?u32 = list.get(num_nodes/2) catch null;

    std.debug.print("value: {any}\n", .{ value });
    std.debug.print("value.?: {any}\n", .{ value.? });

    try expect(value != null);
    try expect(value.? == (num_nodes/2));
    try expect(list.size == num_nodes);
    try expect(list.head != null);
    try expect(list.head.?.value == num_nodes);
    try expect(list.tail != null);
    try expect(list.tail.?.value == 0);
}

test "remove tail on empty list" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    const value_1: ?u32 = list.removeTail() catch null;

    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
    try expect(value_1 == null);
}

test "remove tail with one node" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    try list.insertTail(101);
    const value_1: ?u32 = list.removeTail() catch null;

    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
    try expect(value_1 == 101);
}

test "test remove tail with multiple nodes" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List(u32) = List(u32).init(alloc);

    try list.insertTail(0);
    try list.insertTail(10);
    try list.insertTail(100);
    const value_1: ?u32 = list.removeTail() catch null;
    const value_2: ?u32 = list.removeTail() catch null;
    const value_3: ?u32 = list.removeTail() catch null;

    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
    try expect(value_1 == 100);
    try expect(value_2 == 10);
    try expect(value_3 == 0);
}
