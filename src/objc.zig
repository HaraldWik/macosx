const std = @import("std");

extern "objc" fn objc_msgSend() void;

pub fn msgSend(comptime ReturnType: type, object: anytype, comptime selector_name: [*:0]const u8, args: anytype) ReturnType {
    const Func = comptime func: {
        const info = switch (@typeInfo(@TypeOf(args))) {
            .@"struct" => |@"struct"| @"struct",
            else => |info| @compileError("expected tuple, found '" ++ @tagName(info) ++ "' type of '" ++ @typeName(@TypeOf(args)) ++ "'"),
        };
        if (!info.is_tuple) @compileError("expected tuple, found struct '" ++ @typeName(args) ++ "'");

        var param_types: [info.fields.len + 2]type = undefined;
        param_types[0] = @TypeOf(object);
        param_types[1] = SEL;
        for (info.fields, param_types[2..]) |field, *param_type| switch (@typeInfo(field.type)) {
            .null,
            .comptime_int,
            .comptime_float,
            .enum_literal,
            .undefined,
            .error_set,
            .error_union,
            => @compileError(
                std.fmt.comptimePrint(
                    "parameter of type '{s}' not allowed in selector '{s}' with calling convention '{t}'",
                    .{
                        @typeName(field.type),
                        selector_name,
                        std.builtin.CallingConvention.c,
                    },
                ),
            ),
            else => param_type.* = field.type,
        };

        break :func @Fn(&param_types, &@splat(.{}), ReturnType, .{ .@"callconv" = .c });
    };
    const func: *const Func = @ptrCast(&objc_msgSend);

    const selector: SEL = .registerName(selector_name);
    return @call(.auto, func, .{ object, selector } ++ args);
}

pub const SEL = *opaque {
    extern "objc" fn sel_registerName(str: [*:0]const u8) SEL;
    extern "objc" fn sel_getUid(str: [*:0]const u8) SEL;
    extern "objc" fn sel_isEqual(lhs: SEL, rhs: SEL) bool;

    pub const registerName = sel_registerName;
    pub const getUid = sel_getUid;
    pub const eql = sel_isEqual;
};

