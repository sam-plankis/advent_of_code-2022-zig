const std = @import("std");

pub const Elf = struct {
    calories: []const u32,

    pub fn init(calories: []const u32) Elf {
        return Elf{ .calories = calories };
    }

    pub fn getTotalCalories(self: *Elf) u32 {
        var total: u32 = 0;
        for (self.calories) |number| {
            total += number;
        }
        std.debug.print("\nElf | getTotalCalories | Total calories: {}\n", .{total});
        return total;
    }
};

test "simple elf" {
    const calories = [_]u32{ 2, 15, 14, 1 };
    var elf = Elf.init(&calories);
    const correct: u32 = 32;
    const total = elf.getTotalCalories();
    try std.testing.expectEqual(correct, total);
}

pub const TotalElf = struct {
    calories: u32,

    pub fn init(calories: u32) Elf {
        return Elf{ .calories = calories };
    }
};

test "simple elf" {
    const calories = [_]u32{ 2, 15, 14, 1 };
    var elf = Elf.init(&calories);
    const correct: u32 = 32;
    const total = elf.getTotalCalories();
    try std.testing.expectEqual(correct, total);
}
