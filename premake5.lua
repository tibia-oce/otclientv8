-- =============================================================================
-- Helper functions
-- =============================================================================
local function getPackagePaths()
    local platform = ""
    local rootDir = os.getenv("GITHUB_WORKSPACE") and 
                   os.getenv("GITHUB_WORKSPACE") .. "/vcpkg_installed" or 
                   "vcpkg_installed"

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

local function getLibraryPaths(basePath, boostLibs)
    local paths = {
        base = basePath,
        extra = {},
        foundLibs = {}
    }

    -- If running in a GitHub Actions environment, include paths to the vcpkg-installed libraries.
    local github_path = os.getenv("GITHUB_WORKSPACE")
    if github_path then
        local platform = ""
        if os.target() == "windows" then
            platform = "x64-windows"
        elseif os.target() == "linux" then
            platform = "x64-linux"
        elseif os.target() == "macosx" then
            platform = "x64-osx"
        end
        table.insert(paths.extra, github_path .. "/vcpkg/installed/" .. platform .. "/lib")
    end

    -- For each Boost library, search in the additional paths to verify it exists.
    -- This ensures only available libraries are linked, avoiding build errors between
    -- the operating systems and github runners
    table.insert(paths.extra, basePath .. "/**")
    for _, lib in ipairs(boostLibs) do
        for _, dir in ipairs(paths.extra) do
            if os.isfile(dir .. "/lib" .. lib .. ".a") or os.isfile(dir .. "/lib" .. lib .. "-mt.a") then
                table.insert(paths.foundLibs, lib)
                break
            end
        end
    end

    return paths
end

-- =============================================================================
-- Global Workspace
-- =============================================================================
workspace "otclient"
    configurations { "Debug", "Release" }
    architecture "x64"
    location "build"
    flags { "MultiProcessorCompile" }
    cppdialect "C++17"

    -- Framework options
    newoption { trigger = "framework-sound", description = "Enable sound framework", default = "false" }
    newoption { trigger = "use-luajit", description = "Use LuaJIT instead of Lua", default = "true" }
    newoption { trigger = "framework-graphics", description = "Enable graphics framework", default = "true" }
    newoption { trigger = "framework-xml", description = "Enable XML framework", default = "true" }
    newoption { trigger = "framework-net", description = "Enable networking framework", default = "true" }
    newoption { trigger = "framework-encryption", description = "Enable encryption support", default = "false" }

    -- Shared configurations
    local paths = getPackagePaths()
    local pkgIncludes = paths.includes
    local pkgLibs = paths.libs
    local boostLibs = { "boost_thread", "boost_filesystem", "boost_system", "boost_iostreams", "boost_program_options" }
    local libPaths = getLibraryPaths(pkgLibs, boostLibs)
    includedirs { pkgIncludes }
    libdirs { libPaths.extra }
    links(libPaths.foundLibs)

    -- Platform-specific Configuration
    filter "system:windows"
        systemversion "latest"
        buildoptions { "/bigobj" }
        defines { "PLATFORM_WINDOWS", "WIN32", "_WINDOWS", "NOMINMAX", "_WIN32_WINNT=0x0501" }
        links {
            "kernel32", "user32", "gdi32", "advapi32", "ws2_32",
            "iphlpapi", "mswsock", "bcrypt", "shlwapi", "psapi",
            "winmm", "glu32", "shell32", "OpenGL32", "glew32", "dbghelp",
            "libssl", "libcrypto", "crypt32"
        }
        includedirs { pkgIncludes .. "/GL", pkgIncludes .. "/GLEW", pkgIncludes .. "/luajit" }
        linkoptions { "/NODEFAULTLIB:imagehlp.lib", "/IGNORE:4006" } -- process multiple definitions without warnings

    filter "system:macosx"
        linkoptions { "-pagezero_size 10000", "-image_base 100000000", "-L/opt/X11/lib" }
        includedirs { "/usr/local/include", "/opt/X11/include", pkgIncludes .. "/luajit" }
        links {
            "GLEW", "openal", "luajit-5.1", "zip", "z", "bz2", "ogg",
            "vorbis", "vorbisfile", "vorbisenc", "X11", "Xrandr",
            "Xinerama", "Xcursor", "Xext", "GL", "OpenGL.framework",
            "Cocoa.framework", "Foundation.framework", "CoreFoundation.framework",
            "IOKit.framework", "CoreVideo.framework"
        }
        defines {
            "PLATFORM_MACOS", "GL_SILENCE_DEPRECATION",
            "USE_UNSIGNED_LONG_CONVERSION", "DEBUG_PLATFORM",
            "DEBUG_GRAPHICS", "DEBUG_GL"
        }

    filter "system:linux"
        buildoptions { "`pkg-config --cflags x11 gl luajit`", "-fPIC" }
        linkoptions { "`pkg-config --libs x11 gl luajit`", "-Wl,--start-group", "-Wl,--end-group" }
        links { 
            "stdc++", "pthread", "dl", "m", "z", "zip", "bz2", "physfs", 
            "ssl", "crypto", "GL", "GLU", "GLEW", "X11", "Xrandr", "ogg", 
            "vorbis", "openal", "luajit-5.1" 
        }

-- =============================================================================
-- Framework
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

    filter { "options:use-luajit=false" }
        includedirs { "/usr/include/lua5.1" }

-- =============================================================================
-- Client
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
        linkoptions { "/SUBSYSTEM:WINDOWS", "/ENTRY:mainCRTStartup" }
        files { "src/otcicon.rc" }
        defines { "OPENGL_GRAPHICS" }

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

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"
        optimize "Off"

    filter "configurations:Release"
        defines { "NDEBUG" }
        symbols "Off"
        optimize "Speed"
        flags { "LinkTimeOptimization" }
