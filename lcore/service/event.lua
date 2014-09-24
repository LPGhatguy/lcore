local L, this = ...
this.title = "Event Service"
this.version = "1.2"
this.status = "production"
this.desc = "Provides event support with both manager instantiation and global events."

local lcore = L.lcore
local oop = lcore.utility.oop
local event

local function event_sort(first, second)
	if (not first) then
		return false
	elseif (not second) then
		return true
	else
		return first[2] < second[2]
	end
end

event = oop:class() {
	global = nil,
	registered = {},
	events = {},

	destroy = function(self)
		self.events = {}
		self.registered = {}
	end,

	hook = function(self, event_name, object, priority, ...)
		priority = priority or 0

		if (type(event_name) == "table") then
			for index = 1, #event_name do
				self:hook(event_name[index], object, priority, ...)
			end

			return true
		end

		local target = self.events[event_name]

		if (not target) then
			target = {
				active = true
			}

			self.events[event_name] = target
			self.registered[event_name] = {}
		end

		if (self.registered[event_name][object]) then
			return false, "Object already registered with event."
		end

		local event = {object, priority}

		table.insert(target, event)
		self.registered[event_name][object] = event

		self:sort(event_name)

		return true
	end,

	batch_hook = function(self, event_name, objects, priority, ...)
		for index, object in ipairs(objects) do
			self:hook(event_name, object, priority, ...)
		end
	end,

	unhook_object = function(self, object, event_name)
		if (not event_name) then
			for key, value in pairs(self.events) do
				self:unhook_object(object, key)
			end

			return true
		end

		local event = self.events[event_name]

		if (event) then
			for index = 1, #event do
				if (event[index][1] == object) then
					event[index] = nil
				end
			end

			self.registered[event_name][object] = nil

			self:sort(event_name)
		end
	end,

	unhook_event = function(self, event_name)
		self.events[event_name] = nil
		self.registered[event_name] = nil
	end,

	sort = function(self, event_name)
		if (not event_name) then
			for key, value in pairs(self.events) do
				self:sort(key)
			end

			return true
		end

		local event = self.events[event_name]

		if (event) then
			table.sort(event, event_sort)
		end
	end,

	fire = function(self, event_name, ...)
		local event = self.events[event_name]

		if (event and event.active) then
			for index = 1, #event do
				local object = event[index][1]

				if (type(object) == "table" or type(object) == "userdata") then
					if (object[event_name]) then
						object[event_name](object, ...)
					elseif (object.fire) then
						object:fire(event_name, ...)
					end
				elseif (type(object) == "function") then
					object(...)
				end
			end
		end
	end
}

event.global = event:new()
event.global.__nocopy = true

return event