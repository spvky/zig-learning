const std = @import("std");
const expect = std.testing.expect;

const Direction = enum { north, south, east, west };

const Value = enum(u2) { zero, one, two };

test "enum ordinal value" {
    try expect(@intFromEnum(Value.zero) == 0);
    try expect(@intFromEnum(Value.one) == 1);
    try expect(@intFromEnum(Value.two) == 2);
}
