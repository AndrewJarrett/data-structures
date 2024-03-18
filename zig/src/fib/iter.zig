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
        while (x <= n) {
            sum = fib.iter_fib(x);
            std.debug.print("Loop {}: The {}th fibonacci number is {}\n", .{ loop, x, sum });

            x += 1;
            //if (x == 0) {
            //    break;
            //}
            //else {
            //    x -= 1;
            //}
        }
        x = n;
    }
}
