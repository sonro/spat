const std = @import("std");
const testing = std.testing;

const spat = @import("spat");
const argu = spat.argu;

test "positional name" {
    const Arg = argu.Positional(.{ .name = "foo", .type = .string });
    try testing.expectEqualStrings("foo", Arg.name);
}

test "positional string type" {
    const Arg = argu.Positional(.{ .name = "foo", .type = .string });
    try testing.expectEqual([]const u8, Arg.Type);
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
    try testing.expectEqual([]const u8, Arg.Type);
    try testing.expectEqualStrings("bar", try Arg.parse("bar"));
}

fn parseFooString(arg: []const u8) ![]const u8 {
    return arg;
}

test "positional custom type" {
    const Arg = argu.Positional(.{
        .name = "foo",
        .type = .custom,
        .parser = argu.CustomParser(TestType, TestType.parse),
    });
    try testing.expectEqual(TestType, Arg.Type);
    try testing.expectEqual(TestType{}, try Arg.parse(""));
}

const TestType = struct {
    pub fn parse(arg: []const u8) !TestType {
        _ = arg;
        return TestType{};
    }
};
