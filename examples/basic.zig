const std = @import("std");
const color = @import("zig-color");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("=== ZIG-COLOR BASIC EXAMPLES ===\n\n", .{});

    // Simple convenience functions
    try color.red(allocator, "This is red text!");
    try color.green(allocator, "This is green text!");
    try color.blue(allocator, "This is blue text!");
    try color.yellow(allocator, "This is yellow text!");

    std.debug.print("\n", .{});

    // Custom ColorStyle objects
    var bold_red = try color.new(allocator, .{ .fg = .red, .bold = true });
    defer bold_red.deinit();
    try bold_red.println(allocator, "Bold red text using ColorStyle");

    var cyan_bg = try color.new(allocator, .{ .fg = .black, .bg = .cyan });
    defer cyan_bg.deinit();
    try cyan_bg.println(allocator, "Black text on cyan background");

    std.debug.print("\n", .{});

    // Printf-style formatting
    var italic_green = try color.new(allocator, .{ .fg = .green, .italic = true });
    defer italic_green.deinit();
    try italic_green.printf(allocator, "Italic green: {s} = {d}\n", .{ "value", 42 });

    std.debug.print("\n=== END OF BASIC EXAMPLES ===\n", .{});
}
