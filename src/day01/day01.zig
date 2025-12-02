const std = @import("std");
const utils = @import("../utils.zig");

pub fn a(alloc: std.mem.Allocator, file_path: []const u8) !usize {
    var it = try utils.FileLineIterator.init(alloc, file_path);
    defer it.deinit();

    var dial: isize = 50;
    var zeros: usize = 0;

    while (true) {
        const maybe_line = try it.next();
        if (maybe_line) |line| {
            const turn_dir = line[0];
            const turn_amount = try std.fmt.parseInt(isize, line[1..], 10);
            if (turn_dir == 'R') {
                dial = @mod(dial + turn_amount, 100);
            } else {
                dial -= @mod(turn_amount, 100);
                if (dial < 0) dial = 100 + dial;
            }
            if (dial == 0) zeros += 1;
        } else break;
    }

    return zeros;
}

pub fn b(alloc: std.mem.Allocator, file_path: []const u8) !usize {
    var it = try utils.FileLineIterator.init(alloc, file_path);
    defer it.deinit();

    var dial: isize = 50;
    var wraps_to_zeros: usize = 0;

    while (true) {
        const maybe_line = try it.next();
        if (maybe_line) |line| {
            const turn_dir = line[0];
            const turn_amount = try std.fmt.parseInt(isize, line[1..], 10);
            if (turn_dir == 'R') {
                const total = dial + turn_amount;
                wraps_to_zeros += @intCast(@divFloor(total, 100));
                dial = @mod(total, 100);
            } else {
                const start_step = if (dial == 0) 100 else dial;
                if (turn_amount >= start_step) {
                    wraps_to_zeros += @intCast(1 + @divFloor(turn_amount - start_step, 100));
                }
                dial -= @mod(turn_amount, 100);
                if (dial < 0) dial = 100 + dial;
            }
        } else break;
    }

    return wraps_to_zeros;
}

test "a_example_input" {
    const alloc = std.testing.allocator;
    const result = try a(alloc, "src/day01/input_example");
    std.log.debug("a example result: {d}", .{result});
    try std.testing.expect(result == 3);
}

test "a_real_input" {
    const alloc = std.testing.allocator;
    const result = try a(alloc, "src/day01/input");
    std.log.debug("a result: {d}", .{result});
}

test "b_real_input" {
    const alloc = std.testing.allocator;
    const result = try b(alloc, "src/day01/input");
    std.log.debug("b result: {d}", .{result});
}

test "b_example_input" {
    const alloc = std.testing.allocator;
    const result = try b(alloc, "src/day01/input_example");
    std.log.debug("b example result: {d}", .{result});
    try std.testing.expect(result == 6);
}
