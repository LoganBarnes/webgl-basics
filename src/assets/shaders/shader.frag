#version 100
precision highp float;
precision highp int;

varying vec3 pos;

void main() {
  gl_FragColor = vec4(pos.xy, 0.5, 1.0);
}
