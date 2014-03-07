--[[
#id utility.version
#title Application Version Library

#version 1.0
#status incomplete

##todo Make version comparison better

#desc Handles application versions including reading and writing them to files
]]

local L = (...)
local fs = L:get("utility.filesystem")
local version

version = {
	filename = "version",
	current = nil,

	tostring = function(self, version)
		version = version or self:get()

		if (version) then
			return table.concat(version, ".")
		end
	end,

	parse = function(self, source)
		local version = {}

		for piece in source:gmatch("(%d+)") do
			table.insert(version, tonumber(piece))
		end

		return version
	end,

	get = function(self, refresh)
		if (self.current and not refresh) then
			return self.current
		else
			if (not love or love.filesystem.exists(self.filename)) then
				local source = fs.read(self.filename)
				local version = {}

				if (source) then
					version = self:parse(source)
				else
					return false, L:warn("Could not read version - read error!")
				end

				return version
			else
				return false, L:warn("Could not read version - no version file to read!")
			end
		end
	end,

	write = function(self, version)
		version = version or self:get()

		if (version) then
			self.current = version
			
			if (fs.write(self.filename, self:tostring())) then
				return true
			else
				return false, L:warn("Could not write version file - unable to open file!")
			end
		else
			return false, L:warn("Could not write version file - no version to write!")
		end
	end,

	is_less_than = function(self, version)
		return self:less_than(self:get(), version)
	end,

	is_greater_than = function(self, version)
		return self:less_than(version, self:get())
	end,

	less_than = function(self, version1, version2)
		for index = 1, #version1 - 1 do
			if (version2[index]) then
				if (version1[index] > version2[index]) then
					return false, index
				end
			end
		end

		if (version2[#version1]) then
			if (version1[#version1] >= version2[#version1]) then
				return false, index
			end
		end

		return true
	end,

	greater_than = function(self, version1, version2)
		return self:less_than(version2, version1)
	end
}

return version