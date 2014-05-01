# lcore Framework
Howdy! This is lcore, a framework for Lua, presently also supporting LOVE 0.9.x and 0.8.0. lcore seeks to *extend* applications instead of take complete control of them. It contains facilities for OOP that are easy to interop with, static typing, basic debugging facilities, simple data structures, an event manager, and a large collection of extensible graphics and UI elements.

I (Lucien Greathouse) am the only one working on the project, and its execution is presently tested on the following systems:
- Ubuntu GNOME 14.04 (64-bit)
- Fedora 20 (64-bit)
- Windows 8.1 Pro (64-bit)
- Windows 7 Pro (64-bit)
- Android 4.1.1 (using LOVE for Android)

Additionally, lcore supports the following frameworks for providing API support:
- Vanilla Lua (LuaFileSystem optional)
- LOVE 0.9.x

If you can assist in testing, whether through writing tests or performing manual testing, email me@lpghatguy.com and we can get in touch. If you would like support for a particular framework, (I'm looking at you, Corona developers) also shoot me an email and we can talk about low-level implementation.

## Using lcore
Require `lcore.core` to get the engine itself. This is usually defined locally as `L` for standardization purposes.

To load and retrieve specific parts of the engine, instead of using `require(library)`, use `L:get(library)` as it passes a reference to the framework to the component, allowing simpler initialization logic.

## Adding Components
Put your components wherever you'd like, and optionally use `L:add_path(path)` to create a shorthand map to the folder. lcore's path mechanism works similar to the way the PATH variable works in many operating systems.

For example, if your extra code is in `lib/mine.lua`, you can either load it using `L:get("lib.mine")` or add it to the path using `L:add_path("lib")` and load it with just `L:get("mine")`.