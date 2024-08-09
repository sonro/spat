const std = @import("std");
const testing = std.testing;

const spat = @import("spat");
const Positional = spat.Positional;
const CustomParser = spat.CustomParser;

test "positional name" {
    const Arg = Positional(.{ .name = "foo", .type = .string });
    try testing.expectEqualStrings("foo", Arg.name);
}

test "positional string type" {
    const Arg = Positional(.{ .name = "foo", .type = .string });
    try testing.expectEqual([]const u8, Arg.Type);
}

test "positional default description" {
    const Arg = Positional(.{ .name = "foo", .type = .string });
    try testing.expectEqual(null, Arg.description);
}

test "positional with description" {
    const Arg = Positional(.{
        .name = "foo",
        .type = .string,
        .description = "desc",
    });
    try testing.expectEqualStrings("desc", Arg.description.?);
}

test "positional optional" {
    const Arg = Positional(.{ .name = "foo", .type = .string, .optional = true });
    try testing.expectEqual(true, Arg.optional);
    try testing.expectEqual(?[]const u8, Arg.Type);
}

test "positional default value" {
    const Arg = Positional(.{ .name = "foo", .type = .string, .default = "bar" });
    try testing.expectEqualStrings("bar", Arg.default.?);
}

test "positional string parse" {
    const Arg = Positional(.{ .name = "foo", .type = .string });
    try testing.expectEqualStrings("bar", try Arg.parse("bar"));
}

test "positional custom parse" {
    const Arg = Positional(.{
        .name = "foo",
        .type = .custom,
        .parser = CustomParser([]const u8, parseFooString),
    });
    try testing.expectEqual([]const u8, Arg.Type);
    try testing.expectEqualStrings("bar", try Arg.parse("bar"));
}

fn parseFooString(arg: []const u8) ![]const u8 {
    return arg;
}

test "positional custom type" {
    const Arg = Positional(.{
        .name = "foo",
        .type = .custom,
        .parser = CustomParser(TestType, TestType.parse),
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
