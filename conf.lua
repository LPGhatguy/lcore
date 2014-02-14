--~NODOC

function love.conf(t)
    t.identity = "new"
    t.appendidentity = true
    t.version = "0.9.0"
    t.console = true

    t.window.title = "New Project"
    t.window.icon = nil

    t.window.width = 800
    t.window.height = 600
    t.window.minwidth = 600
    t.window.minheight = 400

    t.window.borderless = false
    t.window.resizable = false
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.display = 1

    t.window.vsync = true
    t.window.fsaa = 0

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = true
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.window = true
end
