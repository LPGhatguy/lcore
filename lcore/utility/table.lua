local L, this = ...
this.title = "Table Extension Library"
this.version = "1.0"
this.status = "production"
this.desc = "Provides extensions for operating on tables."

local utable
local test

utable = {
	equal = function(self, first, second, no_reverse)
		for key, value in pairs(first) do
			if (second[key] ~= value) then
				return false, key
			end
		end

		if (not no_reverse) then
			return utable:equal(second, first, true)
		else
			return true
		end
	end,

	congruent = function(self, first, second, no_reverse)
		for key, value in pairs(first) do
			local value2 = second[key]

			if (type(value) == type(value2)) then
				if (type(value) == "table") then
					if (not utable:congruent(value, value2)) then
						return false, key
					end
				else
					if (value ~= value2) then
						return false, key
					end
				end
			else
				return false, key
			end
		end

		if (not no_reverse) then
			return utable:congruent(second, first, true)
		else
			return true
		end
	end,

	copylock = function(self, target)
		target.__nocopy = true

		return target
	end,

	copy = function(self, source, target)
		target = target or {}

		for key, value in pairs(source) do
			target[key] = value
		end

		return target
	end,

	deepcopy = function(self, source, target, break_lock)
		target = target or {}

		for key, value in pairs(source) do
			if (type(value) == "table") then
				if (value.__nocopy and not break_lock) then
					target[key] = value
				else
					target[key] = utable:deepcopy(value)
				end
			else
				target[key] = value
			end
		end

		return target
	end,

	merge = function(self, source, target)
		if (not target) then
			return nil
		end

		for key, value in pairs(source) do
			if (not target[key]) then
				target[key] = value
			end
		end

		return target
	end,

	copymerge = function(self, source, target, break_lock)
		if (not target) then
			return nil
		end

		for key, value in pairs(source) do
			if (not target[key]) then
				if (type(value) == "table") then
					if (not value.__nocopy and not break_lock) then
						target[key] = utable:copy(value)
					else
						target[key] = value
					end
				else
					target[key] = value
				end
			end
		end

		return target
	end,

	invert = function(self, source, target)
		target = target or {}

		for key, value in pairs(source) do
			target[value] = key
		end

		return target
	end,

	contains = function(self, source, value)
		for key, compare in pairs(source) do
			if (compare == value) then
				return true
			end
		end

		return false
	end
}

return utable