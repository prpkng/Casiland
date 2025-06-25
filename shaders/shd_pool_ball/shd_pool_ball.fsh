//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int color_count;
uniform int pallete_count;
uniform int pallete_index;

uniform sampler2D color_pallete;


void main()
{
    vec4 clr = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    
    float idx = clr.r * float(color_count);
    
    vec3 pallete_clr = texture2D(color_pallete, vec2(idx / float(color_count), float(pallete_index) / float(pallete_count))).rgb;
    
    gl_FragColor.rgb = pallete_clr;
    gl_FragColor.a = clr.a;
}
