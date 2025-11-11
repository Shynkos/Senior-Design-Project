shader_type canvas_item;
render_mode blend_mix;

uniform vec4 Color : source_color = vec4(0.000000, 0.000000, 0.000000, 0.000000);
uniform float Progress : hint_range(0.0, 1.0);



void fragment() {
	vec4 n_out4p0;
// Texture2D:4
	n_out4p0 = texture(TEXTURE, UV);


// ColorParameter:2
	vec4 n_out2p0 = Color;


// FloatParameter:6
	float n_out6p0 = Progress;


// Mix:5
	vec4 n_out5p0 = mix(n_out4p0, n_out2p0, vec4(n_out6p0));


// Output:0
	COLOR.rgb = vec3(n_out5p0.xyz);


}
