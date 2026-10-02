const std = @import("std");

const c = @import("objc");

/// A value that can represent a C scalar, structure, pointer, or
/// Objective-C object.
/// https://developer.apple.com/documentation/foundation/nsvalue
pub const Value = opaque {
    pub fn objCType(self: *Value) [*:0]const u8 {
        return c.msgSend([*:0]const u8, self, "objCType", .{});
    }

    pub fn getValue(self: *Value, out: anytype) void {
        const T = @TypeOf(out);
        if (@typeInfo(T) != .pointer) @compileError("NS.Value.getValue() requires a pointer, got '" ++ @typeName(T) ++ "'");
        c.msgSend(void, self, "getValue:", .{out});
    }
};

/// An object that wraps a scalar numeric value.
/// https://developer.apple.com/documentation/foundation/nsnumber
pub const Number = opaque {
    pub fn value(self: *Number, comptime T: type) T {
        const selector_name: [*:0]const u8 = switch (T) {
            bool => "boolValue",

            i8 => "charValue",
            i16 => "shortValue",
            i32 => "intValue",
            i64 => "longLongValue",
            isize => "integerValue",

            u8 => "unsignedCharValue",
            u16 => "unsignedShortValue",
            u32 => "unsignedIntValue",
            u64 => "unsignedLongLongValue",
            usize => "unsignedIntegerValue",

            f32 => "floatValue",
            f64 => "doubleValue",

            else => @compileError("NS.Number.get() does not support type '" ++ @typeName(T) ++ "'"),
        };

        return c.msgSend(T, self, selector_name, .{});
    }

    // Description
    pub fn string(self: *Number) *String {
        return c.msgSend(*String, self, "stringValue", .{});
    }

    pub fn objCType(self: *Number) [*:0]const u8 {
        return c.msgSend([*:0]const u8, self, "objCType", .{});
    }

    // Comparison
    pub fn eql(self: *Number, other: *Number) bool {
        return c.msgSend(bool, self, "isEqualToNumber:", .{other});
    }

    pub fn compare(self: *Number, other: *Number) std.math.Order {
        const result = c.msgSend(isize, self, "compare:", .{other});

        return switch (result) {
            -1 => .lt,
            0 => .eq,
            1 => .gt,
            else => unreachable,
        };
    }
};

/// An immutable string of Unicode characters.
/// https://developer.apple.com/documentation/foundation/nsstring
pub const String = opaque {
    pub const Encoding = enum(usize) {
        ascii = 1,
        utf8 = 4,
        unicode = 10,
        utf16 = 4 << 20,
    };

    // Creation
    pub fn alloc() *String {
        return c.msgSend(*String, c.Class.get("NSString") catch unreachable, "alloc", .{});
    }

    pub fn initWithUtf8String(self: *String, value: [*:0]const u8) ?*String {
        return c.msgSend(?*String, self, "initWithUTF8String:", .{value});
    }

    pub fn release(self: *String) void {
        c.msgSend(void, self, "release", .{});
    }

    // Information
    pub fn length(self: *String) usize {
        return c.msgSend(usize, self, "length", .{});
    }

    pub fn utf8(self: *String) [*:0]const u8 {
        return c.msgSend([*:0]const u8, self, "UTF8String", .{});
    }

    pub fn data(self: *String, encoding: String.Encoding) ?*Data {
        return c.msgSend(?*Data, self, "dataUsingEncoding:", .{encoding});
    }

    // Comparison
    pub fn eql(self: *String, other: *String) bool {
        return c.msgSend(bool, self, "isEqualToString:", .{other});
    }

    pub fn compare(self: *String, other: *String) std.math.Order {
        const result = c.msgSend(isize, self, "compare:", .{other});

        return switch (result) {
            -1 => .lt,
            0 => .eq,
            1 => .gt,
            else => unreachable,
        };
    }
};

