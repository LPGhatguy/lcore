# 0.8.0
- First changelog entry (huzzah!)

## core
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
