const std = @import("std");
const testing = std.testing;

const spat = @import("spat");
const argu = spat.argu;

test "positional name" {
    const Arg = argu.Positional(.{ .name = "foo", .type = .string });
    try testing.expectEqualStrings("foo", Arg.name);
}

test "positional default description" {
    const Arg = argu.Positional(.{ .name = "foo", .type = .string });
    try testing.expectEqual(null, Arg.description);
}

test "positional with description" {
    const Arg = argu.Positional(.{
        .name = "foo",
        .type = .string,
        .description = "desc",
    });
    try testing.expectEqualStrings("desc", Arg.description.?);
}

test "positional string parse" {
    const Arg = argu.Positional(.{ .name = "foo", .type = .string });
    try testing.expectEqualStrings("bar", try Arg.parse("bar"));
}

test "positional custom parse" {
    const Arg = argu.Positional(.{
        .name = "foo",
        .type = .custom,
        .parser = argu.CustomParser([]const u8, parseFooString),
    });
    try testing.expectEqualStrings("bar", try Arg.parse("bar"));
}

fn parseFooString(arg: []const u8) ![]const u8 {
    return arg;
}
