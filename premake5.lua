workspace "otclient"
    configurations { "Debug", "Release" }
    platforms { "x64" }
    location "build"

    -- Framework options
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

project "framework"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    
    targetdir "build/bin/%{cfg.buildcfg}"
    objdir "build/obj/%{cfg.buildcfg}/framework"

    -- Framework source files
    files {
        "src/framework/**.cpp",
        "src/framework/**.c",
        "src/framework/**.h",
        "src/framework/**.hpp"
    }

    includedirs {
        "src",
        "src/framework"
    }

    -- Special handling for luafunctions.cpp
    filter "files:src/**/luafunctions.cpp"
        buildoptions { "-g0", "-Os" }

    filter "files:**.c"
        language "C"

    defines {
        "FRAMEWORK_LIBRARY",
        (_OPTIONS["framework-sound"] == "true") and "FW_SOUND" or "",
        (_OPTIONS["framework-graphics"] == "true") and "FW_GRAPHICS" or "",
        (_OPTIONS["framework-net"] == "true") and "FW_NET" or "",
        (_OPTIONS["framework-xml"] == "true") and "FW_XML" or "",
        "CRASH_HANDLER"
    }

    filter "system:windows"
        defines { 
            "WIN32",
            "_WINDOWS",
            "NOMINMAX",
            "_WIN32_WINNT=0x0501"
        }
        buildoptions { "/bigobj" }

project "otclient"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    
    targetdir "build/bin/%{cfg.buildcfg}"
    objdir "build/obj/%{cfg.buildcfg}/client"

    files {
        "src/client/**.cpp",
        "src/client/**.h",
        "src/client/**.hpp",
        "src/main.cpp"
    }

    includedirs {
        "src",
        "src/framework"
    }

    links { "framework" }

    defines {
        "CLIENT",
        "WITH_ENCRYPTION"
    }

    filter "system:windows"
        defines { 
            "WIN32",
            "_WINDOWS",
            "NOMINMAX",
            "_WIN32_WINNT=0x0501"
        }
        buildoptions { "/bigobj" }
        
        -- Only linking Windows system libraries that aren't provided by vcpkg
        links {
            "gdi32",
            "ws2_32",
            "iphlpapi",
            "mswsock",
            "dbghelp",
            "bcrypt",
            "shlwapi",
            "psapi",
            "imagehlp",
            "winmm"
        }

        -- Resource file for icon
        files { "src/otcicon.rc" }

    filter "system:linux"
        links {
            "pthread",
            "dl"
        }
        linkoptions { "-rdynamic" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"
        optimize "Off"
        
    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"