/// An immutable byte buffer.
/// https://developer.apple.com/documentation/foundation/nsdata
pub const Data = opaque {
    pub fn length(self: *Data) usize {
        return c.msgSend(usize, self, "length", .{});
    }

    pub fn bytes(self: *Data) *const anyopaque {
        return c.msgSend(*const anyopaque, self, "bytes", .{});
    }

    pub fn eql(self: *Data, other: *Data) bool {
        return c.msgSend(bool, self, "isEqualToData:", .{other});
    }
};

/// An object that enumerates the contents of an Objective-C collection.
/// https://developer.apple.com/documentation/foundation/nsenumerator
pub fn Enumerator(T: type) type {
    return opaque {
        const Self = @This();

        /// nextObject
        pub fn next(self: *Self) ?T {
            return c.msgSend(?T, self, "nextObject", .{});
        }
    };
}

/// An immutable ordered collection of Objective-C objects.
/// https://developer.apple.com/documentation/foundation/nsarray
pub fn Array(T: type) type {
    return opaque {
        const Self = @This();

        // Information
        pub fn count(self: *Self) usize {
            return c.msgSend(usize, self, "count", .{});
        }

        pub fn isEmpty(self: *Self) bool {
            return self.count() == 0;
        }

        // Access
        pub fn objectAt(self: *Self, index: usize) T {
            return c.msgSend(T, self, "objectAtIndex:", .{index});
        }

        pub fn firstObject(self: *Self) ?T {
            return c.msgSend(?T, self, "firstObject", .{});
        }

        pub fn lastObject(self: *Self) ?T {
            return c.msgSend(?T, self, "lastObject", .{});
        }

        // Search
        pub fn containsObject(self: *Self, object: T) bool {
            return c.msgSend(bool, self, "containsObject:", .{object});
        }

        pub fn indexOfObject(self: *Self, object: T) ?usize {
            const index = c.msgSend(usize, self, "indexOfObject:", .{object});

            // NSNotFound == NSUIntegerMax.
            return if (index == std.math.maxInt(usize))
                null
            else
                index;
        }

        // Conversion
        pub fn allocSlice(
            self: *Self,
            allocator: std.mem.Allocator,
            start: usize,
            end: usize,
        ) ![]T {
            std.debug.assert(start <= end);
            std.debug.assert(end <= self.count());

            const result = try allocator.alloc(T, end - start);
            errdefer allocator.free(result);

            for (result, start..) |*item, index| {
                item.* = self.objectAt(index);
            }

            return result;
        }

        // Enumeration
        pub fn objectEnumerator(self: *Self) *Enumerator(T) {
            return c.msgSend(*Enumerator(T), self, "objectEnumerator", .{});
        }
    };
}

/// An immutable collection of key-value pairs.
/// https://developer.apple.com/documentation/foundation/nsdictionary
pub fn Dictionary(Key: type, ValueType: type) type {
    return opaque {
        const Self = @This();

        // Information
        pub fn count(self: *Self) usize {
            return c.msgSend(usize, self, "count", .{});
        }

        pub fn isEmpty(self: *Self) bool {
            return self.count() == 0;
        }

        // Access
        pub fn objectForKey(self: *Self, key: Key) ?ValueType {
            return c.msgSend(?ValueType, self, "objectForKey:", .{key});
        }

        pub fn containsKey(self: *Self, key: Key) bool {
            return self.objectForKey(key) != null;
        }

        // Keys / values
        pub fn allKeys(self: *Self) *Array(Key) {
            return c.msgSend(*Array(Key), self, "allKeys", .{});
        }

        pub fn allValues(self: *Self) *Array(ValueType) {
            return c.msgSend(*Array(ValueType), self, "allValues", .{});
        }

        pub fn allKeysForObject(self: *Self, value: ValueType) *Array(Key) {
            return c.msgSend(*Array(Key), self, "allKeysForObject:", .{value});
        }

        // Enumeration
        pub fn keyEnumerator(self: *Self) *Enumerator(Key) {
            return c.msgSend(*Enumerator(Key), self, "keyEnumerator", .{});
        }

        pub fn objectEnumerator(self: *Self) *Enumerator(ValueType) {
            return c.msgSend(*Enumerator(ValueType), self, "objectEnumerator", .{});
        }
    };
}

