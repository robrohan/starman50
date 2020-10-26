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
WINDOW_WIDTH = 768 -- 1280
WINDOW_HEIGHT = 672 -- 720

math.randomseed(os.time())
love.graphics.setDefaultFilter('nearest', 'nearest')

-- ///////////////////////////////
function love.load()
  print("Starman")
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {vsync=false})
  love.window.setTitle('Starman 2050')
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
end

-- Gloabl time
TIME = 0
-- ///////////////////////////////
function love.update(dt)
  GAME:update(dt)
  TIME = TIME + dt
end

-- ///////////////////////////////
function love.draw()
  -- begin virtual resolution drawing
  Push:apply('start')
  Camera:set()
  -- love.graphics.setFont(FONTS['mediumFont'])
  -- love.graphics.print("Starman 2050", 1, 1)
  GAME:render()
  -- end virtual resolution
  Camera:unset()
  Push:apply('end')
end

-- ///////////////////////////////
function love.keypressed(key)
  -- TODO remove this
  if key == 'escape' then
    love.event.quit()
    -- GAME.state = 'splash'
  end
  GAME:keypressed(key)
end

-- ///////////////////////////////
function love.keyreleased(key)
  GAME:keyreleased(key)
end

-- ///////////////////////////////
-- ///////////////////////////////
function love.resize(w, h)
  Push:resize(w, h)
end

