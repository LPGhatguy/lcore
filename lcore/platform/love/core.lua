local L, this = ...
this.title = "LOVE Platform Core"
this.version = "1.0"
this.status = "production"
this.desc = "Provides useful interfaces for integrating LCORE into LOVE."
this.notes = {
	"Do not use provide_hooks and provide_loop at the same time or double event calls will occur."
}

if (not love) then
	L:error("Could not find 'love' to initialize love platform!")
	return
end

local event = L:get("lcore.service.event")
local love_core

love_core = {
	__platform_name = "love",
	__platform_version = love._version,

	graphics = L:get("lcore.platform.love.graphics"),
	filesystem = L:get("lcore.platform.love.filesystem"),

	love_run = function()
		local global = event.global
		local dt = 0

		love.math.setRandomSeed(os.time())
		love.event.pump()

		if love.load then
			love.load(arg)
		end
		global:fire("load")

		love.timer.step()

		while (true) do
			love.event.pump()

			for e, a, b, c, d in love.event.poll() do
				if (e == "quit") then
					if (not love.quit or not love.quit()) then
						global:fire("quit")
						love.audio.stop()
						return
					end
				end
				
				love.handlers[e](a, b, c, d)
				global:fire(e, a, b, c, d)
			end

			love.timer.step()
			dt = love.timer.getDelta()

			if (love.update) then
				love.update(dt)
			end
			global:fire("update", dt)

			if (love.window.isCreated()) then
				love.graphics.clear()
				love.graphics.origin()

				if (love.draw) then
					love.draw()
				end
				global:fire("draw")

				love.graphics.present()
			end

			love.timer.sleep(0.001)
		end
	end,

	love_hooks = {
		"load", "quit", "update", "draw",
		"errhand", "focus", "resize", "visible",
		"mousepressed", "mousereleased", "mousefocus",
		"keypressed", "keyreleased",
		"textinput", "threaderror",
		"gamepadaxis", "gamepadpressed", "gamepadreleased",
		"joystickadded", "joystickaxis", "joystickhat",
		"joystickpressed", "joystickreleased", "joystickremoved"
	},

	provide_loop = function(self)
		love.run = self.love_run
	end,

	provide_hooks = function(self, overwrite)
		for index, value in ipairs(self.love_hooks) do
			if (not love[value] or overwrite) then
				love[value] = function(...)
					event.global:fire(value, ...)
				end
			end
		end
	end,

	start = function(self)
	end,

	init = function(self)
		self:provide_loop()
	end,

	deinit = function(self)
	end
}

setmetatable(love_core, {
	__index = love
})

return love_core