const std = @import("std");
const fib = @import("impl.zig");

pub fn main() void {
    var n: u8 = 100;

    var sum: u128 = fib.iter_fib(n);
    std.debug.print("The {}th fibonacci number is {}", .{ n, sum });

    sum = fib.iter_fib(n/2);
    std.debug.print("The {}th fibonacci number is {}", .{ (n/2), sum });
}
