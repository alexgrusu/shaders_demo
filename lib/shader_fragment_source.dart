class ShaderFragmentSource {
  static const String baseVertexFrag = '''
            #version 300 es
            precision highp float;
            precision mediump sampler2D;

            in vec2 aPosition;
            out vec2 vUv;
            out vec2 vL;
            out vec2 vR;
            out vec2 vT;
            out vec2 vB;
            uniform vec2 texelSize;

            void main () {
              vUv = aPosition * 0.5 + 0.5;
              vL = vUv - vec2(texelSize.x, 0.0);
              vR = vUv + vec2(texelSize.x, 0.0);
              vT = vUv + vec2(0.0, texelSize.y);
              vB = vUv - vec2(0.0, texelSize.y);
              gl_Position = vec4(aPosition, 0.0, 1.0);
            }
            ''';

  static const String clearFrag = '''
            #version 300 es
            precision highp float;
            precision mediump sampler2D;

            layout(location = 0) out vec2 vUv;
            layout(location = 1) out vec4 fragColor;
            uniform sampler2D uTexture;
            uniform float value;

            void main () {
              fragColor = value * texture(uTexture, vUv);
            }
            ''';

  static const String displayFrag = '''
            #version 300 es
            precision highp float;
            precision mediump sampler2D;

            float amount = 0.1;
            float smoothAmount = 0.2;

            layout(location = 0) out vec2 vUv;
            uniform sampler2D uTexture;
            uniform float uAmount;
            layout(location = 1) out vec4 fragColor;

            float random(vec2 p) {
              vec2 K1 = vec2(
                23.14069263277926, // e^pi (Gelfond's constant)
                2.665144142690225 // 2^sqrt(2) (Gelfond\u2013Schneider constant)
              );
              return fract(cos(dot(p, K1)) * 12345.6789);
            }

            vec3 black = vec3(0.0);

            void main() {
              vec4 color = texture(uTexture, vUv);
              vec2 uvRandom = vUv;
              float c = clamp(smoothAmount, 0.0, 1.0);

              uvRandom.y *= random(vec2(uvRandom.y));
              color.rgb += random(uvRandom) * 0.055 * uAmount;

              fragColor = vec4(mix(color.rgb, black, smoothAmount), amount);
            }
            ''';

  static const String splatFrag = '''
            #version 300 es
            precision highp float;
            precision mediump sampler2D;

            layout(location = 0) out vec2 vUv;
            uniform sampler2D uTarget;
            uniform float aspectRatio;
            uniform vec3 color;
            uniform vec2 point;
            uniform float radius;
            uniform float opacity;
            layout(location = 1) out vec4 fragColor;

            void main () {
              vec2 p = vUv - point.xy;
              p.x *= aspectRatio;
              vec3 splat = exp(-dot(p, p) / radius) * color * opacity;
              vec3 base = texture(uTarget, vUv).xyz;
              fragColor = vec4(base + splat, 1.0);
            }
            ''';

  static const String advectionManualFiltering = '''
            #version 300 es
            precision highp float;
            precision mediump sampler2D;

            layout(location = 0) out vec2 vUv;
            uniform sampler2D uVelocity;
            uniform sampler2D uSource;
            uniform vec2 texelSize;
            uniform float dt;
            uniform float dissipation;
            layout(location = 1) out vec4 fragColor;

            vec4 bilerp (in sampler2D sam, in vec2 p) {
              vec4 st;
              st.xy = floor(p - 0.5) + 0.5;
              st.zw = st.xy + 1.0;
              vec4 uv = st * texelSize.xyxy;
              vec4 a = texture(sam, uv.xy);
              vec4 b = texture(sam, uv.zy);
              vec4 c = texture(sam, uv.xw);
              vec4 d = texture(sam, uv.zw);
              vec2 f = p - st.xy;
              return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
            }

            void main () {
              vec2 coord = gl_FragCoord.xy - dt * texture(uVelocity, vUv).xy;
              fragColor = dissipation * bilerp(uSource, coord);
              fragColor.a = 1.0;
            }
            ''';

  static const String advectionFrag = '''
          #version 300 es
          
          precision highp float;
          precision mediump sampler2D;

          in vec2 vUv;
          uniform sampler2D uVelocity;
          uniform sampler2D uSource;
          uniform vec2 texelSize;
          uniform float dt;
          uniform float dissipation;

          out vec4 fragColor;

          void main() {
            vec2 coord = vUv - dt * texture(uVelocity, vUv).xy * texelSize;
            fragColor = dissipation * texture(uSource, coord);
            fragColor.a = 1.0;
          }
          ''';

  static const String divergenceFrag = '''
          #version 300 es
          precision highp float;
          precision mediump sampler2D;

          layout(location = 0) out vec2 vUv;
          layout(location = 1) out vec2 vL;
          layout(location = 2) out vec2 vR;
          layout(location = 3) out vec2 vT;
          layout(location = 4) out vec2 vB;
          layout(location = 5) out vec4 fragColor;
          uniform sampler2D uVelocity;

          vec2 sampleVelocity (in vec2 uv) {
            vec2 multiplier = vec2(1.0, 1.0);
            if (uv.x < 0.0) { uv.x = 0.0; multiplier.x = -1.0; }
            if (uv.x > 1.0) { uv.x = 1.0; multiplier.x = -1.0; }
            if (uv.y < 0.0) { uv.y = 0.0; multiplier.y = -1.0; }
            if (uv.y > 1.0) { uv.y = 1.0; multiplier.y = -1.0; }
            return multiplier * texture(uVelocity, uv).xy;
          }

          void main () {
            float L = sampleVelocity(vL).x;
            float R = sampleVelocity(vR).x;
            float T = sampleVelocity(vT).y;
            float B = sampleVelocity(vB).y;
            float div = 0.5 * (R - L + T - B);
            fragColor = vec4(div, 0.0, 0.0, 1.0);
          }
          ''';

  static const String curlFrag = '''
          #version 300 es
          precision highp float;
          precision mediump sampler2D;

          layout(location = 0) out vec2 vUv;
          layout(location = 1) out vec2 vL;
          layout(location = 2) out vec2 vR;
          layout(location = 3) out vec2 vT;
          layout(location = 4) out vec2 vB;
          uniform sampler2D uVelocity;
          layout(location = 5) out vec4 fragColor;

          void main () {
            float L = texture(uVelocity, vL).y;
            float R = texture(uVelocity, vR).y;
            float T = texture(uVelocity, vT).x;
            float B = texture(uVelocity, vB).x;
            float vorticity = R - L - T + B;
            fragColor = vec4(vorticity, 0.0, 0.0, 1.0);
          }
          ''';

  static const String vorticityFrag = '''
          #version 300 es
          precision highp float;
          precision mediump sampler2D;

          layout(location = 0) out vec2 vUv;
          layout(location = 1) out vec2 vT;
          layout(location = 2) out vec2 vB;
          uniform sampler2D uVelocity;
          uniform sampler2D uCurl;
          uniform float curl;
          uniform float dt;
          layout(location = 3) out vec4 fragColor;

          void main () {
            float T = texture(uCurl, vT).x;
            float B = texture(uCurl, vB).x;
            float C = texture(uCurl, vUv).x;
            vec2 force = vec2(abs(T) - abs(B), 0.0);
            force *= 1.0 / length(force + 0.00001) * curl * C;
            vec2 vel = texture(uVelocity, vUv).xy;
            fragColor = vec4(vel + force * dt, 0.0, 1.0);
          }
          ''';

  static const String pressureFrag = '''
          #version 300 es
          precision highp float;
          precision mediump sampler2D;

          layout(location = 0) out vec2 vUv;
          layout(location = 1) out vec2 vL;
          layout(location = 2) out vec2 vR;
          layout(location = 3) out vec2 vT;
          layout(location = 4) out vec2 vB;
          uniform sampler2D uPressure;
          uniform sampler2D uDivergence;
          layout(location = 5) out vec4 fragColor;

          vec2 boundary (in vec2 uv) {
            uv = min(max(uv, 0.0), 1.0);
            return uv;
          }

          void main () {
            float L = texture(uPressure, boundary(vL)).x;
            float R = texture(uPressure, boundary(vR)).x;
            float T = texture(uPressure, boundary(vT)).x;
            float B = texture(uPressure, boundary(vB)).x;
            float C = texture(uPressure, vUv).x;
            float divergence = texture(uDivergence, vUv).x;
            float pressure = (L + R + B + T - divergence) * 0.25;
            fragColor = vec4(pressure, 0.0, 0.0, 1.0);
          }
          ''';

  static const String gradientSubtractFrag = '''
          #version 300 es
          precision highp float;
          precision mediump sampler2D;

          layout(location = 0) out vec2 vUv;
          layout(location = 1) out vec2 vL;
          layout(location = 2) out vec2 vR;
          layout(location = 3) out vec2 vT;
          layout(location = 4) out vec2 vB;
          uniform sampler2D uPressure;
          uniform sampler2D uVelocity;
          layout(location = 5) out vec4 fragColor;

          vec2 boundary (in vec2 uv) {
            uv = min(max(uv, 0.0), 1.0);
            return uv;
          }

          void main () {
            float L = texture(uPressure, boundary(vL)).x;
            float R = texture(uPressure, boundary(vR)).x;
            float T = texture(uPressure, boundary(vT)).x;
            float B = texture(uPressure, boundary(vB)).x;
            vec2 velocity = texture(uVelocity, vUv).xy;
            velocity.xy -= vec2(R - L, T - B);
            fragColor = vec4(velocity, 0.0, 1.0);
          }
          ''';
}
