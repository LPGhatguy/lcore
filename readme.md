# LCORE Framework
Howdy! This is LCORE, a framework designed for LOVE, presently supporting the latest release, 0.9.0. LCORE seeks to *extend* applications instead of take complete control of them. It contains facilities for OOP that are easy to interop with, the beginning of static typing, basic debugging facilities, simple data structures, an event manager, and a large collection of extensible graphics and UI elements.

I (Lucien Greathouse) am the only one working on the project, and its execution is presently tested on the following platforms:
- Windows 8.1 Pro (64-bit)
- Windows 7 Pro (64-bit)
- Android 4.1.1 (using LOVE for Android)

If you can assist in testing, whether through writing tests or performing manual testing, email me@lpghatguy.com and we can get in touch.

## Using LCORE
Require `lcore.core` to get the engine itself. This is usually defined locally as `L` for standardization purposes.

To load and retrieve specific parts of the engine, instead of using `require(library)`, use `L:get(library)` as it passes a reference to the framework to the component, allowing simpler initialization logic.

## Adding Components
Put your components wherever you'd like, and optionally use `L:add_path(path)` to create a shorthand map to the folder. LCORE's path mechanism works similar to the way the PATH variable works in many operating systems.

For example, if your extra code is in `lib/mine.lua`, you can either load it using `L:get("lib.mine")` or add it to the path using `L:add_path("lib")` and load it with just `L:get("mine")`.