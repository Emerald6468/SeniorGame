shader_type canvas_item;

// Full-screen damage/hurt vignette — pulsing blood-red edges.
// Put this on a ColorRect sized to cover the whole screen (Full Rect anchor,
// Mouse Filter = Ignore so it doesn't block clicks on anything underneath).

uniform vec4 blood_color : source_color = vec4(0.55, 0.0, 0.0, 1.0);
uniform float size : hint_range(0.0, 0.5) = 0.22;        // how far inward from the edges the effect reaches
uniform float softness : hint_range(0.0, 1.0) = 0.6;      // 0 = hard edge, 1 = very gradual fade
uniform float roughness : hint_range(0.0, 1.0) = 0.35;    // how ragged/vein-like the inner edge looks
uniform float pulse_speed : hint_range(0.0, 10.0) = 1.8;  // pulses per second-ish
uniform float pulse_amount : hint_range(0.0, 1.0) = 0.5;  // how strongly it pulses (0 = steady, 1 = full fade in/out)
uniform float max_alpha : hint_range(0.0, 1.0) = 0.85;    // overall intensity cap

float rand(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float value_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));
	vec2 u = smoothstep(0.0, 1.0, f);
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void fragment() {
	// Distance from this pixel to the nearest screen edge: 0 at the border,
	// up to 0.5 at dead center.
	vec2 edge_dist = min(UV, vec2(1.0) - UV);
	float edge = min(edge_dist.x, edge_dist.y);

	// Slowly shifting organic noise so the inner boundary looks ragged and
	// alive instead of a perfect rounded rectangle.
	float n = value_noise(UV * 6.0 + vec2(0.0, TIME * 0.05));
	edge += (n - 0.5) * roughness * size;

	float soft_start = size * (1.0 - softness);
	float vignette = clamp(1.0 - smoothstep(soft_start, size, edge), 0.0, 1.0);

	// Smooth pulse — strength controlled by pulse_amount, rate by pulse_speed.
	float pulse = 1.0 - pulse_amount + pulse_amount * (sin(TIME * pulse_speed * TAU) * 0.5 + 0.5);

	// Subtle mottling using the same noise field, so the red isn't perfectly flat.
	vec3 mottled_color = blood_color.rgb * (0.85 + 0.3 * n);

	float alpha = vignette * pulse * max_alpha * blood_color.a;
	COLOR = vec4(mottled_color, alpha);
}