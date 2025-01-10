cmake_minimum_required(VERSION 2.6)
project(otclient)

# Add cmake modules directory to path
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

# Include core configuration files
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
    add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/otcicon.o
                       COMMAND ${CMAKE_RC_COMPILER}
                       -I${CMAKE_CURRENT_SOURCE_DIR}/src
                       -i${CMAKE_CURRENT_SOURCE_DIR}/src/otcicon.rc
                       -o ${CMAKE_CURRENT_BINARY_DIR}/otcicon.o)
    list(APPEND executable_SOURCES otcicon.o)
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

# macOS specific linking
if(APPLE AND USE_STATIC_LIBS)
    target_link_libraries(${PROJECT_NAME} "-framework Foundation" "-framework IOKit")
endif()

# Backtrace map generation
if(NOT APPLE AND NOT WASM)
    set(CMAKE_CXX_LINK_FLAGS "${CMAKE_CXX_LINK_FLAGS} -no-pie -Wl,-Map=${PROJECT_NAME}.map")
endif()
