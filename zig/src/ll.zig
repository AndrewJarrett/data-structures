const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;

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
        if (self.tail) |_| {
            // Ignore
        } else {
            self.tail = node;
        }

        self.size += 1;
    }

    pub fn removeHead(self: *Self) !u32 {
        _ = self;
        return 0;
    }

    pub fn getSize(self: Self) u32 {
        return self.size.*;
    }

    fn incrementSize(self: Self) void {
        self.size.* += 1;
    }

    fn decrementSize(self: Self) void {
        self.size.* -= 1;
    }
};

test "empty linked list" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();
    const list: List = List.init(alloc);

    try expect(list.head == null);
    try expect(list.tail == null);
    try expect(list.size == 0);
}

test "insert head with one node" {
    const value: u32 = 1;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
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

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
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
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List = List.init(alloc);

    _ = try list.removeHead();

    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
}

test "remove head with one node" {
    const value: u32 = 1;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List = List.init(alloc);

    try list.insertHead(value);
    var head_value: u32 = try list.removeHead();

    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
    try expect(head_value == value);
}

test "remove head with many nodes" {
    const num_nodes: u32 = 1000;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List = List.init(alloc);

    var i: u32 = 0;
    var value: u32 = undefined;
    var value_array: [num_nodes]u32 = undefined;
    for (0..num_nodes) |_| {
        try list.insertHead(i);
        value = try list.removeHead();
        value_array[i] = value;
        i += 1;
    }

    try expect(list.size == 0);
    try expect(list.head == null);
    try expect(list.tail == null);
    for (0..num_nodes) |j| {
        try expect(value_array[j] == j);
    }
}
