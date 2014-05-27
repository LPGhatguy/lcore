local L, this = ...
this.title = "UI Text Label"
this.version = "2.0"
this.status = "production"
this.desc = "Draws text."

local oop = L:get("lcore.utility.oop")
local color = L:get("lcore.graphics.color")
local font = L:get("lcore.graphics.font")
local text_shape = L:get("lcore.graphics.ui.text_shape")
local label

label = oop:class(text_shape) {
	text_color = color:get("white"),

	draw = function(self)
		text_shape.draw(self)

		local w = self.font:getWidth(self.text)
		local h = self.font:getHeight()

		love.graphics.setFont(self.font)
		love.graphics.setColor(self.text_color)

		local y = self.y

		if (self.valign == "bottom") then
			y = self.y - h
		elseif (self.valign == "center") then
			y = self.y - h / 2
		end

		if (self.align == "right") then
			love.graphics.printf(self.text, self.x - w, y, w, "right")
		elseif (self.align == "center") then
			love.graphics.printf(self.text, self.x - w / 2, y, w, "center")
		else
			love.graphics.print(self.text, self.x, y)
		end
	end
}

return label