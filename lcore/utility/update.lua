local L, this = ...
this.title = "Update Manager"
this.version = "1.0"
this.status = "prototype"
this.desc = "Retrieves updates from a web server and applies them to the client."
this.todo = {
	"Create non-blocking network requests."
}

local http = require("socket.http")
local ltn12 = require("ltn12")
local version = L:get("lcore.utility.version")
local update

update = {
	remote_version = nil,
	version_url = "",
	package_url = "%s",
	package_location = "package.zip",

	get_remote_version = function(self, refresh)
		if (self.remote_version and not refresh) then
			return self.remote_version
		else
			local buffer = {}

			http.request({
				url = self.version_url,
				sink = ltn12.sink.table(buffer)
			})

			local body = table.concat(buffer)
			local version = version:parse(body)

			self.remote_version = version

			return version
		end
	end,

	needs_update = function(self, refresh)
		local remote = self:get_remote_version(refresh)

		L:notice("Local version:", version:tostring())
		L:notice("Remote version:", version:tostring(remote))

		return (version:is_less_than(remote))
	end,

	unload = function(self)
		love.filesystem.unmount(self.package_location)
	end,

	load = function(self)
		love.filesystem.mount(self.package_location, "")
	end,

	remote_update = function(self, refresh)
		if (self:needs_update(refresh)) then
			L:notice("Update started!")
			local package = self.package_url:format(version:tostring(self:get_remote_version()))
			
			local buffer = {}

			http.request({
				url = package,
				sink = ltn12.sink.table(buffer)
			})

			self:unload()
			love.filesystem.remove(self.package_location)
			for key, value in next, buffer do
				love.filesystem.append(self.package_location, value)
			end

			L:notice("Update complete!")
		else
			L:notice("Already up to date.")
		end
	end,

	do_update = function(self)
		self:load()
		self:remote_update()
		self:load()
	end
}

return update