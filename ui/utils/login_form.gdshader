shader_type canvas_item;
uniform sampler2D water: repeat_enable;
uniform float distortion_intencity = 1.0;
uniform vec2 distortion_tiling = vec2(1.0, 1.0);
uniform vec2 distortion_offset_speed= vec2(1.0, 1.0);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 base_uv = UV;
	vec2 noice_uv = UV * distortion_tiling + distortion_offset_speed  *  TIME;
	float noice_text = texture(water, noice_uv).r;
	vec2 distorion_uv = base_uv + noice_text * distortion_intencity;
	//vec4 tex = texture(TEXTURE, UV) * texture(water, UV+vec2(0.0,sin(TIME)));
	if (UV.y > 0.71) {
	COLOR = texture(TEXTURE, distorion_uv);
	}
	//clouds
	//if ((UV.y < 0.2) && (UV.x < 0.3)){
	//	COLOR = texture(TEXTURE, distorion_uv);
	//}
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
