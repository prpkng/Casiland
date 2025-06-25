//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

#define CURVATURE 5.2
#define CA_AMT 1.003
#define BLUR .05
#define PIXEL_SIZE 1.0 / 180.

vec4 blurDirection(vec2 uv, float amt, vec2 dir, int count) {
    return max(vec4(0.0), texture2D(gm_BaseTexture, uv + dir * vec2( amt / float(count),  amt / float(count))) - vec4(0.6)) / (4. * float(count));
}

void main()
{
    vec2 uv = v_vTexcoord;
    uv = uv * 2. - 1.;
    vec2 offset = uv.yx / CURVATURE;
    uv += uv * offset * offset;
    uv = uv * .5 + .5;
    
    vec2 edge=smoothstep(0., BLUR, uv)*(1.-smoothstep(1.-BLUR, 1., uv));
    
    
    //chromatic abberation
    vec4 clr = vec4(
        texture2D(gm_BaseTexture, (uv-.5)*CA_AMT+.5).r,
        texture2D(gm_BaseTexture, uv).g,
        texture2D(gm_BaseTexture, (uv-.5)/CA_AMT+.5).b,
        1
    )*edge.x*edge.y;
    
    //lines
    if(mod(uv.y, PIXEL_SIZE)<PIXEL_SIZE/2.) clr.rgb*=.9;
    //else if(mod(v_vTexcoord.x, 1.5)<1.) clr.rgb*=.7;
    else clr*=1.01;
        
    // clr = vec4(mod(v_vTexcoord.y, .01)*100.);
    // float amt = 0.01;
    // int count = 6;
    // for (int i = 0; i < count; i++) {
    // clr += blurDirection(uv, amt, vec2(1., 0.), count);
    // clr += blurDirection(uv, amt, vec2(-1., 0.), count);
    // clr += blurDirection(uv, amt, vec2(0., 1.), count);
    // clr += blurDirection(uv, amt, vec2(0., -1.), count);
    // clr += blurDirection(uv, amt, vec2(1., 1.), count);
    // clr += blurDirection(uv, amt, vec2(1., -1.), count);
    // clr += blurDirection(uv, amt, vec2(-1., 1.), count);
    // clr += blurDirection(uv, amt, vec2(-1., -1.), count);
    // }
    
    float PI = 6.28318530718; // PI * 2
    
    // Blur
    vec4 blurClr = clr;
    float directions = 8.;
    float quality = 4.0;
    float size = 1.;
    
    vec2 radius = size / vec2(240, 135);
    
    for (float d = 0.0; d < PI; d += PI / directions) {
        for (float i = 1.0/quality; i <= 1.0; i += 1.0 / quality) {
            blurClr += texture2D(gm_BaseTexture, uv + vec2(cos(d), sin(d)) * radius * i);
        }
    }
    
    blurClr /= quality * directions - 10.0;
    clr = mix(clr, blurClr, 0.35);
    
    gl_FragColor = v_vColour * clr;
}
