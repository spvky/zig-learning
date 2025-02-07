const std = @import("std");
const print = std.debug.print;

pub fn main() void {
    const msg = getMsg();
    print("{s}\n", .{msg});
}

fn getMsg() []const u8 {
    return "hello";
}
