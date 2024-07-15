const std = @import("std");
const mem = std.mem;
const log = std.log;

//constants used
const growth_factor = 2;

pub const Stack = struct {
    //    id: f32, // id of item
    allocator: mem.Allocator, //memory allocation
    items: []u8 = &.{}, // storage with default value will coerce to empty slice [ ]
    capacity: usize = 0, // capacity of the stack, defaults to zero.

    const Self = @This();

    pub fn freeAndReset(self: *Self) void {
        if (self.capacity == 0) return;
        //free the used memory by the items
        self.allocator.free(self.items.ptr[0..self.capacity]);
        // reset
        self.items = &.{};
        self.capacity = 0;
    }

    pub fn push(self: *Self, item: u8) !void {
        //check if we need more memory
        if (self.items.len + 1 >= self.capacity) try self.grow();
        self.items.ptr[self.items.len] = item;
        self.items.len += 1;
    }

    pub fn pop(self: *Self) ?u8 {
        if (self.items.len == 0) return null;
        self.items.len -= 1;
        return self.items.ptr[self.items.len];
    }

    pub fn format(
        self: Self,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        try writer.writeAll("Stack { ");
        for (self.items, 0..) |item, i| {
            if (i != 0) try writer.writeAll(", ");
            try writer.print("{}", .{item});
        }
        try writer.writeAll(" }");
    }

    fn grow(self: *Self) !void {
        const old_len = self.items.len;
        const new_capacity = if (self.capacity == 0) 8 else self.capacity * growth_factor;
        self.items = try self.allocator.realloc(self.items.ptr[0..self.capacity], new_capacity);
        log.debug("Grew {} -> {}", .{ self.capacity, new_capacity });
        self.capacity = new_capacity;
        self.items.len = old_len; // the item slice isnt the same as the slice
    }
};
