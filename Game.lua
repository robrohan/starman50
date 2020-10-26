Game = Class{}

require 'Roadster'
require 'Laser'
require 'Enemy'

MAX_ENEMY = 60

SCORE = 0
AI_SCORE = 0
LOSE_SCORE = 9
ATTACK_LEVEL = 5
ATTACK_SPEED = 10
BEST = 0

DEAD_TIME = 0

function Game:init()
  -- love.keyboard.keysPressed = {}
  -- love.keyboard.keysReleased = {}

  self.texture = love.graphics.newImage('assets/graphics/background.png')
  self.shader = love.graphics.newShader("background.glsl")

  self.music = {
    ['splash'] = love.audio.newSource('assets/music/life_on_mars.wav', 'static'),
    ['game'] = love.audio.newSource('assets/music/starman.wav', 'static')
  }

  self.sounds = {
    ['laser1'] = love.audio.newSource('assets/sounds/laser1.wav', 'static'),
    ['laser2'] = love.audio.newSource('assets/sounds/laser2.wav', 'static'),
    ['lose'] = love.audio.newSource('assets/sounds/lose.wav', 'static'),
    ['explode1'] = love.audio.newSource('assets/sounds/explode1.wav', 'static'),
    ['explode2'] = love.audio.newSource('assets/sounds/explode2.wav', 'static'),
    ['musk1'] = love.audio.newSource('assets/sounds/musk1.wav', 'static'),
    ['musk2'] = love.audio.newSource('assets/sounds/musk2.wav', 'static'),
    ['musk3'] = love.audio.newSource('assets/sounds/musk3.wav', 'static'),
    ['musk4'] = love.audio.newSource('assets/sounds/musk4.wav', 'static'),
    ['musk5'] = love.audio.newSource('assets/sounds/musk5.wav', 'static'),
    ['musk6'] = love.audio.newSource('assets/sounds/musk6.wav', 'static'),
    ['musk7'] = love.audio.newSource('assets/sounds/musk7.wav', 'static'),
    ['musk8'] = love.audio.newSource('assets/sounds/musk8.wav', 'static'),
    ['musk9'] = love.audio.newSource('assets/sounds/musk9.wav', 'static'),
    ['musk10'] = love.audio.newSource('assets/sounds/musk10.wav', 'static'),
    ['musk11'] = love.audio.newSource('assets/sounds/musk11.wav', 'static'),
  }

  SWARM = {}
  for i = 1, MAX_ENEMY do
    SWARM[i] = Enemy()
  end

  self.state = 'splash'
  self.states = {
    ['splash'] = function(dt)
      -- TODO
      self.music['splash']:setLooping(false)
      self.music['splash']:play()
    end,
    ['set_stage'] = function(dt)
      self.music['splash']:stop()
      PLAYER:reset()
      for i = 1, MAX_ENEMY do
        SWARM[i]:resetPosition()
      end
      SCORE = 0
      AI_SCORE = 0
      ATTACK_LEVEL = 5
      self.state = 'in_play'
      self.music['game']:setLooping(true)
      self.music['game']:play()
      TIME = 0
    end,
    ['in_play'] = function(dt)
      self:handleInput()

      -- Enemy logic...
      for i = 1, ATTACK_LEVEL do
        local e = SWARM[i]

        -- Check if we've killed an Enemy
        if e.state == 'attack' then
          -- see if the laser hit a bad guy
          if collides(LASER, e) then
            e.state = 'die'
            local v = math.random(1,2)
            self.sounds['explode'..v]:stop()
            self.sounds['explode'..v]:setFilter {
              type = 'lowpass',
              volume = 0.4,
              highgain = 1.
            }
            self.sounds['explode'..v]:play()
            e.y = e.y - 10
            SCORE = SCORE + 1
            -- tmp
            shk = Camera:shake(100, 2)
          end
          -- see if the bad guy this the player
          if collides(PLAYER, e) then
            PLAYER.state = 'hit'
            e.state = 'die'
            self.sounds['lose']:stop()
            self.sounds['lose']:play()
            shk = Camera:shake(150, 10)
          end
        end

        if e.state == 'alive' then
          e.dy = math.min(0.1, math.random() * ATTACK_SPEED)
          e.state = 'attack'
        end

        -- Update the Enemy
        SWARM[i]:update(dt)
      end
      PLAYER:update(dt)
      LASER:update(dt)

      -- run camera shake if it's set
      if shk then
        coroutine.resume(shk)
      end

      if AI_SCORE >= LOSE_SCORE then
        self.state = 'dead'
        self.music['game']:stop()
        local v = math.random(1,11)
        self.sounds['musk'..v]:play()
        DEAD_TIME = 0
      end

      if SCORE == 20 then
        ATTACK_LEVEL = 10
      elseif SCORE == 40 then
        ATTACK_LEVEL = 15
        ATTACK_SPEED = 50
      elseif SCORE == 60 then
        ATTACK_LEVEL = 20
        ATTACK_SPEED = 80
      elseif SCORE == 80 then
        ATTACK_LEVEL = 30
        ATTACK_SPEED = 100
      elseif SCORE == 100 then
        ATTACK_LEVEL = 40
        ATTACK_SPEED = 120
      elseif SCORE == 200 then
        ATTACK_LEVEL = 60
        ATTACK_SPEED = 200
      end
    end,
    ['dead'] = function(dt)
      DEAD_TIME = DEAD_TIME + dt
      PLAYER:update(dt)
      if DEAD_TIME >= 20 then
        self.state = 'splash'
      end
    end,
    ['quit'] = function(dt)
    end
  }

  PLAYER = Roadster()
  LASER = Laser()
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
    local v = math.random(1,2)
    self.sounds['laser'..v]:stop()
    self.sounds['laser'..v]:setFilter {
      type = 'lowpass',
      volume = 0.4,
      highgain = 1.
    }
    self.sounds['laser'..v]:play()
  end
