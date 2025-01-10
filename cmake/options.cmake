# Set default build type
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release")
endif()

# Framework features
option(FRAMEWORK_SOUND "Enable sound support" OFF)
option(FRAMEWORK_GRAPHICS "Enable graphics support" ON)
option(FRAMEWORK_XML "Enable XML support" ON)
option(FRAMEWORK_NET "Enable network support" ON)
option(FRAMEWORK_THREAD_SAFE "Enable thread safety" OFF)

# Platform detection
if(CMAKE_BASE_NAME STREQUAL "em++")
    set(WASM ON)
endif()

# Common build options
option(LUAJIT "Use LuaJIT instead of Lua" ON)
option(USE_LTO "Enable Link Time Optimization" OFF)

# Platform-specific options
if(APPLE)
    set(CRASH_HANDLER OFF CACHE BOOL "Generate crash reports" FORCE)
    set(USE_STATIC_LIBS ON CACHE BOOL "Use static libraries" FORCE)
    set(USE_LIBCPP ON CACHE BOOL "Use libc++" FORCE)
    set(USE_SDL2 ON CACHE BOOL "Use SDL2" FORCE)
else()
    option(CRASH_HANDLER "Generate crash reports" ON)
    option(USE_STATIC_LIBS "Use static libraries" ON)
    option(USE_LIBCPP "Use libc++ instead of libstdc++" OFF)
endif()

# Graphics options
if(FRAMEWORK_GRAPHICS)
    set(OPENGLES "OFF" CACHE STRING "OpenGL ES version (OFF, 1.0, or 2.0)")
    set(OpenGL_GL_PREFERENCE "LEGACY")
endif()

set(BUILD_COMMIT "devel" CACHE STRING "Git commit for release builds")
set(BUILD_REVISION 0 CACHE STRING "Git revision for release builds")