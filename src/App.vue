<template>
  <GLCanvas ref="canvas" />
</template>

<script lang="ts">
import { Options, Vue } from "vue-class-component";
import GLCanvas from "./components/GLCanvas.vue";
import { vec2 } from "gl-matrix";

@Options({
  components: {
    GLCanvas
  }
})
export default class App extends Vue {
  private viewport: vec2 = vec2.create();

  public mounted(): void {
    window.addEventListener("resize", this.handleResize);
    this.handleResize();
    this.buildGLPipeline();
    this.renderGLPipeline();
  }

  public beforeDestroy(): void {
    window.removeEventListener("resize", this.handleResize);
  }

  public handleResize(): void {
    this.viewport = (this.$refs.canvas as GLCanvas).resize();
  }

  private buildGLPipeline(): void {
    const gl: WebGLRenderingContext = (this.$refs.canvas as GLCanvas).glContext;

    gl.clearColor(1.0, 0.5, 0.1, 1.0);
  }

  private renderGLPipeline(): void {
    const gl: WebGLRenderingContext = (this.$refs.canvas as GLCanvas).glContext;

    /* tslint:disable:no-bitwise */
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    /* tslint:enable:no-bitwise */
    gl.viewport(0, 0, gl.drawingBufferWidth, gl.drawingBufferHeight);
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
