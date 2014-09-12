local L, this = ...
this.title = "PAAPI Reference Core Implementation"
this.version = "0.1"
this.status = "prototype"
this.desc = "A module providing a reference API"

local lcore = L.lcore
local utable = lcore.utility.table
local event = lcore.service.event
local ref_core

ref_core = {
	derive = function(self, target)
		return utable:copymerge(self, target)
	end,

	platform_name = "reference nop",
	platform_version = this.version,

	hooks = {"quit"},

	init = function(self)
	end,

	quit = function(self)
		event.global:fire("quit")
	end
}

return ref_core