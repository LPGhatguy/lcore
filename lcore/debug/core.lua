local L, this = ...
this.title = "Debug Core"
this.version = "0.1"
this.status = "incomplete"
this.desc = "Provides debug utility methods for debugging and profiling projects."
this.todo = {
	"Better emulate L:load in dir_success.",
	"Consider using the traditional module format instead of directories."
}

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
							local good, fail = pcall(chunk, L, {})
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