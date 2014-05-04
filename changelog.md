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