local L, this = ...
this.title = "Debug Core"
this.version = "0.2"
this.status = "incomplete"
this.desc = "Provides debug utility methods for debugging and profiling projects."
this.todo = {
	"Better emulate L:load in test_directory.",
	"Consider using the traditional module format instead of directories."
}

local core

core = {
	verbose = true,

	report = function(self, ...)
		if (self.verbose) then
			L:notice(...)
		end
	end,

	test_directory = function(self, dir, compile_only)
		local lfs = love.filesystem
		local success = true

		for index, file in pairs(lfs.getDirectoryItems(dir)) do
			local path = dir .. "/" .. file

			if (lfs.isDirectory(path)) then
				if (not self:test_directory(path, compile_only, verbose)) then
					success = false
				end
			elseif (lfs.isFile(path)) then
				if (file:match("%.lua$")) then
					local chunk, fail = loadfile(path)

					if (chunk) then
						if (compile_only) then
							self:report("COMPILE SUCCESS: " .. path)
						else
							local good, fail = pcall(chunk, L, {})
							if (good) then
								self:report("RUNTIME SUCCESS: " .. path)
							else
								success = false
								self:report("RUNTIME ERROR: " .. path .. "\n" ..  fail)
							end
						end
					else
						success = false
						self:report("COMPILE" .. " ERROR: " .. fail)
					end
				end
			end
		end

		return success
	end
}

return core