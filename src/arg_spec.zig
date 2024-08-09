const std = @import("std");

pub fn ArgSpec(comptime spec: anytype) type {
    const args_fields = genArgsFields(spec);

    const Args = @Type(.{
        .Struct = .{
            .is_tuple = false,
            .layout = .auto,
            .decls = &.{},
            .fields = &args_fields,
        },
    });

    return struct {
        pub fn parse(args: []const []const u8) !Args {
            _ = args;
            return .{};
        }
    };
}

fn genArgsFields(comptime spec: anytype) [spec.len]std.builtin.Type.StructField {
    var fields: [spec.len]std.builtin.Type.StructField = undefined;
    for (spec, 0..) |arg, i| {
        fields[i] = .{
            .name = arg.name,
            .field_type = arg.Type,
            .default_value = null,
            .is_comptime = false,
            .alignment = @alignOf(arg.Type),
        };
    }
    return fields;
}
