# Define framework sources
set(framework_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/const.h
    ${CMAKE_CURRENT_SOURCE_DIR}/global.h
    ${CMAKE_CURRENT_SOURCE_DIR}/pch.h
    ${CMAKE_CURRENT_SOURCE_DIR}/luafunctions.cpp

    # util
    ${CMAKE_CURRENT_SOURCE_DIR}/util/color.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/util/color.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/crypt.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/util/crypt.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/databuffer.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/extras.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/util/extras.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/pngunpacker.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/util/pngunpacker.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/framecounter.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/matrix.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/point.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/qrcodegen.c
    ${CMAKE_CURRENT_SOURCE_DIR}/util/qrcodegen.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/rect.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/size.h
    ${CMAKE_CURRENT_SOURCE_DIR}/util/stats.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/util/stats.h

    # stdext
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/any.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/boolean.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/cast.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/compiler.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/demangle.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/demangle.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/dumper.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/dynamic_storage.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/exception.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/fastrand.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/format.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/math.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/math.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/net.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/net.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/packed_any.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/packed_storage.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/stdext.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/string.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/string.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/thread.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/time.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/time.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/traits.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/types.h
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/uri.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/stdext/uri.h

    # core
    ${CMAKE_CURRENT_SOURCE_DIR}/core/adaptiverenderer.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/adaptiverenderer.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/application.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/application.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/asyncdispatcher.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/asyncdispatcher.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/binarytree.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/binarytree.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/clock.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/clock.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/config.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/config.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/configmanager.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/configmanager.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/declarations.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/event.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/event.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/eventdispatcher.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/eventdispatcher.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/filestream.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/filestream.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/graphicalapplication.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/graphicalapplication.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/inputevent.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/logger.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/logger.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/module.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/module.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/modulemanager.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/modulemanager.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/resourcemanager.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/resourcemanager.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/scheduledevent.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/scheduledevent.h
    ${CMAKE_CURRENT_SOURCE_DIR}/core/timer.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/core/timer.h

    # luaengine
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/declarations.h
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/lbitlib.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/lbitlib.h
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/luabinder.h
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/luaexception.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/luaexception.h
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/luainterface.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/luainterface.h
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/luaobject.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/luaobject.h
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/luavaluecasts.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/luaengine/luavaluecasts.h

    # otml
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/declarations.h
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otml.h
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmldocument.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmldocument.h
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmlemitter.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmlemitter.h
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmlexception.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmlexception.h
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmlnode.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmlnode.h
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmlparser.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/otml/otmlparser.h

    # platform/crash handler
    ${CMAKE_CURRENT_SOURCE_DIR}/platform/crashhandler.h
    ${CMAKE_CURRENT_SOURCE_DIR}/platform/unixcrashhandler.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/platform/win32crashhandler.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/platform/win32platform.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/platform/unixplatform.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/platform/platform.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/platform/platform.h
)

