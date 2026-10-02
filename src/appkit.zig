const c = @import("objc");
const NS = @import("foundation.zig");
const CA = @import("core_graphics.zig");

pub const ColorSpaceName = *NS.String;

pub const Application = opaque {
    pub const TerminateReply = enum(c_long) {
        now,
        cancel,
        later,
    };

    pub const PrintReply = enum(c_long) {
        cancelled,
        success,
        failure,
        reply_later,
    };

    pub const DelegateReply = enum(c_long) {
        success,
        cancel,
        failure,
    };

    pub const RequestUserAttentionType = enum(c_ulong) {
        critical_request,
        informational_request,
    };

    pub const ActivationPolicy = enum(c_long) {
        regular,
        accessory,
        prohibited,
    };

    pub const ActivationOptions = packed struct(c_ulong) {
        activate_all_windows: bool = false,
        activate_ignoring_other_apps: bool = false,
        activate_all_windows_and_all_spaces: bool = false,
        activate_ignoring_other_apps_and_all_spaces: bool = false,
        pad0: u60 = 0,
    };

    pub const PresentationOptions = packed struct(c_ulong) {
        auto_hide_dock: bool = false,
        hide_dock: bool = false,
        auto_hide_menu_bar: bool = false,
        hide_menu_bar: bool = false,
        disable_force_quit: bool = false,
        disable_session_termination: bool = false,
        disable_process_switching: bool = false,
        disable_system_ui: bool = false,
        disable_apple_menu: bool = false,
        disable_hide_application: bool = false,
        disable_window_switching: bool = false,
        disable_menubar_transparency: bool = false,
        full_screen: bool = false,
        pad0: u51 = 0,
    };

    pub const ModalResponse = enum(c_long) {
        stop = -1000,
        abort = -1001,
        @"continue" = -1002,
    };

    pub const ModalSession = opaque {};

    pub const Delegate = c.ProtocolDecl(.NSApplicationDelegate, struct {
        @"applicationWillFinishLaunching:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"applicationDidFinishLaunching:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"applicationShouldTerminate:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application) callconv(.c) TerminateReply = null,
        @"applicationShouldTerminateAfterLastWindowClosed:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application) callconv(.c) bool = null,
        @"applicationWillTerminate:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"application:shouldTerminateWithError:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, err: *NS.Error) callconv(.c) bool = null,
        @"application:openFiles:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, filenames: *NS.Array(*NS.String)) callconv(.c) void = null,
        @"application:openFile:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, filename: *NS.String) callconv(.c) bool = null,
        @"application:openURLs:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, urls: *NS.Array(*NS.URL)) callconv(.c) void = null,
        @"application:openURL:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, url: *NS.URL) callconv(.c) bool = null,
        @"application:openFileWithoutUI:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, filename: *NS.String) callconv(.c) bool = null,
        @"application:openTempFile:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, filename: *NS.String) callconv(.c) bool = null,
        @"application:printFiles:withSettings:showPrintPanels:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, filenames: *NS.Array(*NS.String), settings: *NS.Dictionary(*NS.String, *anyopaque), show_panels: bool) callconv(.c) PrintReply = null,
        @"application:printFiles:withSettings:showPrintPanels:delegate:didPrintSelector:contextInfo:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, filenames: *NS.Array(*NS.String), settings: *NS.Dictionary(*NS.String, *anyopaque), show_panels: bool, delegate: *c.Object, did_print_selector: c.SEL, context_info: ?*anyopaque) callconv(.c) void = null,
        @"application:willPresentError:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, err: *NS.Error) callconv(.c) *NS.Error = null,
        @"application:didRegisterForRemoteNotificationsWithDeviceToken:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, device_token: *NS.Data) callconv(.c) void = null,
        @"application:didFailToRegisterForRemoteNotificationsWithError:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, err: *NS.Error) callconv(.c) void = null,
        @"application:didReceiveRemoteNotification:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, user_info: *NS.Dictionary(*NS.String, *anyopaque)) callconv(.c) void = null,
        @"application:didReceiveLocalNotification:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, notification: *NS.Notification) callconv(.c) void = null,
        @"application:handleReopen:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, has_visible_windows: bool) callconv(.c) bool = null,
        @"applicationShouldHandleReopen:hasVisibleWindows:": ?fn (self: *c.Object, _cmd: c.SEL, sender: *Application, has_visible_windows: bool) callconv(.c) bool = null,
        @"applicationDidBecomeActive:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"applicationDidResignActive:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"applicationWillBecomeActive:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"applicationWillResignActive:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"applicationDidHide:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"applicationDidUnhide:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"applicationWillHide:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"applicationWillUnhide:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"application:continueUserActivity:restorationHandler:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, user_activity: *NS.UserActivity, restoration_handler: *anyopaque) callconv(.c) bool = null,
        @"application:willContinueUserActivityWithType:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, user_activity_type: *NS.String) callconv(.c) bool = null,
        @"application:didFailToContinueUserActivityWithType:error:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, user_activity_type: *NS.String, err: *NS.Error) callconv(.c) void = null,
        @"application:didUpdateUserActivity:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, user_activity: *NS.UserActivity) callconv(.c) void = null,
        @"application:restoreUserActivityState:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, user_activity: *NS.UserActivity) callconv(.c) void = null,
        @"application:shouldSaveState:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, coder: *NS.Coder) callconv(.c) bool = null,
        @"application:shouldRestoreState:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, coder: *NS.Coder) callconv(.c) bool = null,
        @"application:willEncodeRestorableState:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, coder: *NS.Coder) callconv(.c) void = null,
        @"application:didDecodeRestorableState:": ?fn (self: *c.Object, _cmd: c.SEL, application: *Application, coder: *NS.Coder) callconv(.c) void = null,
    });

    // Allocation / lifetime
    pub fn alloc() ?*Application {
        return c.msgSend(?*Application, c.Class.get("NSApplication") catch unreachable, "alloc", .{});
    }

    pub fn release(self: *Application) void {
        c.msgSend(void, self, "release", .{});
    }

    pub fn retain(self: *Application) *Application {
        return c.msgSend(*Application, self, "retain", .{});
    }

    pub fn shared() *Application {
        return c.msgSend(*Application, c.Class.get("NSApplication") catch unreachable, "sharedApplication", .{});
    }

    // Delegate
    pub fn delegate(app: *Application) ?*c.Object {
        return c.msgSend(?*c.Object, app, "delegate", .{});
    }

    // Lifecycle
    pub fn run(app: *Application) void {
        c.msgSend(void, app, "run", .{});
    }

    pub fn finishLaunching(app: *Application) void {
        c.msgSend(void, app, "finishLaunching", .{});
    }

    pub fn stop(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "stop:", .{sender});
    }

    pub fn terminate(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "terminate:", .{sender});
    }

    pub fn isRunning(app: *Application) bool {
        return c.msgSend(bool, app, "isRunning", .{});
    }

    // Events
    pub fn nextEventMatchingMask(
        app: *Application,
        mask: Event.Mask,
        until_date: ?*NS.Date,
        mode: *NS.RunLoop.Mode,
        dequeue: bool,
    ) ?*Event {
        return c.msgSend(
            ?*Event,
            app,
            "nextEventMatchingMask:untilDate:inMode:dequeue:",
            .{ mask, until_date, mode, dequeue },
        );
    }

    pub fn discardEvents(app: *Application, mask: Event.Mask, before: ?*Event) void {
        c.msgSend(void, app, "discardEvents:before:", .{ mask, before });
    }

    pub fn currentEvent(app: *Application) ?*Event {
        return c.msgSend(?*Event, app, "currentEvent", .{});
    }

    pub fn postEvent(app: *Application, event: *Event, at_start: bool) void {
        c.msgSend(void, app, "postEvent:atStart:", .{ event, at_start });
    }

    pub fn sendEvent(app: *Application, event: *Event) void {
        c.msgSend(void, app, "sendEvent:", .{event});
    }

    pub fn updateWindows(app: *Application) void {
        c.msgSend(void, app, "updateWindows", .{});
    }

    // Termination
    pub fn replyToApplicationShouldTerminate(app: *Application, should_terminate: bool) void {
        c.msgSend(void, app, "replyToApplicationShouldTerminate:", .{should_terminate});
    }

    // Activation
    pub fn activate(app: *Application) bool {
        return c.msgSend(bool, app, "activate", .{});
    }

    pub fn activateIgnoringOtherApps(app: *Application, flag: bool) void {
        c.msgSend(void, app, "activateIgnoringOtherApps:", .{flag});
    }

    pub fn deactivate(app: *Application) void {
        c.msgSend(void, app, "deactivate", .{});
    }

    pub fn isActive(app: *Application) bool {
        return c.msgSend(bool, app, "isActive", .{});
    }

    pub fn yieldActivationTo(app: *Application, application: *NS.RunningApplication) void {
        c.msgSend(void, app, "yieldActivationTo:", .{application});
    }

    pub fn yieldActivationToApplicationWithBundleIdentifier(app: *Application, identifier: *NS.String) void {
        c.msgSend(void, app, "yieldActivationToApplicationWithBundleIdentifier:", .{identifier});
    }

    pub fn activateWithOptions(app: *Application, options: ActivationOptions) bool {
        return c.msgSend(bool, app, "activateWithOptions:", .{options});
    }

    // Hiding
    pub fn hide(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "hide:", .{sender});
    }

    pub fn unhide(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "unhide:", .{sender});
    }

    pub fn hideOtherApplications(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "hideOtherApplications:", .{sender});
    }

    pub fn unhideAllApplications(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "unhideAllApplications:", .{sender});
    }

    // Appearance
    pub fn appearance(app: *Application) ?*NS.Appearance {
        return c.msgSend(?*NS.Appearance, app, "appearance", .{});
    }

    pub fn setAppearance(app: *Application, appearance_: ?*NS.Appearance) void {
        c.msgSend(void, app, "setAppearance:", appearance_);
    }

    pub fn effectiveAppearance(app: *Application) *NS.Appearance {
        return c.msgSend(*NS.Appearance, app, "effectiveAppearance", .{});
    }

    // Presentation
    pub fn currentSystemPresentationOptions(app: *Application) PresentationOptions {
        return c.msgSend(PresentationOptions, app, "currentSystemPresentationOptions");
    }

    pub fn presentationOptions(app: *Application) PresentationOptions {
        return c.msgSend(PresentationOptions, app, "presentationOptions", .{});
    }

    pub fn setPresentationOptions(app: *Application, options: PresentationOptions) void {
        c.msgSend(void, app, "setPresentationOptions:", options);
    }

    pub fn applicationShouldSuppressHighDynamicRangeContent(app: *Application) bool {
        return c.msgSend(bool, app, "applicationShouldSuppressHighDynamicRangeContent");
    }

    pub fn setApplicationShouldSuppressHighDynamicRangeContent(app: *Application, value: bool) void {
        c.msgSend(void, app, "setApplicationShouldSuppressHighDynamicRangeContent:", value);
    }

    // Windows

    pub fn keyWindow(app: *Application) ?*Window {
        return c.msgSend(?*Window, app, "keyWindow", .{});
    }

    pub fn mainWindow(app: *Application) ?*Window {
        return c.msgSend(?*Window, app, "mainWindow", .{});
    }

    pub fn orderedWindows(app: *Application) *NS.Array(*Window) {
        return c.msgSend(*NS.Array(*Window), app, "orderedWindows", .{});
    }

    pub fn orderedDocuments(app: *Application) *NS.Array(*NS.Document) {
        return c.msgSend(*NS.Array(*NS.Document), app, "orderedDocuments", .{});
    }

    pub fn arrangeInFront(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "arrangeInFront:", sender);
    }

    pub fn miniaturizeAll(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "miniaturizeAll:", sender);
    }

    // Modal windows

    pub fn modalWindow(app: *Application) ?*Window {
        return c.msgSend(?*Window, app, "modalWindow", .{});
    }

    pub fn runModal(app: *Application, window: *Window) ModalResponse {
        return c.msgSend(ModalResponse, app, "runModalForWindow:", .{window});
    }

    pub fn stopModal(app: *Application) void {
        c.msgSend(void, app, "stopModal", .{});
    }

    pub fn stopModalWithCode(app: *Application, response: ModalResponse) void {
        c.msgSend(void, app, "stopModalWithCode:", response);
    }

    pub fn abortModal(app: *Application) void {
        c.msgSend(void, app, "abortModal", .{});
    }

    pub fn beginModalSession(app: *Application, window: *Window) ?*ModalSession {
        return c.msgSend(?*ModalSession, app, "beginModalSessionForWindow:", window);
    }

    pub fn runModalSession(app: *Application, session: *ModalSession) ModalResponse {
        return c.msgSend(ModalResponse, app, "runModalSession:", session);
    }

    pub fn endModalSession(app: *Application, session: *ModalSession) void {
        c.msgSend(void, app, "endModalSession:", session);
    }

    // Panels
    pub fn orderFrontColorPanel(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "orderFrontColorPanel:", sender);
    }

    pub fn orderFrontStandardAboutPanel(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "orderFrontStandardAboutPanel:", sender);
    }

    pub fn orderFrontStandardAboutPanelWithOptions(app: *Application, options: *NS.Dictionary) void {
        c.msgSend(void, app, "orderFrontStandardAboutPanelWithOptions:", options);
    }

    pub fn orderFrontCharacterPalette(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "orderFrontCharacterPalette:", sender);
    }

    pub fn runPageLayout(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "runPageLayout:", sender);
    }

    // User attention
    pub fn requestUserAttention(app: *Application, request_type: RequestUserAttentionType) c_long {
        return c.msgSend(c_long, app, "requestUserAttention:", request_type);
    }

    pub fn cancelUserAttentionRequest(app: *Application, request: c_long) void {
        c.msgSend(void, app, "cancelUserAttentionRequest:", request);
    }

    pub fn replyToOpenOrPrint(app: *Application, reply: DelegateReply) void {
        c.msgSend(void, app, "replyToOpenOrPrint:", reply);
    }

    // Help
    pub fn showHelp(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "showHelp:", sender);
    }

    pub fn activateContextHelpMode(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "activateContextHelpMode:", sender);
    }

    pub fn helpMenu(app: *Application) ?*Menu {
        return c.msgSend(?*Menu, app, "helpMenu", .{});
    }

    pub fn setHelpMenu(app: *Application, menu: ?*Menu) void {
        c.msgSend(void, app, "setHelpMenu:", menu);
    }

    // Exceptions
    pub fn reportException(app: *Application, exception: *NS.Exception) void {
        c.msgSend(void, app, "reportException:", exception);
    }

    // Activation policy
    pub fn activationPolicy(app: *Application) ActivationPolicy {
        return c.msgSend(ActivationPolicy, app, "activationPolicy", .{});
    }

    pub fn setActivationPolicy(app: *Application, policy: ActivationPolicy) bool {
        return c.msgSend(bool, app, "setActivationPolicy:", .{policy});
    }

    // Dock
    pub fn dockTile(app: *Application) *NS.DockTile {
        return c.msgSend(*NS.DockTile, app, "dockTile", .{});
    }

    pub fn applicationIconImage(app: *Application) ?*NS.Image {
        return c.msgSend(?*NS.Image, app, "applicationIconImage", .{});
    }

    pub fn setApplicationIconImage(app: *Application, image: ?*NS.Image) void {
        c.msgSend(void, app, "setApplicationIconImage:", image);
    }

    // Keyboard access
    pub fn isFullKeyboardAccessEnabled(app: *Application) bool {
        return c.msgSend(bool, app, "isFullKeyboardAccessEnabled", .{});
    }

    // Services
    pub fn servicesProvider(app: *Application) ?*c.Object {
        return c.msgSend(?*c.Object, app, "servicesProvider", .{});
    }

    pub fn setServicesProvider(app: *Application, provider: ?*c.Object) void {
        c.msgSend(void, app, "setServicesProvider:", .{provider});
    }

    pub fn validRequestorForSendTypeReturnType(app: *Application, send_type: ?*NS.String, return_type: ?*NS.String) ?*c.Object {
        return c.msgSend(?*c.Object, app, "validRequestorForSendType:returnType:", .{ send_type, return_type });
    }

    // Menus
    pub fn mainMenu(app: *Application) ?*Menu {
        return c.msgSend(?*Menu, app, "mainMenu", .{});
    }

    pub fn setMainMenu(app: *Application, menu: ?*Menu) void {
        c.msgSend(void, app, "setMainMenu:", .{menu});
    }

    pub fn windowsMenu(app: *Application) ?*Menu {
        return c.msgSend(?*Menu, app, "windowsMenu", .{});
    }

    pub fn setWindowsMenu(app: *Application, menu: ?*Menu) void {
        c.msgSend(void, app, "setWindowsMenu:", .{menu});
    }

    pub fn servicesMenu(app: *Application) ?*Menu {
        return c.msgSend(?*Menu, app, "servicesMenu", .{});
    }

    pub fn setServicesMenu(app: *Application, menu: ?*Menu) void {
        c.msgSend(void, app, "setServicesMenu:", .{menu});
    }

    pub fn addWindowsItem(app: *Application, window: *Window, title: *NS.String, filename: bool) void {
        c.msgSend(void, app, "addWindowsItem:title:filename:", .{ window, title, filename });
    }

    pub fn changeWindowsItem(app: *Application, window: *Window, title: *NS.String, filename: bool) void {
        c.msgSend(void, app, "changeWindowsItem:title:filename:", .{ window, title, filename });
    }

    pub fn removeWindowsItem(app: *Application, window: *Window) void {
        c.msgSend(void, app, "removeWindowsItem:", .{window});
    }

    pub fn updateWindowsItem(app: *Application, window: *Window) void {
        c.msgSend(void, app, "updateWindowsItem:", .{window});
    }

    pub fn registerServicesMenuSendTypes(app: *Application, send_types: *NS.Array(*NS.String), return_types: *NS.Array(*NS.String)) void {
        c.msgSend(void, app, "registerServicesMenuSendTypes:returnTypes:", .{ send_types, return_types });
    }

    // Touch Bar
    pub fn isAutomaticCustomizeTouchBarMenuItemEnabled(app: *Application) bool {
        return c.msgSend(bool, app, "isAutomaticCustomizeTouchBarMenuItemEnabled", .{});
    }

    pub fn setAutomaticCustomizeTouchBarMenuItemEnabled(app: *Application, value: bool) void {
        c.msgSend(void, app, "setAutomaticCustomizeTouchBarMenuItemEnabled:", .{value});
    }

    pub fn toggleTouchBarCustomizationPalette(app: *Application, sender: ?*anyopaque) void {
        c.msgSend(void, app, "toggleTouchBarCustomizationPalette:", .{sender});
    }

    // User interface layout
    pub fn userInterfaceLayoutDirection(app: *Application) c_long {
        return c.msgSend(c_long, app, "userInterfaceLayoutDirection", .{});
    }

    // UI item searching
    pub fn registerUserInterfaceItemSearchHandler(app: *Application, handler: *c.Object) void {
        c.msgSend(void, app, "registerUserInterfaceItemSearchHandler:", .{handler});
    }

    pub fn unregisterUserInterfaceItemSearchHandler(app: *Application, handler: *c.Object) void {
        c.msgSend(void, app, "unregisterUserInterfaceItemSearchHandler:", .{handler});
    }

    pub fn searchStringInUserInterfaceItemStringRangeFound(app: *Application, search: *NS.String, item_string: *NS.String, range: NS.Range, found: ?*NS.Range) bool {
        return c.msgSend(bool, app, "searchString:inUserInterfaceItemString:range:found:", .{ search, item_string, range, found });
    }
};

