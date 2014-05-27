# LCORE Design Philosophy
LCORE is designed to be powerful and flexible, staying usable while still trying to keep high performance. This is all accomplished through various modules and a strict development mentality that's outlined in this document.

## Modules
If you haven't taken the time to glance at it yet, go ahead and check out the "Modules" subsection of the `conventions.md` document, as it defines a couple key things about modules.

An lcore module consists of one or more code files relating to the same general thing. That means that a module can be a folder of files, or just a file.

Modules aren't loaded unless they're specifically used by the engine, which opens the doors for potential optimizations of final game distribution. Modules can only be loaded once, and return persistent objects (usually a table or a Lua userdata, which are functionally the same.) This means that modifications made on a module from one code file will persist to the next. This has benefits and drawbacks.

