precision highp float;
precision mediump sampler2D;

float amount = 0.1;
float smoothAmount = 0.2;

varying vec2 vUv;
uniform sampler2D uTexture;
uniform float uAmount;

float random(vec2 p) {
  vec2 K1 = vec2(
    23.14069263277926, // e^pi (Gelfond's constant)
    2.665144142690225 // 2^sqrt(2) (Gelfond\u2013Schneider constant)
  );
  return fract(cos(dot(p, K1)) * 12345.6789);
}

vec3 black = vec3(0.0);

void main() {
  vec4 color = texture2D(uTexture, vUv);
  vec2 uvRandom = vUv;
  float c = clamp(smoothAmount, 0.0, 1.0);

  uvRandom.y *= random(vec2(uvRandom.y));
  color.rgb += random(uvRandom) * 0.055 * uAmount;

  gl_FragColor = vec4(mix(color.rgb, black, smoothAmount), amount);
}
