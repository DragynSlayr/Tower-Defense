extern float health = 1;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  vec4 pixel = Texel(texture, texture_coords);
  return color * pixel * vec4(1, health, health, 1);
}
