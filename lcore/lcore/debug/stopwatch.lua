--[[
#id debug.stopwatch
#title Stopwatch Code Benchmarker
#status production
#version 1.0

#desc Benchmarks code for profiling of tasks
]]

local L = (...)
local stopwatch

stopwatch = {
	tasks = {},

	begin = function(self, name)
		local task = self.tasks[name]
		if (not task) then
			task = {}
			self.tasks[name] = task
		end

		task.begin = love.timer.getTime()
		task.finish = nil
	end,

	finish = function(self, name)
		if (self.tasks[name]) then
			self.tasks[name].finish = love.timer.getTime()
		end
	end,

	time = function(self, name)
		local task = self.tasks[name]

		if (task and task.begin and task.finish) then
			return task.finish - task.begin
		end
	end
}

return stopwatch