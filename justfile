
build:
    odin build src/ -use-separate-modules -debug -out:build/opengl.exe

run: build
    ./build/opengl.exe