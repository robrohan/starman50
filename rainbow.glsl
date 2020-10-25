uniform float iTime;

/// System wide current color setting         / 0..1           / screen coords
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
  vec2 uv = texture_coords; // / (iResolution * VIRTUAL_SCALE);
  // float y = uv.x;
  // vec3 ccolor = vec3(y);

  vec4 ccolor = Texel(texture, texture_coords);

  vec3 P1ColorIn = vec3(1.0, 0.5, 0.0);
  vec3 P1ColorOut = vec3(1.0, 0.0, 0.0);
  //// 
  float curve = 0.1 * sin( (9.25 * uv.y) + (iTime * 10.) );
  //// 
  float lineAShape = smoothstep(
    1.0 - clamp(distance(curve + uv.x, 0.5) * 1.0, 0.0, 1.0),
    1.0, 
    0.99
  );
  vec3  lineACol = (1.0 - lineAShape) * vec3(mix(P1ColorIn, P1ColorOut, lineAShape));
  ccolor = ccolor + vec4(lineACol, 1.);

  if (ccolor.r <= 0. || ccolor.g <= 0. || ccolor.b <= 0.) {
    discard;
  }

  // vec4 ocolor = vec4(texture_coords.x, texture_coords.y, 0., 1.);
  // if (texture_coords.x > .4 && texture_coords.x < .6) {
  //   // ocolor = vec4(.5, .5, sin(iTime), 1);
  //   ocolor = Texel(texture, texture_coords);
  //   ocolor.r = sin(iTime);
  // } else {
  //   discard;
  // }
  
  // return ocolor;
  return ccolor;
}