pub const Event = opaque {
    pub const Type = enum(u64) {
        left_mouse_down = 1,
        left_mouse_up = 2,
        right_mouse_down = 3,
        right_mouse_up = 4,

        mouse_moved = 5,
        left_mouse_dragged = 6,
        right_mouse_dragged = 7,

        mouse_entered = 8,
        mouse_exited = 9,

        key_down = 10,
        key_up = 11,
        flags_changed = 12,

        app_defined = 13,
        system_defined = 14,
        application_defined = 15,

        periodic = 16,
        cursor_update = 17,

        rotate = 18,
        begin_gesture = 19,
        end_gesture = 20,

        scroll_wheel = 22,
        tablet_point = 23,
        tablet_proximity = 24,

        other_mouse_down = 25,
        other_mouse_up = 26,
        other_mouse_dragged = 27,

        gesture = 29,
        magnify = 30,
        swipe = 31,

        smart_magnify = 32,
        quick_look = 33,
        pressure = 34,
    };

    pub const Mask = packed struct(u64) {
        pad0: u1 = 0,

        left_mouse_down: bool = false,
        left_mouse_up: bool = false,
        right_mouse_down: bool = false,
        right_mouse_up: bool = false,

        mouse_moved: bool = false,
        left_mouse_dragged: bool = false,
        right_mouse_dragged: bool = false,

        mouse_entered: bool = false,
        mouse_exited: bool = false,

        key_down: bool = false,
        key_up: bool = false,
        flags_changed: bool = false,

        app_defined: bool = false,
        system_defined: bool = false,
        application_defined: bool = false,

        periodic: bool = false,
        cursor_update: bool = false,

        rotate: bool = false,
        begin_gesture: bool = false,
        end_gesture: bool = false,

        pad1: u1 = 0,

        scroll_wheel: bool = false,
        tablet_point: bool = false,
        tablet_proximity: bool = false,

        other_mouse_down: bool = false,
        other_mouse_up: bool = false,
        other_mouse_dragged: bool = false,

        pad2: u1 = 0,

        gesture: bool = false,
        magnify: bool = false,
        swipe: bool = false,

        smart_magnify: bool = false,
        quick_look: bool = false,
        pressure: bool = false,

        pad3: u29 = 0,

        pub const any: Mask = @bitCast(~@as(u64, 0));
    };

    pub const Phase = enum(c_ulong) {
        none,
        began,
        stationary,
        changed,
        ended,
        cancelled,
        may_begin,
    };

    pub const GestureAxis = enum(c_long) {
        none,
        horizontal,
        vertical,
    };

    // General information
    pub fn @"type"(self: *Event) Type {
        return c.msgSend(Type, self, "type", .{});
    }

    pub fn locationInWindow(self: *Event) NS.Point {
        return c.msgSend(NS.Point, self, "locationInWindow", .{});
    }

    pub fn timestamp(self: *Event) f64 {
        return c.msgSend(f64, self, "timestamp", .{});
    }

    pub fn window(self: *Event) ?*Window {
        return c.msgSend(?*Window, self, "window", .{});
    }

    pub fn windowNumber(self: *Event) isize {
        return c.msgSend(isize, self, "windowNumber", .{});
    }

    // Keyboard
    pub fn characters(self: *Event) ?*NS.String {
        return c.msgSend(?*NS.String, self, "characters", .{});
    }

    pub fn charactersIgnoringModifiers(self: *Event) ?*NS.String {
        return c.msgSend(?*NS.String, self, "charactersIgnoringModifiers", .{});
    }

    pub fn keyCode(self: *Event) u16 {
        return c.msgSend(u16, self, "keyCode", .{});
    }

    pub fn isARepeat(self: *Event) bool {
        return c.msgSend(bool, self, "isARepeat", .{});
    }

    // Mouse
    pub fn mouseLocation() NS.Point {
        return c.msgSend(NS.Point, c.Class.get("NSEvent", "mouseLocation", .{}));
    }

    pub fn pressedMouseButtons() usize {
        return c.msgSend(usize, c.Class.get("NSEvent", "pressedMouseButtons", .{}));
    }

    pub fn buttonNumber(self: *Event) isize {
        return c.msgSend(isize, self, "buttonNumber", .{});
    }

    pub fn clickCount(self: *Event) isize {
        return c.msgSend(isize, self, "clickCount", .{});
    }

    // Movement / scrolling
    pub fn deltaX(self: *Event) f64 {
        return c.msgSend(f64, self, "deltaX", .{});
    }

    pub fn deltaY(self: *Event) f64 {
        return c.msgSend(f64, self, "deltaY", .{});
    }

    pub fn deltaZ(self: *Event) f64 {
        return c.msgSend(f64, self, "deltaZ", .{});
    }

    pub fn hasPreciseScrollingDeltas(self: *Event) bool {
        return c.msgSend(bool, self, "hasPreciseScrollingDeltas", .{});
    }

    pub fn scrollingDeltaX(self: *Event) f64 {
        return c.msgSend(f64, self, "scrollingDeltaX", .{});
    }

    pub fn scrollingDeltaY(self: *Event) f64 {
        return c.msgSend(f64, self, "scrollingDeltaY", .{});
    }

    pub fn directionInvertedFromDevice(self: *Event) bool {
        return c.msgSend(bool, self, "isDirectionInvertedFromDevice", .{});
    }

    // Tracking
    pub fn eventNumber(self: *Event) isize {
        return c.msgSend(isize, self, "eventNumber", .{});
    }

    pub fn trackingNumber(self: *Event) isize {
        return c.msgSend(isize, self, "trackingNumber", .{});
    }

    // Tablet
    pub fn absoluteX(self: *Event) isize {
        return c.msgSend(isize, self, "absoluteX", .{});
    }

    pub fn absoluteY(self: *Event) isize {
        return c.msgSend(isize, self, "absoluteY", .{});
    }

    pub fn absoluteZ(self: *Event) isize {
        return c.msgSend(isize, self, "absoluteZ", .{});
    }

    pub fn buttonMask(self: *Event) u32 {
        return c.msgSend(u32, self, "buttonMask", .{});
    }

    pub fn rotation(self: *Event) f64 {
        return c.msgSend(f64, self, "rotation", .{});
    }

    pub fn tangentialPressure(self: *Event) f64 {
        return c.msgSend(f64, self, "tangentialPressure", .{});
    }

    // Custom events
    pub fn data1(self: *Event) isize {
        return c.msgSend(isize, self, "data1", .{});
    }

    pub fn data2(self: *Event) isize {
        return c.msgSend(isize, self, "data2", .{});
    }
};

