Enemy = Class{}

function Enemy:init()
  self.x = 18
  self.y = 32
  self.w = 18
  self.h = 32

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
      -- to go to the next state... self.state = '...'
      self.currentFrame = self.animation:getCurrentFrame()
    end,
    ['die'] = function(dt)
      self.scale = self.scale - 0.001
      self.r = (self.r - 0.01)
    end,
    ['dead'] = function(dt)
    end,
  }

  -- don't set the these directly either. Use self.state
  self.animation = self.animations[self.state]
  self.currentFrame = self.animation:getCurrentFrame()
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