pub const foundation = @import("foundation.zig");
pub const appkit = @import("appkit.zig");
pub const core_graphic = @import("core_graphics.zig");

pub const NS = struct {
    pub const Array = foundation.Array;
    pub const Bundle = foundation.Bundle;
    pub const Coder = foundation.Coder;
    pub const Data = foundation.Data;
    pub const Date = foundation.Date;
    pub const Dictionary = foundation.Dictionary;
    pub const Enumerator = foundation.Enumerator;
    pub const Error = foundation.Error;
    pub const Exception = foundation.Exception;
    pub const Notification = foundation.Notification;
    pub const Number = foundation.Number;
    pub const Object = foundation.Object;
    pub const Point = foundation.Point;
    pub const ProcessInfo = foundation.ProcessInfo;
    pub const Range = foundation.Range;
    pub const Rect = foundation.Rect;
    pub const RunLoop = foundation.RunLoop;
    pub const Set = foundation.Set;
    pub const Size = foundation.Size;
    pub const String = foundation.String;
    pub const UndoManager = foundation.UndoManager;
    pub const URL = foundation.URL;
    pub const UserActivity = foundation.UserActivity;
    pub const Value = foundation.Value;

    pub const Appearance = appkit.Appearance;
    pub const Application = appkit.Application;
    pub const ColorSpaceName = appkit.ColorSpaceName;
    pub const Event = appkit.Event;
    pub const Menu = appkit.Menu;
    pub const Pasteboard = appkit.Pasteboard;
    pub const PreviewRepresentableActivityItem = appkit.PreviewRepresentableActivityItem;
    pub const Responder = appkit.Responder;
    pub const Screen = appkit.Screen;
    pub const SelectionDirection = appkit.SelectionDirection;
    pub const TouchBar = appkit.TouchBar;
    pub const View = appkit.View;
    pub const Window = appkit.Window;
};

pub const CA = core_graphic;
