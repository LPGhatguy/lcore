local L, this = ...
this.title = "Stopwatch Profiler"
this.version = "1.0"
this.status = "production"
this.desc = "Benchmarks code using a logged timer"

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