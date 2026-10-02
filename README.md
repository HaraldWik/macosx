# ZigObjc

**Native** Zig bindings for Objc and some macOS system frameworks.

This project provides low-level Zig bindings for interacting directly with Apple's native MacOS APIs, including:

* [Foundation](https://developer.apple.com/documentation/foundation) — core types, collections, dates, data, URLs, run loops, and more.
* [AppKit](https://developer.apple.com/documentation/appkit) — windows, views, events, applications, menus, and other macOS UI functionality.
* [Core Graphics](https://developer.apple.com/documentation/coregraphics) — 2D graphics, images, colors, display services, and related APIs.

More frameworks are planned for the future, including QuartzCore and Metal (perhaps).

The bindings are implemented in Zig and are largely based on Apple's official API documentation and Objective-C runtime interfaces. The goal is to provide an idiomatic Zig layer over the native macOS APIs rather than introducing a separate abstraction on top of them.
