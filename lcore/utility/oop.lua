local L, this = ...
this.title = "Object Orientation Provider"
this.version = "2.0"
this.status = "production"
this.desc = "Provides advanced object orientation capabilities."

local utable = L:get("lcore.utility.table")
local oop

oop = {
	objectify = function(self, target)
		utable:merge(self.object, target)

		return target
	end,

	class = function(self, ...)
		local new = utable:deepcopy(self.object)
		new:inherit(...)

		return function(target)
			if (target) then
				utable:merge(new, target)
				return target
			else
				return new
			end
		end
	end,

	static = function(self, ...)
		local new = utable:deepcopy(self.static_object)
		new:inherit(...)

		return function (target)
			if (target) then
				utable:merge(new, target)
				return target
			else
				return new
			end
		end
	end,

	wrap = function(self, object, interface)
		interface = interface or newproxy(true)
		local imeta = getmetatable(interface)

		object.get_internal = function()
			return object
		end

		imeta.__index = object
		imeta.__newindex = object
		imeta.__gc = function(self)
			if (self.destroy) then
				self:destroy()
			end
		end

		for key, value in pairs(object.__metatable) do
			imeta[key] = value
		end

		return interface
	end,

	mix = function(self, ...)
		local result = {}
		local mixing = {}
		local imixing = {}
		local args = {...}

		for step, class in pairs(args) do
			for key, value in pairs(class) do
				local typed = type(value)

				if (typed == "function") then
					if (not mixing[key]) then
						mixing[key] = {value}
						imixing[value] = true
					else
						if (not imixing[value]) then
							imixing[value] = true
							table.insert(mixing[key], value)
						end
					end
				elseif (not result[key]) then
					if (typed == "table") then
						result[key] = utable:deepcopy(value)
					else
						result[key] = value
					end
				end
			end
		end

		for key, value in pairs(mixing) do
			if (#value > 1) then
				result[key] = function(...)
					local result = {}

					for index, functor in ipairs(value) do
						result = {functor(...)}
					end

					return unpack(result)
				end
			else
				result[key] = value[1]
			end
		end

		return result
	end,

	object = {
		__metatable = {},

		--Class Methods
		inherit = function(self, ...)
			for key, item in ipairs({...}) do
				utable:deepcopymerge(item, self)

				local imeta = item.__metatable or getmetatable(item)
				if (imeta) then
					utable:merge(imeta, self.__metatable)
				end
			end

			return self
		end,

		new = function(self, ...)
			local internal = utable:deepcopy(self)
			local interface = oop:wrap(internal)

			if (interface._new) then
				interface:_new(...)
			end

			return interface
		end,

		add_metamethods = function(self, methods)
			for key, value in pairs(methods) do
				self.__metatable[key] = value
			end
		end,

		--Object Methods
		copy = function(self)
			if (self.__nocopy) then
				return self
			else
				return oop:wrap(utable:deepcopy(self:get_internal()))
			end
		end,

		point = function(self, object)
			oop:wrap(object, self)
		end
	},

	static_object = {
		inherit = function(self, ...)
		end
	}
}

return oop