package Opengl

import "core:fmt"
import "core:os"
import "vendor:glfw"
import gl "vendor:OpenGL"

print :: fmt.println

vertex_shader_code := #load("vertex_shader.glsl", cstring)
fragment_shader_code := #load("fragment_shader.glsl", cstring)

main :: proc() {
    glfw.Init()
    defer glfw.Terminate()

    glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
    glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 3)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)
    glfw.WindowHint(glfw.FLOATING, glfw.TRUE)
    glfw.WindowHint(glfw.RESIZABLE, glfw.FALSE)

    window := glfw.CreateWindow(800, 600, "LearnOpenGL", nil, nil)
    if (window == nil)
    {
        fmt.println("Failed to create window")
        os.exit(1)
    }
    defer glfw.DestroyWindow(window)

    glfw.MakeContextCurrent(window)

    gl.load_up_to(3, 3, glfw.gl_set_proc_address)

    gl.Viewport(0, 0, 800, 600)

    nrAttributes : i32 = 0
    gl.GetIntegerv(gl.MAX_VERTEX_ATTRIBS, &nrAttributes)
    print(nrAttributes)

    vertex_shader, fragment_shader, shader_program : u32
    {
        vertex_shader = gl.CreateShader(gl.VERTEX_SHADER)
        gl.ShaderSource(vertex_shader, 1, &vertex_shader_code, nil)
        gl.CompileShader(vertex_shader)

        check_shader_compilation(vertex_shader)

        fragment_shader = gl.CreateShader(gl.FRAGMENT_SHADER)
        gl.ShaderSource(fragment_shader, 1, &fragment_shader_code, nil)
        gl.CompileShader(fragment_shader)

        check_shader_compilation(fragment_shader)

        shader_program = gl.CreateProgram()
        gl.AttachShader(shader_program, vertex_shader)
        gl.AttachShader(shader_program, fragment_shader)
        gl.LinkProgram(shader_program)

        check_shader_program_linking(shader_program)
    }
    defer gl.DeleteShader(vertex_shader)
    defer gl.DeleteShader(fragment_shader)

    vertices := [9]f32{
        -0.5, -0.5, 0.0,
         0.5, -0.5, 0.0,
         0.0,  0.5, 0.0
    }

    VBO : u32
    VAO : u32
    gl.GenVertexArrays(1, &VAO)
    gl.GenBuffers(1, &VBO)

    gl.BindVertexArray(VAO)
    gl.BindBuffer(gl.ARRAY_BUFFER, VBO)
    gl.BufferData(gl.ARRAY_BUFFER, size_of(vertices), &vertices[0], gl.STATIC_DRAW)

    gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * size_of(f32), 0)
    gl.EnableVertexAttribArray(0)

    for !glfw.WindowShouldClose(window) {
        process_inputs(window)

        gl.ClearColor(0.2, 0.3, 0.3, 1)
        gl.Clear(gl.COLOR_BUFFER_BIT)

        gl.UseProgram(shader_program)
        gl.BindVertexArray(VAO)
        gl.DrawArrays(gl.TRIANGLES, 0, 3)

        glfw.SwapBuffers(window)
        glfw.PollEvents()
    }
}

process_inputs :: proc(window: glfw.WindowHandle) {
    if glfw.GetKey(window, glfw.KEY_ESCAPE) == glfw.PRESS do glfw.SetWindowShouldClose(window, true)
    if glfw.GetKey(window, glfw.KEY_Q) == glfw.PRESS do glfw.SetWindowShouldClose(window, true)
}

check_shader_compilation :: proc(shader: u32) {
    success : i32
    info_log : [512]byte
    gl.GetShaderiv(shader, gl.COMPILE_STATUS, &success);

    if success == 0 {
        gl.GetShaderInfoLog(shader, len(info_log), nil, &info_log[0]);
        info_log_string := string(info_log[:])
        fmt.println(info_log_string)
        os.exit(1)
    }
}

check_shader_program_linking :: proc(shader_program: u32) {
    success : i32
    info_log : [512]byte
    gl.GetProgramiv(shader_program, gl.LINK_STATUS, &success)
    if success == 0 {
        gl.GetProgramInfoLog(shader_program, len(info_log), nil, &info_log[0]);
        fmt.println(string(info_log[:]))
    }
}