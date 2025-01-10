# Setup module path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/modules")

# Required packages
set(REQUIRED_BOOST_COMPONENTS system filesystem)
set(Boost_USE_MULTITHREADED ON)
set(Boost_USE_STATIC_LIBS ${USE_STATIC_LIBS})
find_package(Boost 1.67.0 COMPONENTS ${REQUIRED_BOOST_COMPONENTS} REQUIRED)

find_package(LibZip REQUIRED)
find_package(ZLIB REQUIRED)
find_package(BZip2 REQUIRED)
find_package(PhysFS REQUIRED)
find_package(OpenSSL REQUIRED)

# Find Lua/LuaJIT
if(LUAJIT)
    find_package(LuaJIT REQUIRED)
    set(LUA_INCLUDE_DIR ${LUAJIT_INCLUDE_DIR})
    set(LUA_LIBRARY ${LUAJIT_LIBRARY})
else()
    find_package(Lua REQUIRED)
endif()

# Setup framework libraries
set(framework_LIBRARIES
    ${Boost_LIBRARIES}
    ${LUA_LIBRARY}
    ${PHYSFS_LIBRARY}
    ${OPENSSL_LIBRARIES}
    ${ZLIB_LIBRARY}
    ${LIBZIP_LIBRARY}
    ${BZIP2_LIBRARIES}
)

# Graphics dependencies
if(FRAMEWORK_GRAPHICS)
    if(OPENGLES STREQUAL "2.0")
        find_package(OpenGLES2 REQUIRED)
        find_package(EGL REQUIRED)
        list(APPEND framework_LIBRARIES ${EGL_LIBRARY} ${OPENGLES2_LIBRARY})
    elseif(OPENGLES STREQUAL "1.0")
        find_package(OpenGLES1 REQUIRED)
        find_package(EGL REQUIRED)
        list(APPEND framework_LIBRARIES ${EGL_LIBRARY} ${OPENGLES1_LIBRARY})
    else()
        find_package(OpenGL REQUIRED)
        find_package(GLEW REQUIRED)
        list(APPEND framework_LIBRARIES ${GLEW_LIBRARY} ${OPENGL_LIBRARIES})
    endif()
endif()

# Sound dependencies
if(FRAMEWORK_SOUND)
    find_package(OpenAL REQUIRED)
    find_package(VorbisFile REQUIRED)
    find_package(Vorbis REQUIRED)
    find_package(Ogg REQUIRED)
    list(APPEND framework_LIBRARIES ${OPENAL_LIBRARY} ${VORBISFILE_LIBRARY} ${VORBIS_LIBRARY} ${OGG_LIBRARY})
endif()

# Platform specific libraries
if(WIN32)
    list(APPEND framework_LIBRARIES bcrypt dbghelp shlwapi iphlpapi psapi)
elseif(UNIX AND NOT APPLE)
    list(APPEND framework_LIBRARIES dl rt)
endif()
if(UNIX AND NOT APPLE AND NOT WASM)
    find_package(X11 REQUIRED)
    list(APPEND framework_LIBRARIES ${X11_LIBRARIES})
    list(APPEND framework_INCLUDE_DIRS ${X11_INCLUDE_DIR})
endif()

# Framework includes
set(framework_INCLUDE_DIRS
    ${Boost_INCLUDE_DIRS}
    ${LUA_INCLUDE_DIR}
    ${PHYSFS_INCLUDE_DIR}
    ${OPENSSL_INCLUDE_DIR}
    ${LIBZIP_INCLUDE_DIR_ZIP}
    ${LIBZIP_INCLUDE_DIR_ZIPCONF}
    ${ZLIB_INCLUDE_DIR}
    ${BZIP2_INCLUDE_DIR}
)

# Graphics-specific includes
if(FRAMEWORK_GRAPHICS)
    if(OPENGLES)
        list(APPEND framework_INCLUDE_DIRS ${EGL_INCLUDE_DIR} ${OPENGLES2_INCLUDE_DIR})
    endif()
endif()

# Sound-specific includes
if(FRAMEWORK_SOUND)
    list(APPEND framework_INCLUDE_DIRS ${OPENAL_INCLUDE_DIR} ${VORBISFILE_INCLUDE_DIR})
endif()
