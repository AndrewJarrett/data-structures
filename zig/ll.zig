const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;

pub const Node = struct {
    value: u32 = undefined,
    next: *Node = undefined,
};

pub const List = struct {
    first: *Node = undefined,
    last: *Node = undefined,
    size: u32 = 0,

    // Functions go here
};

test "test empty linked list" {
    const list: List = List{};
    assert(list.size == 0);
}
