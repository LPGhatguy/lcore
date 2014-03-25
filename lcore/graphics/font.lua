local L, this = ...
this.title = "Font Core"
this.version = "1.0"
this.status = "production"
this.desc = "Provides an efficient interface into using multiple font faces and sizes."
this.todo = {
	"Work into lcore.service.content's featureset."
}

local font

font = {
	loaded = {},

	get = function(self, size, name)
		local rname = name or "default"
		local lfont

		if (self.loaded[rname]) then
			lfont = self.loaded[rname][size]
		else
			self.loaded[rname] = {}
		end

		if (not lfont) then
			if (name) then
				lfont = love.graphics.newFont(name, size)
			else
				lfont = love.graphics.newFont(size)
			end

			self.loaded[rname][size] = lfont
		end

		return lfont
	end
}

return font