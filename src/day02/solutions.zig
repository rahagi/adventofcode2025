const std = @import("std");
const utils = @import("../utils.zig");

fn isEven(num: usize) bool {
    return num % 2 == 0;
}

pub fn a(alloc: std.mem.Allocator, file_path: []const u8) !usize {
    var it = try utils.FileContentIterator.init(alloc, file_path, ',');
    defer it.deinit();

    var sum: usize = 0;
    while (try it.next()) |line| {
        var id_range = std.mem.splitScalar(u8, line, '-');
        const min = id_range.next() orelse "";
        const max = id_range.next() orelse "";
        const maybe_has_invalid_id = isEven(min.len) or isEven(max.len);
        if (maybe_has_invalid_id) {
            const min_num = try std.fmt.parseInt(usize, min, 10);
            const max_num = try std.fmt.parseInt(usize, max, 10);
            var buf: [32]u8 = undefined;
            for (min_num..max_num + 1) |i| {
                const digit = try std.fmt.bufPrint(&buf, "{d}", .{i});

                if (!isEven(digit.len)) continue;

                const digit_l = digit[0 .. digit.len / 2];
                const digit_r = digit[digit.len / 2 ..];
                if (std.mem.eql(u8, digit_l, digit_r)) sum += i;
            }
        }
    }

    return sum;
}

pub fn b(alloc: std.mem.Allocator, file_path: []const u8) !usize {
    var it = try utils.FileContentIterator.init(alloc, file_path, ',');
    defer it.deinit();

    var sum: usize = 0;
    while (try it.next()) |line| {
        var id_range = std.mem.splitScalar(u8, line, '-');
        const min = id_range.next() orelse "";
        const max = id_range.next() orelse "";
        const min_num = try std.fmt.parseInt(usize, min, 10);
        const max_num = try std.fmt.parseInt(usize, max, 10);
        var buf: [32]u8 = undefined;
        for (min_num..max_num + 1) |i| {
            const digit = try std.fmt.bufPrint(&buf, "{d}", .{i});
            for (1..digit.len / 2 + 1) |j| {
                if (digit.len % j == 0) {
                    const substr = digit[0..j];
                    const parts = digit.len / j;

                    var k = j;
                    var pair: usize = 1;
                    while (k < digit.len) : (k += substr.len) {
                        const next_substr = digit[k .. k + substr.len];
                        if (!std.mem.eql(u8, substr, next_substr)) break;
                        pair += 1;
                    }
                    if (pair == parts) {
                        sum += i;
                        break;
                    }
                }
            }
        }
    }

    return sum;
}

test "a_real_input" {
    const alloc = std.testing.allocator;
    const result = try a(alloc, "src/day02/input");
    std.log.debug("a result: {d}", .{result});
}

test "a_example_input" {
    const alloc = std.testing.allocator;
    const result = try a(alloc, "src/day02/input_example");
    std.log.debug("a example result: {d}", .{result});
    try std.testing.expect(result == 1227775554);
}

test "b_real_input" {
    const alloc = std.testing.allocator;
    const result = try b(alloc, "src/day02/input");
    std.log.debug("b result: {d}", .{result});
}

test "b_example_input" {
    const alloc = std.testing.allocator;
    const result = try b(alloc, "src/day02/input_example");
    std.log.debug("b example result: {d}", .{result});
    try std.testing.expect(result == 4174379265);
}
