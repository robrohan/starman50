Enemy = Class{}

function Enemy:init()
  self.x = math.max(18, VIRTUAL_WIDTH * math.random() - (18 * 0.5))
  self.y = -32
  self.w = 18
  self.h = 32

  self.dx = 0
  self.dy = 0

  self.scale = 1

  self.r = 3.14

  self.texture = love.graphics.newImage('assets/graphics/roadster_animation_test.png')

  -- used to determine behavior and animations
  self.state = 'alive'
  -- all the currrently in use animation frames.
  -- don't set this directly use a behaviour
  self.frames = {}
  self.animations = {
    ['alive'] = Animation({
      texture = self.texture,
      frames = {
        love.graphics.newQuad(0, 0, 18, 32, self.texture:getDimensions())
      }
    }),
  }
  self.behaviours = {
    ['alive'] = function(dt)
      self.animation = self.animations['alive']
      self.currentFrame = self.animation:getCurrentFrame()
    end,
    ['attack'] = function(dt)
      self.y = self.y + self.dy

      -- got all the way to the bottom of the screen
      if self.y >= VIRTUAL_HEIGHT + self.h then
        self.state = 'dead'
        AI_SCORE = AI_SCORE + 1
      end
    end,
    ['die'] = function(dt)
      self.scale = self.scale - 0.001
      self.y = self.y + (self.dy * 2)
      self.r = (self.r - math.random() / 100) -- 0.01)
      if self.scale <= 0 then
        self.state = 'dead'
      end
    end,
    ['dead'] = function(dt)
      self:resetPosition()
    end,
  }

  -- don't set the these directly either. Use self.state
  self.animation = self.animations[self.state]
  self.currentFrame = self.animation:getCurrentFrame()
end

function Enemy:resetPosition()
  self.scale = 1
  self.x = math.max(self.w, VIRTUAL_WIDTH * math.random() - (self.w * 0.5))
  self.y = -self.h
  self.r = 3.14
  self.state = 'alive'
end

function Enemy:update(dt)
  self.behaviours[self.state](dt)
end

function Enemy:render()
  if self.state == 'dead' or self.scale <= 0 then
    return
  end

  love.graphics.draw(
    self.texture, self.currentFrame,
    -- x, y, rotation
    self.x, self.y, self.r,
    -- scale x, y
    self.scale, self.scale,
    -- origin offset x, y
    self.w * 0.5, self.h * 0.5
  )
end