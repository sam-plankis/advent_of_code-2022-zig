const std = @import("std");
const Elf = @import("elf.zig").Elf;
const TotalElf = @import("elf.zig").TotalElf;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    var dir = std.fs.cwd();
    //var file = try dir.openFile("test.txt", .{});
    var file = try dir.openFile("calories.txt", .{});
    defer file.close();
    var io = std.io.bufferedReader(std.fs.File.reader(file));
    var reader = io.reader();
    var buffer: [4096]u8 = undefined;
    var current: u32 = 0;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var totals = std.ArrayList(u32).init(arena.allocator());
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        //std.debug.print("Line: {s}\n", .{line});
        var value = std.fmt.parseInt(u32, line, 10) catch 0;
        switch (value) {
            // 0 is a blank line because I could not yet figure out how
            0 => {
                //std.debug.print("  Blank Line\n", .{});
                switch (current) {
                    0 => {
                        // should not see a blank line without a current total
                        unreachable;
                    },
                    // Need to add the current to the totals
                    else => {
                        try totals.append(current);
                        current = 0;
                    },
                }
            },
            else => {
                //std.debug.print("  Value: {any}\n", .{value});
                current += value;
            },
        }
    }
    try totals.append(current);
    var highest: u32 = 0;
    for (totals.items) |total| {
        if (total >= highest) {
            highest = total;
        }
        //std.debug.print("Total: {any}\n", .{total});
    }
    std.debug.print("Highest Calorie Count: {any}\n", .{highest});
}