/// An immutable unordered collection of Objective-C objects.
/// https://developer.apple.com/documentation/foundation/nsset
pub fn Set(T: type) type {
    return opaque {
        const Self = @This();

        // Information
        pub fn count(self: *Self) usize {
            return c.msgSend(usize, self, "count", .{});
        }

        pub fn isEmpty(self: *Self) bool {
            return self.count() == 0;
        }

        // Search
        pub fn containsObject(self: *Self, object: T) bool {
            return c.msgSend(bool, self, "containsObject:", .{object});
        }

        pub fn anyObject(self: *Self) ?T {
            return c.msgSend(?T, self, "anyObject", .{});
        }

        // Conversion
        pub fn allObjects(self: *Self) *Array(T) {
            return c.msgSend(*Array(T), self, "allObjects", .{});
        }

        // Enumeration
        pub fn objectEnumerator(self: *Self) *Enumerator(T) {
            return c.msgSend(*Enumerator(T), self, "objectEnumerator", .{});
        }
    };
}

/// A structure used to describe a portion of a series, such as characters in a string or objects in an array.
/// https://developer.apple.com/documentation/foundation/nsrange-c.struct
pub const Range = extern struct {
    location: usize,
    length: usize,
};

/// A point in time.
/// https://developer.apple.com/documentation/foundation/nsdate
pub const Date = opaque {
    pub const TimeInterval = f64;

    // Creation
    pub fn get() *Date {
        return c.msgSend(*Date, c.Class.get("NSDate") catch unreachable, "date", .{});
    }

    pub fn distantFuture() *Date {
        return c.msgSend(*Date, c.Class.get("NSDate") catch unreachable, "distantFuture", .{});
    }

    pub fn distantPast() *Date {
        return c.msgSend(*Date, c.Class.get("NSDate") catch unreachable, "distantPast", .{});
    }

    pub fn dateWithTimeIntervalSinceNow(seconds: TimeInterval) *Date {
        return c.msgSend(*Date, c.Class.get("NSDate") catch unreachable, "dateWithTimeIntervalSinceNow:", .{seconds});
    }

    pub fn dateWithTimeIntervalSinceReferenceDate(seconds: TimeInterval) *Date {
        return c.msgSend(*Date, c.Class.get("NSDate") catch unreachable, "dateWithTimeIntervalSinceReferenceDate:", .{seconds});
    }

    pub fn dateWithTimeIntervalSince1970(seconds: TimeInterval) *Date {
        return c.msgSend(*Date, c.Class.get("NSDate") catch unreachable, "dateWithTimeIntervalSince1970:", .{seconds});
    }

    // Time intervals
    pub fn timeIntervalSinceNow(self: *Date) TimeInterval {
        return c.msgSend(TimeInterval, self, "timeIntervalSinceNow", .{});
    }

    pub fn timeIntervalSinceReferenceDate(self: *Date) TimeInterval {
        return c.msgSend(TimeInterval, self, "timeIntervalSinceReferenceDate", .{});
    }

    pub fn timeIntervalSince1970(self: *Date) TimeInterval {
        return c.msgSend(TimeInterval, self, "timeIntervalSince1970", .{});
    }

    pub fn timeIntervalSince(self: *Date, other: *Date) TimeInterval {
        return c.msgSend(TimeInterval, self, "timeIntervalSinceDate:", .{other});
    }

    // Comparison
    pub fn eql(self: *Date, other: *Date) bool {
        return c.msgSend(bool, self, "isEqualToDate:", .{other});
    }

    pub fn compare(self: *Date, other: *Date) std.math.Order {
        const result = c.msgSend(isize, self, "compare:", .{other});

        return switch (result) {
            -1 => .lt,
            0 => .eq,
            1 => .gt,
            else => unreachable,
        };
    }

    pub fn earlierDate(self: *Date, other: *Date) *Date {
        return c.msgSend(*Date, self, "earlierDate:", .{other});
    }

    pub fn laterDate(self: *Date, other: *Date) *Date {
        return c.msgSend(*Date, self, "laterDate:", .{other});
    }

    // Arithmetic
    pub fn addingTimeInterval(self: *Date, seconds: TimeInterval) *Date {
        return c.msgSend(*Date, self, "dateByAddingTimeInterval:", .{seconds});
    }
};

