workspace "otclient"
    configurations { "Debug", "Release" }
    architecture "x64"
    location "build"
    
    -- Framework options (unchanged)...
    newoption {
        trigger = "framework-sound",
        description = "Enable sound framework",
        default = "false"
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

    -- Detect platform and set vcpkg paths
    local pkgDirectory = "vcpkg_installed"
    local pkgIncludes, pkgLibs
    if os.target() == "windows" then
        pkgIncludes = pkgDirectory .. "/x64-windows/include"
        pkgLibs = pkgDirectory .. "/x64-windows/lib"
    elseif os.target() == "linux" then
        pkgIncludes = pkgDirectory .. "/x64-linux/include"
        pkgLibs = pkgDirectory .. "/x64-linux/lib"
    else
        error("Unsupported platform: " .. os.target())
    end

    -- Global settings
    flags { "MultiProcessorCompile" }
    cppdialect "C++17"

project "framework"
    kind "StaticLib"
    language "C++"
    
    targetdir "build/bin/%{cfg.buildcfg}"
    objdir "build/obj/%{cfg.buildcfg}/framework"

    includedirs {
        "src",
        "src/framework",
        pkgIncludes
    }

    libdirs {
        pkgLibs
    }

    files {
        -- Files section unchanged...
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
        "src/framework/protocol/**.h",
        "src/framework/platform/**.cpp",
        "src/framework/platform/**.h",
        "src/framework/util/crypt.*",
        "src/framework/core/resourcemanager.*"
    }

    -- Framework options filters remain unchanged...
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
        (_OPTIONS["framework-encryption"] == "true") and "WITH_ENCRYPTION" or "",
        (_OPTIONS["framework-sound"] == "true") and "FW_SOUND" or "",
        (_OPTIONS["framework-net"] == "true") and "FW_NET" or "",
        (_OPTIONS["framework-xml"] == "true") and "FW_XML" or "",
        "CRASH_HANDLER"
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

project "otclient"
    kind "WindowedApp"
    language "C++"
    
    targetdir "build/bin/%{cfg.buildcfg}"
    objdir "build/obj/%{cfg.buildcfg}/client"

    includedirs {
        "src",
        "src/framework",
        pkgIncludes
    }

    libdirs {
        pkgLibs
    }

    files {
        "src/client/**.cpp",
        "src/client/**.h",
        "src/client/**.hpp",
        "src/main.cpp",
        "src/otcicon.rc"
    }

    links { 
        "framework",
        -- Windows system libraries (required)
        "gdi32",
        "ws2_32",
        "iphlpapi",
        "mswsock",
        "dbghelp",
        "bcrypt",
        "shlwapi",
        "psapi",
        "imagehlp",
        "winmm",
        "kernel32",
        "user32",
        "glu32",
        "shell32",
        "advapi32"
    }

    defines {
        "CLIENT",
        (_OPTIONS["framework-encryption"] == "true") and "WITH_ENCRYPTION" or "",
        "FW_OTML",
        "FW_CRYPTO",
        (_OPTIONS["framework-graphics"] == "true") and "GRAPHICS_APPLICATION" or "CONSOLE_APPLICATION",
        (_OPTIONS["framework-sound"] == "true") and "FW_SOUND" or "",
        (_OPTIONS["framework-graphics"] == "true") and "FW_GRAPHICS" or "",
        (_OPTIONS["framework-net"] == "true") and "FW_NET" or "",
        (_OPTIONS["framework-xml"] == "true") and "FW_XML" or ""
    }

    filter "system:windows"
        systemversion "latest"
        defines { 
            "WIN32",
            "_WINDOWS",
            "NOMINMAX",
            "_WIN32_WINNT=0x0501",
            "PLATFORM_WINDOWS"
        }
        buildoptions { "/bigobj" }
        linkoptions { "/SUBSYSTEM:WINDOWS", "/ENTRY:mainCRTStartup" }
        
        -- OpenGL configuration for Windows
        local opengl_version = "2.0"
        
        -- Check if OpenGL 2.0 or higher is supported
        if os.outputof('wmic path win32_videocontroller get driverversion'):find(opengl_version) then
            defines { "OPENGL_GRAPHICS" }
            
            -- Add OpenGL and GLEW libraries
            links {
                "OpenGL32",
                "glew32"
            }
            
            -- Add OpenGL and GLEW include directories
            includedirs {
                pkgIncludes .. "/GL",
                pkgIncludes .. "/GLEW"
            }
        else
            error("OpenGL 2.0 or higher is not supported. Please update your graphics drivers.")
        end

    filter "system:linux"
        defines { "PLATFORM_LINUX" }
        links { "GL" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"
        runtime "Debug"
        optimize "Off"
        
    filter "configurations:Release"
        defines { "NDEBUG" }
        symbols "Off"
        runtime "Release"
        optimize "On"