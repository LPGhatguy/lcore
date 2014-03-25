local L, this = ...
this.title = "UI Text Label"
this.version = "1.0"
this.status = "production"
this.desc = "Draws text with a rectangular background."
this.todo = {
	"Decouple this and lcore.ui.rectangle to provide a 'text_shape' class."
}

local oop = L:get("lcore.utility.oop")
local color = L:get("lcore.graphics.color")
local font = L:get("lcore.graphics.font")
local rectangle = L:get("lcore.graphics.ui.rectangle")
local label

label = oop:class(rectangle)({
	text_color = color:get("white"),
	text = "",
	align = "center",
	font = nil,

	_new = function(self, new, manager, text, x, y, w, h, align)
		new = rectangle._new(self, new, manager, x, y, w, h)

		new.font = font:get(h)
		new.text = text or new.text
		new.align = align or new.align

		return new
	end,

	draw = function(self)
		rectangle.draw(self)

		love.graphics.setFont(self.font)
		love.graphics.setColor(self.text_color)
		love.graphics.printf(self.text, self.x, self.y, self.w, self.align)
	end
})

return label