pub const Class = opaque {
    pub const Version = packed struct(u32) {
        major: u8,
        minor: u8,
        patch: u16,
    };

    pub const GetClassError = error{ClassNotFound};
    pub const AllocatePairError = error{AllocatePair};
    pub const AddPropertyError = error{AddProperty};
    pub const AddMethodError = error{AddMethod};
    pub const AddProtocolError = error{ProtocolNotFound};
    pub const ConformToProtocolError = error{ConformToProtocol};

    extern "objc" fn objc_getClass(name: [*:0]const u8) ?*Class;
    extern "objc" fn objc_getFutureClass(name: [*:0]const u8) *Class;
    extern "objc" fn objc_duplicateClass(original: *Class, name: [*:0]const u8, extra_bytes: usize) *Class;
    extern "objc" fn objc_allocateClassPair(superclass: *Class, name: [*:0]const u8, extra_bytes: usize) ?*Class;
    extern "objc" fn objc_registerClassPair(class: *Class) void;
    extern "objc" fn objc_disposeClassPair(class: *Class) void;

    extern "objc" fn class_getName(class: *Class) [*:0]const u8;
    extern "objc" fn class_getSuperclass(class: *Class) ?*Class;
    /// Deprecated; not recommended
    extern "objc" fn class_setSuperclass(class: *Class, new_super: *Class) ?*Class;
    extern "objc" fn class_isMetaClass(class: *Class) bool;
    extern "objc" fn class_getInstanceSize(class: *Class) usize;

    extern "objc" fn class_getInstanceVariable(class: *Class, name: [*:0]const u8) *IVar;
    extern "objc" fn class_getClassVariable(class: *Class, name: [*:0]const u8) *IVar;
    /// return of true means success
    extern "objc" fn class_addIvar(class: *Class, name: [*:0]const u8, size: usize, alignment: u8, types: [*:0]const u8) bool;
    extern "objc" fn class_copyIvarList(class: *Class, out_count: *c_uint) ?[*]*IVar;
    extern "objc" fn class_getIvarLayout(class: *Class) ?[*:0]const u8;
    extern "objc" fn class_setIvarLayout(class: *Class, layout: ?[*:0]const u8) void;
    extern "objc" fn class_getWeakIvarLayout(class: *Class) ?[*:0]const u8;
    extern "objc" fn class_setWeakIvarLayout(class: *Class, layout: ?[*:0]const u8) void;

    extern "objc" fn class_addProperty(class: *Class, name: [*:0]const u8, attributes: [*]const Property.Attribute, attribute_count: c_uint) bool;
    extern "objc" fn class_replaceProperty(class: *Class, name: [*:0]const u8, attributes: [*]const Property.Attribute, attribute_count: c_uint) void;
    extern "objc" fn class_copyPropertyList(class: *Class, out_count: *c_uint) ?[*]Property;
    extern "objc" fn class_getProperty(class: *Class, name: [*:0]const u8) *Property;

    extern "objc" fn class_addMethod(class: *Class, name: SEL, imp: IMP, types: [*:0]const u8) bool;
    extern "objc" fn class_getInstanceMethod(class: *Class, name: SEL) *Method;
    extern "objc" fn class_getClassMethod(class: *Class, name: SEL) *Method;
    extern "objc" fn class_replaceMethod(class: *Class, name: SEL, imp: IMP, types: [*:0]const u8) IMP;
    extern "objc" fn class_getMethodImplementation(class: *Class, name: SEL) IMP;
    extern "objc" fn class_getMethodImplementation_stret(class: *Class, name: SEL) IMP;
    extern "objc" fn class_copyMethodList(class: *Class, out_count: *c_uint) ?[*]*Method;

    extern "objc" fn class_addProtocol(class: *Class, protocol: *Protocol) bool;
    extern "objc" fn class_copyProtocolList(class: *Class, out_count: *c_uint) ?[*]*Protocol;
    extern "objc" fn class_conformsToProtocol(class: *Class, protocol: *Protocol) bool;

    extern "objc" fn class_respondsToSelector(class: *Class, sel: SEL) bool;

    extern "objc" fn class_getVersion(class: *Class) Version;
    extern "objc" fn class_setVersion(class: *Class, version: Version) void;

    extern "objc" fn class_createInstance(class: *Class, extra_bytes: usize) ?*Object;

    pub fn get(name: [*:0]const u8) GetClassError!*Class {
        return objc_getClass(name) orelse error.ClassNotFound;
    }
    pub const getFuture = objc_getFutureClass;
    pub const duplicate = objc_duplicateClass;
    pub fn allocatePair(superclass: *Class, name: [*:0]const u8, extra_bytes: usize) AllocatePairError!*Class {
        return objc_allocateClassPair(superclass, name, extra_bytes) orelse error.AllocatePair;
    }

    pub const registerPair = objc_registerClassPair;
    pub const disposePair = objc_disposeClassPair;

    pub const getName = class_getName;
    pub const getSuperclass = class_getSuperclass;
    pub const setSuperclass = class_setSuperclass;
    pub const isMetaClass = class_isMetaClass;
    pub const getInstanceSize = class_getInstanceSize;

    pub const getInstanceVariable = class_getInstanceVariable;
    pub const getClassVariable = class_getClassVariable;
    pub const addIvarRaw = class_addIvar;
    pub fn addIvar(class: *Class, name: [*:0]const u8, comptime T: type) error{AddIvar}!void {
        const alignment: u8 = @alignOf(T);
        std.debug.assert(std.math.isPowerOfTwo(alignment));
        const alignment_log2 = @ctz(alignment);

        if (!class.addIvarRaw(name, @sizeOf(T), @intCast(alignment_log2), &.{helper.typeEncoding(T)})) return error.AddIvar;
    }
    pub fn copyIvarList(class: *Class) []*IVar {
        var count: c_uint = 0;
        const list = class_copyIvarList(class, &count) orelse return &.{};
        return list[0..count];
    }
    pub const getIvarLayout = class_getIvarLayout;
    pub const setIvarLayout = class_setIvarLayout;
    pub const getWeakIvarLayout = class_getWeakIvarLayout;
    pub const setWeakIvarLayout = class_setWeakIvarLayout;

    pub fn addProperty(class: *Class, name: [*:0]const u8, attributes: []const Property.Attribute) AddPropertyError!void {
        if (!class_addProperty(class, name, attributes.ptr, attributes.len)) return error.AddProperty;
    }
    pub fn replaceProperty(class: *Class, name: [*:0]const u8, attributes: []const Property.Attribute) void {
        class_replaceProperty(class, name, attributes.ptr, attributes.len);
    }
    pub fn copyPropertyList(class: *Class) []Property {
        var count: c_uint = 0;
        const list = class_copyPropertyList(class, &count) orelse return &.{};
        return list[0..count];
    }
    pub const getProperty = class_getProperty;

    pub fn addMethod(class: *Class, name: SEL, implementation: anytype) AddMethodError!void {
        const implementation_info = @typeInfo(@TypeOf(implementation)).@"fn";
        comptime if (!implementation_info.calling_convention.eql(.c)) {
            @compileError(std.fmt.comptimePrint(
                "excpected method to be calling convention '{t}', found '{t}'",
                .{ std.builtin.CallingConvention.c, implementation_info.calling_convention },
            ));
        };

        const types = comptime helper.methodTypeEncoding(implementation_info).ptr;
        if (!class_addMethod(class, name, @ptrCast(&implementation), types)) return error.AddMethod;
    }
    pub const getInstanceMethod = class_getInstanceMethod;
    pub const getClassMethod = class_getClassMethod;
    pub fn replaceMethod(class: *Class, name: SEL, implementation: anytype) !@TypeOf(&implementation) {
        const implementation_info = @typeInfo(@TypeOf(implementation)).@"fn";
        const types = comptime helper.methodTypeEncoding(implementation_info).ptr;
        return @ptrCast(class_replaceMethod(class, name, &implementation, types));
    }
    pub fn getMethodImplementation(class: *Class, name: SEL, comptime T: type) T {
        return @ptrCast(class_getMethodImplementation(class, name));
    }
    pub fn getMethodImplementation_stret(class: *Class, name: SEL, comptime T: type) T {
        return @ptrCast(class_getMethodImplementation_stret(class, name));
    }
    pub fn copyMethodList(class: *Class) []Method {
        var count: c_uint = 0;
        const list = class_copyMethodList(class, &count) orelse return &.{};
        return list[0..count];
    }

    pub fn addProtocol(class: *Class, protocol: *Protocol) AddProtocolError!void {
        if (!class_addProtocol(class, protocol)) return error.ProtocolNotFound;
    }
    pub fn copyProtocolList(class: *Class) []*Protocol {
        var count: c_uint = 0;
        const list = class_copyProtocolList(class, &count) orelse return &.{};
        return list[0..count];
    }
    pub fn conformsToProtocol(class: *Class, protocol: *Protocol) ConformToProtocolError!void {
        if (!class_conformsToProtocol(class, protocol)) return error.ConformToProtocol;
    }

    pub const respondsToSelector = class_respondsToSelector;

    pub const getVersion = class_getVersion;
    pub const setVersion = class_setVersion;

    pub const createInstance = class_createInstance;
};

