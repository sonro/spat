const std = @import("std");
const testing = std.testing;

const spat = @import("spat");
const argu = spat.argu;

test "simple string positional arg" {
    const Arg = argu.Positional(.{
        .name = "foo",
        .type = .string,
    });
    try testing.expectEqualStrings("foo", Arg.name);
    try testing.expectEqualStrings("bar", try Arg.parse("bar"));
}

test "custom string parser positional arg" {
    const Arg = argu.Positional(.{
        .name = "foo",
        .type = .custom,
        .parser = argu.CustomParser([]const u8, parseFooString),
    });
    try testing.expectEqualStrings("foo", Arg.name);
    try testing.expectEqualStrings("bar", try Arg.parse("bar"));
}

fn parseFooString(arg: []const u8) ![]const u8 {
    return arg;
}
