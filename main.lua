Class = require 'Class'
Push = require 'Push'

require 'Animation'
require 'Roadster'

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
  -- love.keyboard.keysPressed = {}
  -- love.keyboard.keysReleased = {}

  ----
  PLAYER = Roadster()
end

-- ///////////////////////////////
function love.update(dt)
  PLAYER:update(dt)
end

-- ///////////////////////////////
function love.draw()
  -- begin virtual resolution drawing
  Push:apply('start')

  -- clear screen using Mario background blue
  love.graphics.clear(0.098, 0.129, 0.251, 1)

  -- renders our map object onto the screen
  -- love.graphics.translate(math.floor(-map.camX + 0.5), math.floor(-map.camY + 0.5))
  -- map:render()

  -- love.graphics.setColor(math.random(), math.random(), math.random(), 1)
  love.graphics.setFont(FONTS['mediumFont'])
  love.graphics.print("Starman 2050", 1, 1)

  ----
  PLAYER:render()

  -- end virtual resolution
  Push:apply('end')
end

-- ///////////////////////////////
function love.keypressed(key)
  print(key)
  if key == 'left' then
    PLAYER.state = 'bank_left'
  elseif key == 'right' then
    PLAYER.state = 'bank_right'
  end
end

-- ///////////////////////////////
function love.keyreleased(key)
  print(key)
  PLAYER.state = 'idle'
end


-- ///////////////////////////////
-- ///////////////////////////////
function love.resize(w, h)
  Push:resize(w, h)
end

