Class = require 'Class'
Push = require 'Push'

require 'Camera'
require 'Animation'
require 'Game'

-- close resolution to NES but 16:9
-- snes
VIRTUAL_WIDTH = 256 -- 320 -- 432
VIRTUAL_HEIGHT = 224 -- 240 -- 243

-- actual window resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

math.randomseed(os.time())
love.graphics.setDefaultFilter('nearest', 'nearest')

-- ///////////////////////////////
function love.load()
  print("Starman")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {vsync=false})
  love.window.setTitle('Starman 50')
  Push:setupScreen(
      VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
      WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true
    }
  )
  FONTS = {
    ['defaultFont'] = love.graphics.newFont('assets/fonts/font.ttf', 8),
    ['mediumFont'] = love.graphics.newFont('assets/fonts/font.ttf', 16),
    ['largeFont'] = love.graphics.newFont('assets/fonts/font.ttf', 32)
  }
  GAME = Game()

  LASER = love.graphics.newImage('assets/graphics/laser.png')
  SHADER = love.graphics.newShader("rainbow.glsl")
end

TIME = 0
-- ///////////////////////////////
function love.update(dt)

  GAME:update(dt)

  -------------------------------
  if SHAKE == true then
    -- create a coroutine
    shk = Camera:shake(1000, 5)
  end
  if shk then
    -- if it exists "play" it
    coroutine.resume(shk)
  end
  -------------------------------

  TIME = TIME + dt
end

-- ///////////////////////////////
function love.draw()
  -- begin virtual resolution drawing
  Push:apply('start')
  Camera:set()

  love.graphics.clear(0.098, 0.129, 0.251, 1)
  love.graphics.setFont(FONTS['mediumFont'])
  love.graphics.print("Starman 2050", 1, 1)

  GAME:render()

  --------------------------------
  -- Most shaders will need a time element
  SHADER:send("iTime", TIME)
  love.graphics.setShader(SHADER)
  -- We need to draw to a proper graph or the texture_coords
  -- don't really work. I.e. using a fill rectangle
                          -- x, y, r, sX, sY,  oX        oY
  love.graphics.draw(LASER, 100, 100, 0, 1, 1, 18 / 2, 32 / 2)
  love.graphics.setShader()
  --------------------------------

  -- end virtual resolution
  Camera:unset()
  Push:apply('end')
end

-- ///////////////////////////////
function love.keypressed(key)
  -- TODO remove this
  if key == 'escape' then
    love.event.quit()
  end

  if key == 'space' then
    SHAKE = true
  end

  GAME:keypressed(key)
end

-- ///////////////////////////////
function love.keyreleased(key)
  GAME:keyreleased(key)

  if key == 'space' then
    SHAKE = false
  end
end

-- ///////////////////////////////
-- ///////////////////////////////
function love.resize(w, h)
  Push:resize(w, h)
end

