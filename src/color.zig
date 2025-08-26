const std = @import("std");

pub const Color = enum {
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,

    pub fn toFgCode(self: Color) []const u8 {
        return switch (self) {
            .black => "30",
            .red => "31",
            .green => "32",
            .yellow => "33",
            .blue => "34",
            .magenta => "35",
            .cyan => "36",
            .white => "37",
        };
    }

    pub fn toBgCode(self: Color) []const u8 {
        return switch (self) {
            .black => "40",
            .red => "41",
            .green => "42",
            .yellow => "43",
            .blue => "44",
            .magenta => "45",
            .cyan => "46",
            .white => "47",
        };
    }
};

pub const Config = struct {
    fg: ?Color = null,
    bg: ?Color = null,
    bold: bool = false,
    faint: bool = false,
    italic: bool = false,
    underline: bool = false,
    reverse: bool = false,
    strikethrough: bool = false,
};

pub const ColorStyle = struct {
    allocator: std.mem.Allocator,
    config: Config,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator, config: Config) Self {
        return Self{
            .allocator = allocator,
            .config = config,
        };
    }

    pub fn deinit(self: *Self) void {
        _ = self;
    }

    fn generateAnsiSequence(self: *Self, allocator: std.mem.Allocator) ![]u8 {
        // Use a simple buffer approach instead of ArrayList for compatibility
        var buffer: [256]u8 = undefined;
        var pos: usize = 0;

        // Add style codes
        if (self.config.bold) {
            if (pos > 0) {
                buffer[pos] = ';';
                pos += 1;
            }
            @memcpy(buffer[pos .. pos + 1], "1");
            pos += 1;
        }
        if (self.config.faint) {
            if (pos > 0) {
                buffer[pos] = ';';
                pos += 1;
            }
            @memcpy(buffer[pos .. pos + 1], "2");
            pos += 1;
        }
        if (self.config.italic) {
            if (pos > 0) {
                buffer[pos] = ';';
                pos += 1;
            }
            @memcpy(buffer[pos .. pos + 1], "3");
            pos += 1;
        }
        if (self.config.underline) {
            if (pos > 0) {
                buffer[pos] = ';';
                pos += 1;
            }
            @memcpy(buffer[pos .. pos + 1], "4");
            pos += 1;
        }
        if (self.config.reverse) {
            if (pos > 0) {
                buffer[pos] = ';';
                pos += 1;
            }
            @memcpy(buffer[pos .. pos + 1], "7");
            pos += 1;
        }
        if (self.config.strikethrough) {
            if (pos > 0) {
                buffer[pos] = ';';
                pos += 1;
            }
            @memcpy(buffer[pos .. pos + 1], "9");
            pos += 1;
        }

        // Add foreground color
        if (self.config.fg) |fg| {
            if (pos > 0) {
                buffer[pos] = ';';
                pos += 1;
            }
            const fg_code = fg.toFgCode();
            @memcpy(buffer[pos .. pos + fg_code.len], fg_code);
            pos += fg_code.len;
        }

        // Add background color
        if (self.config.bg) |bg| {
            if (pos > 0) {
                buffer[pos] = ';';
                pos += 1;
            }
            const bg_code = bg.toBgCode();
            @memcpy(buffer[pos .. pos + bg_code.len], bg_code);
            pos += bg_code.len;
        }

        return std.fmt.allocPrint(allocator, "\x1b[{s}m", .{buffer[0..pos]});
    }

    const reset_sequence = "\x1b[0m";

    pub fn print(self: *Self, allocator: std.mem.Allocator, comptime format: []const u8, args: anytype) !void {
        const ansi_start = try self.generateAnsiSequence(allocator);
        defer allocator.free(ansi_start);

        // Use a local buffer for stdout - this is the new Zig 0.15.1 way
        var stdout_buffer: [1024]u8 = undefined;
        var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
        const stdout = &stdout_writer.interface;

        try stdout.print("{s}", .{ansi_start});
        try stdout.print(format, args);
        try stdout.print("{s}", .{reset_sequence});
        try stdout.flush();
    }

    pub fn println(self: *Self, allocator: std.mem.Allocator, text: []const u8) !void {
        try self.print(allocator, "{s}\n", .{text});
    }

    pub fn printf(self: *Self, allocator: std.mem.Allocator, comptime format: []const u8, args: anytype) !void {
        try self.print(allocator, format, args);
    }
};

pub fn new(allocator: std.mem.Allocator, config: Config) !ColorStyle {
    return ColorStyle.init(allocator, config);
}

pub fn red(allocator: std.mem.Allocator, text: []const u8) !void {
    var style = try new(allocator, .{ .fg = .red });
    defer style.deinit();
    try style.println(allocator, text);
}

pub fn green(allocator: std.mem.Allocator, text: []const u8) !void {
    var style = try new(allocator, .{ .fg = .green });
    defer style.deinit();
    try style.println(allocator, text);
}

pub fn yellow(allocator: std.mem.Allocator, text: []const u8) !void {
    var style = try new(allocator, .{ .fg = .yellow });
    defer style.deinit();
    try style.println(allocator, text);
}

pub fn blue(allocator: std.mem.Allocator, text: []const u8) !void {
    var style = try new(allocator, .{ .fg = .blue });
    defer style.deinit();
    try style.println(allocator, text);
}

pub fn magenta(allocator: std.mem.Allocator, text: []const u8) !void {
    var style = try new(allocator, .{ .fg = .magenta });
    defer style.deinit();
    try style.println(allocator, text);
}

pub fn cyan(allocator: std.mem.Allocator, text: []const u8) !void {
    var style = try new(allocator, .{ .fg = .cyan });
    defer style.deinit();
    try style.println(allocator, text);
}

pub fn white(allocator: std.mem.Allocator, text: []const u8) !void {
    var style = try new(allocator, .{ .fg = .white });
    defer style.deinit();
    try style.println(allocator, text);
}

pub fn bold(allocator: std.mem.Allocator, text: []const u8) !void {
    var style = try new(allocator, .{ .bold = true });
    defer style.deinit();
    try style.println(allocator, text);
}
