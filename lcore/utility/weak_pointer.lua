local L, this = ...
this.title = "Weak Pointer"
this.version = "1.0"
this.status = "prototype"
this.desc = "Points to some data without affecting garbage collection"

local lcore = L.lcore
local oop = lcore.utility.oop
local weak_pointer

weak_pointer = {
	new = function(self, item)
		local pointer = newproxy(true)
		local pmeta = getmetatable(pointer)

		local body = {
			__wp = true,
			value = item
		}

		setmetatable(body, {
			__mode = "v"
		})

		pmeta.__index = body
		pmeta.__newindex = body

		return pointer
	end
}

return weak_pointer