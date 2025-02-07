const expect = @import("std").testing.expect;

fn fibonacci(n: u16) u16 {
    if (n == 0 or n == 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

test "comptime blocks" {
    // Comptime is like rust macros but easier to write and use, this is telling the compiler to calulate this value at compile time.
    const x = comptime fibonacci(10);
    // comptime is not limited to single expressions, this block is being evaluated at comptime
    const y = comptime blk: {
        break :blk fibonacci(10);
    };

    try expect(y == 55);
    try expect(x == 55);
}

// B is of type comptime_int here
test "comptime int" {
    const a = 12;
    const b = a + 10;

    const c: u4 = a;
    const d: f32 = b;

    try expect(c == 12);
    try expect(d == 22);
}

test "comptime_float" {
    const a = 5;
    const b: if (a < 10) f32 else i32 = 5;
    try expect(b == 5);
    try expect(@TypeOf(b) == f32);
}

// Function params can be marked as comptime, meaning the type must be known at compile time
fn Matrix(
    comptime T: type,
    comptime width: comptime_int,
    comptime height: comptime_int,
) type {
    return [height][width]T;
}

test "returning a type" {
    try expect(Matrix(f32, 4, 4) == [4][4]f32);
}

// We can reflect upon types using built-in @typeInfo, which takes in a type and returns a tagged union

fn addSmallInts(comptime T: type, a: T, b: T) T {
    return switch (@typeInfo(T)) {
        .ComptimeInt => a + b,
        .Int => |info| if (info.bits <= 16)
            a + b
        else
            @compileError("ints too large"),
        else => @compileError("only ints accepted"),
    };
}

test "typeinfo switch" {
    const x = addSmallInts(u16, 20, 30);
    try expect(@TypeOf(x) == u16);
    try expect(x == 50);
}
