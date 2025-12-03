const std = @import("std");

test {
    std.testing.log_level = .debug;

    // std.log.debug("---day01---", .{});
    // _ = @import("day01/solutions.zig");

    std.log.debug("---day02---", .{});
    _ = @import("day02/solutions.zig");
}
