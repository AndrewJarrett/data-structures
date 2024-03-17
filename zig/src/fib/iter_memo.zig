const std = @import("std");
const AutoHashMap = std.hash_map.AutoHashMap;
const fib = @import("impl.zig");

pub fn main() !void {
    var n: u8 = 100;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();
    var map = AutoHashMap(u8, u128).init(alloc);

    var sum: u128 = try fib.iter_memo_fib(n, &map);
    std.debug.print("The {}th fibonacci number is {}", .{ n, sum });

    sum = try fib.iter_memo_fib((n/2), &map);
    std.debug.print("The {}th fibonacci number is {}", .{ (n/2), sum });
}