pub const Protocol = opaque {
    pub const Error = error{ProtocolNotFound};

    extern "objc" fn objc_getProtocol(name: [*:0]const u8) ?*Protocol;
    extern "objc" fn objc_copyProtocolList(out_count: *c_uint) ?[*]*Protocol;

    extern "objc" fn objc_allocateProtocol(name: [*:0]const u8) *Protocol;
    extern "objc" fn objc_registerProtocol(protocol: *Protocol) void;

    extern "objc" fn protocol_addProtocol(protocol: *Protocol, addition: *Protocol) void;
    extern "objc" fn protocol_copyProtocolList(protocol: *Protocol, out_count: *c_uint) ?[*]*Protocol;

    extern "objc" fn protocol_getName(protocol: *Protocol) ?[*:0]const u8;
    extern "objc" fn protocol_isEqual(a: *Protocol, b: *Protocol) ?[*:0]const u8;

    extern "objc" fn protocol_getProperty(protocol: *Protocol, name: [*:0]const u8, is_required_property: bool, is_instance_property: bool) void;
    extern "objc" fn protocol_addProperty(protocol: *Protocol, name: [*:0]const u8, attributes: *const Property.Attribute, attribute_count: c_uint, is_required_property: bool, is_instance_property: bool) void;
    extern "objc" fn protocol_copyPropertyList(protocol: *Protocol, out_count: *c_uint) [*]*Property;

    extern "objc" fn protocol_getMethodDescription(protocol: *Protocol, a_sel: SEL, is_required_method: bool, is_instance_method: bool) Method.Description;
    extern "objc" fn protocol_addMethodDescription(protocol: *Protocol, name: SEL, types: [*:0]const u8, is_required_method: bool, is_instance_method: bool) void;
    extern "objc" fn protocol_copyMethodDescriptionList(protocol: *Protocol, is_required_method: bool, is_instance_method: bool, out_count: *c_uint) *Method.Description;

    /// returns true if protocol conforms to other
    extern "objc" fn protocol_conformsToProtocol(protocol: *Protocol, other: *Protocol) bool;

    pub fn get(name: [*:0]const u8) Error!*Protocol {
        return objc_getProtocol(name) orelse error.ProtocolNotFound;
    }
    pub fn copyList() []*Protocol {
        var count: c_uint = 0;
        const list = objc_copyProtocolList(&count) orelse return &.{};
        return list[0..count];
    }

    pub const allocate = objc_allocateProtocol;
    pub const register = objc_registerProtocol;

    pub const addProtocol = protocol_addProtocol;
    pub fn copyProtocolList() []*Protocol {
        var count: c_uint = 0;
        const list = protocol_copyProtocolList(&count) orelse return &.{};
        return list[0..count];
    }

    pub const getName = protocol_getName;
    pub const eql = protocol_isEqual;

    pub const getProperty = protocol_getProperty;
    pub const addProperty = protocol_addProperty;
    pub fn copyPropertyList() []*Protocol {
        var count: c_uint = 0;
        const list = protocol_copyPropertyList(&count) orelse return &.{};
        return list[0..count];
    }

    pub const getMethodDescription = protocol_getMethodDescription;
    pub const addMethodDescription = protocol_addMethodDescription;
    pub fn copyMethodDescriptionList() []*Method.Description {
        var count: c_uint = 0;
        const list = protocol_copyMethodDescriptionList(&count) orelse return &.{};
        return list[0..count];
    }
};

