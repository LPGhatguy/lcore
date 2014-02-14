--[[
#id utility.table
#title Table Extension Library

#version 1.0
#status production

#desc Provides extensions for operating on tables that Lua doesn't have by default.
]]

local L = (...)

local etable
local test

etable = {
	--[[
	@method equal
	#title Equality
	#def (table first, table second, [boolean no_reverse])
	#returns boolean result, [mixed error_key]
	#desc Checks if each value of tables first and second are equal.
	#desc If result is false, error_key contains the first key where a mismatch occured.
	#desc If no_reverse is true, only first is iterated through. This is used internally.
	]]
	equal = function(self, first, second, no_reverse)
		for key, value in pairs(first) do
			if (second[key] ~= value) then
				return false, key
			end
		end

		if (not no_reverse) then
			return etable:equal(second, first, true)
		else
			return true
		end
	end,

	--[[
	@method congruent
	#title Congruency
	#def (table first, table second, [boolean no_reverse])
	#returns boolean result, [mixed error_key]
	#desc Checks if first and second are equal recursively. Tables are iterated through.
	#desc If result is false, error_key contains the first key where a mismatch occured.
	#desc If no_reverse is true, only first is iterated through. This is used internally.
	]]
	congruent = function(self, first, second, no_reverse)
		for key, value in pairs(first) do
			local value2 = second[key]

			if (type(value) == type(value2)) then
				if (type(value) == "table") then
					if (not etable:congruent(value, value2)) then
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
			return etable:congruent(second, first, true)
		else
			return true
		end
	end,

	--[[
	@method copylock
	#title Copylock
	#def (table target)
	#returns table target
	#desc Sets a flag in the table that forces copying and merging functions to not copy this table.
	]]
	copylock = function(self, target)
		target.__nocopy = true

		return target
	end,

	--[[
	@method copy
	#title Shallow Copy
	#def (table source, [table target])
	#returns table target
	#desc Performs a shallow copy from source to target.
	#desc If target is not specified, a new table is created. The location copied to is returned.
	]]
	copy = function(self, source, target)
		target = target or {}

		for key, value in pairs(source) do
			target[key] = value
		end

		return target
	end,

	--[[
	@method deepcopy
	#title Deep Copy
	#def (table source, [table target, boolean break_lock])
	#returns table target
	#desc Performs a deep copy from source to target.
	#desc If a target is not specified, a new table is created. The location copied to is returned.
	#desc If break_lock is true, any copylocked tables are copied anyway.
	]]
	deepcopy = function(self, source, target, break_lock)
		target = target or {}

		for key, value in pairs(source) do
			if (type(value) == "table") then
				if (value.__nocopy and not break_lock) then
					target[key] = value
				else
					target[key] = etable:deepcopy(value)
				end
			else
				target[key] = value
			end
		end

		return target
	end,

	--[[
	@method merge
	#title Shallow Merge
	#def (table source, table target)
	#returns table target
	#desc Performs a shallow merge from source to target.
	#desc Values from source are copied into target unless they already exist.
	]]
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

	--[[
	@method copymerge
	#title Shallow Copy-Merge
	#def (table source, table target)
	#returns table target
	#desc Performs a shallow merge from source to target.
	#desc Values from source are copied into target unless they already exist.
	#desc Table values are copied unless they are copylocked.
	#desc If break_lock is true, any copylocked tables are copied anyway.
	]]
	copymerge = function(self, source, target, break_lock)
		if (not target) then
			return nil
		end

		for key, value in pairs(source) do
			if (not target[key]) then
				if (type(value) == "table") then
					if (not value.__nocopy and not break_lock) then
						target[key] = etable:copy(value)
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

	--[[
	@method invert
	#title Invert
	#def (table source, [table target])
	#returns table target
	#desc Inverts the table source into target. All keys become values and vice versa.
	#desc Behavior with duplicate values is undefined.
	#desc If not target is not defined, a new table will be created.
	]]
	invert = function(self, source, target)
		target = target or {}

		for key, value in pairs(source) do
			target[value] = key
		end

		return target
	end
}

--NOMINI START
if (L.debug) then
	etable.__test = function(self, test)
		local suite = test:suite("Table Extension Library")
		local a, b, c, d

		suite:section("table.equal")
		a = {1, 2, {},   key = "value"}
		b = {1, 2, a[3], key = "value"}
		c = {1, 2, {}}
		suite:test("equal", self:equal(a, b))
		suite:test("equal-flip", self:equal(b, a))
		suite:test("equal-wrong", not self:equal(a, c))
		suite:test("equal-wrong-flip", not self:equal(c, a))


		suite:section("table.congruent")
		a = {1, 2, {}}
		b = {1, 2, {}}
		c = {1, 2}
		suite:test("congruent", self:congruent(a, b))
		suite:test("congruent-flip", self:congruent(b, a))
		suite:test("congruent-wrong", not self:congruent(a, c))
		suite:test("congruent-wrong-flip", not self:congruent(c, a))


		suite:section("table.copylock")
		a = {}
		self:copylock(a)
		suite:test("copylock", a.__nocopy)

		
		suite:section("table.copy")
		a = {1, 2, 3, {}}
		b = {}
		self:copy(a, b)
		suite:test("copy", self:equal(a, b))


		suite:section("table.deepcopy")
		a = {1, 2, key = {1, 2, value = 3}}
		b = self:deepcopy(a)
		suite:test("deepcopy", self:congruent(a, b))


		suite:section("table.merge")
		a = {5, 4, 3, key = "value"}
		b = {1, 2}
		c = {1, 2, 3, key = "value"}
		d = self:merge(a, b)
		suite:test("merge", self:equal(c, d))


		suite:section("table.copymerge")
		a = {5, 4, {}, key = "value"}
		b = {1, 2}
		c = {1, 2, {}, key = "value"}
		d = self:merge(a, b)
		suite:test("copymerge", self:congruent(c, d))


		suite:section("table.invert")
		a = {1, 2, 3}
		b = {3, 2, 1}
		c = self:invert(a)
		self:invert(a, b)
		suite:test("invert-self", self:equal(a, c))
		suite:test("invert-target", self:equal(a, b))

		return suite
	end
end
--NOMINI END

return etable