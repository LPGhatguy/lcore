--[[
#id graphics.ui.richtextlabel
#title Rich Text Label
#status incomplete
#version 0.1

#desc Creates a block of text with color formatting and such.
]]

local L = (...)
local oop = L:get("utility.oop")
local textlabel = L:get("graphics.ui.textlabel")
local rectangle = L:get("graphics.ui.rectangle")
local richtextlabel

richtextlabel = oop:class(textlabel)({
	canvas = nil,

	_new = function(self, new, ...)
	end,

	draw = function(self)
		rectangle.draw(self)
	end
})

return richtextlabel