pub const Property = extern struct {
    name: [*:0]const u8,
    attributes: [*:0]const u8,

    pub const Attribute = extern struct {
        name: [*:0]const u8,
        value: [*:0]const u8 = "",

        pub const readonly: Attribute = .{ .name = "R" };
        pub const nonatomic: Attribute = .{ .name = "N" };
        pub const copy: Attribute = .{ .name = "C" };
        pub const retain: Attribute = .{ .name = "&" };

        pub fn @"type"(comptime T: type) Attribute {
            return .{ .name = "T", .value = &.{helper.typeEncoding(T)} };
        }
    };

    extern "objc" fn property_getName(property: *Property) [*:0]const u8;
    extern "objc" fn property_getAttributes(property: *Property) ?[*:0]const u8;
    extern "objc" fn property_copyAttributeValue(property: *Property, attribute_name: [*:0]const u8) ?[*:0]u8;
    extern "objc" fn property_copyAttributeList(property: *Property, out_count: *c_uint) ?[*]Attribute;

    pub const getName = property_getName;
    pub const getAttributes = property_getAttributes;
    pub const copyAttributeValue = property_copyAttributeValue;
    pub fn copyAttributeList(property: *Property) []Attribute {
        var count: c_uint = 0;
        const list = property_copyAttributeList(property, &count) orelse return &.{};
        return list[0..count];
    }
};

pub const IVar = opaque {
    extern "objc" fn ivar_getName(ivar: *IVar) [*:0]const u8;
    extern "objc" fn ivar_getTypeEncoding(ivar: *IVar) [*:0]const u8;
    extern "objc" fn ivar_getOffset(ivar: *IVar) isize;

    pub fn name(ivar: *IVar) [*:0]const u8 {
        return ivar_getName(ivar);
    }

    pub fn typeEncoding(ivar: *IVar) [*:0]const u8 {
        return ivar_getTypeEncoding(ivar);
    }

    pub fn offset(ivar: *IVar) isize {
        return ivar_getOffset(ivar);
    }
};

