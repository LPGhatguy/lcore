# LCORE Development Conventions

## LCORE's Name
LCORE is seen sometimes in full uppercase and other times completely lowercase. This is similar to that of xkcd; if lcore appears in a place where a word is normally capitalized, such as at the beginning of a sentence or in a title, it should be in all uppercase, such as 'LCORE,' though it should otherwise (especially in code) be referred to as 'lcore.'

## Modules

### Module locations
Modules in lcore are referred to using their 'module name,' which is not unlike Lua's path format when using `require`. Folders are separated by a period, and folder names should generally be lowercase. Keeping everything lowercase solves problems between case sensitive operating systems like *nix and operating systems like Windows that are more lax.

### Versions
Versions should have two to three numbers depending on granularity of updates. These should be separated by periods and kept in a version string that is discussed in the `General Form` section. These numbers may be of any number of digits but should not have leading zeros. The first number should denote major paradigm changes in the module, and is indeed the 'major version.' The second number should be incremented with code-breaking API changes. Additions are not necessarily breaking changes in this case. This is the 'minor version' number. The third number should be incremented only when the designated change will not break existing code and should only fix bugs and adjust to intended behavior. This field is the 'revision' number.

Alongside the version field is usually an associated `status` field. This status can be `experimental`, `prototype`, `development`, or `production`. The `experimental` flag is used when a concept is being evaluated for potential full implementation in the future. `prototype` declares that the concept is planned and implemented, but consistency is not guaranteed. The `development` status indicates relative instability in the module, whether due to pre-production or post-production work. This status is widespread in the `dev` branch of lcore. `production` should be used when the intended API is in place and the module is fully (or very nearly) functional for its purpose.

Version numbers with the `experimental` and `prototype` flags should tend to be less than '1.0' if appropriate.

## Code Conventions

### General Form
Usually a module designed for lcore will begin with a block of code resembling the following:

```lua
local L, this = ...
this.title = "Example Module"
this.author = "A. Dev"
this.status = "development"
this.version = "0.1.7"
this.desc = "An example module for conventions.md"
this.notes = {
	"The 'notes' field is not required, but can be useful!",
	"This module is completely useless!"
}
this.todo = {
	"Give a non-contrived example of a module header"
}
```

The first line of the example creates local variables referencing two important things for a module. The first is a reference to `lcore.core`, where most of the interaction with lcore will be piped through. The second field, `this` is a reference to a metadata table about the module. This is the field where information about the module should be put in place, such as its name and version. All fields are _optional_.

The list of currently accepted fields are as follows:
- `title` - The name of the module
- `author` - Whoever wrote the module
- `status` - The current development status (see 'Modules - Versions')
- `version` - The version of the module in the format MAJOR.MINOR.REVISION, where REVISION is optional
- `desc` - A short description of the module's purpose
- `notes` - A list of things to keep in mind when using the module
- `todo` - Future changes that may occur to the module

After giving this information about the module, references to other modules are usually declared in a format like so:

```lua
local http = require("socket.http")

local oop = L:get("lcore.utility.oop")
local event = L:get("lcore.service.event")
local my_other_lib = L:get("adev.my_other_lib")
local example_module
```

These blocks should begin with references to non-lcore modules. In the example, we create a reference to LuaSocket's HTTP module, which is useful for handling HTTP requests. Then, we declare references to modules within lcore followed by references to custom modules. In our case, we reference lcore's OOP and event libraries followed by our own 'my_other_lib' library that performs whatever action. We then create an undefined local variable with our module's recommended reference name, which should be the same as its filename, or more specific if necessary. We create this reference both for people reading the code and for the code itself. Lua functions defined inside a table usually cannot reference the table by its explicit name unless the table is declared before it is defined. This isn't necessarily important to know as long as this convention is kept.

Some modules will opt to declare certain private utility functions and variables here:

```lua
local dev_verbose = false

local function pretty_print(...)
	print("Pretty!", ...)
end
```

It is important to remember that any code using this module will not have access to these fields. If we want fields that code *can* access but probably shouldn't, we can put it in the primary module table with a prefix of two underscores ('__'). This is later discussed in the `Lua Conventions` section.

After this, we'll declare the star of the show: our actual module:

```lua
example_module = oop:class(event) {
	__almost_private_field = 6,

	public_field = "Hello, world!",

	cool_method = function(self, ...)
		pretty_print(...)
		pretty_print("Huzzah!", ...)
	end
}

--If the modules has anything tricky to do, 
--like metatables on the module object,
--it can do that here.

return example_module
```

Note that we exclude the parentheses around our curly braces even though we are calling a method returned from oop.class. This is purely for ease of modification, as turning a regular table into a class becomes much simpler.

The last line is the most important, as it returns the module itself and ensures it can be registered by lcore and properly retrieved by the framework. It is _not_ necessary to return the `this` field for the module.

## Lua Conventions
*todo*