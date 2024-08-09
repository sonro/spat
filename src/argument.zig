const std = @import("std");

pub const Kind = enum {
    positional,
    option,
    subcommand,
};

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
    description: ?[]const u8 = null,
    optional: bool = false,
    default: ?[]const u8 = null,
    multiple: bool = false,
};

pub fn Positional(comptime options: PositionalOptions) type {
    if (options.optional and options.default != null) {
        @compileError("optional positional cannot have a default value");
    }

    if (options.multiple and options.default != null) {
        @compileError("multiple positional cannot have a default value");
    }

    if (options.multiple and options.optional) {
        @compileError("multiple positional cannot be optional");
    }

    const T: type = switch (options.type) {
        .string => []const u8,
        .custom => if (options.parser) |parser| parser.Type else {
            @compileError("custom type requires parser");
        },
        else => @compileError("unsupported type: " ++ @typeName(options.type)),
    };

    const parser = if (options.parser) |parser| parser.parse else ParseFn(T);

    const RealType = if (options.multiple) []const T else if (options.optional) ?T else T;

    return struct {
        pub const kind: Kind = .positional;
        pub const name = options.name;
        pub const Type = RealType;
        pub const parse = parser;
        pub const description = options.description;
        pub const optional = options.optional;
        pub const default = options.default;
        pub const multiple = options.multiple;
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
