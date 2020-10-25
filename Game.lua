Game = Class{}

require 'Roadster'

function Game:init()
  -- love.keyboard.keysPressed = {}
  -- love.keyboard.keysReleased = {}
  PLAYER = Roadster()
end

function Game:update(dt)
  PLAYER:update(dt)
end

function Game:render()
  PLAYER:render()
end

function Game:keypressed(key)
  if key == 'left' then
    PLAYER.state = 'bank_left'
  elseif key == 'right' then
    PLAYER.state = 'bank_right'
  end
end

function Game:keyreleased(key)
  PLAYER.state = 'idle'
end