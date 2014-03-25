local L, this = ...
this.title = "Object Orientation Provider"
this.version = "1.3"
this.status = "production"
this.desc = "Provides advanced object orientation capabilities."
this.todo = {
	"Look into optimizing oop.mix using mutable functable objects."
}

local utable = L:get("lcore.utility.table")
local oop

--Checks an argument for whether it's a type or a type identifier
local resolve = function(item)
	return (type(item) == "table") and item or L:get(tostring(item))
end

oop = {
	--@method objectify
	objectify = function(self, target)
		utable:merge(self.object, target)

		return target
	end,

	--@method class
	class = function(self, ...)
		local new = utable:merge(self.object, {})
		new:inherit(...)

		return function(target)
			target = target or {}
			
			utable:merge(new, target)
			return target
		end
	end,

	--@method mix
	mix = function(self, ...)
		local result = {}
		local mixing = {}
		local args = {...}

		for key, value in pairs(args) do
			args[key] = resolve(value)
		end

		for step, class in pairs(args) do
			for key, value in pairs(class) do
				local typed = type(value)

				if (typed == "function") then
					if (not mixing[key]) then
						mixing[key] = {value}
					else
						table.insert(mixing[key], value)
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
					local result

					for index, functor in pairs(value) do
						result = {functor(...)}
					end

					return result and unpack(result)
				end
			else
				result[key] = value[1]
			end
		end

		return result
	end,

	--/@class object
	--documentation doesn't work with non-method member items
	object = {
		inherit = function(self, ...)
			local args = {...}

			for key = 1, #args do
				utable:merge(resolve(args[key]), self)
			end

			return self
		end,

		copy = function(self)
			return utable:deepcopy(self)
		end,

		new = function(self, ...)
			if (self._new) then
				return self:_new(self:copy(), ...)
			else
				return self:copy()
			end
		end,

		destroy = function(self, ...)
			if (self._destroy) then
				return self:_destroy(...)
			else
				return true
			end
		end
	}
}

return oop