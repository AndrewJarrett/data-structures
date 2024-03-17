const std = @import("std");
const expect = std.testing.expect;
const AutoHashMap = std.AutoHashMap;

// Write the nth Fibonacci number
pub fn fibonacci(n: u8) u32 {
    if (n == 0) return 0;
    if (n == 1) return 1;

    return fibonacci(n - 2) + fibonacci(n - 1);
}

// Memoize the nth fibonacci number
pub fn memo_fib(n: u8, map: *AutoHashMap(u8, u32)) !u32 {
    const result = try map.getOrPut(n);
    
    if (result.found_existing) {
        return result.value_ptr.*;
    }
    else if (n == 0 or n == 1) {
        try map.put(n, n);
        return n;
    }
    else {
        const val_1 = try memo_fib(n - 2, map);
        const val_2 = try memo_fib(n - 1, map);
        const sum = val_1 + val_2;
        try map.put(n, sum);
        return sum;
    }
}

// Iterate to the nth fibonacci number
pub fn iter_fib(n: u8) u32 {
    var sum: u32 = 0;

    if (n < 2) {
        sum = @intCast(n);
    }
    else {
        var sum_2: u32 = 0;
        var sum_1: u32 = 1;
        for (1..n) |_| {
            sum = sum_2 + sum_1;
            sum_2 = sum_1;
            sum_1 = sum;
        }
    }

    return sum;
}

test "it should recursively fibonate" {
    try expect(0 == fibonacci(0));
    try expect(1 == fibonacci(1));
    try expect(1 == fibonacci(2));
    try expect(2 == fibonacci(3));
    try expect(3 == fibonacci(4));
    try expect(5 == fibonacci(5));
    try expect(8 == fibonacci(6));
    try expect(13 == fibonacci(7));
    try expect(21 == fibonacci(8));
    try expect(34 == fibonacci(9));
    try expect(55 == fibonacci(10));
}

test "it should memomize the fibonachos" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const alloc = arena.allocator();
    var map = AutoHashMap(u8, u32).init(alloc);

    try expect(55 == try memo_fib(10, &map));
    try expect(34 == try memo_fib(9, &map));
    try expect(21 == try memo_fib(8, &map));
    try expect(13 == try memo_fib(7, &map));
    try expect(8 == try memo_fib(6, &map));
    try expect(5 == try memo_fib(5, &map));
    try expect(3 == try memo_fib(4, &map));
    try expect(2 == try memo_fib(3, &map));
    try expect(1 == try memo_fib(2, &map));
    try expect(1 == try memo_fib(1, &map));
    try expect(0 == try memo_fib(0, &map));
}

test "it should iter to the nth fibber" {
        try expect(0 == iter_fib(0));
        try expect(1 == iter_fib(1));
        try expect(1 == iter_fib(2));
        try expect(2 == iter_fib(3));
        try expect(3 == iter_fib(4));
        try expect(5 == iter_fib(5));
        try expect(8 == iter_fib(6));
        try expect(13 == iter_fib(7));
        try expect(21 == iter_fib(8));
        try expect(34 == iter_fib(9));
        try expect(55 == iter_fib(10));
}
