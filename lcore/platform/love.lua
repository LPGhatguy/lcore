local L, this = ...
this.title = "LOVE Platform Assistance"
this.version = "1.0"
this.status = "production"
this.desc = "Provides useful interfaces for integrating LCORE into LOVE."
this.notes = {
	"Do not use provide_hooks and provide_loop at the same time or double event calls will occur."
}

local event = L:get("lcore.service.event")
local L_love

L_love = {
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

	hooks = {
		"load", "quit", "update", "draw",
		"mousepressed", "mousereleased",
		"keypressed", "keyreleased",
		--##todo fill these in from the love site
	},

	--[[
	@method provide_loop
	#desc Overrides love.run with a custom loop.
	#desc This preserves existing love.* events but still calls all LCORE-hooked events.
	]]
	provide_loop = function(self)
		love.run = self.love_run
	end,

	--[[
	@method provide_hooks
	#desc Adds callbacks in love.* to called LCORE-hooked events.
	#desc This is best if a custom love.run is in place or the default is important to preserve.
	]]
	provide_hooks = function(self, overwrite)
		for index = 1, #self.hooks do
			local value = self.hooks[index]

			if (not love[value] or overwrite) then
				love[value] = function(...)
					event.global:fire(value, ...)
				end
			end
		end
	end
}

return L_love