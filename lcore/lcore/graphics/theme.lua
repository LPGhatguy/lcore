--[[
#id graphics.theme
#title Theme Engine
#status prototype
#version 0.1

#desc Provides engine theming.
]]

local L = (...)
local color = L:get("lcore.graphics.color")
local theme

theme = {
	current = nil, --defined as default in footer
	themes = {
		default = {
			["clear"] = color:get("black")
		}
	},

	get = function(self, name)
		if (self.themes[name]) then
			return self.themes[name], true
		else
			L:warn("Couldn't get theme '" .. (name or "nil") .. "'")
			return {}, false
		end
	end,

	set = function(self, name)
		if (self.themes[name]) then
			self.current = self.themes[name]
			return true
		else
			L:warn("Couldn't set theme '" .. (name or "nil") .. "'")
			return false
		end
	end,

	set_color = function(self, color_name)
		if (type(color_name) == "table") then
			love.graphics.setColor(color_name)
			return true
		elseif (self.current[color_name]) then
			love.graphics.setColor(self.current[color_name])
			return true
		else
			L:warn("Couldn't set color '" .. (color_name or "nil") .. "'")
			return false
		end
	end,

	add = function(self, name, object)
		self.themes[name] = object
	end
}

theme.current = theme.themes.default

return theme