pub const Method = extern struct {
    name: SEL,
    types: [*:0]const u8,
    imp: IMP,

    extern "objc" fn method_getName(method: *Method) *SEL;
    extern "objc" fn method_getImplementation(method: *Method) *anyopaque;
    extern "objc" fn method_getTypeEncoding(method: *Method) ?[*:0]const u8;
    extern "objc" fn method_copyReturnType(method: *Method) ?[*:0]u8;
    extern "objc" fn method_copyArgumentType(method: *Method, index: u32) ?[*:0]u8;
    extern "objc" fn method_getReturnType(method: *Method, dst: [*]u8, dst_len: usize) void;
    extern "objc" fn method_getNumberOfArguments(method: *Method) u32;
    extern "objc" fn method_getArgumentType(method: *Method, index: u32, dst: [*]u8, dst_len: usize) void;
    extern "objc" fn method_getDescription(method: *Method) ?*Description;
    extern "objc" fn method_setImplementation(method: *Method, implementation: *anyopaque) *anyopaque;
    extern "objc" fn method_exchangeImplementations(m1: *Method, m2: *Method) void;

    pub const Description = extern struct {
        name: ?*SEL,
        types: ?[*:0]u8,
    };

    pub fn getName(method: *Method) *SEL {
        return method_getName(method);
    }

    pub fn getImplementation(method: *Method) *anyopaque {
        return method_getImplementation(method);
    }

    pub fn getTypeEncoding(method: *Method) ?[:0]const u8 {
        const encoding = method_getTypeEncoding(method) orelse return null;
        return std.mem.span(encoding);
    }

    pub fn copyReturnType(method: *Method) ?[:0]u8 {
        const type_encoding = method_copyReturnType(method) orelse return null;
        return std.mem.span(type_encoding);
    }

    pub fn copyArgumentType(method: *Method, index: u32) ?[:0]u8 {
        const type_encoding = method_copyArgumentType(method, index) orelse return null;
        return std.mem.span(type_encoding);
    }

    pub fn getReturnType(method: *Method, dst: []u8) void {
        method_getReturnType(method, dst.ptr, dst.len);
    }

    pub fn getNumberOfArguments(method: *Method) u32 {
        return method_getNumberOfArguments(method);
    }

    pub fn getArgumentType(method: *Method, index: u32, dst: []u8) void {
        method_getArgumentType(method, index, dst.ptr, dst.len);
    }

    pub fn getDescription(method: *Method) ?*Description {
        return method_getDescription(method);
    }

    pub fn setImplementation(method: *Method, implementation: *anyopaque) *anyopaque {
        return method_setImplementation(method, implementation);
    }

    pub fn exchangeImplementations(m1: *Method, m2: *Method) void {
        method_exchangeImplementations(m1, m2);
    }
};

pub const IMP = *const fn () callconv(.c) void;

pub const Object = opaque {
    pub fn class(object: *Object) *Class {
        return @ptrCast(object);
    }

    extern "objc" fn object_copy(object: *Object, size: usize) ?*anyopaque;
    extern "objc" fn object_dispose(object: *Object) void;

    extern "objc" fn object_getClass(object: *Object) *Class;
    extern "objc" fn object_setClass(object: *Object, class: *Class) *Class;
    extern "objc" fn object_getIndexedIvars(object: *Object) ?*anyopaque;
    extern "objc" fn object_getIvar(object: *Object, ivar: *IVar) ?*anyopaque;
    extern "objc" fn object_setIvar(object: *Object, ivar: *IVar, value: ?*anyopaque) void;

    pub const copy = object_copy;
    pub const dispose = object_dispose;
    pub const getClass = object_getClass;
    pub const setClass = object_setClass;
    pub fn getIndexedIvars(object: *Object, comptime T: type) *T {
        return @ptrCast(object_getIndexedIvars(object));
    }
    pub const getIvar = object_getIvar;
    pub const setIvar = object_setIvar;

    pub fn getIvarPtr(self: *Object, ivar: *IVar) *anyopaque {
        const offset = ivar.offset();
        const address = @as([*]u8, @ptrCast(self)) + @as(usize, @intCast(offset));
        return @ptrCast(address);
    }
};

