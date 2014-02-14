--~NODOC
--This uses a custom build system that will be eventually published. It is relatively unimportant.

local version = require("lcore.utility.version")
local current = version:get() or {0, 0, 0, 0}

current[4] = current[4] + 1

version:write(current)

return {
	outfile = "lcore-" .. version:tostring()
}