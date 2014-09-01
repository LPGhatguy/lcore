local L, this = ...
this.title = "Object Orientation Provider"
this.version = "1.4"
this.status = "production"
this.desc = "Provides advanced object orientation capabilities."
this.todo = {
	"Look into optimizing oop.mix using mutable functable objects."
}

local utable = L:get("lcore.utility.table")
local oop

oop = {
	objectify = function(self, target)
		utable:merge(self.object, target)

		return target
	end,

	class = function(self, ...)
		local new = utable:merge(self.object, {})
		new:inherit(...)

		return function(target)
			target = target or {}
			
			utable:merge(new, target)
			return target
		end
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
		inherit = function(self, ...)
			for key, item in ipairs({...}) do
				utable:merge(item, self)
			end

			return self
		end,

		copy = function(self)
			return utable:deepcopy(self)
		end,

		new = function(self, ...)
			if (self._new) then
				local instance = self:copy()
				self:_new(instance, ...)

				return instance
			else
				return self:copy()
			end
		end,

		destroy = function(self, ...)
			if (self._destroy) then
				return self:_destroy(...)
			end
		end
	}
}

return oop