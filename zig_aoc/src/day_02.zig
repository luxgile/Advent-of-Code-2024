const std = @import("std");
const ArrayList = std.ArrayList;

const input = @embedFile("day_02.txt");

const Direction = enum { None, Up, Down };

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var lines_it = std.mem.tokenizeScalar(u8, input, '\n');
    var reports_safe: u32 = 0;
    var reports_safe_guarded: u32 = 0;
    while (lines_it.next()) |line| {
        var number_it = std.mem.tokenizeScalar(u8, line, ' ');
        var numbers = ArrayList(i32).init(arena.allocator());
        while (number_it.next()) |number| {
            try numbers.append(try std.fmt.parseInt(i32, number, 10));
        }
        if (is_report_safe(numbers.items)) {
            reports_safe += 1;
        }
        if (is_report_safe_dampened(numbers.items, arena.allocator())) {
            reports_safe_guarded += 1;
        }
    }

    // FIXME: Not working, printing wrong numbers.
    std.debug.print("Part 1 - Reports safe: {}\n", .{reports_safe});
    std.debug.print("Part 2 - Reports safe with damp: {}\n", .{reports_safe_guarded});
}

fn is_report_safe(report: []i32) bool {
    var dir = Direction.None;
    var prev = report[0];
    for (1..report.len) |i| {
        const level = report[i];

        if (dir == .None) dir = get_dir(prev, level);

        if (!is_pair_safe(dir, prev, level)) {
            return false;
        }

        prev = level;
    }
    return true;
}

fn is_report_safe_dampened(report: []i32, allocator: std.mem.Allocator) bool {
    if (is_report_safe(report)) {
        return true;
    }

    for (0..report.len) |i| {
        var new_report = ArrayList(i32).init(allocator);
        new_report.appendSlice(report[0..i]) catch unreachable;
        new_report.appendSlice(report[i + 1 ..]) catch unreachable;

        if (is_report_safe(new_report.items)) {
            return true;
        }
    }

    return false;
}

fn is_pair_safe(direction: Direction, a: i32, b: i32) bool {
    if (a == b) return false;
    if (@abs(a - b) > 3) return false;
    const dir = get_dir(a, b);
    if (direction != dir) return false;
    return true;
}

fn get_dir(a: i32, b: i32) Direction {
    if (a == b) return Direction.None;
    if (a - b < 0) return Direction.Up else return Direction.Down;
}
