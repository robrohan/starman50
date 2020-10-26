uniform float iTime;

// https://thebookofshaders.com/10/
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

/// System wide current color setting         / 0..1           / screen coords
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
  vec2 uv = texture_coords;
  vec4 ccolor = Texel(texture, texture_coords);
  vec3 colorout = vec3(0., .666, 0.);

  float curve = 0.1 * sin( (9.25 * uv.y) + (iTime * 10.) );

  float lineAShape = smoothstep(
    1.0 - clamp(distance(curve + uv.x, 0.5) * .5, 0.0, 1.0),
    1.0, 
    0.99
  );
  vec3  lineACol = (1.0 - lineAShape) * vec3(mix(ccolor.rgb, colorout, lineAShape));
  ccolor = vec4(.5,.5,0., 1.) + vec4(lineACol, 1.);

  if (ccolor.r <= 0. || ccolor.g <= 0. || ccolor.b <= 0.) {
    discard;
  }

  return ccolor;
}