pub const Responder = opaque {
    // Lifetime

    pub fn alloc() *Responder {
        return c.msgSend(*Responder, c.Class.get("NSResponder") catch unreachable, "alloc", .{});
    }

    pub fn init(self: *Responder) *Responder {
        return c.msgSend(*Responder, self, "init", .{});
    }

    pub fn release(self: *Responder) void {
        c.msgSend(void, self, "release", .{});
    }

    pub fn retain(self: *Responder) *Responder {
        return c.msgSend(*Responder, self, "retain", .{});
    }

    // Responder Chain
    pub fn nextResponder(self: *Responder) ?*Responder {
        return c.msgSend(?*Responder, self, "nextResponder", .{});
    }

    pub fn setNextResponder(self: *Responder, next: ?*Responder) void {
        c.msgSend(void, self, "setNextResponder:", .{next});
    }

    // First Responder
    pub fn acceptsFirstResponder(self: *Responder) bool {
        return c.msgSend(bool, self, "acceptsFirstResponder", .{});
    }

    pub fn becomeFirstResponder(self: *Responder) bool {
        return c.msgSend(bool, self, "becomeFirstResponder", .{});
    }

    pub fn resignFirstResponder(self: *Responder) bool {
        return c.msgSend(bool, self, "resignFirstResponder", .{});
    }

    pub fn validateProposedFirstResponder(self: *Responder, responder: *Responder, event: *Event) bool {
        return c.msgSend(bool, self, "validateProposedFirstResponder:forEvent:", .{ responder, event });
    }

    // Keyboard
    pub fn keyDown(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "keyDown:", .{event});
    }

    pub fn keyUp(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "keyUp:", .{event});
    }

    pub fn flagsChanged(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "flagsChanged:", .{event});
    }

    pub fn interpretKeyEvents(self: *Responder, events: *NS.Array(*Event)) void {
        c.msgSend(void, self, "interpretKeyEvents:", .{events});
    }

    pub fn performKeyEquivalent(self: *Responder, event: *Event) bool {
        return c.msgSend(bool, self, "performKeyEquivalent:", .{event});
    }

    // Mouse
    pub fn mouseDown(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "mouseDown:", .{event});
    }

    pub fn mouseDragged(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "mouseDragged:", .{event});
    }

    pub fn mouseUp(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "mouseUp:", .{event});
    }

    pub fn mouseMoved(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "mouseMoved:", .{event});
    }

    pub fn mouseEntered(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "mouseEntered:", .{event});
    }

    pub fn mouseExited(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "mouseExited:", .{event});
    }

    pub fn rightMouseDown(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "rightMouseDown:", .{event});
    }

    pub fn rightMouseDragged(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "rightMouseDragged:", .{event});
    }

    pub fn rightMouseUp(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "rightMouseUp:", .{event});
    }

    pub fn otherMouseDown(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "otherMouseDown:", .{event});
    }

    pub fn otherMouseDragged(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "otherMouseDragged:", .{event});
    }

    pub fn otherMouseUp(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "otherMouseUp:", .{event});
    }

    // Scrolling / Tablet / Pressure
    pub fn scrollWheel(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "scrollWheel:", .{event});
    }

    pub fn pressureChangeWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "pressureChangeWithEvent:", .{event});
    }

    pub fn tabletPoint(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "tabletPoint:", .{event});
    }

    pub fn tabletProximity(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "tabletProximity:", .{event});
    }

    pub fn cursorUpdate(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "cursorUpdate:", .{event});
    }

    // Gestures
    pub fn beginGestureWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "beginGestureWithEvent:", .{event});
    }

    pub fn endGestureWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "endGestureWithEvent:", .{event});
    }

    pub fn magnifyWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "magnifyWithEvent:", .{event});
    }

    pub fn rotateWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "rotateWithEvent:", .{event});
    }

    pub fn swipeWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "swipeWithEvent:", .{event});
    }

    pub fn smartMagnifyWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "smartMagnifyWithEvent:", .{event});
    }

    // Touch
    pub fn touchesBeganWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "touchesBeganWithEvent:", .{event});
    }

    pub fn touchesMovedWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "touchesMovedWithEvent:", .{event});
    }

    pub fn touchesEndedWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "touchesEndedWithEvent:", .{event});
    }

    pub fn touchesCancelledWithEvent(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "touchesCancelledWithEvent:", .{event});
    }

    // Actions
    pub fn tryToPerform(self: *Responder, action: c.SEL, object: ?*anyopaque) bool {
        return c.msgSend(bool, self, "tryToPerform:with:", .{ action, object });
    }

    pub fn supplementalTargetForAction(
        self: *Responder,
        action: c.SEL,
        sender: ?*anyopaque,
    ) ?*anyopaque {
        return c.msgSend(?*anyopaque, self, "supplementalTargetForAction:sender:", .{ action, sender });
    }

    // Menus / Services / Undo
    pub fn menu(self: *Responder) ?*Menu {
        return c.msgSend(?*Menu, self, "menu", .{});
    }

    pub fn validRequestorForSendType(self: *Responder, send_type: *NS.String, return_type: *NS.String) ?*anyopaque {
        return c.msgSend(?*anyopaque, self, "validRequestorForSendType:returnType:", .{ send_type, return_type });
    }

    pub fn undoManager(self: *Responder) ?*NS.UndoManager {
        return c.msgSend(?*NS.UndoManager, self, "undoManager", .{});
    }

    // Errors
    pub fn presentError(self: *Responder, err: *NS.Error) bool {
        return c.msgSend(bool, self, "presentError:", .{err});
    }

    pub fn willPresentError(self: *Responder, err: *NS.Error) *NS.Error {
        return c.msgSend(*NS.Error, self, "willPresentError:", .{err});
    }

    pub fn presentErrorModalForWindow(self: *Responder, err: *NS.Error, window: *Window, delegate: ?*anyopaque, did_present_selector: c.SEL, context_info: ?*anyopaque) void {
        c.msgSend(
            void,
            self,
            "presentError:modalForWindow:delegate:didPresentSelector:contextInfo:",
            .{ err, window, delegate, did_present_selector, context_info },
        );
    }

    // Miscellaneous

    pub fn helpRequested(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "helpRequested:", .{event});
    }

    pub fn noResponderFor(self: *Responder, event: c.SEL) void {
        c.msgSend(void, self, "noResponderFor:", .{event});
    }

    pub fn shouldBeTreatedAsInkEvent(
        self: *Responder,
        event: *Event,
    ) bool {
        return c.msgSend(bool, self, "shouldBeTreatedAsInkEvent:", .{event});
    }

    // Scroll Gesture Configuration
    pub fn wantsForwardedScrollEventsForAxis(self: *Responder, axis: Event.GestureAxis) bool {
        return c.msgSend(bool, self, "wantsForwardedScrollEventsForAxis:", .{axis});
    }

    pub fn wantsScrollEventsForSwipeTrackingOnAxis(self: *Responder, axis: Event.GestureAxis) bool {
        return c.msgSend(bool, self, "wantsScrollEventsForSwipeTrackingOnAxis:", .{axis});
    }

    // Touch Bar

    pub fn touchBar(self: *Responder) ?*TouchBar {
        return c.msgSend(?*TouchBar, self, "touchBar", .{});
    }

    pub fn makeTouchBar(self: *Responder) ?*TouchBar {
        return c.msgSend(?*TouchBar, self, "makeTouchBar", .{});
    }

    // Restorable State

    pub fn encodeRestorableStateWithCoder(self: *Responder, coder: *NS.Coder) void {
        c.msgSend(void, self, "encodeRestorableStateWithCoder:", .{coder});
    }

    pub fn restoreStateWithCoder(self: *Responder, coder: *NS.Coder) void {
        c.msgSend(void, self, "restoreStateWithCoder:", .{coder});
    }

    pub fn invalidateRestorableState(self: *Responder) void {
        c.msgSend(void, self, "invalidateRestorableState", .{});
    }

    // Text Finder
    pub fn performTextFinderAction(self: *Responder, action: c_long) void {
        c.msgSend(void, self, "performTextFinderAction:", .{action});
    }

    // Tabs
    pub fn newWindowForTab(self: *Responder, event: *Event) void {
        c.msgSend(void, self, "newWindowForTab:", .{event});
    }
};

