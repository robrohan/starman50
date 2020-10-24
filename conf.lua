function love.conf(t)
  -- The LÖVE version this game was made for (string)
  t.version = "11.3"
  -- Attach a console (boolean, Windows only)
  t.console = true
  -- No window, we'll do this in main
  t.window = false

  -- Box2D
  t.modules.physics = true

  t.modules.joystick = false
  end