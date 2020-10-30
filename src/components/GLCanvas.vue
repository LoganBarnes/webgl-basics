<template>
  <canvas id="canvas" tabindex="1">
    HTML5 canvas is not supported in this browser :(
  </canvas>
</template>

<script lang="ts">
import { Vue } from "vue-class-component";
import { vec2 } from "gl-matrix";

export default class GLCanvas extends Vue {
  private gl: null | WebGLRenderingContext = null;

  /**
   * Initializes WebGL when the canvas is ready.
   */
  public mounted(): void {
    const canvas: HTMLCanvasElement = this.$el as HTMLCanvasElement;
    const options: WebGLContextAttributes = {
      antialias: false
    };
    const gl = canvas.getContext("webgl", options);

    if (!gl) {
      throw new Error("Failed to initialise WebGL");
    }
    this.gl = gl;

    canvas.focus();

    canvas.width = canvas.clientWidth;
    canvas.height = canvas.clientHeight;
  }

  /**
   * Adjust the canvas when the window is resized
   */
  public resize(): vec2 {
    const canvas: HTMLCanvasElement = this.$el as HTMLCanvasElement;
    canvas.width = canvas.clientWidth;
    canvas.height = canvas.clientHeight;

    return vec2.fromValues(canvas.width, canvas.height);
  }

  get glContext(): WebGLRenderingContext {
    return this.gl as WebGLRenderingContext;
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
canvas {
  /*fill container completely */
  width: 100%;
  height: 100%;
  background-color: black; /*ideally matches WebGL clear color*/
}
</style>
