# cmake/compiler.cmake

set(CMAKE_CXX_STANDARD 17)

# Warning flags
set(WARNS_FLAGS "-Wall -Wextra -Wno-unused -Wno-unused-parameter -Wno-unused-result")

# Add framework definitions first
if(FRAMEWORK_GRAPHICS)
    add_definitions(-DFW_GRAPHICS)
endif()
if(FRAMEWORK_SOUND)
    add_definitions(-DFW_SOUND)
endif()
if(FRAMEWORK_NET)
    add_definitions(-DFW_NET)
endif()
if(FRAMEWORK_XML)
    add_definitions(-DFW_XML)
endif()

if(WASM)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARNS_FLAGS} ${ARCH_FLAGS} -s USE_ZLIB=1 -s USE_LIBPNG=1 -s USE_SDL=2 -s USE_BOOST_HEADERS=1 -s USE_PTHREADS=1 -O1")
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${WARNS_FLAGS} ${ARCH_FLAGS} -pipe")
    set(CMAKE_CXX_FLAGS_COMPILESPEED "-O0")
    set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O1 -g -fno-omit-frame-pointer")
    set(CMAKE_CXX_FLAGS_RELEASE "-O2")
    set(CMAKE_CXX_FLAGS_PERFORMANCE "-Ofast -march=native")
endif()

# LTO settings
if(USE_LTO)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fwhole-program -flto")
    if(WIN32)
        set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -Wl,-O1,--gc-sections,--sort-common,--relax")
    else()
        set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -Wl,-O1,--gc-sections,--sort-common,--relax,-z,relro")
    endif()
endif()

# Platform specific settings
if(USE_STATIC_LIBS AND NOT APPLE)
    set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -static-libgcc -static-libstdc++")
endif()

# Platform flags
if(WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mthreads")
    set(framework_DEFINITIONS ${framework_DEFINITIONS} -D_WIN32_WINNT=0x0501 -DWIN32)
elseif(APPLE)
    set(framework_DEFINITIONS ${framework_DEFINITIONS} -D_REENTRANT)
elseif(NOT WASM)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
    set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -rdynamic -Wl,-rpath,./libs")
endif()