/// A URL representing a resource or location.
/// https://developer.apple.com/documentation/foundation/nsurl
pub const URL = opaque {
    // Information

    pub fn absoluteString(self: *URL) ?*String {
        return c.msgSend(?*String, self, "absoluteString", .{});
    }

    pub fn path(self: *URL) ?*String {
        return c.msgSend(?*String, self, "path", .{});
    }

    pub fn lastPathComponent(self: *URL) ?*String {
        return c.msgSend(?*String, self, "lastPathComponent", .{});
    }

    pub fn pathExtension(self: *URL) ?*String {
        return c.msgSend(?*String, self, "pathExtension", .{});
    }

    pub fn isFileURL(self: *URL) bool {
        return c.msgSend(bool, self, "isFileURL", .{});
    }

    pub fn isDirectory(self: *URL) bool {
        return c.msgSend(bool, self, "hasDirectoryPath", .{});
    }

    // Comparison
    pub fn eql(self: *URL, other: *URL) bool {
        return c.msgSend(bool, self, "isEqual:", .{other});
    }
};

/// The application's resource bundle.
/// https://developer.apple.com/documentation/foundation/nsbundle
pub const Bundle = opaque {
    pub fn main() ?*Bundle {
        return c.msgSend(?*Bundle, c.Class.get("NSBundle") catch unreachable, "mainBundle", .{});
    }

    pub fn bundleURL(self: *Bundle) ?*URL {
        return c.msgSend(?*URL, self, "bundleURL", .{});
    }

    pub fn resourceURL(self: *Bundle) ?*URL {
        return c.msgSend(?*URL, self, "resourceURL", .{});
    }

    // Resources
    pub fn urlForResource(
        self: *Bundle,
        name: *String,
        extension: ?*String,
    ) ?*URL {
        return c.msgSend(?*URL, self, "URLForResource:withExtension:", .{ name, extension });
    }
};

/// Information about the current process.
/// https://developer.apple.com/documentation/foundation/nsprocessinfo
pub const ProcessInfo = opaque {
    pub fn processInfo() *ProcessInfo {
        return c.msgSend(*ProcessInfo, c.Class.get("NSProcessInfo") catch unreachable, "processInfo", .{});
    }

    pub fn processName(self: *ProcessInfo) *String {
        return c.msgSend(*String, self, "processName", .{});
    }

    pub fn processorCount(self: *ProcessInfo) usize {
        return c.msgSend(usize, self, "processorCount", .{});
    }

    pub fn activeProcessorCount(self: *ProcessInfo) usize {
        return c.msgSend(usize, self, "activeProcessorCount", .{});
    }
};

/// A container for information broadcast through a notification center to all registered observers.
/// https://developer.apple.com/documentation/foundation/nsnotification
pub const Notification = opaque {
    pub const Name = *String;

    pub fn object(self: *Notification, comptime T: type) ?T {
        if (@typeInfo(T) != .pointer) @compileError("Notification.object() requires an Objective-C object pointer, got '" ++ @typeName(T) ++ "'");
        return c.msgSend(?T, self, "object", .{});
    }

    pub fn name(self: *Notification) *String {
        return c.msgSend(*String, self, "name", .{});
    }

    pub fn userInfo(self: *Notification) ?*anyopaque {
        return c.msgSend(?*anyopaque, self, "userInfo", .{});
    }
};

