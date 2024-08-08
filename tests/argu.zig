const std = @import("std");
const testing = std.testing;

const spat = @import("spat");
const argu = spat.argu;

test "simple string positional arg" {
    const Arg = argu.Positional(.{
        .name = "foo",
        .type = .string,
    });
    const actual = try Arg.parse("bar");
    try testing.expectEqualStrings("bar", actual);
}

test "custom string parser positional arg" {
    const Arg = argu.Positional(.{
        .name = "foo",
        .type = .custom,
        .parser = argu.CustomParser([]const u8, parseFooString),
    });
    const actual = try Arg.parse("bar");
    try testing.expectEqualStrings("bar", actual);
}

fn parseFooString(arg: []const u8) anyerror![]const u8 {
    return arg;
}
