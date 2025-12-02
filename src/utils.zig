const std = @import("std");

pub const FileLineIterator = struct {
    alloc: std.mem.Allocator,
    file: std.fs.File,
    file_reader: std.fs.File.Reader,
    reader_buf: []u8,
    line: std.Io.Writer.Allocating,

    pub fn init(alloc: std.mem.Allocator, file_path: []const u8) !FileLineIterator {
        const file = try std.fs.cwd().openFile(file_path, .{});
        errdefer file.close();

        const reader_buf = try alloc.alloc(u8, 1024);
        errdefer alloc.free(reader_buf);

        const file_reader = file.reader(reader_buf);

        return .{
            .alloc = alloc,
            .file = file,
            .reader_buf = reader_buf,
            .file_reader = file_reader,
            .line = std.Io.Writer.Allocating.init(alloc),
        };
    }

    pub fn deinit(self: *FileLineIterator) void {
        self.file.close();
        self.alloc.free(self.reader_buf);
        self.line.deinit();
    }

    pub fn next(self: *FileLineIterator) !?[]const u8 {
        self.line.clearRetainingCapacity();
        const io_reader = &self.file_reader.interface;
        _ = io_reader.streamDelimiter(&self.line.writer, '\n') catch |err| {
            if (err == error.EndOfStream) return null;
            return err;
        };
        _ = io_reader.toss(1);
        return self.line.written();
    }
};
