# 1.0.0 (in development)
- Updated PAAPI graphics, especially retained mode
- Renamed lcore/core.lua to lcore/init.lua
	- Use require("lcore") to load lcore now
- Minor UI module tweaks
- Added 'meta' module for engine/project metadata specification
- The 'headers' folder now contains metadata about the engine itself
	- This folder replicates the structure of the main lcore folder, just containing headers instead.
- Added utility.range object for specifying numeric ranges
- Added utility.compound_range for compounding numeric ranges
- Added utility.primitive_pointer for encasing primitive types in a userdata
- Added utility.weak_pointer for encasing items in a userdata without affecting their garbage collection
- Added utility.vector3 for 3D vector math
- Moved tests folder into lcore.tests for unification purposes

## core (1.0.0)
- Rename 'safe' parameter to flags (breaking change)
- Directories can now be fully loaded by passing {fully_load=true} into flags
- Safe calls have been moved into the 'safe' flag

## utility.table
- utility.table no longer handles copylock management
- Userdata objects are now copied if they have a method called 'copy'

## utility.oop (2.0)
- Restructure OOP along the lines of the in-development Coeus engine
- _new no longer needs to return self
- Constructors are now of the form (self, ...) instead of (base, self, ...)
- Object instances are now userdata objects that act like pointers
- Removed utility.table.copylock
- Added table.wrap
- Added oop.wrap, oop.static
- Added object.add_metamethods, object.get_internal, object.point
- Added static_object class for services that just require inheritance.

## graphics platform (0.2)
- Added scissor and get_scissor
- Added set_line_width and get_line_width
- Added set_point_size and get_point_size
- Added set_color_c4 and get_color_c4, using color objects
- Removed set_color and get_color, use set_color_rgba and get_color_rgba instead

# 0.9.0 (unreleased)
- Removed platform.nspire, it was a stub
- Removed graphics.theme, this will be replaced but was not useful.
- Removed utility.math, it only had a non-functional expmod method.
- Usages of utility.oop.class now omit parentheses
- Removed more straggling documentation from the old documentation engine
- Cleaned up a couple typos in a few modules

## lcore.platform (PAAPI)
- Created platform.reference as a reference, no-op implementation of methods and features.
- platform.love and platform.vanilla now properly conform to this prototype PAAPI standard.

## lcore.graphics
- Reworked internal code of `graphics.ui.complex.color_picker`
- Added hsv_to_rgb and hsl_to_rgb to `graphics.color` in preparation for their inverse counterparts
- Internal changes for `graphics.ui.image`
- Fixed default sizing bug in `graphics.ui.rectangle`


# 0.8.1
- Improved PAAPI compliance on several modules

### core (0.8.1)
- Added warning and error levels

### platform.interface (1.1)
- Removed `get`, no longer needed
- Added `load_platform`
- Restructured module loading
- Interface methods moved to `__interface` member

### platform.vanilla.filesystem (1.1)
- Removed `exists`
- Made `is_file` and `is_directory` work given LuaFileSystem

### platform.love.graphics (1.1)
- Added new entries to conform to new standard

### platform.love.core (1.1)
- Now provides `hooks` field
- Uses lcore 0.8.x method of loading directories now

# 0.8.0
- First changelog entry (huzzah!)

### core (0.8.0)
- Removed reliance on love.filesystem.exists
- LCORE now loads folders, letting users do operations such as:

	```lua
	local L = require("lcore.core")
	local lcore = L:get("lcore")
	print(lcore.graphics.ui.complex.color_picker)
	```
- LCORE will error if loaded as an lcore module
- Renamed L.module_to_path to L.module_to_file_path
- Added L.module_to_dir_path
- Removed L.base_path
- Added L.load_file and L.load_directory

### platform.love.core (1.1)
- Updated to use core 0.8.0 semantics
- Renamed 'love_hooks' to 'hooks'