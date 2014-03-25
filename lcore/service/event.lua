local L, this = ...
this.title = "Event Service"
this.version = "1.1"
this.status = "production"
this.desc = "Provides event support with both manager instantiation and global events."

local oop = L:get("lcore.utility.oop")
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

event = oop:class()({
	__nocopy = true,
	global = nil,
	events = {},

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
		end

		table.insert(target, {object, priority})

		return true
	end,

	unhook_object = function(self, object, event_name)
		if (not event_name) then
			for key, value in pairs(self.hooks) do
				self:unhook_object(object, key)
			end

			return true
		end

		local event = self.hooks[event_name]

		if (event) then
			for index = 1, #event do
				if (event[index][1] == object) then
					event[index] = nil
				end
			end

			self:sort(event_name)
		end
	end,

	unhook_event = function(self, event_name)
		self.events[event_name] = nil
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

				if (type(object) == "table") then
					if (object[event_name]) then
						object[event_name](object, ...)
					end

					if (object.fire) then
						object:fire(event_name, ...)
					end
				elseif (type(object) == "function") then
					object(...)
				end
			end
		end
	end
})

event.global = event:new()

return event