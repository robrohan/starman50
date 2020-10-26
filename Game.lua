Game = Class{}

require 'Roadster'
require 'Laser'
require 'Enemy'

MAX_ENEMY = 20

function Game:init()
  -- love.keyboard.keysPressed = {}
  -- love.keyboard.keysReleased = {}

  SWARM = {}
  local o = 0
  for i = 1, MAX_ENEMY do
    SWARM[i] = Enemy()
    SWARM[i].x = o
    o = o + 18
  end

  self.state = 'in_play'
  self.states = {
    ['splash'] = function(dt)
    end,
    ['in_play'] = function(dt)
      self.handleInput()
      PLAYER:update(dt)

      ------------------------------
      -- if ENEMY.state == 'alive' and collides(ENEMY, LASER) then
      --   ENEMY.state = 'die'
      --   shk = Camera:shake(1000, 5)
      -- end
      -- if shk then
      --   coroutine.resume(shk)
      -- end
      ------------------------------
      for i = 1, MAX_ENEMY do
        local e = SWARM[i]
        if e.state == 'alive' and collides(LASER, e) then
          e.state = 'die'
        end
        SWARM[i]:update(dt)
      end
      LASER:update(dt)

    end,
    ['dead'] = function(dt)
    end,
    ['quit'] = function(dt)
    end
  }

  PLAYER = Roadster()
  LASER = Laser()
  -- ENEMY = Enemy()
end

function Game:handleInput()
  if love.keyboard.isDown('left') and
    not love.keyboard.isDown('right') then
    PLAYER.state = 'bank_left'
  end
  if love.keyboard.isDown('right') and
    not love.keyboard.isDown('left') then
    PLAYER.state = 'bank_right'
  end
  if not love.keyboard.isDown('left') and
    not love.keyboard.isDown('right')then
    PLAYER.state = 'idle'
  end

  if love.keyboard.isDown('space')
    and LASER.state == 'offscreen' then
    LASER.x = PLAYER.x
    LASER.y = PLAYER.y - 26
    LASER.state = 'fire'
  end

  -------------------------------
  -- if SHAKE == true then
  --   -- create a coroutine
  --   shk = Camera:shake(1000, 5)
  -- end
  -- if shk then
  --   -- if it exists "play" it
  --   coroutine.resume(shk)
  -- end
  -------------------------------
end

function Game:update(dt)
  self.states[self.state](dt)
end

function Game:render()
  love.graphics.clear(0.098, 0.129, 0.251, 1)

  if self.state == 'in_play' then
    PLAYER:render()
    LASER:render()
    -- ENEMY:render()
    for i = 1, MAX_ENEMY do
      SWARM[i]:render()
    end
  end
end

function Game:keypressed(key)
  -- if key == 'space' then
  --   SHAKE = true
  -- end
end

function Game:keyreleased(key)
  -- if key == 'space' then
  --   SHAKE = false
  -- end
end

-- sees if a overlaps with b
function collides(a, b)
  local a1x = a.x
  local a1y = a.y
  local a2x = a.x + a.w
  local a2y = a.y + a.h

  local b1x = b.x
  local b1y = b.y
  local b2x = b.x + b.w
  local b2y = b.y + b.h

  local o = a1x > b2x or
            b1x > a2x or
            a1y > b2y or
            b1y > a2y

  return not o
end