const std = @import("std");
const windows_schema = @import("./schema/windows.schema.zig");
const dx12_schema = @import("./schema/dx12.schema.zig");
const commons = @import("./schema/commons.zig");

pub fn main() !void {
    try write_schema(windows_schema, "windows");
    try write_schema(dx12_schema, "d3d12");
}

fn write_schema(schema: type, comptime file_path: []const u8) !void {
    var file = try std.fs.cwd().createFile("./src/" ++ file_path ++ ".generated.zig", .{});
    defer file.close();

    _ = try file.write("// This is a auto-generated file, do not edit!\n");
    inline for (schema.required_imports) |import| {
        _ = try file.write(std.fmt.comptimePrint("const {s} = {s};\n", .{ import.alias, import.path }));
    }

    _ = try file.write("\n");

    const fields = @typeInfo(@TypeOf(schema.Interfaces)).@"struct".fields;
    inline for (fields) |field| {
        const definition = @field(schema.Interfaces, field.name);
        comptime var base = @field(definition, "base");
        comptime var resolved_bases: []const commons.StructDefinition = &.{};
        comptime var resolved_names: []const []const u8 = &.{};
        comptime {
            while (base) |base_class| {
                if (std.mem.eql(u8, base_class[0..7], "windows")) {
                    const new_base = @field(windows_schema.Interfaces, base_class[8..]);
                    resolved_bases = resolved_bases ++ .{new_base};
                    resolved_names = resolved_names ++ .{base_class[8..]};
                    base = new_base.base;
                }
                if (std.mem.eql(u8, base_class[0..4], "dx12")) {
                    const new_base = @field(dx12_schema.Interfaces, base_class[5..]);
                    resolved_bases = resolved_bases ++ .{new_base};
                    resolved_names = resolved_names ++ .{base_class[5..]};
                    base = new_base.base;
                }
            }
        }
        const is_extern: bool = @field(definition, "is_extern");
        _ = try file.write(std.fmt.comptimePrint("pub const {s} = {s} struct {{\n", .{
            field.name,
            if (is_extern) "extern" else "",
        }));
        _ = try file.write("\t__v: *const VTable,\n\n");
        const methods = @field(definition, "methods");

        inline for (resolved_bases, resolved_names) |resolved_base, resolved_name| {
            inline for (resolved_base.methods) |method| {
                try write_func(resolved_name, &method, &file);
            }
        }
        inline for (methods) |method| {
            try write_func(field.name, &method, &file);
        }

        const resolved_name = if (resolved_names.len >= 1) resolved_names[0] else null;
        try build_vtable(field.name, &methods, resolved_name, &file);

        _ = try file.write("};\n");
    }
}

pub fn write_func(interface: []const u8, method: *const commons.Method, file: *std.fs.File) !void {
    _ = try file.write("\t/// Docs: ");
    _ = try file.write(method.doc);
    _ = try file.write("\n");
    var buffer: [1024]u8 = undefined;
    const slice = try std.fmt.bufPrint(&buffer, "\tpub inline fn {s}(\n", .{method.name});
    _ = try file.write(slice);

    for (method.params, 1..) |param, i| {
        if (i == method.params.len and method.method_type == .ParamReturn) continue;
        const fn_slice = try std.fmt.bufPrint(&buffer, "\t\t{s}: {s},\n", .{ param.name, param.member_type });
        _ = try file.write(fn_slice);
    }
    _ = try file.write("\t) ");
    _ = try file.write(method.return_type);
    _ = try file.write(" {\n");
    _ = try file.write("\t\t");
    if (!std.mem.eql(u8, method.return_type, "void") and !(method.method_type == .ParamReturn)) _ = try file.write("return ");
    if (method.method_type == .ParamReturn) {
        _ = try file.write("var return_value: ");
        _ = try file.write(method.params[method.params.len - 1].member_type);
        _ = try file.write(" = undefined;\n");
        _ = try file.write("\t\t_ = ");
    }
    _ = try file.write("@as(*const ");
    _ = try file.write(interface);
    _ = try file.write(".VTable, @ptrCast(self.__v)).");
    _ = try file.write(method.name);
    _ = try file.write("(\n\t\t\t@as(*");
    _ = try file.write(interface);
    _ = try file.write(", @ptrCast(self)),\n");
    for (method.params, 1..) |param, i| {
        // skip the self as we do the casting
        if (std.mem.eql(u8, param.name, "self")) continue;
        if (method.method_type == .ParamReturn and i == method.params.len) {
            continue;
        }
        _ = try file.write("\t\t\t");
        _ = try file.write(param.name);
        _ = try file.write(",\n");
    }
    if (method.method_type == .ParamReturn) {
        _ = try file.write("\t\t\t&return_value,\n");
    }
    _ = try file.write("\t\t);\n");
    if (method.method_type == .ParamReturn) {
        _ = try file.write("\t\treturn return_value;\n");
    }
    _ = try file.write("\t}\n");
    _ = try file.write("\n");
}

fn build_vtable(interface: [:0]const u8, methods: *const []const commons.Method, base: ?[]const u8, file: *std.fs.File) !void {
    _ = try file.write("\tpub const VTable = extern struct {\n");
    if (base) |fbase| {
        _ = try file.write("\t\tbase: ");
        _ = try file.write(fbase);
        _ = try file.write(".VTable,\n");
    }
    for (methods.*) |method| {
        _ = try file.write("\t\t");
        _ = try file.write(method.name);
        _ = try file.write(": *const fn (\n\t\t\t*");
        _ = try file.write(interface);
        _ = try file.write(",\n");
        for (method.params) |param| {
            if (std.mem.eql(u8, param.name, "self")) continue;
            _ = try file.write("\t\t\t");
            if (method.method_type == .ParamReturn) {
                _ = try file.write("*");
            }
            _ = try file.write(param.member_type);
            _ = try file.write(",\n");
        }
        _ = try file.write("\t\t) ");
        if (method.call_conv) |call_conv| {
            _ = try file.write("callconv(");
            _ = try file.write(call_conv);
            _ = try file.write(") ");
        }
        if (method.method_type == .ParamReturn) {
            _ = try file.write("*");
        }
        _ = try file.write(method.return_type);
        _ = try file.write(",\n");
    }
    _ = try file.write("\t};\n");
}
