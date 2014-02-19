--[[
#id utility.functor
#title Functor (Function stand-in)
#status prototype
#version 0.1

#desc Provides customizable, but slow function stand-in objects.
]]

local L = (...)
local oop = L:get("utility.oop")
local functor

functor = oop:class()({
	_new = function(self, new)
		return new
	end,

	__call = function(self)
	end
})

setmetatable(functor, functor)

return functor