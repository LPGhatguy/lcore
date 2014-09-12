local L, this = ...
this.title = "Lua Filesystem Interface"
this.version = "1.1"
this.status = "production"
this.desc = "Provides a filesystem interface for vanilla Lua."

local lfs_enabled, lfs = pcall(require, "lfs")

if (not lfs_enabled) then
	L:warn("LuaFileSystem not found; some filesystem calls may be affected.")
end

local lcore = L.lcore
local ref_fs = lcore.platform.reference.filesystem
local vanilla_fs

vanilla_fs = ref_fs:derive {
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

	list = function(path)
		if (lfs_enabled) then
			local paths = {}

			for path in lfs.dir(path) do
				table.insert(paths, path)
			end

			return paths
		else
			return nil, L:error("Unable to filesystem.list in platform 'vanilla' without LuaFileSystem!")
		end
	end,

	is_file = function(path)
		local handle, err = io.open(path, "r")

		if (handle) then
			handle:close()
			return true
		else
			return nil, err
		end
	end,

	is_directory = function(path)
		if (lfs_enabled) then
			local mode = lfs.attributes(path, "mode")

			return (not path:match("%.+$") and (mode == "directory"))
		else
			return nil, L:error("Cannot use is_directory without LFS enabled!")
		end
	end
}

return vanilla_fs