pub const ProtocolCreateError = (Class.GetClassError || Class.AllocatePairError || Class.AddProtocolError || Class.AddMethodError || Protocol.Error || error{CreateInstance});

pub fn ProtocolDecl(name: @EnumLiteral(), VTable: type) type {
    return struct {
        const Self = @This();

        class: *Class,
        instance: *Object,
        userdata: *anyopaque,

        pub fn create(comptime table: VTable, comptime Userdata: type, userdata_value: Userdata) ProtocolCreateError!Self {
            const protocol_name: [:0]const u8 = @tagName(name) ++ "_" ++ @typeName(Userdata);

            const class: *Class = try .allocatePair(try .get("NSObject"), protocol_name.ptr, 0);
            errdefer class.disposePair();

            const protocol: *Protocol = try .get(@tagName(name).ptr);
            try class.addProtocol(protocol);

            class.registerPair();

            const instance = class.createInstance(@sizeOf(Userdata)) orelse return error.CreateInstance;
            const userdata = instance.getIndexedIvars(Userdata);
            userdata.* = userdata_value;

            inline for (@typeInfo(VTable).@"struct".fields) |field| {
                const implementation = switch (@typeInfo(field.type)) {
                    .optional => if (@field(table, field.name)) |imp| imp else continue,
                    .@"fn" => |@"fn"| f: {
                        if (@"fn".calling_convention != std.builtin.CallingConvention.c)
                            @compileError(std.fmt.comptimePrint(
                                "excpected method '{s}' on protocol '{t}' to be calling convention '{s}', found '{s}'",
                                .{ field.name, name, std.builtin.CallingConvention.c, @"fn".calling_convention },
                            ));

                        break :f @field(table, field.name);
                    },
                    else => unreachable,
                };

                try class.addMethod(.registerName(field.name), implementation);
            }

            return .{
                .class = class,
                .instance = instance,
                .userdata = @ptrCast(userdata),
            };
        }

        pub fn setAsDelegate(self: Self, host: anytype) void {
            const Host = @typeInfo(@TypeOf(host)).pointer.child;
            if (!@hasDecl(Host, "Delegate")) @compileError("'" ++ @typeName(Host) ++ "' invalid host, does not contain delegate");
            msgSend(void, host, "setDelegate:", .{self.instance});
        }

        pub fn getUserdata(self: Self, comptime Userdata: type) *Userdata {
            return self.instance.getIndexedIvars(Userdata);
        }
    };
}

pub const helper = struct {
    pub fn typeEncoding(comptime T: type) u8 {
        if (T == SEL) return ':';

        return switch (@typeInfo(T)) {
            .void => 'v',
            .bool => 'B',
            .int => |info| switch (info.bits) {
                8 => if (info.signedness == .signed) 'c' else 'C',
                16 => if (info.signedness == .signed) 's' else 'S',
                32 => if (info.signedness == .signed) 'i' else 'I',
                64 => if (info.signedness == .signed) 'q' else 'Q',
                else => @compileError("unsupported integer size"),
            },
            .float => |info| switch (info.bits) {
                32 => 'f',
                64 => 'd',
                else => @compileError("unsupported floating-point size"),
            },
            .pointer, .@"opaque" => '@',
            .optional => |info| typeEncoding(info.child),
            .@"enum" => |info| typeEncoding(info.tag_type),
            else => @compileError("unsupported Objective-C type: " ++ @typeName(T)),
        };
    }

    pub fn methodTypeEncoding(info: std.builtin.Type.Fn) [:0]const u8 {
        comptime var types: []const u8 = "";

        types = types ++ .{typeEncoding(info.return_type orelse void)};
        types = types ++ "@:";

        for (info.params) |param| {
            const T = param.type orelse @compileError("generic parameters are not supported");
            types = types ++ .{typeEncoding(T)};
        }

        return @ptrCast(types ++ .{0});
    }
};
