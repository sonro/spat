const std = @import("std");
const testing = std.testing;

const spat = @import("spat");
const ArgSpec = spat.ArgSpec;
const Positional = spat.argument.Positional;

test "no args has no fields" {
    const Spec = ArgSpec(&.{});
    const args = try Spec.parse(&[_][]const u8{});
    const fields = @typeInfo(@TypeOf(args)).Struct.fields;
    try testing.expectEqual(0, fields.len);
}

test "one string positional arg" {
    const Spec = ArgSpec(&.{
        Positional(.{ .name = "foo", .type = .string }),
    });
    const args = try Spec.parse(&[_][]const u8{"bar"});
    const fields = @typeInfo(@TypeOf(args)).Struct.fields;
    try testing.expectEqual(1, fields.len);
    try testing.expectEqualStrings("foo", fields[0].name);
    try testing.expectEqual([]const u8, fields[0].type);
    try testing.expectEqualStrings("bar", args.foo);
}
