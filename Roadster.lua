Roadster = Class{}

function Roadster:init()
  self.x = 100
  self.y = VIRTUAL_HEIGHT - 32
  self.w = 18
  self.h = 32
  self.r = 0

  self.dx = 0
  self.dy = 0

  self.scale = 1

  self.texture = love.graphics.newImage('assets/graphics/roadster_animation_test.png')

  -- used to determine behavior and animations
  self.state = 'idle'
  -- all the currrently in use animation frames.
  -- don't set this directly use a behaviour
  self.frames = {}
  self.animations = {
    ['idle'] = Animation({
      texture = self.texture,
      frames = {
        love.graphics.newQuad(0, 0, 18, 32, self.texture:getDimensions())
      }
    }),
    ['bank_left'] = Animation({
      texture = self.texture,
      frames = {
        love.graphics.newQuad(36, 0, 18, 32, self.texture:getDimensions())
      }
    }),
    ['bank_right'] = Animation({
      texture = self.texture,
      frames = {
        love.graphics.newQuad(18, 0, 18, 32, self.texture:getDimensions())
      }
    })
  }
  self.behaviours = {
    ['idle'] = function(dt)
      self.animation = self.animations['idle']
      -- to go to the next state... self.state = '...'
      self.currentFrame = self.animation:getCurrentFrame()
    end,
    ['bank_left'] = function(dt)
      self.animation = self.animations['bank_left']
      self.currentFrame = self.animation:getCurrentFrame()
      self.x = math.max(0+9, self.x - 0.2)
    end,
    ['bank_right'] = function(dt)
      self.animation = self.animations['bank_right']
      self.currentFrame = self.animation:getCurrentFrame()
      self.x = math.min(VIRTUAL_WIDTH-9, (self.x + 0.2))
    end,
    ['hit'] = function(dt)
      self.x = (self.x + math.random(-self.w * 0.5, self.w * 0.5))
    end,
    ['die'] = function(dt)
      self.scale = math.min(self.scale + 0.01, 200)
      self.r = self.r + 0.001
    end,
  }

  -- don't set the these directly either. Use self.state
  self.animation = self.animations[self.state]
  self.currentFrame = self.animation:getCurrentFrame()
end

function Roadster:reset()
  self.x = 100
  self.y = VIRTUAL_HEIGHT - 32
  self.w = 18
  self.h = 32
  self.r = 0
  self.scale = 1
  self.state = 'idle'
end

function Roadster:update(dt)
  self.behaviours[self.state](dt)
end

function Roadster:render()
  love.graphics.draw(
    self.texture, self.currentFrame,
    -- x, y, rotation
    self.x, self.y, self.r,
    -- scale x, y
    self.scale, self.scale,
    -- origin offset x, y
    -- self.w * 0.5, self.h * 0.5
    self.w * 0.5, self.h * 0.5
  )
end