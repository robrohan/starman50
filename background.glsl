uniform float iTime;

// Star Nest by Pablo Roman Andrioli
// This content is under the MIT License.
// Adapted from: https://www.shadertoy.com/view/XlfGRj

#define iterations 12
#define formuparam 0.53

#define volsteps 10
#define stepsize 0.1

#define zoom   0.900
#define tile   0.650
#define speed  0.010 

#define brightness 0.0015
#define darkmatter 0.200
#define distfading 0.330
#define saturation 0.250

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	//get coords and direction
	vec2 uv = fragCoord.xy;
	vec3 dir = vec3(uv * zoom, 1.);
	float time = iTime * speed + .25;

	float a1=3.14;
	float a2=1.;

	mat2 rot1=mat2(cos(a1),sin(a1),-sin(a1),cos(a1));
	mat2 rot2=mat2(cos(a2),sin(a2),-sin(a2),cos(a2));

	dir.xy*=rot1;
	dir.xz*=rot2;

	vec3 from = vec3(1.,1.,1.);
	from += vec3(time*2.,time,-2.);
	
  from.xz*=rot1;
	from.xy*=rot2;
	
	//volumetric rendering
	float s=0.1,fade=1.;
	vec3 v=vec3(0.);
	for (int r=0; r<volsteps; r++) {
		vec3 p=from+s*dir*.5;
		p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
		float pa,a=pa=0.;
		for (int i=0; i<iterations; i++) { 
			p=abs(p)/dot(p,p)-formuparam; // the magic formula
			a+=abs(length(p)-pa); // absolute sum of average change
			pa=length(p);
		}
		float dm=max(0.,darkmatter-a*a*.001); //dark matter
		a*=a*a; // add contrast
		if (r>6) fade*=1.-dm; // dark matter, don't render near
		//v+=vec3(dm,dm*.5,0.);
		v+=fade;
		v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
		fade*=distfading; // distance fading
		s+=stepsize;
	}
	v=mix(vec3(length(v)),v,saturation); //color adjust
	fragColor = vec4(v*.01,1.);	
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
  mainImage(color, texture_coords);
  return color;
}