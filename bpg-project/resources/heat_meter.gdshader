shader_type canvas_item;

uniform float scroll_speed : hint_range(0.0, 4.0) = 0.5;
uniform float cell_size : hint_range(4.0, 80.0) = 5.0;
uniform float min_radius : hint_range(0.02, 0.5) = 0.08;
uniform float max_radius : hint_range(0.02, 0.5) = 0.38;
uniform float darken : hint_range(0.0, 1.0) = 0.75;
uniform float grid_rotation : hint_range(0.0, 360.0) = 35.0;
uniform float move_angle : hint_range(0.0, 360.0) = 180.0;

varying vec2 v_pixel;

void vertex() {
	v_pixel = VERTEX;
}

void fragment() {
	vec4 base = texture(TEXTURE, UV);

	float rot = radians(grid_rotation);
	mat2 rot_mat = mat2(vec2(cos(rot), -sin(rot)), vec2(sin(rot), cos(rot)));
	vec2 pattern = v_pixel * rot_mat;

	float move = radians(move_angle);
	vec2 dir = vec2(cos(move), sin(move));
	pattern += dir * TIME * scroll_speed * 60.0;

	vec2 cell = fract(pattern / cell_size) - 0.5;
	float dist = length(cell);

	float radius = mix(min_radius, max_radius, UV.x);
	float dot_mask = 1.0 - smoothstep(radius - 0.02, radius, dist);

	vec4 dot_color = vec4(base.rgb * darken, base.a);
	COLOR = mix(base, dot_color, dot_mask);
}