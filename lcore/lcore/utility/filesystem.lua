--[[
#id utility.filesystem
#title Filesystem Wrapper
#version 1.0
#staus incomplete

#desc Wraps I/O procedures to bring APIs together

#note The vanilla/LFS implementation of 'list' is less efficient than the love one.
#note 'iterate' has more predictable performance.
]]

local L = (...)
local lfs_enabled, lfs = pcall(require, "lfs")
local fs = {}
local fs_interface = {}

local value_iterator = function(source)
	local key

	return function()
		key, value = next(source, key)
		return value
	end
end

--What is love?
if (love) then
	fs["love"] = {
		read = love.filesystem.read,
		write = love.filesystem.write,
		exists = love.filesystem.exists,
		list = love.filesystem.getDirectoryItems,
		iterate = function(path)
			return value_iterator(love.filesystem.getDirectoryItems(path))
		end
	}
end

fs["lua"] = {
	read = function(path)
		local handle, errorstring = io.open(path, "r")

		if (handle) then
			local body = handle:read()
			handle:close()

			return body
		else
			return nil, errorstring
		end
	end,

	write = function(path, body)
		local handle, errorstring = io.open(path, "w")

		if (handle) then
			handle:write(body)
			handle:close()

			return true
		else
			return nil, errorstring
		end
	end,

	exists = function(path)
		local handle, errorstring = io.open(path, "r")

		if (handle) then
			handle:close()
			return true
		else
			return nil, errorstring
		end
	end,

	list = function(path)
		if (lfs_enabled) then
			local paths = {}

			for path in lfs.dir(path) do
				table.insert(paths, path)
			end

			return paths
		else
			--well, oops
			return nil, "Unable to list without love or LFS available!"
		end
	end,

	iterate = function(path)
		return lfs.dir(path)
	end
}

setmetatable(fs_interface, {
	__index = function(self, key)
		if (fs[L.platform]) then
			return fs[L.platform][key]
		else
			return fs["lua"][key]
		end
	end
})

return fs_interface