# Graphics files
if(FRAMEWORK_GRAPHICS)
    set(PLATFORM_WINDOW_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/platform/platformwindow.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/platform/platformwindow.h
    )
    list(APPEND framework_SOURCES
        ${PLATFORM_WINDOW_SOURCES}
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/animatedtexture.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/animatedtexture.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/apngloader.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/apngloader.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/atlas.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/atlas.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/bitmapfont.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/bitmapfont.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/cachedtext.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/cachedtext.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/colorarray.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/coordsbuffer.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/coordsbuffer.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/declarations.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/deptharray.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/drawcache.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/drawcache.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/drawqueue.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/drawqueue.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/fontmanager.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/fontmanager.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/framebuffer.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/framebuffer.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/framebuffermanager.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/framebuffermanager.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/glutil.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/graphics.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/graphics.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/graph.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/graph.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/hardwarebuffer.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/hardwarebuffer.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/image.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/image.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/painter.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/painter.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/paintershaderprogram.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/paintershaderprogram.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/shader.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/shader.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/shaderprogram.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/shaderprogram.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/shadermanager.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/shadermanager.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/textrender.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/textrender.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/texture.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/texture.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/texturemanager.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/texturemanager.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/vertexarray.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/shaders/newshader.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/shaders/shaders.h
        ${CMAKE_CURRENT_SOURCE_DIR}/graphics/shaders/shadersources.h

        # ui
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/declarations.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/ui.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uianchorlayout.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uianchorlayout.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiboxlayout.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiboxlayout.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiflexbox.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiflexbox.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uigridlayout.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uigridlayout.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uihorizontallayout.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uihorizontallayout.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uilayout.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uilayout.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uimanager.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uimanager.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uitextedit.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uitextedit.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uitranslator.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uitranslator.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiverticallayout.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiverticallayout.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiwidget.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiwidget.h
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiwidgetbasestyle.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiwidgetimage.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/ui/uiwidgettext.cpp

        # platform window
        ${CMAKE_CURRENT_LIST_DIR}/platform/platformwindow.cpp
        ${CMAKE_CURRENT_LIST_DIR}/platform/platformwindow.h
        ${CMAKE_CURRENT_LIST_DIR}/platform/win32window.cpp
        ${CMAKE_CURRENT_LIST_DIR}/platform/win32window.h
        ${CMAKE_CURRENT_LIST_DIR}/platform/x11window.cpp
        ${CMAKE_CURRENT_LIST_DIR}/platform/x11window.h
        ${CMAKE_CURRENT_LIST_DIR}/platform/sdlwindow.cpp
        ${CMAKE_CURRENT_LIST_DIR}/platform/sdlwindow.h

        # window input
        ${CMAKE_CURRENT_SOURCE_DIR}/input/mouse.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/input/mouse.h
    )
endif()

# Add sound sources if enabled
if(FRAMEWORK_SOUND)
    list(APPEND framework_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/combinedsoundsource.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/combinedsoundsource.h
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/declarations.h
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/oggsoundfile.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/oggsoundfile.h
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundbuffer.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundbuffer.h
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundchannel.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundchannel.h
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundfile.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundfile.h
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundmanager.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundmanager.h
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundsource.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/soundsource.h
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/streamsoundsource.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/sound/streamsoundsource.h
    )
endif()

# Add network sources if enabled
if(FRAMEWORK_NET)
    list(APPEND framework_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/net/connection.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/net/connection.h
        ${CMAKE_CURRENT_SOURCE_DIR}/net/declarations.h
        ${CMAKE_CURRENT_SOURCE_DIR}/net/inputmessage.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/net/inputmessage.h
        ${CMAKE_CURRENT_SOURCE_DIR}/net/outputmessage.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/net/outputmessage.h
        ${CMAKE_CURRENT_SOURCE_DIR}/net/protocol.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/net/protocol.h
        ${CMAKE_CURRENT_SOURCE_DIR}/net/server.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/net/server.h
        ${CMAKE_CURRENT_SOURCE_DIR}/net/packet_player.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/net/packet_player.h
        ${CMAKE_CURRENT_SOURCE_DIR}/net/packet_recorder.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/net/packet_recorder.h
        ${CMAKE_CURRENT_SOURCE_DIR}/proxy/proxy.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/proxy/proxy.h
        ${CMAKE_CURRENT_SOURCE_DIR}/proxy/proxy_client.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/proxy/proxy_client.h
        ${CMAKE_CURRENT_SOURCE_DIR}/http/http.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/http/http.h
        ${CMAKE_CURRENT_SOURCE_DIR}/http/session.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/http/session.h
        ${CMAKE_CURRENT_SOURCE_DIR}/http/websocket.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/http/websocket.h
        ${CMAKE_CURRENT_SOURCE_DIR}/http/result.h
    )
endif()

# Add XML sources if enabled
if(FRAMEWORK_XML)
    list(APPEND framework_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/xml/tinyxml.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/xml/tinyxml.h
        ${CMAKE_CURRENT_SOURCE_DIR}/xml/tinystr.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/xml/tinystr.h
        ${CMAKE_CURRENT_SOURCE_DIR}/xml/tinyxmlerror.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/xml/tinyxmlparser.cpp
    )
endif()

add_library(framework STATIC ${framework_SOURCES})
target_include_directories(framework 
    PUBLIC 
        ${CMAKE_SOURCE_DIR}/src
        ${framework_INCLUDE_DIRS}
)

target_compile_definitions(framework PUBLIC ${framework_DEFINITIONS})
