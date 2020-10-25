vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
  // This reads a color from our texture at the coordinates LOVE gave us (0-1, 0-1)
  vec4 c = Texel(texture, texture_coords); 
  // This just returns a white color that's modulated by the brightest color channel 
  // at the given pixel in the texture. Nothing too complex, and not exactly the prettiest 
  // way to do B&W :P
  return vec4(vec3(.5, .5, .5) * (max(c.r, max(c.g, c.b))), 1.0);
}