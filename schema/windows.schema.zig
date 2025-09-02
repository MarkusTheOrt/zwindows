const commons = @import("./commons.zig");
const StructDefinition = commons.StructDefinition;
const Method = commons.Method;
const MethodParam = commons.MethodParam;

pub const required_imports = &.{
    .{ .alias = "std", .path = "@import(\"std\")" },
    .{ .alias = "winapi", .path = "std.builtin.CallingConvention.winapi" },
    .{ .alias = "windows", .path = "std.os.windows" },
    .{ .alias = "GUID", .path = "windows.GUID" },
    .{ .alias = "ULONG", .path = "windows.ULONG" },
    .{ .alias = "HRESULT", .path = "windows.HRESULT" },
};

pub const Interfaces = .{
    .IUnknown = StructDefinition{
        .base = null,
        .is_extern = true,
        .methods = &.{
            .{
                .name = "QueryInterface",
                .call_conv = "winapi",
                .namespace = null,
                .return_type = "HRESULT",
                .method_type = .Default,
                .params = &.{
                    .{ .name = "self", .member_type = "*@This()" },
                    .{ .name = "guid", .member_type = "*const GUID" },
                    .{ .name = "ppvObject", .member_type = "?*?*anyopaque" },
                },
                .doc = "https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-queryinterface(q)",
            },
            .{
                .name = "AddRef",
                .call_conv = "winapi",
                .namespace = null,
                .return_type = "ULONG",
                .method_type = .Default,
                .params = &.{
                    .{ .name = "self", .member_type = "*@This()" },
                },
                .doc = "https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-addref",
            },
            .{
                .name = "Release",
                .call_conv = "winapi",
                .namespace = null,
                .return_type = "ULONG",
                .method_type = .Default,
                .params = &.{
                    .{ .name = "self", .member_type = "*@This()" },
                },
                .doc = "https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-release",
            },
        },
    },
};
