# LCORE Framework
Howdy! This is lcore (or LCORE), a framework for Lua that also supports LOVE 0.9.1. LCORE seeks to *extend* applications instead of take complete control of them. It contains facilities for OOP that are easy to interop with, static typing, basic debugging facilities, simple data structures, an event manager, and a large collection of extensible graphics and UI elements.

I (Lucien Greathouse) am the only one working on the project, and its execution is presently tested on the following systems:
- Windows 8.1 Pro (64-bit)
- Windows 7 Pro (64-bit)
- Android 4.1.1 (using LOVE for Android)

Additionally, lcore supports the following frameworks for providing API support:
- Vanilla Lua (LuaFileSystem optional)
- LOVE 0.9.1

If you can assist in testing, whether through writing tests or performing manual testing, email me@lpghatguy.com and we can get in touch. If you would like support for a particular framework, (I'm looking at you, Corona developers) also shoot me an email and we can talk about low-level implementation.

## Using lcore
Require `lcore` to get the engine itself. This is usually defined locally as `L` for standardization purposes.

To load and retrieve specific parts of the engine, instead of using `require(library)`, use `L:get(library)` as it passes a reference to the framework to the component, allowing simpler initialization logic.

Starting in core version 0.8.0, folders can be referenced using L.get, creating a more natural library indexing scheme.

## Adding Components
Put your components wherever you'd like, and optionally use `L:add_path(path)` to create a shorthand map to the folder. lcore's path mechanism works similar to the way the PATH variable works in many operating systems.

For example, if your extra code is in `lib/mine.lua`, you can either load it using `L:get("lib.mine")` or add it to the path using `L:add_path("lib")` and load it with just `L:get("mine")`. As of 0.8.0, you can use `local lib = L:get("lib")` to load the folder and then use `lib.mine`.

## Platform Agnosticism API
LCORE is not restricted to a single platform and the entire framework can be rebased to work with another framework or API by using the lcore Platform Agnosticism API (PAAPI). Presently, PAAPI bindings are available for vanilla Lua, and LOVE 0.9.x. A prototype binding is also in the works for TI-Nspire and other platforms such as Corona are being evaluated.