# 🎨 Zig Color

A Zig library that provides colorful output for terminal logging.

## ✨ Features

- 🌈 Full ANSI color support
- 🎯 Simple and intuitive API
- 🔧 Color disable support
- 📱 Cross-platform compatible
- ⚡ Fast and lightweight
- 🎨 Text styles (bold, italic, underline)
- 🎪 Background colors

## 🚀 Installation

```bash
# Clone the project
git clone https://github.com/ahmedmelihozdemir/zig-color.git

# Add to your Zig project
# In your build.zig file:
# const color = @import("zig-color");
```

## 📖 Usage

### Simple Colors

```zig
const color = @import("zig-color");

// Simple colored output
color.red("This text is red!");
color.green("This text is green!");
color.blue("This text is blue!");

// With format support
color.yellow("Warning: {s} not found!", .{"file.txt"});
```

### Custom Color Objects

```zig
// Create a custom color object
var c = color.new(.{ .fg = .red, .bold = true });
c.println("Bold red text!");

// Combine multiple styles
var highlight = color.new(.{ .fg = .white, .bg = .blue, .bold = true });
highlight.print("Important info: ");
```

### String Formats

```zig
// Return colored string (doesn't print)
const warning = color.yellowString("WARNING");
const error = color.redString("ERROR");

std.debug.print("Status: {s} or {s}\n", .{ warning, error });
```

## 🎨 Supported Colors

### Foreground Colors
- `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`
- `hi_black`, `hi_red`, `hi_green`, `hi_yellow`, `hi_blue`, `hi_magenta`, `hi_cyan`, `hi_white`

### Background Colors
- `bg_black`, `bg_red`, `bg_green`, `bg_yellow`, `bg_blue`, `bg_magenta`, `bg_cyan`, `bg_white`

### Text Styles
- `bold`, `faint`, `italic`, `underline`, `reverse`

## 🔧 Advanced Features

### Disabling Colors

```zig
// Disable colors globally
color.setNoColor(true);

// For a specific object only
var c = color.new(.{ .fg = .red });
c.disableColor();
c.println("This will be printed without colors");
```

### Terminal Control

```zig
// Check terminal support
if (color.isTerminal()) {
    color.green("Terminal supports colors!");
} else {
    std.debug.print("Colors are not supported.\n");
}
```

## 📊 Project Status

- [x] Project configuration
- [x] README created
- [ ] Basic ANSI codes
- [ ] Color struct
- [ ] Simple color functions
- [ ] Format support
- [ ] Text styles
- [ ] Background colors
- [ ] Tests
- [ ] Documentation

## 🤝 Open Contributing

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Zig community for support and feedback

---
💡 **Note**: This project is under active development. API changes may occur.
