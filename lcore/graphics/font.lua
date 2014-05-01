local L, this = ...
this.title = "Font Core"
this.version = "1.0"
this.status = "production"
this.desc = "Provides an efficient interface into using multiple font faces and sizes."
this.todo = {
	"Work into lcore.service.content's featureset.",
	"Figure out support for bitmap fonts."
}

local font

font = {
	default_face = nil,
	default_scaling = {"linear", "linear"},
	loaded = {},

	get = function(self, size, name)
		name = name or self.default_face
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

			lfont:setFilter(unpack(self.default_scaling))
			self.loaded[rname][size] = lfont
		end

		return lfont
	end
}

return font