shader_type canvas_item;

uniform float shine_t;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	float brightness = abs(UV.x - shine_t) / TEXTURE_PIXEL_SIZE.x;
	brightness = clamp(64.0 - brightness, 0.0, 64.0);
	brightness = (brightness / 64.0);
	brightness *= brightness;
	
	COLOR = mix(COLOR, vec4(1.0), brightness);
	
}