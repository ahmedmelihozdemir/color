const std = @import("std");
const color = @import("zig-color");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("=== ZIG-COLOR ADVANCED FEATURES ===\n\n", .{});

    // Complex combinations
    std.debug.print("1. Complex Style Combinations:\n", .{});
    try showComplexCombinations(allocator);
    std.debug.print("\n", .{});

    // Log level simulation
    std.debug.print("2. Log Level Simulation:\n", .{});
    try simulateLogLevels(allocator);
    std.debug.print("\n", .{});

    // Table formatting
    std.debug.print("3. Table Formatting:\n", .{});
    try showTableFormatting(allocator);
    std.debug.print("\n", .{});

    // Status indicators
    std.debug.print("4. Status Indicators:\n", .{});
    try showStatusIndicators(allocator);

    std.debug.print("\n=== END OF ADVANCED FEATURES ===\n", .{});
}

fn showComplexCombinations(allocator: std.mem.Allocator) !void {
    const combinations = [_]struct { config: color.Config, description: []const u8 }{
        .{ .config = .{ .fg = .red, .bg = .white, .bold = true, .underline = true }, .description = "Bold underlined red on white" },
        .{ .config = .{ .fg = .cyan, .italic = true, .faint = true }, .description = "Faint italic cyan" },
        .{ .config = .{ .fg = .yellow, .bg = .blue, .reverse = true }, .description = "Reversed yellow on blue" },
        .{ .config = .{ .fg = .magenta, .bold = true, .strikethrough = true }, .description = "Bold strikethrough magenta" },
    };

    for (combinations) |combo| {
        var style = try color.new(allocator, combo.config);
        defer style.deinit();
        try style.printf(allocator, "  • {s}", .{combo.description});
        std.debug.print("\n", .{});
    }
}

fn simulateLogLevels(allocator: std.mem.Allocator) !void {
    const log_entries = [_]struct { level: []const u8, config: color.Config, message: []const u8 }{
        .{ .level = "TRACE", .config = .{ .fg = .white, .faint = true }, .message = "Detailed debugging information" },
        .{ .level = "DEBUG", .config = .{ .fg = .cyan }, .message = "General debugging information" },
        .{ .level = "INFO ", .config = .{ .fg = .green }, .message = "General information message" },
        .{ .level = "WARN ", .config = .{ .fg = .yellow, .bold = true }, .message = "Warning: potential issue detected" },
        .{ .level = "ERROR", .config = .{ .fg = .red, .bold = true }, .message = "Error: operation failed" },
        .{ .level = "FATAL", .config = .{ .fg = .white, .bg = .red, .bold = true }, .message = "Fatal: system crash imminent" },
    };

    for (log_entries) |entry| {
        var timestamp_style = try color.new(allocator, .{ .fg = .white, .faint = true });
        defer timestamp_style.deinit();
        try timestamp_style.printf(allocator, "[2024-12-19 15:30:42] ", .{});

        var level_style = try color.new(allocator, entry.config);
        defer level_style.deinit();
        try level_style.printf(allocator, "[{s}] ", .{entry.level});

        std.debug.print("{s}\n", .{entry.message});
    }
}

fn showTableFormatting(allocator: std.mem.Allocator) !void {
    var header_style = try color.new(allocator, .{ .fg = .black, .bg = .white, .bold = true });
    defer header_style.deinit();
    try header_style.printf(allocator, " {s:<15} | {s:<10} | {s:<8} ", .{ "Component", "Status", "CPU %" });
    std.debug.print("\n", .{});

    const table_data = [_]struct { component: []const u8, status: []const u8, status_color: color.Color, cpu: []const u8 }{
        .{ .component = "Web Server", .status = "Running", .status_color = .green, .cpu = "12.5%" },
        .{ .component = "Database", .status = "Running", .status_color = .green, .cpu = "8.2%" },
        .{ .component = "Cache", .status = "Warning", .status_color = .yellow, .cpu = "45.7%" },
        .{ .component = "Backup", .status = "Stopped", .status_color = .red, .cpu = "0.0%" },
    };

    for (table_data) |row| {
        std.debug.print(" {s:<15} | ", .{row.component});

        var status_style = try color.new(allocator, .{ .fg = row.status_color, .bold = true });
        defer status_style.deinit();
        try status_style.printf(allocator, "{s:<10}", .{row.status});

        std.debug.print(" | {s:<8} \n", .{row.cpu});
    }
}

fn showStatusIndicators(allocator: std.mem.Allocator) !void {
    const statuses = [_]struct { icon: []const u8, config: color.Config, text: []const u8 }{
        .{ .icon = "✓", .config = .{ .fg = .green, .bold = true }, .text = "Connection established" },
        .{ .icon = "⚠", .config = .{ .fg = .yellow, .bold = true }, .text = "High memory usage detected" },
        .{ .icon = "✗", .config = .{ .fg = .red, .bold = true }, .text = "Failed to connect to database" },
        .{ .icon = "ℹ", .config = .{ .fg = .blue, .bold = true }, .text = "System maintenance scheduled" },
        .{ .icon = "⟳", .config = .{ .fg = .cyan, .bold = true }, .text = "Automatic backup in progress" },
    };

    for (statuses) |status| {
        var icon_style = try color.new(allocator, status.config);
        defer icon_style.deinit();
        try icon_style.printf(allocator, "{s} ", .{status.icon});
        std.debug.print("{s}\n", .{status.text});
    }
}
