local L, this = ...
this.title = "LOVE Graphics Interface"
this.version = "1.2"
this.status = "production"
this.desc = "Provides the base graphics interface from LOVE to LCORE"

if (not love.graphics) then
	L:error("Could not get LOVE graphics module")
end

local lg = love.graphics
local ref_gfx = L:get("lcore.platform.reference.graphics")
local love_gfx

love_gfx = ref_gfx:derive {
	--IMPLEMENTATION
	__states = {},
	__transforms = {},

	--API
	immediate = true,
	retained = false,

	rectangle = lg.rectangle,
	circle = lg.circle,
	arc = lg.arc,
	polygon = lg.polygon,
	line = lg.line,
	point = lg.point,

	clear = lg.clear,
	origin = function()
		lg.origin()

		love_gfx.__transforms = {}
	end,
	pop = function()
		lg.pop()
		local state = love_gfx.__states[#love_gfx.__states]

		if (state) then
			for index = #love_gfx.__transforms, state, -1 do
				love_gfx.__transforms[index] = nil
			end
		else
			error("Too many graphics.pops!")
		end
	end,
	push = function()
		lg.push()
		table.insert(love_gfx.__states, #love_gfx.__transforms + 1)
	end,

	translate = function(x, y)
		lg.translate(x, y)
		table.insert(love_gfx.__transforms, {"translate", x, y})
	end,
	scale = function(x, y)
		lg.scale(x, y)
		table.insert(love_gfx.__transforms, {"scale", x, y})
	end,
	rotate = function(r)
		lg.rotate(r)
		table.insert(love_gfx.__transforms, {"rotate", r})
	end,
	shear = function(x, y)
		lg.shear(x, y)
		table.insert(love_gfx.__transforms, {"shear", x, y})
	end,

	project = function(x, y)
		local r = 0
		local scx, scy = 1, 1
		local shx, shy = 0, 0

		for index, transform in ipairs(love_gfx.__transforms) do
			local method = transform[1]

			if (method == "translate") then
				x = x + math.cos(r) * method[2] * scx
				y = y + math.sin(r) * method[3] * scy
			elseif (method == "scale") then
				scx = scx * method[2]
				scy = scy * method[3]
			elseif (method == "rotate") then
				r = r + method[2]
			elseif (method == "shear") then
				shx = shx * method[2]
				shy = shy * method[3]
			end
		end
	end,

	scissor = lg.setScissor,
	get_scissor = lg.getScissor,

	set_color_rgba = lg.setColor,
	get_color_rgba = lg.getColor,
	set_color = lg.setColor,
	get_color = lg.getColor,

	set_background_color_rgb = lg.setBackgroundColor,
	get_background_color_rgb = lg.getBackgroundColor,
	set_background_color = lg.setBackgroundColor,
	get_background_color = lg.getBackgroundColor
}

return love_gfx