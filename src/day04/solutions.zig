const std = @import("std");
const utils = @import("../utils.zig");

fn isAccessible(i: usize, j: usize, map: *std.ArrayList([]u8)) bool {
    var papers: usize = 0;

    const deltas: [3]isize = .{ -1, 0, 1 };
    for (deltas) |di| {
        for (deltas) |dj| {
            const ci = @as(isize, @intCast(i)) + di;
            if (ci < 0 or ci > map.*.items.len - 1) continue;

            const cj = @as(isize, @intCast(j)) + dj;
            if (cj < 0 or cj > map.*.items[i].len - 1) continue;

            if (map.*.items[@as(usize, @intCast(ci))][@as(usize, @intCast(cj))] == '@') papers += 1;
        }
    }

    return papers <= 4;
}

pub fn a(alloc: std.mem.Allocator, file_path: []const u8) !usize {
    var it = try utils.FileContentIterator.init(alloc, file_path, '\n');
    defer it.deinit();

    var map = try std.ArrayList([]u8).initCapacity(alloc, 1024);
    defer {
        for (map.items) |item| alloc.free(item);
        map.deinit(alloc);
    }
    while (try it.next()) |line| {
        const buf = try alloc.alloc(u8, line.len);
        @memcpy(buf, line);
        try map.append(alloc, buf);
    }

    var sum: usize = 0;
    for (map.items, 0..) |line, i| {
        for (line, 0..) |maybe_paper, j| {
            if (maybe_paper != '@') continue;
            if (isAccessible(i, j, &map)) sum += 1;
        }
    }

    return sum;
}

pub fn b(alloc: std.mem.Allocator, file_path: []const u8) !usize {
    var it = try utils.FileContentIterator.init(alloc, file_path, '\n');
    defer it.deinit();

    var map = try std.ArrayList([]u8).initCapacity(alloc, 1024);
    defer {
        for (map.items) |item| alloc.free(item);
        map.deinit(alloc);
    }
    while (try it.next()) |line| {
        const buf = try alloc.alloc(u8, line.len);
        @memcpy(buf, line);
        try map.append(alloc, buf);
    }

    var sum: usize = 0;
    while (true) {
        var removed: usize = 0;
        for (map.items, 0..) |line, i| {
            for (line, 0..) |maybe_paper, j| {
                if (maybe_paper != '@') continue;
                if (isAccessible(i, j, &map)) {
                    removed += 1;
                    map.items[i][j] = '.';
                }
            }
        }
        if (removed == 0) break;
        sum += removed;
    }

    return sum;
}

test "a_real_input" {
    const alloc = std.testing.allocator;
    const result = try a(alloc, "src/day04/input");
    std.log.debug("a result: {d}", .{result});
}

test "a_example_input" {
    const alloc = std.testing.allocator;
    const result = try a(alloc, "src/day04/input_example");
    std.log.debug("a example result: {d}", .{result});
    try std.testing.expect(result == 13);
}

test "b_real_input" {
    const alloc = std.testing.allocator;
    const result = try b(alloc, "src/day04/input");
    std.log.debug("b result: {d}", .{result});
}

test "b_example_input" {
    const alloc = std.testing.allocator;
    const result = try b(alloc, "src/day04/input_example");
    std.log.debug("b example result: {d}", .{result});
    try std.testing.expect(result == 43);
}
