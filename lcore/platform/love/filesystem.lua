local L, this = ...
this.title = "LOVE Filesystem Interface"
this.version = "1.0"
this.status = "production"
this.desc = "Provies an interface to LOVE's filesystem API using lcore's API generics."

if (not love.filesystem) then
	L:error("LOVE filesystem API not found for using LOVE filesystem platform.")
end

local love_filesystem

love_filesystem = {
	read = love.filesystem.read,
	write = love.filesystem.write,
	exists = love.filesystem.exists,
	list = love.filesystem.getDirectoryItems,
	is_file = love.filesystem.isFile,
	is_directory = love.filesystem.isDirectory
}

setmetatable(love_filesystem, {
	__index = function(self, key)
		L:warn("Falling back to love for filesystem entry '" .. tostring(key) .. "'")
		return love.filesystem[key]
	end
})

return love_filesystem