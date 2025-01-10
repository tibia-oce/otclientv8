cmake_minimum_required(VERSION 2.6)
project(otclient)

# Add cmake modules directory to path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

# Include core configuration files
include(cmake/toolchain.cmake)
include(cmake/options.cmake)
include(cmake/compiler.cmake)
include(cmake/dependencies.cmake)

# Add source directories
add_subdirectory(src/framework)
add_subdirectory(src/client)

# Main executable source
set(executable_SOURCES
    src/main.cpp
)

# Windows icon handling
if(WIN32)
    set(RC_FILE "${CMAKE_CURRENT_SOURCE_DIR}/src/otcicon.rc")
    set(RC_OUT "${CMAKE_CURRENT_BINARY_DIR}/otcicon.res")
    add_custom_command(
        OUTPUT ${RC_OUT}
        COMMAND rc.exe
        ARGS /fo "${RC_OUT}" "${RC_FILE}"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src
        DEPENDS ${RC_FILE}
        COMMENT "Compiling Windows resources"
    )
    list(APPEND executable_SOURCES ${RC_OUT})
endif()

# Version definition if provided
if(VERSION)
    add_definitions(-DVERSION=\"${VERSION}\")
endif()

# Create executable
add_executable(${PROJECT_NAME} ${executable_SOURCES})

target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/src
    ${framework_INCLUDE_DIRS}
)

# Link libraries
target_link_libraries(${PROJECT_NAME} 
    PRIVATE 
    framework 
    client 
    ${framework_LIBRARIES}
)

# Windows-specific linking
if(WIN32)
    target_link_libraries(${PROJECT_NAME} PRIVATE winmm)
endif()

# macOS specific linking
if(APPLE AND USE_STATIC_LIBS)
    target_link_libraries(${PROJECT_NAME} "-framework Foundation" "-framework IOKit")
endif()

# Backtrace map generation - only for non-MSVC platforms
if(NOT APPLE AND NOT WASM AND NOT MSVC)
    set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -no-pie -Wl,-Map=${PROJECT_NAME}.map")
endif()
