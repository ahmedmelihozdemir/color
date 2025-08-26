const std = @import("std");
const color = @import("zig-color");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    try color.red(allocator, "[ERROR] Connection failed!");
    try color.green(allocator, "[INFO] Operation successful.");
    try color.yellow(allocator, "[WARN] Low disk space.");
}
