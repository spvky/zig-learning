const expect = @import("std").testing.expect;

//take in a pointer to a u8 array, and the size of the buffer
fn doubleAllManyPointer(buffer: [*]u8, byte_count: usize) void {
    var i: usize = 0;
    // for each byte in the buffer, double it's value
    while (i < byte_count) : (i += 1) buffer[i] *= 2;
}

test "many-item pointers" {
    // Create an array of 100 bytes set to one
    var buffer: [100]u8 = [_]u8{1} ** 100;
    // create a pointer to the the array
    const buffer_ptr = &buffer;

    //Create a many pointer to the arrays elements
    const buffer_many_ptr: [*]u8 = buffer_ptr;
    //pass the many ptr to our function
    doubleAllManyPointer(buffer_many_ptr, buffer.len);
    // expect each of the bytes in our array to equal 2
    for (buffer) |byte| try expect(byte == 2);

    // Create a single item pointer to the first element of the array
    const first_elem_ptr: *u8 = &buffer_many_ptr[0];
    // Coerce the many pointer into a single item pointer
    const first_elem_ptr_2: *u8 = @ptrCast(buffer_many_ptr);
    try expect(first_elem_ptr == first_elem_ptr_2);
}
