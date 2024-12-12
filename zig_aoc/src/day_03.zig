const std = @import("std");
const mvzr = @import("mvzr");
const ArrayList = std.ArrayList;

const input = @embedFile("day_03.txt");

pub fn main() !void {
    try part_01();
    try part_02();
}

fn part_01() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const mult_regex = mvzr.compile("mul\\([0-9]{1,3},[0-9]{1,3}\\)").?;
    const num_regex = mvzr.compile("[0-9]{1,3}").?;
    var it = mult_regex.iterator(input);
    var solution: i32 = 0;
    while (it.next()) |m| {
        var num_it = num_regex.iterator(m.slice);
        const lhs: i32 = try std.fmt.parseInt(i32, num_it.next().?.slice, 10);
        const rhs: i32 = try std.fmt.parseInt(i32, num_it.next().?.slice, 10);
        solution += lhs * rhs;
    }
    std.debug.print("Part 1 - {}\n", .{solution});
}

fn part_02() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const mult_regex = mvzr.compile("mul\\([0-9]{1,3},[0-9]{1,3}\\)|don't|do").?;
    const num_regex = mvzr.compile("[0-9]{1,3}").?;
    var it = mult_regex.iterator(input);
    var solution: i32 = 0;
    var enabled = true;
    while (it.next()) |m| {
        if (std.mem.count(u8, m.slice, "don't") > 0) {
            enabled = false;
            continue;
        } else if (std.mem.count(u8, m.slice, "do") > 0) {
            enabled = true;
            continue;
        }

        if (!enabled) continue;

        var num_it = num_regex.iterator(m.slice);
        const lhs: i32 = try std.fmt.parseInt(i32, num_it.next().?.slice, 10);
        const rhs: i32 = try std.fmt.parseInt(i32, num_it.next().?.slice, 10);
        solution += lhs * rhs;
    }
    std.debug.print("Part 2 - {}\n", .{solution});
}
