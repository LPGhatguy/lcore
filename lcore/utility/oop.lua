--[[
#id utility.oop
#title OOP Interface
#version 1.2
#status production

#desc Provides object orientation to the framework.
]]

local L = (...)

local oop
local etable = L:get("utility.table")

oop = {
	--@method objectify
	objectify = function(self, target)
		etable:merge(self.object, target)

		return target
	end,

	--@method class
	class = function(self, ...)
		local new = etable:merge(self.object, {})
		new:inherit(...)

		return function(target)
			target = target or {}
			
			etable:merge(new, target)
			return target
		end
	end,

	--@method static
	static = function(self, ...)
		local new = etable.merge(self.static_object, {})
		new:inherit(...)

		return function(target)
			etable:merge(new, target)
			return target
		end
	end,

	--@class object
	object = {
		inherit = function(self, ...)
			local args = {...}
			for key = 1, #args do
				etable:merge(args[key], self)
			end

			return self
		end,

		new = function(self, ...)
			if (self._new) then
				return self:_new(self:copy(), ...)
			else
				return self:copy()
			end
		end,

		copy = function(self)
			return etable:deepcopy(self)
		end,

		destroy = function(self, ...)
			if (self._destroy) then
				return self:_destroy(...)
			else
				return true
			end
		end
	},

	--@class static_object
	static_object = {
		inherit = function(self, ...)
			local args = {...}
			for key = 1, #args do
				etable:merge(args[key], self)
			end

			return self
		end
	}
}

return oop