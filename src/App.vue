<template>
  <GLCanvas ref="canvas" />
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import GLCanvas from "@/components/GLCanvas.vue";
import { vec2 } from "gl-matrix";
import shaderVert from "ts-shader-loader!@/assets/shaders/shader.vert";
import shaderFrag from "ts-shader-loader!@/assets/shaders/shader.frag";

@Options({
  components: {
    GLCanvas
  }
})
export default class App extends Vue {
  private viewport: vec2 = vec2.create();
  private glProgram: WebGLProgram | null = null;

  public mounted(): void {
    window.addEventListener("resize", this.handleResize);
    this.buildGLPipeline();
    this.handleResize();
  }

  public beforeDestroy(): void {
    window.removeEventListener("resize", this.handleResize);
  }

  public handleResize(): void {
    this.viewport = (this.$refs.canvas as GLCanvas).resize();
    this.renderGLPipeline();
  }

  private buildGLPipeline(): void {
    const gl: WebGLRenderingContext = (this.$refs.canvas as GLCanvas).glContext;

    gl.clearColor(0.2, 0.2, 0.2, 1.0);

    /*
     * Create and compile the vertex shader
     */
    const glVertexShader: WebGLShader | null = gl.createShader(
      gl.VERTEX_SHADER
    );
    if (glVertexShader === null) {
      throw new Error("Failed to create WebGL vertex shader");
    }

    gl.shaderSource(glVertexShader, shaderVert);
    gl.compileShader(glVertexShader);

    if (!gl.getShaderParameter(glVertexShader, gl.COMPILE_STATUS)) {
      throw new Error(
        "Failed to compile vertex shader: " +
          gl.getShaderInfoLog(glVertexShader)
      );
    }

    /*
     * Create and compile the fragment shader
     */
    const glFragmentShader: WebGLShader | null = gl.createShader(
      gl.FRAGMENT_SHADER
    );
    if (glFragmentShader === null) {
      throw new Error("Failed to create WebGL fragment shader");
    }

    gl.shaderSource(glFragmentShader, shaderFrag);
    gl.compileShader(glFragmentShader);

    if (!gl.getShaderParameter(glFragmentShader, gl.COMPILE_STATUS)) {
      throw new Error(
        "Failed to compile fragment shader: " +
          gl.getShaderInfoLog(glVertexShader)
      );
    }

    /*
     * Create and link the program using the compiled shaders
     */
    const program: WebGLProgram | null = gl.createProgram();
    if (program === null) {
      throw new Error("Failed to create WebGL program");
    }

    gl.attachShader(program, glVertexShader);
    gl.attachShader(program, glFragmentShader);
    gl.linkProgram(program);

    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
      throw new Error(
        "Failed to link program: " + gl.getProgramInfoLog(program)
      );
    }
    this.glProgram = program;

    // Shaders no longer need to remain attached
    gl.detachShader(program, glVertexShader);
    gl.detachShader(program, glFragmentShader);
  }

  private renderGLPipeline(): void {
    const gl: WebGLRenderingContext = (this.$refs.canvas as GLCanvas).glContext;

    /* tslint:disable:no-bitwise */
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    /* tslint:enable:no-bitwise */
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);

    gl.useProgram(this.glProgram);
    gl.drawArrays(gl.POINTS, 0, 1);

    gl.useProgram(null);
  }
}
</script>

<style>
html,
body {
  width: 100%;
  height: 100%;
  padding: 0;
  margin: 0;
  overflow: hidden;
}
#app {
  width: 100%;
  height: 100%;
  padding: 0;
  margin: 0;
  overflow: hidden;
}
</style>
