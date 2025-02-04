const std = @import("std");
const expect = std.testing.expect;

fn failingFunction() !void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        try expect(err == error.Oops);
        return;
    };
}
