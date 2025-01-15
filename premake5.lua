-- Helper functions for path resolution
local function getPackagePaths()
    local rootDir = os.getenv("GITHUB_WORKSPACE") and 
                   os.getenv("GITHUB_WORKSPACE") .. "/vcpkg_installed" or 
                   "vcpkg_installed"

    local platform = ""
    if os.target() == "windows" then
        platform = "x64-windows"
    elseif os.target() == "linux" then
        platform = "x64-linux"
    elseif os.target() == "macosx" then
        platform = os.host() == "macosx" and os.getenv("HOSTTYPE") == "arm64" 
                  and "arm64-osx" or "x64-osx"
    else
        error("Unsupported platform: " .. os.target())
    end

    return {
        includes = rootDir .. "/" .. platform .. "/include",
        libs = rootDir .. "/" .. platform .. "/lib"
    }
end

local function getLibraryPaths(basePath)
    local paths = {
        base = basePath,
        extra = {}
    }

    -- Add environment-specific paths
    local github_path = os.getenv("GITHUB_WORKSPACE")
    if github_path then
        table.insert(paths.extra, github_path .. "/vcpkg/installed/x64-linux/lib")
        table.insert(paths.extra, github_path .. "/vcpkg/packages/**/lib")
    end

    -- Add recursive search for local builds
    table.insert(paths.extra, basePath .. "/**")

    return paths
end

-- =============================================================================
-- Global Configuration
-- =============================================================================
workspace "otclient"
    configurations { "Debug", "Release" }
    architecture "x64"
    location "build"
    flags { "MultiProcessorCompile" }
    cppdialect "C++17"

    newoption {
        trigger = "framework-sound",
        description = "Enable sound framework",
        default = "false"
    }
    newoption {
        trigger = "use-luajit",
        description = "Use LuaJIT instead of Lua", 
        default = "true"
    }
    newoption {
        trigger = "framework-graphics",
        description = "Enable graphics framework",
        default = "true"
    }
    newoption {
        trigger = "framework-xml",
        description = "Enable XML framework",
        default = "true"
    }
    newoption {
        trigger = "framework-net",
        description = "Enable networking framework",
        default = "true"
    }
    newoption {
        trigger = "framework-encryption",
        description = "Enable encryption support",
        default = "false"
    }

    -- Get package paths
    local paths = getPackagePaths()
    local pkgIncludes = paths.includes
    local pkgLibs = paths.libs

    -- System configurations
    filter "system:linux"
        buildoptions { "`pkg-config --cflags x11 gl luajit`" }
        linkoptions { "`pkg-config --libs x11 gl luajit`" }
        local libPaths = getLibraryPaths(pkgLibs)
        libdirs(libPaths.extra)
        links {
            -- System libraries
            "stdc++", "pthread", "dl", "m",
            "z", "zip", "bz2", "physfs",
            -- Boost libraries
            "boost_thread", "boost_filesystem", "boost_system",
            "boost_iostreams", "boost_program_options",
            -- Other dependencies
            "ssl", "crypto",
            "GL", "GLU", "GLEW", "X11", "Xrandr",
            "ogg", "vorbis", "openal",
            "luajit-5.1"
        }

    filter "system:macosx"
        linkoptions { 
            "-pagezero_size 10000",
            "-image_base 100000000"
        }
        defines { 
            "PLATFORM_MACOS",
            "GL_SILENCE_DEPRECATION",
            "USE_UNSIGNED_LONG_CONVERSION",
            "DEBUG_PLATFORM",
            "DEBUG_GRAPHICS",
            "DEBUG_GL"
        }
        
        includedirs {
            pkgIncludes,
            pkgIncludes .. "/arm64-osx/lib",
            pkgIncludes .. "/arm64-osx/include",
            pkgIncludes .. "/arm64-osx/include/luajit-2.1",
            "/usr/local/include",
            "/opt/X11/include"
        }
        
        libdirs { 
            pkgLibs,
            pkgLibs .. "/arm64-osx/lib",
            "/usr/local/lib",
            "/opt/X11/lib"
        }
        
        links {
            "boost_system", "boost_filesystem", "boost_iostreams",
            "boost_program_options", "boost_process", "boost_random",
            "boost_regex", "boost_atomic",
            "crypto", "ssl", "physfs", "GLEW", "openal",
            "luajit-5.1", "zip", "z", "bz2",
            "ogg", "vorbis", "vorbisfile", "vorbisenc",
            "X11", "Xrandr", "Xinerama", "Xcursor", "Xext", "GL",
            "OpenGL.framework", "Cocoa.framework",
            "Foundation.framework", "CoreFoundation.framework",
            "IOKit.framework", "CoreVideo.framework"
        }