pub const SelectionDirection = enum(c_ulong) {
    direct_selection,
    selecting_next,
    selecting_previous,
};

pub const Window = opaque {
    pub const did = struct {
        pub const become_key_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidBecomeKeyNotification" });
        pub const become_main_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidBecomeMainNotification" });
        pub const change_screen_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidChangeScreenNotification" });
        pub const change_screen_profile_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidChangeScreenProfileNotification" });
        pub const deminiaturize_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidDeminiaturizeNotification" });
        pub const end_sheet_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidEndSheetNotification" });
        pub const end_live_resize_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidEndLiveResizeNotification" });
        pub const expose_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidExposeNotification" });
        pub const miniaturize_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidMiniaturizeNotification" });
        pub const move_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidMoveNotification" });
        pub const resign_key_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidResignKeyNotification" });
        pub const resign_main_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidResignMainNotification" });
        pub const resize_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidResizeNotification" });
        pub const update_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidUpdateNotification" });
        pub const enter_full_screen_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidEnterFullScreenNotification" });
        pub const exit_full_screen_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidExitFullScreenNotification" });
        pub const enter_version_browser_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidEnterVersionBrowserNotification" });
        pub const exit_version_browser_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidExitVersionBrowserNotification" });
        pub const change_backing_properties_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidChangeBackingPropertiesNotification" });
        pub const change_occlusion_state_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowDidChangeOcclusionStateNotification" });
    };
    pub const will = struct {
        pub const begin_sheet_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowWillBeginSheetNotification" });
        pub const close_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowWillCloseNotification" });
        pub const miniaturize_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowWillMiniaturizeNotification" });
        pub const move_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowWillMoveNotification" });
        pub const start_live_resize_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowWillStartLiveResizeNotification" });
        pub const enter_full_screen_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowWillEnterFullScreenNotification" });
        pub const exit_full_screen_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowWillExitFullScreenNotification" });
        pub const enter_version_browser_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowWillEnterVersionBrowserNotification" });
        pub const exit_version_browser_notification = @extern(*const NS.Notification.Name, .{ .name = "NSWindowWillExitVersionBrowserNotification" });
    };

    pub const Button = enum(c_ulong) {
        close_button,
        miniaturize_button,
        zoom_button,
        toolbar_button,
        document_icon_button,
        document_versions_button,
        full_screen_button,
    };

    pub const Depth = enum(i32) {
        @"128_bit_rgb",
        @"64_bit_rgb",
        @"24_bit_rgb",
        _,

        extern fn NSBitsPerPixelFromDepth(depth: Depth) c_ulong;
        extern fn NSBitsPerSampleFromDepth(depth: Depth) c_ulong;
        extern fn NSColorSpaceNameNSColorSpaceFromDepth(depth: Depth) ColorSpaceName;
        extern fn NSPlanarFromDepth(depth: Depth) bool;

        pub const bitsPerPixel = NSBitsPerPixelFromDepth;
        pub const bitsPerSample = NSBitsPerSampleFromDepth;
        pub const colorSpaceName = NSColorSpaceNameNSColorSpaceFromDepth;
        // Returns true if the specified window depth is planar and false if it is not.
        pub const planar = NSPlanarFromDepth;
    };

    pub const BackingStoreType = enum(c_ulong) {
        /// Deprecated
        retained = 0,
        /// Deprecated
        nonretained = 1,
        buffered = 2,
        _,
    };

    pub const OrderingMode = enum(c_long) {
        /// Moves the window above the indicated window.
        above,
        /// Moves the window below the indicated window.
        below,
        /// Moves the window off the screen.
        out,
        _,
    };

    pub const SharingType = enum(c_ulong) {
        /// A legacy constant that macOS no longer uses.
        none,
        read_only,
        /// Deprecated
        read_write,
    };

    pub const NumberListOptions = enum(c_ulong) {
        applications,
        spaces,
    };

    pub const AnimationBehavior = enum(c_ulong) {
        default,
        none,
        document_window,
        utility_window,
        alert_panel,
    };

    pub const CollectionBehavior = enum(c_ulong) {

        // Stage Manager and full screen

        /// The behavior marking this window as primary for both Stage Manager and full screen.
        primary,
        /// The behavior marking this window as auxiliary for both Stage Manager and full screen.
        auxiliary,
        /// The behavior marking this window as one that can join all apps for both Stage Manager and full screen.
        can_join_all_applications,

        // Spaces

        /// The window appears in only one space at a time.
        default,
        /// The window can appear in all spaces.
        can_join_all_spaces,
        /// When the window becomes active, move it to the active space instead of switching spaces.
        move_to_active_space,

        // Mission Control

        /// Mission Control doesn't affect the window, so it stays visible and stationary, like the desktop window.
        stationary,

        // Spaces and Mission Control

        /// The window participates in Mission Control and Spaces.
        managed,
        /// The window floats in Spaces and hides in Mission Control.
        transient,

        // Full screen

        /// The window can enter full-screen mode.
        full_screen_primary,
        /// The window displays on the same space as the full screen window.
        full_screen_auxiliary,
        /// The window doesn't support full-screen mode.
        full_screen_none,
        /// The window can be a secondary full screen tile even if it can't be a full screen window itself.
        full_screen_allows_tiling,
        /// The window doesn't support being a full-screen tile window, but may support being a full-screen window.
        full_screen_disallows_tiling,

        // Window cycling

        /// The window participates in the window cycle for use with the Cycle Through Windows menu item.
        participates_in_cycle,
        /// The window isn't part of the window cycle for use with the Cycle Through Windows menu item.
        ignores_cycle,
    };

    pub const OcclusionState = enum(c_ulong) {
        visible,
    };

    pub const TitleVisible = enum(c_long) {
        /// The window has the regular window title and title bar buttons.
        visible,
        hidden,
    };

    pub const UserTabbingPreference = enum(c_long) {
        always,
        in_full_screen,
        manual,
    };

    pub const TabbingMode = enum(c_long) {
        automatic,
        disallowed,
        preferred,
    };

    pub const StyleMask = packed struct(u64) {
        titled: bool = true,
        closable: bool = true,
        miniaturizable: bool = true,
        resizable: bool = true,
        pad0: u4 = 0,
        textured: bool = false,
        pad1: u3 = 0,
        unified_title_and_toolbar: bool = false,
        pad2: u1 = 0,
        full_screen: bool = false,
        full_size_content_view: bool = false,
        pad3: u48 = 0,
    };

    pub const Delegate = c.ProtocolDecl(.NSWindowDelegate, struct {
        @"window:willPositionSheet:usingRect:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, sheet: *Window, rect: NS.Rect) callconv(.c) NS.Rect = null,
        @"windowWillBeginSheet:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidEndSheet:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"windowWillResize:toSize:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, size: NS.Size) callconv(.c) NS.Size = null,
        @"windowDidResize:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowWillStartLiveResize:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidEndLiveResize:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"windowWillMiniaturize:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidMiniaturize:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidDeminiaturize:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"windowWillUseStandardFrame:defaultFrame:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, default_frame: NS.Rect) callconv(.c) NS.Rect = null,
        @"windowShouldZoom:toFrame:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, frame: NS.Rect) callconv(.c) bool = null,

        @"window:willUseFullScreenContentSize:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, size: NS.Size) callconv(.c) NS.Size = null,
        @"window:willUseFullScreenPresentationOptions:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, options: Application.PresentationOptions) callconv(.c) Application.PresentationOptions = null,
        @"windowWillEnterFullScreen:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidEnterFullScreen:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowWillExitFullScreen:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidExitFullScreen:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"customWindowsToEnterFullScreenForWindow:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window) callconv(.c) ?*NS.Array(*Window) = null,
        @"customWindowsToEnterFullScreenForWindow:onScreen:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, screen: *Screen) callconv(.c) ?*NS.Array(*Window) = null,
        @"window:startCustomAnimationToEnterFullScreenWithDuration:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, duration: f64) callconv(.c) void = null,
        @"window:startCustomAnimationToEnterFullScreenOnScreen:withDuration:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, screen: *Screen, duration: f64) callconv(.c) void = null,
        @"windowDidFailToEnterFullScreen:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window) callconv(.c) void = null,
        @"customWindowsToExitFullScreenForWindow:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window) callconv(.c) ?*NS.Array(*Window) = null,
        @"window:startCustomAnimationToExitFullScreenWithDuration:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, duration: f64) callconv(.c) void = null,
        @"windowDidFailToExitFullScreen:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window) callconv(.c) void = null,

        @"windowWillMove:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidMove:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidChangeScreen:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidChangeScreenProfile:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidChangeBackingProperties:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"windowShouldClose:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window) callconv(.c) bool = null,
        @"windowWillClose:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"windowDidBecomeKey:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidResignKey:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"windowDidBecomeMain:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidResignMain:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"windowWillReturnFieldEditor:toObject:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, object: *anyopaque) callconv(.c) ?*anyopaque = null,

        @"windowDidUpdate:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidExpose:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidChangeOcclusionState:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"window:shouldDragDocumentWithEvent:from:withPasteboard:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, event: *Event, from: NS.Point, pasteboard: *Pasteboard) callconv(.c) bool = null,

        @"windowWillReturnUndoManager:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window) callconv(.c) ?*NS.UndoManager = null,
        @"window:shouldPopUpDocumentPathMenu:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, menu: *Menu) callconv(.c) bool = null,

        @"window:willEncodeRestorableState:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, coder: *NS.Coder) callconv(.c) void = null,
        @"window:didDecodeRestorableState:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, coder: *NS.Coder) callconv(.c) void = null,

        @"window:willResizeForVersionBrowserWithMaxPreferredSize:maxAllowedSize:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window, max_preferred_size: NS.Size, max_allowed_size: NS.Size) callconv(.c) NS.Size = null,
        @"windowWillEnterVersionBrowser:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidEnterVersionBrowser:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowWillExitVersionBrowser:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,
        @"windowDidExitVersionBrowser:": ?fn (self: *c.Object, _cmd: c.SEL, notification: *NS.Notification) callconv(.c) void = null,

        @"previewRepresentableActivityItemsForWindow:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window) callconv(.c) ?*NS.Array(*PreviewRepresentableActivityItem) = null,
        @"windowForSharingRequestFromWindow:": ?fn (self: *c.Object, _cmd: c.SEL, window: *Window) callconv(.c) ?*Window = null,
    });

    // Lifetime
    pub fn alloc() *Window {
        return c.msgSend(*Window, c.Class.get("NSWindow") catch unreachable, "alloc", .{});
    }

    pub fn release(self: *Window) void {
        c.msgSend(void, self, "release", .{});
    }

    pub fn retain(self: *Window) *Window {
        return c.msgSend(*Window, self, "retain", .{});
    }

    pub fn init(
        window: *Window,
        content_rect: NS.Rect,
        style_mask: StyleMask,
        backing: BackingStoreType,
        @"defer": bool,
    ) *Window {
        return c.msgSend(*Window, window, "initWithContentRect:styleMask:backing:defer:", .{ content_rect, style_mask, backing, @"defer" });
    }

    pub fn setTitleSlice(window: *Window, title: [*:0]const u8) void {
        const string = NS.String.alloc();
        defer string.release();

        const initialized = string.initWithUtf8String(title).?;

        window.setTitle(initialized);
    }

    pub fn setTitle(window: *Window, string: *NS.String) void {
        c.msgSend(void, window, "setTitle:", .{string});
    }

    // Visibility
    pub fn makeKeyAndOrderFront(window: *Window) void {
        c.msgSend(void, window, "makeKeyAndOrderFront:", .{@as(?*anyopaque, null)});
    }

    pub fn orderOut(window: *Window) void {
        c.msgSend(void, window, "orderOut:", .{@as(?*anyopaque, null)});
    }

    pub fn close(window: *Window) void {
        c.msgSend(void, window, "close", .{});
    }

    // Key / main window
    pub fn makeKey(window: *Window) void {
        c.msgSend(void, window, "makeKeyWindow", .{});
    }

    pub fn resignKey(window: *Window) void {
        c.msgSend(void, window, "resignKeyWindow", .{});
    }

    pub fn makeMain(window: *Window) void {
        c.msgSend(void, window, "makeMainWindow", .{});
    }

    pub fn resignMain(window: *Window) void {
        c.msgSend(void, window, "resignMainWindow", .{});
    }

    // Minimize / maximize
    pub fn miniaturize(window: *Window) void {
        c.msgSend(void, window, "miniaturize:", .{@as(?*anyopaque, null)});
    }

    pub fn deminiaturize(window: *Window) void {
        c.msgSend(void, window, "deminiaturize:", .{@as(?*anyopaque, null)});
    }

    pub fn zoom(window: *Window) void {
        c.msgSend(void, window, "zoom:", .{@as(?*anyopaque, null)});
    }

    // Frame
    pub fn frame(window: *Window) NS.Rect {
        return c.msgSend(NS.Rect, window, "frame", .{});
    }

    pub fn setFrame(window: *Window, frame_rect: NS.Rect, display: bool) void {
        c.msgSend(void, window, "setFrame:display:", .{ frame_rect, display });
    }

    pub fn setFrameOrigin(window: *Window, origin: NS.Point) void {
        c.msgSend(void, window, "setFrameOrigin:", .{origin});
    }

    pub fn setFrameTopLeftPoint(window: *Window, point: NS.Point) void {
        c.msgSend(void, window, "setFrameTopLeftPoint:", .{point});
    }

    pub fn toggleFullScreen(window: *Window) void {
        c.msgSend(void, window, "toggleFullScreen:", .{@as(?*anyopaque, null)});
    }

    // Style
    pub fn styleMask(window: *Window) StyleMask {
        return c.msgSend(StyleMask, window, "styleMask", .{});
    }

    pub fn setStyleMask(window: *Window, mask: StyleMask) void {
        c.msgSend(void, window, "setStyleMask:", .{mask});
    }

    // Size limits
    pub fn setMinSize(window: *Window, size: NS.Size) void {
        c.msgSend(void, window, "setMinSize:", .{size});
    }

    pub fn setMaxSize(window: *Window, size: NS.Size) void {
        c.msgSend(void, window, "setMaxSize:", .{size});
    }

    // State
    pub fn isVisible(window: *Window) bool {
        return c.msgSend(bool, window, "isVisible", .{});
    }

    pub fn isKeyWindow(window: *Window) bool {
        return c.msgSend(bool, window, "isKeyWindow", .{});
    }

    pub fn isMainWindow(window: *Window) bool {
        return c.msgSend(bool, window, "isMainWindow", .{});
    }

    pub fn isMiniaturized(window: *Window) bool {
        return c.msgSend(bool, window, "isMiniaturized", .{});
    }

    pub fn isZoomed(window: *Window) bool {
        return c.msgSend(bool, window, "isZoomed", .{});
    }

    // Other
    pub fn setContentView(self: *Window, view: *View) void {
        c.msgSend(void, self, "setContentView:", .{view});
    }

    pub fn makeFirstResponder(window: *Window, responder: ?*Responder) bool {
        return c.msgSend(bool, window, "makeFirstResponder:", .{responder});
    }

    pub fn setAcceptsMouseMovedEvents(self: *Window, value: bool) void {
        c.msgSend(void, self, "setAcceptsMouseMovedEvents:", .{value});
    }
};

