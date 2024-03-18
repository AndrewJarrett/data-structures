const std = @import("std");
const fib = @import("impl.zig");

const key_type = fib.key_type;
const val_type = fib.val_type;
const n: key_type = fib.max_test_n;
const loops: key_type = fib.max_test_loops;

pub fn main() void {
    var x: key_type = 0;
    var sum: val_type = 0;

    for (0..loops) |loop| {
        while (x <= fib.max_test_n) {
            if (fib.iter_fib(x)) |num| {
                sum = num;
            }
            else |err| switch (err) {
                error.TooBig => {
                    std.debug.print("Loop {}: Error: {}; Fibonacci info: number = {}; value = {}\n", .{ loop, err, (x - 1), sum });
                    break;
                }
            }
            x += 1;
        }
        x = n;
    }
}