-- =============================================================================
-- Framework Project
-- =============================================================================
project "framework"
    kind "StaticLib"
    language "C++"
    flags { "NoImportLib" }
    targetdir "build/bin/%{cfg.buildcfg}"
    objdir "build/obj/%{cfg.buildcfg}/framework"

    includedirs {
        "src",
        "src/framework",
        pkgIncludes
    }
    libdirs { pkgLibs }

    files {
        "src/framework/const.h",
        "src/framework/global.h",
        "src/framework/pch.h",
        "src/framework/luafunctions.cpp",
        "src/framework/otml/**.cpp",
        "src/framework/otml/**.h",
        "src/framework/xml/**.cpp",
        "src/framework/xml/**.h",
        "src/framework/util/**.cpp",
        "src/framework/util/**.c",
        "src/framework/util/**.h",
        "src/framework/stdext/**.cpp",
        "src/framework/stdext/**.h",
        "src/framework/core/**.cpp",
        "src/framework/core/**.h",
        "src/framework/luaengine/**.cpp",
        "src/framework/luaengine/**.h",
        "src/framework/net/**.cpp",
        "src/framework/net/**.h",
        "src/framework/http/**.cpp",
        "src/framework/http/**.h",
        "src/framework/proxy/**.cpp",
        "src/framework/proxy/**.h",
        "src/framework/protocol/**.cpp",
        "src/framework/protocol/**.h"
    }

    filter "system:macosx"
        files {
            "src/framework/platform/platform.cpp",
            "src/framework/platform/platform.h",
            "src/framework/platform/platformwindow.cpp",
            "src/framework/platform/platformwindow.h",
            "src/framework/platform/x11window.*",
            "src/framework/platform/unixplatform.*",
            "src/framework/platform/unixcrashhandler.*"
        }

    filter "system:not macosx"
        files {
            "src/framework/platform/**"
        }

    filter { "options:framework-graphics=true" }
        files {
            "src/framework/graphics/**.cpp",
            "src/framework/graphics/**.h",
            "src/framework/ui/**.cpp",
            "src/framework/ui/**.h",
            "src/framework/input/**.cpp",
            "src/framework/input/**.h",
            "src/framework/core/graphicalapplication.cpp",
            "src/framework/core/graphicalapplication.h"
        }
        removefiles {
            "src/framework/core/consoleapplication.cpp",
            "src/framework/core/consoleapplication.h"
        }
        defines {
            "GRAPHICS_APPLICATION",
            "FW_GRAPHICS",
            "OPENGL_APPLICATION"
        }

    filter { "options:framework-graphics=false" }
        files {
            "src/framework/core/consoleapplication.cpp",
            "src/framework/core/consoleapplication.h"
        }
        removefiles {
            "src/framework/core/graphicalapplication.cpp",
            "src/framework/core/graphicalapplication.h"
        }
        defines { "CONSOLE_APPLICATION" }

    defines {
        "FRAMEWORK_LIBRARY",
        "FW_OTML",
        "GLEW_STATIC",
        (_OPTIONS["framework-encryption"]) and "WITH_ENCRYPTION" or "",
        (_OPTIONS["framework-sound"]) and "FW_SOUND" or "",
        (_OPTIONS["framework-net"]) and "FW_NET" or "",
        (_OPTIONS["framework-xml"]) and "FW_XML" or "",
        "CRASH_HANDLER"
    }

    filter "system:linux"
        buildoptions { "-fPIC" }
        libdirs { 
            pkgLibs,
            pkgLibs .. "/**"
        }

    filter "system:windows"
        systemversion "latest"
        defines {
            "WIN32",
            "_WINDOWS",
            "NOMINMAX",
            "_WIN32_WINNT=0x0501"
        }
        buildoptions { "/bigobj" }

    filter { "options:use-luajit=true" }
        defines { "USE_LUAJIT" }
        includedirs { 
            "/usr/include/luajit-2.1",
            pkgIncludes .. "/luajit-2.1"
        }

    filter { "options:use-luajit=false" }
        includedirs { "/usr/include/lua5.1" }

-- =============================================================================
-- Client Project
-- =============================================================================
project "otclient"
    kind "WindowedApp"
    language "C++"
    targetdir "build/bin/%{cfg.buildcfg}"
    objdir "build/obj/%{cfg.buildcfg}/client"
    
    libdirs { "build/bin/%{cfg.buildcfg}", pkgLibs }
    includedirs { pkgIncludes, "src", "src/framework", "src/client" }
    links { "framework" }

    files {
        "src/client/**.cpp",
        "src/client/**.h",
        "src/client/**.hpp",
        "src/main.cpp"
    }

    defines {
        "CLIENT",
        "FW_OTML",
        "FW_CRYPTO",
        (_OPTIONS["framework-encryption"]) and "WITH_ENCRYPTION" or "",
        (_OPTIONS["framework-graphics"]) and "GRAPHICS_APPLICATION" or "CONSOLE_APPLICATION",
        (_OPTIONS["framework-sound"]) and "FW_SOUND" or "",
        (_OPTIONS["framework-graphics"]) and "FW_GRAPHICS" or "",
        (_OPTIONS["framework-net"]) and "FW_NET" or "",
        (_OPTIONS["framework-xml"]) and "FW_XML" or ""
    }

    filter "system:windows"
        buildoptions { "/bigobj" }
        linkoptions { "/SUBSYSTEM:WINDOWS", "/ENTRY:mainCRTStartup" }
        systemversion "latest"
        files { "src/otcicon.rc" }
        defines {
            "WIN32",
            "_WINDOWS", 
            "NOMINMAX",
            "_WIN32_WINNT=0x0501",
            "PLATFORM_WINDOWS"
        }
        links {
            "gdi32", "ws2_32", "iphlpapi", "mswsock",
            "dbghelp", "bcrypt", "shlwapi", "psapi",
            "imagehlp", "winmm", "kernel32", "user32",
            "glu32", "shell32", "advapi32"
        }

    filter "system:linux"
        defines { "PLATFORM_LINUX" }
        linkoptions { 
            "-Wl,--start-group",
            "-L" .. pkgLibs,
            "-Wl,--end-group"
        }

    filter "system:macosx"
        kind "ConsoleApp"
        targetextension ""
        linkoptions { 
            "-pagezero_size 10000",
            "-image_base 100000000",
            "-L/opt/X11/lib"
        }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"
        optimize "Off"

    filter "configurations:Release"
        defines { "NDEBUG" }
        symbols "Off"
        optimize "Speed"
        flags { "LinkTimeOptimization" }
