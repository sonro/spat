const std = @import("std");

pub const ArgType = enum {
    string,
    int,
    custom,
};

pub fn CustomParser(comptime T: type, comptime Fn: fn ([]const u8) anyerror!T) type {
    return struct {
        pub const Type = T;
        pub const parse = Fn;
    };
}

pub const PositionalOptions = struct {
    name: []const u8,
    type: ArgType,
    parser: ?type = null,
};

pub fn Positional(comptime options: PositionalOptions) type {
    const T: type = switch (options.type) {
        .string => []const u8,
        .custom => if (options.parser) |parser| parser.Type else {
            @compileError("custom type requires parser");
        },
        else => @compileError("unsupported type: " ++ @typeName(options.type)),
    };
    return struct {
        pub const name = options.name;
        pub const parse = if (options.parser) |parser| parser.parse else ParseFn(T);
    };
}

fn ParseFn(comptime T: type) fn ([]const u8) anyerror!T {
    switch (@typeInfo(T)) {
        .Pointer => |ptr_info| {
            return switch (ptr_info.size) {
                .Slice => parseString,
                else => @compileError("unsupported type: " ++ @typeName(T)),
            };
        },
        else => @compileError("unsupported type: " ++ @typeName(T)),
    }
}

fn parseString(arg: []const u8) anyerror![]const u8 {
    return arg;
}
