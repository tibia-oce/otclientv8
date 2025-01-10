# Build options
if(CMAKE_BASE_NAME STREQUAL "em++")
    set(WASM ON)
endif()

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

# Framework options
option(FRAMEWORK_SOUND "Use SOUND" OFF)
option(FRAMEWORK_GRAPHICS "Use GRAPHICS" ON)
option(FRAMEWORK_XML "Use XML" ON)
option(FRAMEWORK_NET "Use NET" ON)
option(FRAMEWORK_THREAD_SAFE "Enable thread safety" OFF)

# Other options
option(LUAJIT "Use lua jit" ON)
if(NOT APPLE)
    option(CRASH_HANDLER "Generate crash reports" ON)
    option(USE_STATIC_LIBS "Don't use shared libraries (dlls)" ON)
    option(USE_LIBCPP "Use the new libc++ library instead of stdc++" OFF)
    option(USE_LTO "Use link time optimizations" OFF)
else()
    set(CRASH_HANDLER OFF)
    set(USE_STATIC_LIBS ON)
    set(USE_LIBCPP ON)
endif()

set(BUILD_COMMIT "devel" CACHE STRING "Git commit string (intended for releases)")
set(BUILD_REVISION 0 CACHE STRING "Git revision string (intended for releases)")

if(FRAMEWORK_GRAPHICS)
    set(OPENGLES "OFF" CACHE STRING "Use OpenGL ES 1.0 or 2.0 (for mobiles devices)")
    set(OpenGL_GL_PREFERENCE "LEGACY")
endif()

if(APPLE)
    set(CRASH_HANDLER OFF)
    set(USE_STATIC_LIBS ON)
    set(USE_LIBCPP ON)
    set(USE_SDL2 ON)
endif()
