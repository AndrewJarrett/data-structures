const std = @import("std");
const AutoHashMap = std.hash_map.AutoHashMap;
const fib = @import("impl.zig");

pub fn main() !void {
    const n: u8 = 50;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();
    var map = AutoHashMap(u8, u64).init(alloc);
    const sum: u64 = try fib.iter_memo_fib(n, &map);

    std.debug.print("The {}th fibonacci number is {}", .{ n, sum });
}
