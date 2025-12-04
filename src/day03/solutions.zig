const std = @import("std");
const utils = @import("../utils.zig");

pub fn a(alloc: std.mem.Allocator, file_path: []const u8) !usize {
    var it = try utils.FileContentIterator.init(alloc, file_path, '\n');
    defer it.deinit();

    var sum: usize = 0;
    while (try it.next()) |bank| {
        var first_bty: usize = 0;
        var second_bty: usize = 0;
        for (bank, 0..) |battery, i| {
            const jolt = try std.fmt.parseInt(usize, &[_]u8{battery}, 10);
            if (jolt > first_bty and i < bank.len - 1) {
                first_bty = jolt;
                second_bty = 0;
            } else if (jolt > second_bty) {
                second_bty = jolt;
            }
        }
        const total_joltage = (first_bty * 10) + second_bty;
        sum += total_joltage;
    }

    return sum;
}

pub fn b(alloc: std.mem.Allocator, file_path: []const u8) !usize {
    var it = try utils.FileContentIterator.init(alloc, file_path, '\n');
    defer it.deinit();

    var sum: usize = 0;
    while (try it.next()) |bank| {
        var active_batteries: [12]u8 = undefined;
        var max: usize = 0;
        var last_max_pos: usize = 0;
        for (0..12) |i| {
            const last_possible_pos: usize = bank.len - 12 + i + 1;
            for (bank[last_max_pos..last_possible_pos], last_max_pos..) |battery, j| {
                const joltage = try std.fmt.parseInt(usize, &[_]u8{battery}, 10);
                if (joltage > max) {
                    max = joltage;
                    active_batteries[i] = battery;
                    last_max_pos = j + 1;
                }
            }
            max = 0;
        }
        const active_batteries_num = try std.fmt.parseInt(usize, &active_batteries, 10);
        sum += active_batteries_num;
    }

    return sum;
}

test "a_real_input" {
    const alloc = std.testing.allocator;
    const result = try a(alloc, "src/day03/input");
    std.log.debug("a result: {d}", .{result});
}

test "a_example_input" {
    const alloc = std.testing.allocator;
    const result = try a(alloc, "src/day03/input_example");
    std.log.debug("a example result: {d}", .{result});
    try std.testing.expect(result == 357);
}

test "b_real_input" {
    const alloc = std.testing.allocator;
    const result = try b(alloc, "src/day03/input");
    std.log.debug("b result: {d}", .{result});
}

test "b_example_input" {
    const alloc = std.testing.allocator;
    const result = try b(alloc, "src/day03/input_example");
    std.log.debug("b example result: {d}", .{result});
    try std.testing.expect(result == 3121910778619);
}
