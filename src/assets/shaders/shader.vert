#version 100
precision highp float;
precision highp int;

attribute vec3 position;

varying vec3 pos;

void main() {
  pos = position;
  gl_Position = vec4(position, 1.0);
}