/// The event loop for processing input sources and timers.
/// https://developer.apple.com/documentation/foundation/nsrunloop
pub const RunLoop = opaque {
    pub const default = @extern(**Mode, .{ .name = "NSDefaultRunLoopMode" });
    pub const common = @extern(**Mode, .{ .name = "NSRunLoopCommonModes" });
    pub const event_tracking = @extern(**Mode, .{ .name = "NSEventTrackingRunLoopMode" });
    pub const modal_panel = @extern(**Mode, .{ .name = "NSModalPanelRunLoopMode" });

    pub const Mode = *String;

    pub fn current() *RunLoop {
        return c.msgSend(*RunLoop, c.Class.get("NSRunLoop") catch unreachable, "currentRunLoop", .{});
    }

    pub fn main() *RunLoop {
        return c.msgSend(*RunLoop, c.Class.get("NSRunLoop") catch unreachable, "mainRunLoop", .{});
    }

    pub fn run(self: *RunLoop) void {
        c.msgSend(void, self, "run", .{});
    }

    pub fn runUntilDate(self: *RunLoop, date: *Date) void {
        c.msgSend(void, self, "runUntilDate:", .{date});
    }
};

/// An error object containing a domain, code, and additional information.
/// https://developer.apple.com/documentation/foundation/nserror
pub const Error = opaque {
    pub fn code(self: *Error) isize {
        return c.msgSend(isize, self, "code", .{});
    }

    pub fn domain(self: *Error) *String {
        return c.msgSend(*String, self, "domain", .{});
    }

    pub fn localizedDescription(
        self: *Error,
    ) *String {
        return c.msgSend(*String, self, "localizedDescription", .{});
    }

    pub fn userInfo(
        self: *Error,
    ) *Dictionary(*String, *anyopaque) {
        return c.msgSend(*Dictionary(*String, *anyopaque), self, "userInfo", .{});
    }
};

/// An exception raised by Foundation or other Objective-C APIs.
/// https://developer.apple.com/documentation/foundation/nsexception
pub const Exception = opaque {
    pub fn name(self: *Exception) *String {
        return c.msgSend(*String, self, "name", .{});
    }

    pub fn reason(self: *Exception) ?*String {
        return c.msgSend(?*String, self, "reason", .{});
    }

    pub fn userInfo(
        self: *Exception,
    ) ?*Dictionary(*String, *anyopaque) {
        return c.msgSend(?*Dictionary(*String, *anyopaque), self, "userInfo", .{});
    }
};

pub const Object = opaque {
    pub fn alloc() *Object {
        return c.msgSend(*Object, c.Class.get("NSObject") catch unreachable, "alloc", .{});
    }

    pub fn release(self: *Object) void {
        c.msgSend(void, self, "release", .{});
    }

    pub fn retain(self: *Object) *Object {
        return c.msgSend(*Object, self, "retain", .{});
    }
};

/// An abstract class that serves as the basis for objects that enable archiving and distribution of other objects.
/// https://developer.apple.com/documentation/foundation/nscoder
pub const Coder = opaque {};

/// A general-purpose recorder of operations that enables undo and redo.
/// https://developer.apple.com/documentation/foundation/undomanager
pub const UndoManager = opaque {};

/// A representation of the state of your app at a moment in time.
/// https://developer.apple.com/documentation/foundation/nsuseractivity
pub const UserActivity = opaque {};

pub const Point = extern struct {
    x: f64,
    y: f64,
};

pub const Size = extern struct {
    width: f64,
    height: f64,
};

pub const Rect = extern struct {
    origin: Point,
    size: Size,
};
