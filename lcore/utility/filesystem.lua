--[[
#id utility.filesystem
#title Filesystem Wrapper
#version 1.0
#staus incomplete

#desc Wraps I/O procedures to bring APIs together
]]

local L = (...)
local fs

if (L.platform == "love") then
	fs = {
		read = love.filesystem.read,
		write = love.filesystem.write
	}
else
	fs = {
		read = function(path)
			local handle = io.open(path, "r")

			if (handle) then
				local body = handle:read()
				handle:close()

				return body
			end
		end,

		write = function(path, body)
			local handle = io.open(path, "w")

			if (handle) then
				handle:write(body)
				handle:close()

				return true
			end
		end,

		exists = function(path)
			local handle = io.open(path, "r")

			if (handle) then
				handle:close()
				return true
			end
		end
	}
end

return fs