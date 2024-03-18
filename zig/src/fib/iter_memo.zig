const std = @import("std");
const AutoHashMap = std.hash_map.AutoHashMap;
const fib = @import("impl.zig");

const key_type = fib.key_type;
const val_type = fib.val_type;
const n: key_type = fib.max_test_n;
const loops: key_type = fib.max_test_loops;

pub fn main() !void {
    var x: key_type = 0;
    var sum: val_type = 0;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();
    var map = AutoHashMap(key_type, val_type).init(alloc);

    for (0..loops) |loop| {
        while (x <= fib.max_test_n) {
            if (fib.iter_memo_fib(x, &map)) |num| {
                sum = num;
            } else |err| switch (err) {
                error.TooBig => {
                    std.debug.print("Loop {}: Error: {}; Fibonacci info: number = {}; value = {}\n", .{ loop, err, (x - 1), sum });
                    break;
                },
                error.OutOfMemory => {
                    std.debug.print("Ran out of memory. Tough luck. {}\n", .{ err });
                    break;
                }
            }
            x += 1;
        }
        x = n;
    }
}
