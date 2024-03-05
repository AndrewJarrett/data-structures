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

        const current_head = self.head;
        node.value = value;
        node.next = current_head;

        self.head = node;
        self.size += 1;
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
    const num_nodes: u8 = 10;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();
    var list: List = List.init(alloc);

    var i: u8 = 0;
    var value_array: [num_nodes]u32 = undefined;
    for (0..num_nodes) |_| {
        try list.insertHead(i);
        value_array[i] = i;
        i += 1;
    }

    //const head: List.Node = list.head orelse null;

    assert(list.size == num_nodes);
    assert(list.head.?.value == value_array[num_nodes - 1]);
    assert(list.tail.?.value == value_array[0]);
    //assert(head != null);
    //try expect(list.head.?.*.value == (num_nodes - 1));
    //assert(head.value == (num_nodes - 1));
    //assert(list.tail.?.value == 0);
}
