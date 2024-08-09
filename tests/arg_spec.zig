const std = @import("std");
const testing = std.testing;

const spat = @import("spat");
const ArgSpec = spat.ArgSpec;

test "no args" {
    const Spec = ArgSpec(.{});
    const args = try Spec.parse(&[_][]const u8{});
    const fields = @typeInfo(@TypeOf(args)).Struct.fields;
    try testing.expectEqual(0, fields.len);
}
