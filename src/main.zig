// from Zig Master: Let's Create a Stack!
// by  Dude the builder
// https://youtu.be/RCiGRNlaoJY?si=8j9kS2D-M3HQ3zal

const std = @import("std");
const mem = std.mem;
const heap = std.heap;
const print = std.debug.print;

const Stack = @import("stack.zig").Stack;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All is {s} \n", .{"fine"});

    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var stack = Stack{ .allocator = allocator };
    defer stack.freeAndReset();

    for (0..10) |i| {
        try stack.push(@intCast(i));
        print("{}\n", .{stack});
    }

    while (stack.pop()) |item| {
        print("{}\n", .{item});
        print("{}\n", .{stack});
    }
}
