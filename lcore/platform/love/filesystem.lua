local L, this = ...
this.title = "LOVE Filesystem Interface"
this.version = "1.0"
this.status = "production"
this.desc = "Provies an interface to LOVE's filesystem API using lcore's API generics."

if (not love.filesystem) then
	L:error("LOVE filesystem API not found for using LOVE filesystem platform.")
end

local ref_fs = L:get("lcore.platform.reference.filesystem")
local love_fs

love_fs = ref_fs:derive {
	read = love.filesystem.read,
	write = love.filesystem.write,
	list = love.filesystem.getDirectoryItems,
	is_file = love.filesystem.isFile,
	is_directory = love.filesystem.isDirectory
}

return love_fs