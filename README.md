# Zig Color

A simple and lightweight Zig library for adding colors to your terminal output.

## Features

- Full ANSI color support for terminals
- Simple and intuitive API
- Support for text styles (bold, italic, underline)
- Background color support
- Cross-platform compatible
- Ability to disable colors when needed
- Fast and lightweight

## Installation

Add this library to your Zig project using the Zig package manager:

```bash
# Clone the repository
git clone https://github.com/ahmedmelihozdemir/zig-color.git
```

Then add it to your `build.zig`:

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Add the color module
    const color_module = b.addModule("color", .{
        .root_source_file = .{ .path = "path/to/zig-color/src/main.zig" },
    });

    const exe = b.addExecutable(.{
        .name = "your-app",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // Import the color module
    exe.root_module.addImport("color", color_module);

    b.installArtifact(exe);
}
```

## Getting Started

Here's a complete example showing how to use the library in your project:

```zig
const std = @import("std");
const color = @import("color");

pub fn main() !void {
    // Simple colored messages
    color.green("✓ Build successful!");
    color.red("✗ Error: File not found");
    color.yellow("⚠ Warning: Deprecated function");

    // Formatted output with colors
    const filename = "config.json";
    color.blue("Loading configuration from {s}...", .{filename});

    // Create custom styled text
    var error_style = color.new(.{
        .fg = .red,
        .bold = true
    });
    error_style.println("CRITICAL ERROR");

    // Combine foreground and background colors
    var highlight = color.new(.{
        .fg = .white,
        .bg = .blue,
        .bold = true
    });
    highlight.print("INFO: ");
    std.debug.print("Server started on port 8080\n", .{});

    // Get colored strings without printing
    const success_msg = color.greenString("PASSED");
    const fail_msg = color.redString("FAILED");
    std.debug.print("Test result: {s}\n", .{success_msg});
}
```

## Usage Examples

### Basic Colors

```zig
const color = @import("color");

color.red("Error message");
color.green("Success message");
color.blue("Info message");
color.yellow("Warning message");
color.cyan("Debug message");
color.magenta("Special message");
```

### Formatted Output

```zig
const username = "john";
const count = 42;

color.green("Hello, {s}!", .{username});
color.yellow("You have {d} new messages", .{count});
```

### Custom Styles

```zig
// Bold red text
var error = color.new(.{ .fg = .red, .bold = true });
error.println("Fatal error occurred!");

// Underlined blue text
var link = color.new(.{ .fg = .blue, .underline = true });
link.println("https://example.com");

// White text on red background
var alert = color.new(.{ .fg = .white, .bg = .red, .bold = true });
alert.println(" ALERT ");
```

### Conditional Coloring

```zig
// Disable colors in production or when piping output
if (std.os.getenv("NO_COLOR")) |_| {
    color.setNoColor(true);
}

// Or disable for specific instances
var plain = color.new(.{ .fg = .red });
plain.disableColor();
plain.println("This won't be colored");
```

## Available Colors

**Foreground Colors:**

- `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`
- `hi_black`, `hi_red`, `hi_green`, `hi_yellow`, `hi_blue`, `hi_magenta`, `hi_cyan`, `hi_white`

**Background Colors:**

- `bg_black`, `bg_red`, `bg_green`, `bg_yellow`, `bg_blue`, `bg_magenta`, `bg_cyan`, `bg_white`

**Text Styles:**

- `bold`, `faint`, `italic`, `underline`, `reverse`

## Development Status

- [x] Project setup and configuration
- [x] Documentation
- [ ] ANSI color code implementation
- [ ] Color struct and API
- [ ] Format string support
- [ ] Text styling support
- [ ] Background color support

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Note:** This library is under active development. The API may change in future versions.
