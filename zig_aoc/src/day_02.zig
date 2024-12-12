const std = @import("std");
const ArrayList = std.ArrayList;

const input = @embedFile("day_02.txt");

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
        if (is_report_safe(numbers.items, true)) {
            reports_safe += 1;
        }
        if (is_report_safe(numbers.items, false)) {
            reports_safe_guarded += 1;
        }
    }

    // FIXME: Not working, printing wrong numbers.
    std.debug.print("Part 1 - Reports safe: {}\n", .{reports_safe});
    std.debug.print("Part 2 - Reports safe with damp: {}\n", .{reports_safe_guarded});
}

fn is_report_safe(report: []i32, start_failed: bool) bool {
    const ascending = report[0] - report[1] > 0;
    var failed = start_failed;
    var prev = report[0];
    for (1..report.len) |i| {
        const level = report[i];
        if (!is_pair_safe(ascending, prev, level)) {
            if (!failed) {
                failed = true;
                continue;
            }
            return false;
        }
        prev = level;
    }
    return true;
}

fn is_pair_safe(ascending: bool, a: i32, b: i32) bool {
    if (a == b) return false;
    if (@abs(a - b) >= 3) return false;
    if (ascending and a - b < 0) return false;
    return true;
}
