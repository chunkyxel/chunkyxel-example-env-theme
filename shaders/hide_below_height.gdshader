// Hides any 3D object while the camera is below `cut_height` (world units), like the island and sea of Chunkyxel's
// default Sand island environment. Assign it as a ShaderMaterial to any MeshInstance3D / CSG node: no group needed.
//
//   veil_alpha = 0.0  -> the object disappears completely under the cut (like the island)
//   veil_alpha > 0.0  -> it stays as a faint veil (like the water seen from below)
//
// Note: writing ALPHA makes Godot draw the object in the transparent pass (sorted by depth, no shadows). If you only need
// "hidden or visible", the group `chunkyxel_ground` + root metadata `chunkyxel_ground_cut` does the same with no shader.
shader_type spatial;
render_mode depth_draw_opaque;

uniform vec4 albedo_color : source_color = vec4(0.82, 0.72, 0.5, 1.0);
uniform sampler2D albedo_texture : source_color, filter_linear_mipmap, repeat_enable;
uniform float cut_height = 0.0;   // world height of the surface; below it the object is hidden
uniform float veil_alpha = 0.0;   // 0 = fully hidden under the cut

void fragment() {
	bool camera_below = CAMERA_POSITION_WORLD.y < cut_height;
	if (camera_below && veil_alpha <= 0.0) {
		discard;
	}
	vec4 base = albedo_color * texture(albedo_texture, UV);
	ALBEDO = base.rgb;
	ALPHA = camera_below ? veil_alpha : base.a;
}
