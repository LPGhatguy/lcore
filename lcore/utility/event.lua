--[[
#id utility.event
#title Extended Event Core
#status production
#version 1.0

#desc Allows event hooks on a higher level
]]

local L = (...)
local event

event = {
	hooks = {},

	hook = function(self, name, object, key)
		key = key or name

		local target = self.hooks[name]

		if (not target) then
			target = {}
			self.hooks[name] = target
			L:notice("Created event hook '" .. (name or "nil") .. "'")
		end

		table.insert(target, {object, key})
	end,

	unhook = function(self, object)
		local count = 0

		for key, value in pairs(self.hooks) do
			for name, container in pairs(value) do
				if (container[1] == object) then
					value[name] = nil
					count = count + 1
				end
			end
		end

		return count
	end,

	fire = function(self, name, ...)
		local methods = self.hooks[name]

		if (methods) then
			for key, container in pairs(methods) do
				local source = container[1]
				source[container[2]](source, ...)
			end

			return true
		else
			return false
		end
	end
}

return event