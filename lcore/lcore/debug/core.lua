--[[
#id debug.core
#title Debug Core
#status incomplete
#version 0.1

#desc Provides utility and plugin methods for debugging projects
]]

local L = (...)
local core

local function report(verbose, ...)
	L:notice(...)
end

core = {
	dir_success = function(self, dir, compile_only, verbose)
		local lfs = love.filesystem
		local success = true

		for index, file in pairs(lfs.getDirectoryItems(dir)) do
			local path = dir .. "/" .. file

			if (lfs.isDirectory(path)) then
				if (not self:dir_success(path, compile_only, verbose)) then
					success = false
				end
			elseif (lfs.isFile(path)) then
				if (file:match("%.lua$")) then
					local chunk, fail = loadfile(path)

					if (chunk) then
						if (compile_only) then
							print("COMPILE", "SUCCESS", path)
						else
							local good, fail = pcall(chunk, L)
							if (good) then
								report(verbose, "RUNTIME" .. " SUCCESS: " .. path)
							else
								success = false
								print("RUNTIME", "ERROR", fail)
							end
						end
					else
						success = false
						report(verbose, "COMPILE" .. " ERROR: " .. fail)
					end
				end
			end
		end

		return success
	end
}

return core