pub const View = opaque {
    pub fn alloc() *View {
        return c.msgSend(*View, c.Class.get("NSView") catch unreachable, "alloc", .{});
    }

    pub fn initWithFrame(self: *View, frame: NS.Rect) *View {
        return c.msgSend(*View, self, "initWithFrame:", .{frame});
    }

    pub fn acceptsFirstResponder(self: *View) bool {
        return c.msgSend(bool, self, "acceptsFirstResponder", .{});
    }

    pub fn convertPointFromWindow(self: *View, point: NS.Point) NS.Point {
        return c.msgSend(NS.Point, self, "convertPoint:fromView:", .{ point, null });
    }

    pub fn setWantsLayer(self: *View, value: bool) void {
        c.msgSend(
            void,
            self,
            .registerName("setWantsLayer:"),
            .{value},
        );
    }

    pub fn layer(self: *View) ?*CA.Layer {
        return c.msgSend(?*CA.Layer, self, .registerName("layer"), .{});
    }

    pub fn setLayer(self: *View, layer_: *CA.Layer) void {
        c.msgSend(void, self, "setLayer:", .{layer_});
    }
};

pub const Menu = opaque {};

pub const Pasteboard = opaque {};

pub const TouchBar = opaque {};

pub const PreviewRepresentableActivityItem = opaque {};

pub const Appearance = opaque {};

pub const Screen = opaque {};
