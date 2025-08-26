const std = @import("std");
const color = @import("zig-color");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("=== ZIG-COLOR PERFORMANCE BENCHMARK ===\n\n");

    // Color object creation benchmark
    try benchmarkColorCreation(allocator);

    // String formatting benchmark
    try benchmarkStringFormatting(allocator);

    // ANSI sequence generation benchmark
    try benchmarkAnsiGeneration(allocator);

    // Comparison with plain strings
    try benchmarkPlainVsColored(allocator);

    std.debug.print("\n=== BENCHMARK TAMAMLANDI ===\n");
}

fn benchmarkColorCreation(allocator: std.mem.Allocator) !void {
    const iterations = 100_000;

    std.debug.print("1. Color Object Creation Benchmark ({d} iterations):\n", .{iterations});

    const start_time = std.time.nanoTimestamp();

    var i: u32 = 0;
    while (i < iterations) : (i += 1) {
        var c = try color.new(allocator, .{ .fg = .red, .bold = true });
        c.deinit();
    }

    const end_time = std.time.nanoTimestamp();
    const elapsed_ns = @as(u64, @intCast(end_time - start_time));
    const elapsed_ms = elapsed_ns / 1_000_000;
    const ops_per_sec = (@as(f64, @floatFromInt(iterations)) / @as(f64, @floatFromInt(elapsed_ns))) * 1_000_000_000;

    std.debug.print("   Süre: {d}ms\n", .{elapsed_ms});
    std.debug.print("   Hız: {d:.0} ops/sec\n", .{ops_per_sec});
    std.debug.print("   Ortalama: {d:.2}ns per operation\n\n", .{@as(f64, @floatFromInt(elapsed_ns)) / @as(f64, @floatFromInt(iterations))});
}

fn benchmarkStringFormatting(allocator: std.mem.Allocator) !void {
    const iterations = 50_000;

    std.debug.print("2. String Formatting Benchmark ({d} iterations):\n", .{iterations});

    var c = try color.new(allocator, .{ .fg = .green, .bold = true });
    defer c.deinit();

    const start_time = std.time.nanoTimestamp();

    var i: u32 = 0;
    while (i < iterations) : (i += 1) {
        const result = try c.sprintf(allocator, "Test message {d}", .{i});
        allocator.free(result);
    }

    const end_time = std.time.nanoTimestamp();
    const elapsed_ns = @as(u64, @intCast(end_time - start_time));
    const elapsed_ms = elapsed_ns / 1_000_000;
    const ops_per_sec = (@as(f64, @floatFromInt(iterations)) / @as(f64, @floatFromInt(elapsed_ns))) * 1_000_000_000;

    std.debug.print("   Süre: {d}ms\n", .{elapsed_ms});
    std.debug.print("   Hız: {d:.0} ops/sec\n", .{ops_per_sec});
    std.debug.print("   Ortalama: {d:.2}ns per operation\n\n", .{@as(f64, @floatFromInt(elapsed_ns)) / @as(f64, @floatFromInt(iterations))});
}

fn benchmarkAnsiGeneration(allocator: std.mem.Allocator) !void {
    const iterations = 100_000;

    std.debug.print("3. ANSI Sequence Generation Benchmark ({d} iterations):\n", .{iterations});

    var c = try color.new(allocator, .{ .fg = .red, .bg = .white, .bold = true, .underline = true });
    defer c.deinit();

    const start_time = std.time.nanoTimestamp();

    var i: u32 = 0;
    while (i < iterations) : (i += 1) {
        const result = try c.sprint(allocator, "test");
        allocator.free(result);
    }

    const end_time = std.time.nanoTimestamp();
    const elapsed_ns = @as(u64, @intCast(end_time - start_time));
    const elapsed_ms = elapsed_ns / 1_000_000;
    const ops_per_sec = (@as(f64, @floatFromInt(iterations)) / @as(f64, @floatFromInt(elapsed_ns))) * 1_000_000_000;

    std.debug.print("   Süre: {d}ms\n", .{elapsed_ms});
    std.debug.print("   Hız: {d:.0} ops/sec\n", .{ops_per_sec});
    std.debug.print("   Ortalama: {d:.2}ns per operation\n\n", .{@as(f64, @floatFromInt(elapsed_ns)) / @as(f64, @floatFromInt(iterations))});
}

fn benchmarkPlainVsColored(allocator: std.mem.Allocator) !void {
    const iterations = 50_000;

    std.debug.print("4. Plain vs Colored String Comparison ({d} iterations):\n", .{iterations});

    // Plain string benchmark
    const plain_start = std.time.nanoTimestamp();
    var i: u32 = 0;
    while (i < iterations) : (i += 1) {
        const result = try std.fmt.allocPrint(allocator, "Plain message {d}", .{i});
        allocator.free(result);
    }
    const plain_end = std.time.nanoTimestamp();
    const plain_elapsed = @as(u64, @intCast(plain_end - plain_start));

    // Colored string benchmark
    const colored_start = std.time.nanoTimestamp();
    i = 0;
    while (i < iterations) : (i += 1) {
        const result = try color.redString(allocator, "Colored message {d}", .{i});
        allocator.free(result);
    }
    const colored_end = std.time.nanoTimestamp();
    const colored_elapsed = @as(u64, @intCast(colored_end - colored_start));

    const plain_ops_per_sec = (@as(f64, @floatFromInt(iterations)) / @as(f64, @floatFromInt(plain_elapsed))) * 1_000_000_000;
    const colored_ops_per_sec = (@as(f64, @floatFromInt(iterations)) / @as(f64, @floatFromInt(colored_elapsed))) * 1_000_000_000;
    const overhead = (@as(f64, @floatFromInt(colored_elapsed)) / @as(f64, @floatFromInt(plain_elapsed)) - 1.0) * 100.0;

    std.debug.print("   Plain string:    {d:.0} ops/sec ({d}ms)\n", .{ plain_ops_per_sec, plain_elapsed / 1_000_000 });
    std.debug.print("   Colored string:  {d:.0} ops/sec ({d}ms)\n", .{ colored_ops_per_sec, colored_elapsed / 1_000_000 });
    std.debug.print("   Overhead:        {d:.1}%\n\n", .{overhead});

    // Memory usage comparison
    try benchmarkMemoryUsage(allocator);
}

fn benchmarkMemoryUsage(allocator: std.mem.Allocator) !void {
    std.debug.print("5. Memory Usage Comparison:\n");

    // Plain string
    const plain_str = try std.fmt.allocPrint(allocator, "Hello World", .{});
    const plain_size = plain_str.len;
    allocator.free(plain_str);

    // Colored string
    const colored_str = try color.redString(allocator, "Hello World", .{});
    const colored_size = colored_str.len;
    allocator.free(colored_str);

    const size_increase = colored_size - plain_size;
    const percentage_increase = (@as(f64, @floatFromInt(size_increase)) / @as(f64, @floatFromInt(plain_size))) * 100.0;

    std.debug.print("   Plain string size:    {d} bytes\n", .{plain_size});
    std.debug.print("   Colored string size:  {d} bytes\n", .{colored_size});
    std.debug.print("   Size increase:        +{d} bytes ({d:.1}%)\n", .{ size_increase, percentage_increase });
}
