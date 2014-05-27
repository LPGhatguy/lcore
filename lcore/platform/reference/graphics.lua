local L, this = ...
this.title = "PAAPI Reference Graphics Implementation"
this.version = "0.1"
this.status = "prototype"
this.desc = "A no-op module providing a reference API"

local utable = L:get("lcore.utility.table")
local ref_gfx

local gfx_nop = function(name, ...)
	local arg = {...}
	local called
	
	return function()
		if (not called) then
			called = true
			print("Method 'graphics." .. tostring(name) .. "' is not implemented.")
		end

		return unpack(arg)
	end
end

ref_gfx = {
	derive = function(self, target)
		return utable:copymerge(self, target)
	end,

	immediate = true,
	retained = false,

	--IMMEDIATE-MODE API
	rectangle = gfx_nop("rectangle"),
	circle = gfx_nop("circle"),
	arc = gfx_nop("arc"),
	polygon = gfx_nop("polygon"),
	line = gfx_nop("line"),
	point = gfx_nop("point"),

	clear = gfx_nop("clear"),
	origin = gfx_nop("origin"),
	pop = gfx_nop("pop"),
	push = gfx_nop("push"),

	translate = gfx_nop("translate"),
	scale = gfx_nop("scale"),
	rotate = gfx_nop("rotate"),
	shear = gfx_nop("shear"),

	set_color_rgb = gfx_nop("set_color_rgb"),
	get_color_rgb = gfx_nop("get_color_rgb"),
	set_color = gfx_nop("set_color"),
	get_color = gfx_nop("get_color"),

	set_background_color_rgb = gfx_nop("set_background_color_rgb"),
	get_background_color_rgb = gfx_nop("get_background_color_rgb"),
	set_background_color = gfx_nop("set_background_color"),
	get_background_color = gfx_nop("get_background_color"),

	set_scissor = gfx_nop("set_scissor"),
	get_scissor = gfx_nop("get_scissor")
}

return ref_gfx