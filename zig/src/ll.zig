const std = @import("std");

// Testing related
const expect = std.testing.expect;
const expectError = std.testing.expectError;
const assert = std.debug.assert;
const heap_alloc = std.heap.page_allocator;

pub const List = struct {
    const Self = @This();

    allocator: std.mem.Allocator,
    head: ?*Node,
    tail: ?*Node,
    size: u32,

    pub const Node = struct {
        value: u32,
        next: ?*Node,
    };

    // Functions go here
    pub fn init(allocator: std.mem.Allocator) List {
        return List {
            .head = null,
            .tail = null,
            .size = 0,
            .allocator = allocator,
        };
    }

    pub fn insertHead(self: *Self, value: u32) !void {
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

    pub fn removeHead(self: *Self) !?u32 {
        var value: ?u32 = null;
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

};

test "empty linked list" {
    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    const list: List = List.init(alloc);

    try expect(list.head == null);
    try expect(list.tail == null);
    try expect(list.size == 0);
}

test "insert head with one node" {
    const value: u32 = 1;

    var arena = std.heap.ArenaAllocator.init(heap_alloc);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List = List.init(alloc);
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
    var list: List = List.init(alloc);

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
    var list: List = List.init(alloc);

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
    var list: List = List.init(alloc);

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
    var list: List = List.init(alloc);

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
