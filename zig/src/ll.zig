const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;

pub const List = struct {
    const Self = @This();

    head: ?*Node = undefined,
    tail: ?*Node = undefined,
    size: *u32 = undefined,

    pub const Node = struct {
        value: u32,
        next: ?*Node,
    };

    // Functions go here
    pub fn init() List {
        var size: u32 = 0;
        return List {
            .head = null,
            .tail = null,
            .size = &size,
        };
    }

    pub fn insertHead(self: Self, node: Node) void {
        if (self.head) |head| {
            node.next.?.* = head.*;
            head.* = node;
        } else {
            self.head.?.* = node;
            self.tail.?.* = node;
        }
        incrementSize(self);
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
    const list: List = List.init();
    try expect(list.head == null);
    try expect(list.tail == null);
    try expect(list.getSize() == 0);
}

test "insert head with one node" {
    const list: List = List.init();
    const node: List.Node = List.Node{ .value = 1, .next = undefined };
    List.insertHead(list, node);

    assert(list.getSize() == 1);
    assert(list.head == &node);
    assert(list.tail == &node);
}

test "insert head with many nodes" {
    const num_nodes: u8 = 10;
    const list: List = List.init();

    var i: u8 = 0;
    var node_array: [num_nodes]*const List.Node = undefined;
    for (0..num_nodes) |_| {
        const node: List.Node = List.Node{ .value = i, .next = undefined };
        List.insertHead(list, node);
        node_array[i] = &node;
        i += 1;
    }

    //const head: List.Node = list.head orelse null;

    assert(list.getSize() == num_nodes);
    assert(list.head == node_array[num_nodes - 1]);
    assert(list.tail == node_array[0]);
    //assert(head != null);
    //try expect(list.head.?.*.value == (num_nodes - 1));
    //assert(head.value == (num_nodes - 1));
    //assert(list.tail.?.value == 0);
}
