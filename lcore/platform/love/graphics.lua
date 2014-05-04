local L, this = ...
this.title = "LOVE Graphics Interface"
this.version = "1.1"
this.status = "production"
this.desc = "Provides the base graphics interface from LOVE to LCORE"

if (not love.graphics or not love.window) then
	L:error("Could not get LOVE graphics module")
end

local love_graphics

--A list of items that LOVE is the reference API for
local love_reference = {
	"rectangle", "circle", "arc",
	"polygon", "line", "point",

	"clear", "present",
	"origin", "pop", "push",
	"rotate", "scale", "shear",
	"translate"
}

--Items explicitly defined here are not reference API entries or have been renamed
love_graphics = {
	set_color_rgb = love.graphics.setColor,
	get_color_rgb = love.graphics.getColor,
	set_color = love.graphics.setColor,
	get_color = love.graphics.getColor,
	set_background_color_rgb = love.graphics.setBackgroundColor,
	get_background_color_rgb = love.graphics.getBackgroundColor,
	set_scissor = love.graphics.setScissor,
	get_scissor = love.graphics.getScissor,

	draw = love.graphics.draw,
	print = love.graphics.print,
	printf = love.graphics.printf,
}

for index, item in ipairs(love_reference) do
	love_graphics[item] = love.graphics[item]
end

setmetatable(love_graphics, {
	__index = function(self, key)
		L:warn("Falling back to love for graphics entry '" .. tostring(key) .. "'")
		return love.graphics[key]
	end
})

return love_graphics