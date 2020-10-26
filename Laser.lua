Laser = Class{}

function Laser:init()
  self.x = -4
  self.y = -30
  self.w = 4
  self.h = 30

  self.r = 0
  self.dx = 0
  self.dy = 0

  self.texture = love.graphics.newImage('assets/graphics/laser.png')
  self.shader = love.graphics.newShader("sine.glsl")

  self.state = 'offscreen'
end

function Laser:update(dt)
  if self.state == 'fire' and self.y > -self.h then
    self.y = self.y - 1
  end
  if self.y <= -self.h then
    self.state = 'offscreen'
  end
end

function Laser:render()
  self.shader:send("iTime", TIME)
  love.graphics.setShader(self.shader)
  -- We need to draw to a proper graph or the texture_coords
  -- don't really work. I.e. using a fill rectangle
                          -- x, y, r, sX, sY,  oX        oY
  love.graphics.draw(self.texture,
    self.x, self.y, self.r,
    1, 1,
    self.w * 0.5, self.h * 0.5)
  love.graphics.setShader()
end