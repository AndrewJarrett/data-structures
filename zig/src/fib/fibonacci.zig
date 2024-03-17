const std = @import("std");
const fib = @import("impl.zig");

pub fn main() void {
    const n: u8 = 50;
    const sum: u64 = fib.fibonacci(n);

    std.debug.print("The {}th fibonacci number is {}", .{ n, sum });
}
