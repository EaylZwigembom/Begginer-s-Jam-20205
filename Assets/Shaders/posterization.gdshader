shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// Posterization parameters
uniform float RED_COMPONENT : hint_range(1, 256) = 8.0;
uniform float GREEN_COMPONENT : hint_range(1, 256) = 8.0;
uniform float BLUE_COMPONENT : hint_range(1, 256) = 8.0;
uniform float SCREEN_WIDTH : hint_range(1, 1920) = 320.0;

// Glitch parameters
uniform float _ScanLineJitter : hint_range(.2, 1) = .25;
uniform float _VerticalJump : hint_range(0, 1) = .01;
uniform float _HorizontalShake : hint_range(0, 1) = 0.0;
uniform float _ColorDrift : hint_range(0, 1) = .02;

float nrand(float x, float y){
    return fract(sin(dot(vec2(x, y), vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment(){
    vec2 pixel_size = SCREEN_PIXEL_SIZE;
	vec2 screen_res = vec2(SCREEN_WIDTH, SCREEN_WIDTH / (1.0 / SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x));
    vec2 size = screen_res * pixel_size / pixel_size.x;
    vec2 uv_base = floor(UV * size);
    vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy;

    // ========== GLITCH EFFECT ==========
    float sl_thresh = dot(vec2(1.0 - _ScanLineJitter * 1.2), vec2(1.0 - _ScanLineJitter * 1.2));
    float sl_disp = 0.002 + pow(_ScanLineJitter, 3.0) * 0.05;
    vec2 sl = vec2(sl_disp, sl_thresh);

    float _verticalJumpTime = TIME * _VerticalJump * 11.3;
    vec2 vj = vec2(_VerticalJump, _verticalJumpTime);

    float hs = _HorizontalShake * 0.2;
    vec2 cd = vec2(_ColorDrift * 0.04, TIME * 606.11);

    float u = FRAGCOORD.x / (1.0 / SCREEN_PIXEL_SIZE).x;
    float v = FRAGCOORD.y / (1.0 / SCREEN_PIXEL_SIZE).y;

    float jitter = nrand(v, TIME) * 2.0 - 1.0;
    jitter *= step(sl.y, abs(jitter)) * sl.x;
    float jump = mix(v, fract(v + vj.y), vj.x);
    float shake = (nrand(TIME, 2.0) - 0.5) * hs;
    float drift = sin(jump + cd.y) * cd.x;

    vec2 glitch_uv1 = fract(vec2(u + jitter + shake, jump));
    vec2 glitch_uv2 = fract(vec2(u + jitter + shake + drift, jump));

    vec4 final1 = texture(SCREEN_TEXTURE, glitch_uv1);
    vec4 final2 = texture(SCREEN_TEXTURE, glitch_uv2);
    vec3 col = vec3(final1.r, final2.g, final1.b);

    // ========== POSTERIZATION ==========
    col.r = floor(col.r * RED_COMPONENT) / RED_COMPONENT;
    col.g = floor(col.g * GREEN_COMPONENT) / GREEN_COMPONENT;
    col.b = floor(col.b * BLUE_COMPONENT) / BLUE_COMPONENT;

    COLOR = vec4(col, 1.0);
}
