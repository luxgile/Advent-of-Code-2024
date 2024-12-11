const std = @import("std");
const ArrayList = std.ArrayList;

const input = @embedFile("day_01.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var left_column = ArrayList(i32).init(arena.allocator());
    var right_column = ArrayList(i32).init(arena.allocator());

    var lines_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines_it.next()) |line| {
        var number_it = std.mem.tokenizeScalar(u8, line, ' ');
        const left: i32 = @intCast(try std.fmt.parseInt(u32, number_it.next().?, 10));
        const right: i32 = @intCast(try std.fmt.parseInt(u32, number_it.next().?, 10));

        try left_column.append(left);
        try right_column.append(right);
    }

    std.mem.sort(i32, left_column.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, right_column.items, {}, comptime std.sort.asc(i32));

    const distance = get_distance(left_column.items, right_column.items);
    std.debug.print("Part 01 - Distance: {}\n", .{distance});

    const similarities = get_similarities(left_column.items, right_column.items);
    std.debug.print("Part 02 - Similarities: {}\n", .{similarities});
}

fn get_distance(left: []i32, right: []i32) u32 {
    var total_distance: u32 = 0;
    for (left, right) |l, r| {
        total_distance += @abs(l - r);
    }
    return total_distance;
}

fn get_similarities(left: []i32, right: []i32) i32 {
    var similarities: i32 = 0;
    for (left) |l| {
        const repetitions: i32 = @intCast(std.mem.count(i32, right, &[_]i32{l}));
        similarities += l * repetitions;
    }
    return similarities;
}
