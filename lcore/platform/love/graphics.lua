local L, this = ...
this.title = "LOVE Graphics Interface"
this.version = "1.1"
this.status = "production"
this.desc = "Provides the base graphics interface from LOVE to LCORE"

if (not love.graphics or not love.window) then
	L:error("Could not get LOVE graphics module")
end

local lg = love.graphics
local ref_gfx = L:get("lcore.platform.reference.graphics")
local love_gfx

love_gfx = ref_gfx:derive {
	immediate = true,
	retained = false,

	rectangle = lg.rectangle,
	circle = lg.circle,
	arc = lg.arc,
	polygon = lg.polygon,
	line = lg.line,
	point = lg.point,

	clear = lg.clear,
	origin = lg.origin,
	pop = lg.pop,
	push = lg.push,

	translate = lg.translate,
	scale = lg.scale,
	rotate = lg.rotate,
	shear = lg.shear,

	set_color_rgb = lg.setColor,
	get_color_rgb = lg.getColor,
	set_color = lg.setColor,
	get_color = lg.getColor,

	set_background_color_rgb = lg.setBackgroundColor,
	get_background_color_rgb = lg.getBackgroundColor,
	set_background_color = lg.setBackgroundColor,
	get_background_color = lg.getBackgroundColor,

	set_scissor = lg.setScissor,
	get_scissor = lg.getScissor
}

return love_gfx