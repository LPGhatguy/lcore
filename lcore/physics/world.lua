local L, this = ...
this.title = "Physics World"
this.version = "0.1"
this.status = "prototype"
this.desc = "Contains all physically simulated objects."

local oop = L:get("lcore.utility.oop")

local world

world = oop:class()({
	b2world = nil,
	scale = 1,
	objects = {},

	_new = function(self, new)
		--love.physics.setMeter(1)
		new.b2world = love.physics.newWorld(0, 9.81 * 64, true)

		return new
	end,

	add = function(self, id, object)
		if (self.objects[id]) then
			L:warn("Object already exists with ID '" .. (id or "unknown") .. "', replacing existing object.")
		else
			self.objects[id] = object
		end
	end,

	adds = function(self, ...)
		local arg = {...}

		for index = 1, #arg do
			table.insert(self.objects, arg[index])
		end
	end,

	update = function(self, delta)
		self.b2world:update(delta)
	end
})

return world