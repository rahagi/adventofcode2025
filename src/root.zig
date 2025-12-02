const std = @import("std");

test {
    std.testing.log_level = .debug;
    _ = @import("day01/day01.zig");
}
