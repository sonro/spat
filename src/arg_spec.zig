const std = @import("std");

pub fn ArgSpec(comptime spec: []const type) type {
    const args_fields = genArgsFields(spec);

    const Args = @Type(.{
        .Struct = .{
            .is_tuple = false,
            .layout = .auto,
            .decls = &.{},
            .fields = &args_fields,
        },
    });

    const params = genSpec(spec);

    return struct {
        const ThisParser = Parser(Args, params);

        pub fn parse(argv: []const []const u8) !Args {
            var parser = ThisParser.init(argv);
            return try parser.parse();
        }
    };
}

const Spec = struct {
    positionals: []const type,
};

fn Parser(comptime Args: type, comptime params: Spec) type {
    return struct {
        args: Args = undefined,
        argc: usize = 0,
        position: usize = 0,
        argv: []const []const u8,

        const Self = @This();

        pub fn init(argv: []const []const u8) Self {
            return .{ .argv = argv };
        }

        pub fn parse(self: *Self) !Args {
            while (self.argc < self.argv.len) : (self.argc += 1) {
                try self.parsePositional();
            }

            return self.args;
        }

        pub fn parsePositional(self: *Self) !void {
            const arg = self.argv[self.argc];
            self.argc += 1;
            inline for (params.positionals, 0..) |pos, i| {
                if (i == self.position) {
                    const field = &@field(self.args, pos.name);
                    field.* = try pos.parse(arg);
                    self.position += 1;
                    return;
                }
            }
        }
    };
}

fn genArgsFields(comptime spec: []const type) [spec.len]std.builtin.Type.StructField {
    var fields: [spec.len]std.builtin.Type.StructField = undefined;
    for (spec, 0..) |arg, i| {
        fields[i] = .{
            .name = arg.name,
            .type = arg.Type,
            .default_value = null,
            .is_comptime = false,
            .alignment = @alignOf(arg.Type),
        };
    }
    return fields;
}

fn genSpec(comptime spec: []const type) Spec {
    var positionals: []const type = &.{};
    for (spec) |arg| {
        if (arg.kind == .positional) {
            positionals = positionals ++ [_]type{arg};
        }
    }
    return Spec{ .positionals = positionals };
}
