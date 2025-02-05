const expect = @import("std").testing.expect;

test "optional" {
    // Optionals store a value of null or the child type, they are essentially the same as Option<T> in rust
    var found_index: ?usize = null;
    const data = [_]i32{ 1, 2, 3, 4, 5, 6, 7, 8, 12 };
    for (data, 0..) |v, i| {
        if (v == 10) found_index = i;
    }
    try expect(found_index == null);
}

test "orelse" {
    const a: ?f32 = null;
    const fallback_value: f32 = 0;
    // orelse is like an unwrap_or in rust
    // the following line in Rust:
    //      b = a.unwrap_or(fallback_value);
    const b = a orelse fallback_value;
    try expect(b == 0);
    try expect(@TypeOf(b) == f32);
}

test "orelse unreachable" {
    const a: ?f32 = 5;
    // for when a can never be null
    const b = a orelse unreachable;
    // this is shorthand for orelse unreachable
    // Note that this is simmilar to [unwrap()] in Rust,
    // [unreachable] is essentially a panic in zig, with the primary difference being that the panic will only happen if the program is compiled in [Debug] or [ReleaseSafe] whereas in [ReleaseFast] and [ReleaseSmall] it will essentially be ignored, leading to UB
    const c = a.?;
    try expect(b == c);
    try expect(@TypeOf(c) == f32);
}

test "if optional payload capture" {
    const a: ?i32 = 5;
    if (a != null) {
        const value = a.?;
        _ = value;
    }

    // This is also simmilar to writing out an [if let Some(_)], in Rust:
    //                  Rust                    /
    //      let b = Some(5);                    /
    //      if let Some(ref mut value) = b {    /
    //          value += 1;                     /
    //      }                                   /
    /////////////////////////////////////////////
    var b: ?i32 = 5;
    if (b) |*value| {
        value.* += 1;
    }

    try expect(b.? == 6);
}

var numbers_left: u32 = 4;
fn eventuallyNullSequence() ?u32 {
    if (numbers_left == 0) return null;
    numbers_left -= 1;
    return numbers_left;
}

test "while null capture" {
    var sum: u32 = 0;
    // When doing a payload capture of an optional with a while loop, the loop will continue until the optional evaluates to null
    while (eventuallyNullSequence()) |value| {
        sum += value;
    }
    try expect(sum == 6); // 3 + 2 + 1
}

// Important ending note from the guide:
//
// Optional pointer and optional slice types do not take up any extra memory compared to non-optional ones. This is because internally they use the 0 value of the pointer for null.
//
// This is how null pointers in Zig work - they must be unwrapped to a non-optional before dereferencing, which stops null pointer dereferences from happening accidentally.
//

test "optional pointer value" {
    // note that they use the 0 value of the pointer does not mean they are coerced to 0
    const a: ?u8 = 0;
    const b: ?u8 = null;
    try expect(a != b);
}