end

function Game:update(dt)
  self.states[self.state](dt)
end

function Game:render()
  -- love.graphics.clear(0.098, 0.129, 0.251, 1)

  self.shader:send("iTime", TIME)
  love.graphics.setShader(self.shader)
  love.graphics.draw(self.texture, 0, 0, 0, 1, 1)
  love.graphics.setShader()

  if self.state == 'in_play' then
    PLAYER:render()
    LASER:render()
    for i = 1, MAX_ENEMY do
      SWARM[i]:render()
    end

    love.graphics.setFont(FONTS['mediumFont'])
    love.graphics.print(SCORE, 4, 1)

    love.graphics.setColor(0.5, 0.5, 0.5, 1.)
    love.graphics.setFont(FONTS['mediumFont'])
    love.graphics.print((ATTACK_LEVEL / 5),
      VIRTUAL_WIDTH - 10,
      1
    )
    love.graphics.print(BEST,
      4,
      VIRTUAL_HEIGHT - 16
    )

    love.graphics.setColor(1., 1., 1., 1.)
    love.graphics.print(AI_SCORE,
      VIRTUAL_WIDTH - 15,
      VIRTUAL_HEIGHT - 16
    )
  elseif self.state == 'dead' then
    PLAYER.state = 'die'
    PLAYER:render()
    love.graphics.setColor(1., 1., 1., 1.)
    love.graphics.setFont(FONTS['mediumFont'])
    love.graphics.printf("Failure.",100, 100, 200,"center")

    if SCORE > BEST then
      BEST = SCORE
    end

    if love.keyboard.isDown('return') then
      self.state = 'set_stage'
    end
  elseif self.state == 'splash' then
    love.graphics.setFont(FONTS['defaultFont'])
    love.graphics.printf("Enter to start.",100, 200, 200,"center")
    if love.keyboard.isDown('return') then
      self.state = 'set_stage'
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