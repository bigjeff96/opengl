package Opengl

import "core:fmt"
import "core:os"
import "vendor:glfw"
import gl "vendor:opengl"

main :: proc() {
    glfw.Init()
    defer glfw.Terminate()

    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    window := glfw.CreateWindow(800, 600, "LearnOpenGL", nil, nil)
    if (window == nil)
    {
        fmt.println("Failed to create window")
        os.exit(1)
    }
    glfw.MakeContextCurrent(window)

    gl.load_up_to(3, 3, glfw.gl_set_proc_address)

    gl.Viewport(0, 0, 800, 600)

    for !glfw.WindowShouldClose(window) {
        process_inputs(window)

        gl.ClearColor(0.2, 0.3, 0.3, 1)
        gl.Clear(gl.COLOR_BUFFER_BIT)

        glfw.SwapBuffers(window)
        glfw.PollEvents()
    }
}

process_inputs :: proc(window: glfw.WindowHandle) {
    if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS do glfw.SetWindowShouldClose(window, true)
}
