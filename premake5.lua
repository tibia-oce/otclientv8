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

   local pkgDirectory = "vcpkg_installed"
   local pkgIncludes, pkgLibs
   if os.target() == "windows" then
       pkgIncludes = pkgDirectory .. "/x64-windows/include"
       pkgLibs = pkgDirectory .. "/x64-windows/lib"
   elseif os.target() == "linux" then
       pkgIncludes = pkgDirectory .. "/x64-linux/include"
       pkgLibs = pkgDirectory .. "/x64-linux/lib"
   elseif os.target() == "macosx" then
       pkgIncludes = pkgDirectory .. "/x64-macos/include"
       pkgLibs = pkgDirectory .. "/x64-macos/lib"
   else
       error("Unsupported platform: " .. os.target())
   end

   filter "system:linux"
       buildoptions { "`pkg-config --cflags x11 gl luajit`" }
       linkoptions { "`pkg-config --libs x11 gl luajit`" }
       links {
           "stdc++", "pthread", "dl", "m",
           "z", "zip", "bz2", "physfs",
           "boost_thread", "boost_filesystem", "boost_system",
           "boost_iostreams", "boost_program_options",
           "ssl", "crypto",
           "GL", "GLU", "GLEW", "X11", "Xrandr",
           "ogg", "vorbis", "openal",
           "luajit-5.1"
       }

   filter "system:macosx" 
       if _OPTIONS["use-static-libs"] then
           links {
               "Foundation.framework",
               "IOKit.framework"
           }
       end

   if not os.target() == "macosx" and not _OPTIONS["wasm"] then
       if _OPTIONS["crash-handler"] then
           defines { "CRASH_HANDLER" }
           if os.target() == "windows" then
               links { "imagehlp" }
           end
       end
   end

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
       "src/framework/protocol/**.h",
       "src/framework/platform/**.cpp",
       "src/framework/platform/**.h",
       "src/framework/util/crypt.*",
       "src/framework/core/resourcemanager.*"
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
       includedirs { "/usr/include/luajit-2.1" }

   filter { "options:use-luajit=false" }
       includedirs { "/usr/include/lua5.1" }

   filter "system:linux"
       buildoptions { "-fPIC" }

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

       local opengl_version = "2.0"
       if os.target() == "windows" then
           local wmic_output = os.outputof('wmic path win32_videocontroller get driverversion')
           if wmic_output and wmic_output:find(opengl_version) then
               defines { "OPENGL_GRAPHICS" }
               links { "OpenGL32", "glew32" }
               includedirs {
                   pkgIncludes .. "/GL",
                   pkgIncludes .. "/GLEW",
                   pkgIncludes .. "/luajit"
               }
           else
               error("OpenGL 2.0 or higher is not supported. Please update your graphics drivers.")
           end
       end

   filter "system:linux"
       defines { "PLATFORM_LINUX" }
       linkoptions { 
           "-Wl,--start-group",
           "-L" .. pkgLibs,
           "-L../vcpkg_installed/x64-linux/lib",
           "-Wl,--end-group"
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
