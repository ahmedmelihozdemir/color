const std = @import("std");
const color = @import("zig-color");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("=== ZIG-COLOR TEXT STYLES AND COLORS ===\n\n", .{});

    // Basic text styles
    std.debug.print("1. Basic Text Styles:\n", .{});
    try showBasicStyles(allocator);
    std.debug.print("\n", .{});

    // All colors
    std.debug.print("2. All Basic Colors:\n", .{});
    try showAllColors(allocator);
    std.debug.print("\n", .{});

    // Background colors
    std.debug.print("3. Background Colors:\n", .{});
    try showBackgroundColors(allocator);
    std.debug.print("\n", .{});

    // Combined styles
    std.debug.print("4. Combined Styles:\n", .{});
    try showCombinedStyles(allocator);
    std.debug.print("\n", .{});

    // Color palette demo
    std.debug.print("5. Color Palette Demo:\n", .{});
    try showColorPalette(allocator);
    std.debug.print("\n", .{});

    std.debug.print("=== END OF STYLES DEMO ===\n", .{});
}

fn showBasicStyles(allocator: std.mem.Allocator) !void {
    const styles = [_]struct { config: color.Config, name: []const u8 }{
        .{ .config = .{ .bold = true }, .name = "Bold text" },
        .{ .config = .{ .faint = true }, .name = "Faint text" },
        .{ .config = .{ .italic = true }, .name = "Italic text" },
        .{ .config = .{ .underline = true }, .name = "Underlined text" },
        .{ .config = .{ .reverse = true }, .name = "Reversed text" },
        .{ .config = .{ .strikethrough = true }, .name = "Strikethrough text" },
    };

    for (styles) |style| {
        var style_obj = try color.new(allocator, style.config);
        defer style_obj.deinit();
        try style_obj.println(allocator, style.name);
    }
}

fn showAllColors(allocator: std.mem.Allocator) !void {
    const colors = [_]struct { fg: color.Color, name: []const u8 }{
        .{ .fg = .black, .name = "Black" },
        .{ .fg = .red, .name = "Red" },
        .{ .fg = .green, .name = "Green" },
        .{ .fg = .yellow, .name = "Yellow" },
        .{ .fg = .blue, .name = "Blue" },
        .{ .fg = .magenta, .name = "Magenta" },
        .{ .fg = .cyan, .name = "Cyan" },
        .{ .fg = .white, .name = "White" },
    };

    for (colors) |col| {
        var color_obj = try color.new(allocator, .{ .fg = col.fg });
        defer color_obj.deinit();
        try color_obj.println(allocator, col.name);
    }
}

fn showBackgroundColors(allocator: std.mem.Allocator) !void {
    const bg_colors = [_]struct { fg: color.Color, bg: color.Color, name: []const u8 }{
        .{ .fg = .white, .bg = .black, .name = "White on Black" },
        .{ .fg = .white, .bg = .red, .name = "White on Red" },
        .{ .fg = .black, .bg = .green, .name = "Black on Green" },
        .{ .fg = .black, .bg = .yellow, .name = "Black on Yellow" },
        .{ .fg = .white, .bg = .blue, .name = "White on Blue" },
        .{ .fg = .white, .bg = .magenta, .name = "White on Magenta" },
        .{ .fg = .black, .bg = .cyan, .name = "Black on Cyan" },
        .{ .fg = .black, .bg = .white, .name = "Black on White" },
    };

    for (bg_colors) |bg_col| {
        var bg_color_obj = try color.new(allocator, .{ .fg = bg_col.fg, .bg = bg_col.bg });
        defer bg_color_obj.deinit();
        try bg_color_obj.printf(allocator, " {s} ", .{bg_col.name});
        std.debug.print("\n", .{});
    }
}

fn showCombinedStyles(allocator: std.mem.Allocator) !void {
    const combined = [_]struct { config: color.Config, name: []const u8 }{
        .{ .config = .{ .fg = .red, .bold = true }, .name = "Bold Red" },
        .{ .config = .{ .fg = .green, .italic = true }, .name = "Italic Green" },
        .{ .config = .{ .fg = .blue, .underline = true }, .name = "Underlined Blue" },
        .{ .config = .{ .fg = .yellow, .bold = true, .underline = true }, .name = "Bold Underlined Yellow" },
        .{ .config = .{ .fg = .magenta, .bold = true, .italic = true }, .name = "Bold Italic Magenta" },
        .{ .config = .{ .fg = .cyan, .faint = true, .strikethrough = true }, .name = "Faint Strikethrough Cyan" },
        .{ .config = .{ .fg = .white, .bg = .red, .bold = true }, .name = "Bold White on Red Background" },
    };

    for (combined) |combo| {
        var combo_obj = try color.new(allocator, combo.config);
        defer combo_obj.deinit();
        try combo_obj.println(allocator, combo.name);
    }
}

fn showColorPalette(allocator: std.mem.Allocator) !void {
    // Rainbow effect
    const rainbow_text = "RAINBOW";
    const rainbow_colors = [_]color.Color{ .red, .yellow, .green, .cyan, .blue, .magenta, .red };

    for (rainbow_text, 0..) |char, i| {
        const color_index = i % rainbow_colors.len;
        var rainbow_style = try color.new(allocator, .{ .fg = rainbow_colors[color_index], .bold = true });
        defer rainbow_style.deinit();
        try rainbow_style.printf(allocator, "{c}", .{char});
    }
    std.debug.print("\n", .{});

    // Progress bar simulation
    std.debug.print("Progress: ", .{});
    const total_bars = 20;
    const completed = 14;

    for (0..total_bars) |i| {
        if (i < completed) {
            var progress_style = try color.new(allocator, .{ .fg = .green, .bold = true });
            defer progress_style.deinit();
            try progress_style.printf(allocator, "█", .{});
        } else {
            var empty_style = try color.new(allocator, .{ .fg = .white, .faint = true });
            defer empty_style.deinit();
            try empty_style.printf(allocator, "░", .{});
        }
    }

    var percentage_style = try color.new(allocator, .{ .fg = .cyan, .bold = true });
    defer percentage_style.deinit();
    try percentage_style.printf(allocator, " {d}%", .{(completed * 100) / total_bars});
    std.debug.print("\n", .{});
}
