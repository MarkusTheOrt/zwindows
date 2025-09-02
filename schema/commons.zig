pub const MethodParam = struct {
    name: []const u8,
    member_type: []const u8,
};

pub const FunctionType = enum {
    Default,
    ParamReturn,
};

pub const Method = struct {
    name: []const u8,
    call_conv: ?[]const u8,
    namespace: ?[]const u8,
    return_type: []const u8,
    method_type: FunctionType,
    params: []const MethodParam,
    doc: []const u8,
};

pub const StructDefinition = struct {
    base: ?[]const u8,
    methods: []const Method,
    is_extern: bool,
};
