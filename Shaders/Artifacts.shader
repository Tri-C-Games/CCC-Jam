shader_type canvas_item;

uniform sampler2D artifact_noise_texture : hint_black;
uniform sampler2D simplex_noise_texture : hint_black;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
	vec2 simplex_noise_offset = vec2(0.0);//vec2(clamp(tan(TIME), -0.5, 0.5), clamp(tan(TIME), -0.5, 0.5));
	vec4 artifact_noise = texture(artifact_noise_texture, UV);
	vec4 simplex_noise = texture(simplex_noise_texture, UV + simplex_noise_offset);
	
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	int freq = 3;
	if (simplex_noise.r > 0.5 && int(UV.x * 100.0) % freq == 0 && int(UV.y * 100.0) % freq == 0) {
		COLOR = artifact_noise;
		COLOR.a = 0.8;
	}
}