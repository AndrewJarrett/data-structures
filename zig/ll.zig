const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;

//pub const Node = struct {
//    value: u32 = undefined,
//    next: *Node = undefined,
//};

pub const List = struct {
    const Self = @This();

    head: ?*Node = undefined,
    tail: ?*Node = undefined,
    size: u32 = 0,

    pub const Node = struct {
        value: u32,
        next: ?*Node,
    };

    // Functions go here
    pub fn insertHead(self: Self, node: Node) void {
        if (self.head == undefined) {
            self.head = &node;
            self.tail = &node;
        } else {
            node.next = self.head;
            self.head = &node;
        }
        incrementSize(self);
    }

    fn incrementSize(self: Self) void {
        self.size += 1;
    }

    fn decrementSize(self: Self) void {
        self.size -= 1;
    }
};

test "empty linked list" {
    const list: List = List{};
    assert(list.size == 0);
}

test "insert head with one node" {
    const list: List = List{};
    const node: List.Node = List.Node{ .value = 1, .next = undefined };
    List.insertHead(list, node);

    assert(list.size == 1);
    assert(list.head == &node);
    assert(list.tail == &node);
}

test "insert head with many nodes" {
    const num_nodes: u8 = 10;
    const list: List = List{};

    var i: u8 = 0;
    var node_array: [num_nodes]*const List.Node = undefined;
    for (0..num_nodes) |_| {
        const node: List.Node = List.Node{ .value = i, .next = undefined };
        List.insertHead(list, node);
        node_array[i] = &node;
        i += 1;
    }

    assert(list.size == num_nodes);
    assert(list.head == node_array[num_nodes - 1]);
    assert(list.tail == node_array[0]);
    assert(list.head.value == (num_nodes - 1));
    assert(list.tail.value == 0);
}
