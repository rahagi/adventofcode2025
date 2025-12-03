const std = @import("std");

pub const FileContentIterator = struct {
    delimiter: u8,
    alloc: std.mem.Allocator,
    file: std.fs.File,
    file_reader: std.fs.File.Reader,
    reader_buf: []u8,
    line: std.Io.Writer.Allocating,

    pub fn init(alloc: std.mem.Allocator, file_path: []const u8, delimiter: u8) !FileContentIterator {
        const file = try std.fs.cwd().openFile(file_path, .{});
        errdefer file.close();

        const reader_buf = try alloc.alloc(u8, 1024);
        errdefer alloc.free(reader_buf);

        const file_reader = file.reader(reader_buf);

        return .{
            .delimiter = delimiter,
            .alloc = alloc,
            .file = file,
            .reader_buf = reader_buf,
            .file_reader = file_reader,
            .line = std.Io.Writer.Allocating.init(alloc),
        };
    }

    pub fn deinit(self: *FileContentIterator) void {
        self.file.close();
        self.alloc.free(self.reader_buf);
        self.line.deinit();
    }

    pub fn next(self: *FileContentIterator) !?[]const u8 {
        self.line.clearRetainingCapacity();
        const io_reader = &self.file_reader.interface;
        _ = io_reader.streamDelimiter(&self.line.writer, self.delimiter) catch |err| {
            if (err == error.EndOfStream) {
                if (self.line.written().len > 0) return std.mem.trimRight(u8, self.line.written(), "\r\n");
                return null;
            }
            return err;
        };
        _ = io_reader.toss(1);
        return self.line.written();
    }
};
