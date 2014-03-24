--[[
#id graphics.font
#title Font Core
#status needs-testing
#version 1.0

#desc Provides fonts and reduces memory footprint when using multiple fonts.
]]

local L = (...)
local font

font = {
	loaded = {},

	get = function(self, size, name)
		local rname = name or "default"
		local lfont

		if (self.loaded[rname]) then
			lfont = self.loaded[rname][size]
		else
			self.loaded[rname] = {}
		end

		if (not lfont) then
			if (name) then
				lfont = love.graphics.newFont(name, size)
			else
				lfont = love.graphics.newFont(size)
			end

			self.loaded[rname][size] = lfont
		end

		return lfont
	end
}

return font