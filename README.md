# OTClientV8
[![Workflow](https://github.com/tibia-oce/migrate/actions/workflows/build-release.yaml/badge.svg)](https://github.com/tibia-oce/migrate/actions/workflows/build-release.yaml)

> \[!NOTE]
>
>Based on [edubart/otclient](https://github.com/edubart/otclient).

OTClientV8 is highly optimized, cross-platform tile based 2d game engine built with c++17, lua, physfs, OpenGL ES 2.0 and OpenAL. It has been created as alternative client for OpenTibia. This client is designed specifically to work with the [Mythbound server](https://github.com/tibia-oce/server).

<div style="text-align: center;">
  <table>
    <tr>
      <td>
        <img src="https://github.com/tibia-oce/otclientv8/blob/main/docs/images/client.png?raw=true?raw=true" width="200" alt="Login Screen" style="max-width:200px;">
      </td>
      <td>
        <img src="https://github.com/kokekanon/OTredemption-Picture-NODELETE/blob/main/Picture/Attached%20Effect/Creature/001_Bone.gif?raw=true" width="200" alt="Character Attachments" style="max-width:200px;">
        </td>
      <td>
        <img src="https://github.com/tibia-oce/otclientv8/blob/main/docs/images/client.png?raw=true" width="200" alt="Game Interface" style="max-width:200px;">
      </td>
    </tr>
    <tr>
      <td>Login Screen</td>
      <td>Character Cosmetics</td>
      <td>Game Interface</td>
    </tr>
  </table>
</div>

## Getting started

You can download a pre-compiled version [here](https://github.com/tibia-oce/otclientv8/releases/latest), or [compile](#Compilation) the client yourself.

Afterward, you need to provide the client a copy of the [assets](https://github.com/tibia-oce/assets/tree/master/things/1098) in `./data/things`.

Command-promt:
```
mklink /D "D:\CompSci\Projects\tibia-oce\otclientv8\data\things" "D:\CompSci\Projects\tibia-oce\assets\things"
```


## Latest Builds

| Platform       | Build        | Notes        |
| :------------- | :----------: | :----------: |
| Linux        | [![Build & Release](https://github.com/tibia-oce/otclientv8/actions/workflows/build-release.yaml/badge.svg)](https://github.com/tibia-oce/otclientv8/actions/workflows/build-release.yaml) | |
| Windows        | [![Build & Release](https://github.com/tibia-oce/otclientv8/actions/workflows/build-release.yaml/badge.svg)](https://github.com/tibia-oce/otclientv8/actions/workflows/build-release.yaml) | Requires Windows 7+ |
| MacOS        | [![Build & Release](https://github.com/tibia-oce/otclientv8/actions/workflows/build-release.yaml/badge.svg)](https://github.com/tibia-oce/otclientv8/actions/workflows/build-release.yaml) | Requires [xquartz](https://www.xquartz.org/) |

## Compilation

### Linux

#### Docker (Via Ubuntu 22.04)

```sh
make compile
```

#### Ubuntu 22.04

```sh
sudo apt update
sudo apt install git curl build-essential cmake gcc g++ pkg-config autoconf libtool libglew-dev -y
cd ~
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg && ./bootstrap-vcpkg.sh && cd ..
git clone https://github.com/tibia-oce/otclientv8.git
cd otclientv8 && mkdir build && cd build
cmake -DCMAKE_TOOLCHAIN_FILE=~/vcpkg/scripts/buildsystems/vcpkg.cmake .. && make -j$(nproc)
cp otclient ../otclient && cd ..
./otclient
```

### Windows

#### Visual Studio 2022

Install vcpkg:

```sh
git clone https://github.com/microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg.exe integrate install
```

Use Visual Studio 2022, select backend (OpenGL, DirectX), platform (x86, x64) and just build, all required libraries will be installed for you.

```
otclientv8
├─ 📁src
│  ├─ 📁client
│  │  ├─ 📄animatedtext.cpp
│  │  ├─ 📄animatedtext.h
│  │  ├─ 📄animator.cpp
│  │  ├─ 📄animator.h
│  │  ├─ 📄client.cpp
│  │  ├─ 📄client.h
│  │  ├─ 📄CMakeLists.txt
│  │  ├─ 📄const.h
│  │  ├─ 📄container.cpp
│  │  ├─ 📄container.h
│  │  ├─ 📄creature.cpp
│  │  ├─ 📄creature.h
│  │  ├─ 📄creatures.cpp
│  │  ├─ 📄creatures.h
│  │  ├─ 📄declarations.h
│  │  ├─ 📄effect.cpp
│  │  ├─ 📄effect.h
│  │  ├─ 📄game.cpp
│  │  ├─ 📄game.h
│  │  ├─ 📄global.h
│  │  ├─ 📄healthbars.cpp
│  │  ├─ 📄healthbars.h
│  │  ├─ 📄houses.cpp
│  │  ├─ 📄houses.h
│  │  ├─ 📄item.cpp
│  │  ├─ 📄item.h
│  │  ├─ 📄itemtype.cpp
│  │  ├─ 📄itemtype.h
│  │  ├─ 📄lightview.cpp
│  │  ├─ 📄lightview.h
│  │  ├─ 📄localplayer.cpp
│  │  ├─ 📄localplayer.h
│  │  ├─ 📄luafunctions_client.cpp
│  │  ├─ 📄luavaluecasts_client.cpp
│  │  ├─ 📄luavaluecasts_client.h
│  │  ├─ 📄map.cpp
│  │  ├─ 📄map.h
│  │  ├─ 📄mapio.cpp
│  │  ├─ 📄mapview.cpp
│  │  ├─ 📄mapview.h
│  │  ├─ 📄minimap.cpp
│  │  ├─ 📄minimap.h
│  │  ├─ 📄missile.cpp
│  │  ├─ 📄missile.h
│  │  ├─ 📄outfit.cpp
│  │  ├─ 📄outfit.h
│  │  ├─ 📄player.cpp
│  │  ├─ 📄player.h
│  │  ├─ 📄position.h
│  │  ├─ 📄protocolcodes.cpp
│  │  ├─ 📄protocolcodes.h
│  │  ├─ 📄protocolgame.cpp
│  │  ├─ 📄protocolgame.h
│  │  ├─ 📄protocolgameparse.cpp
│  │  ├─ 📄protocolgamesend.cpp
│  │  ├─ 📄spritemanager.cpp
│  │  ├─ 📄spritemanager.h
│  │  ├─ 📄statictext.cpp
│  │  ├─ 📄statictext.h
│  │  ├─ 📄thing.cpp
│  │  ├─ 📄thing.h
│  │  ├─ 📄thingstype.h
│  │  ├─ 📄thingtype.cpp
│  │  ├─ 📄thingtype.h
│  │  ├─ 📄thingtypemanager.cpp
│  │  ├─ 📄thingtypemanager.h
│  │  ├─ 📄tile.cpp
│  │  ├─ 📄tile.h
│  │  ├─ 📄towns.cpp
│  │  ├─ 📄towns.h
│  │  ├─ 📄uicreature.cpp
│  │  ├─ 📄uicreature.h
│  │  ├─ 📄uigraph.cpp
│  │  ├─ 📄uigraph.h
│  │  ├─ 📄uigrid.cpp
│  │  ├─ 📄uigrid.h
│  │  ├─ 📄uiitem.cpp
│  │  ├─ 📄uiitem.h
│  │  ├─ 📄uimap.cpp
│  │  ├─ 📄uimap.h
│  │  ├─ 📄uimapanchorlayout.cpp
│  │  ├─ 📄uimapanchorlayout.h
│  │  ├─ 📄uiminimap.cpp
│  │  ├─ 📄uiminimap.h
│  │  ├─ 📄uiprogressrect.cpp
│  │  ├─ 📄uiprogressrect.h
│  │  ├─ 📄uisprite.cpp
│  │  ├─ 📄uisprite.h
│  │  └─ 📄walkmatrix.h
│  ├─ 📁framework
│  │  ├─ 📁core
│  │  │  ├─ 📄adaptiverenderer.cpp
│  │  │  ├─ 📄adaptiverenderer.h
│  │  │  ├─ 📄application.cpp
│  │  │  ├─ 📄application.h
│  │  │  ├─ 📄asyncdispatcher.cpp
│  │  │  ├─ 📄asyncdispatcher.h
│  │  │  ├─ 📄binarytree.cpp
│  │  │  ├─ 📄binarytree.h
│  │  │  ├─ 📄clock.cpp
│  │  │  ├─ 📄clock.h
│  │  │  ├─ 📄config.cpp
│  │  │  ├─ 📄config.h
│  │  │  ├─ 📄configmanager.cpp
│  │  │  ├─ 📄configmanager.h
│  │  │  ├─ 📄consoleapplication.cpp
│  │  │  ├─ 📄consoleapplication.h
│  │  │  ├─ 📄declarations.h
│  │  │  ├─ 📄event.cpp
│  │  │  ├─ 📄event.h
│  │  │  ├─ 📄eventdispatcher.cpp
│  │  │  ├─ 📄eventdispatcher.h
│  │  │  ├─ 📄filestream.cpp
│  │  │  ├─ 📄filestream.h
│  │  │  ├─ 📄graphicalapplication.cpp
│  │  │  ├─ 📄graphicalapplication.h
│  │  │  ├─ 📄inputevent.h
│  │  │  ├─ 📄logger.cpp
│  │  │  ├─ 📄logger.h
│  │  │  ├─ 📄module.cpp
│  │  │  ├─ 📄module.h
│  │  │  ├─ 📄modulemanager.cpp
│  │  │  ├─ 📄modulemanager.h
│  │  │  ├─ 📄resourcemanager.cpp
│  │  │  ├─ 📄resourcemanager.h
│  │  │  ├─ 📄scheduledevent.cpp
│  │  │  ├─ 📄scheduledevent.h
│  │  │  ├─ 📄timer.cpp
│  │  │  └─ 📄timer.h
│  │  ├─ 📁graphics
│  │  │  ├─ 📁shaders
│  │  │  │  ├─ 📄newshader.h
│  │  │  │  ├─ 📄outfits.h
│  │  │  │  ├─ 📄shaders.h
│  │  │  │  └─ 📄shadersources.h
│  │  │  ├─ 📄animatedtexture.cpp
│  │  │  ├─ 📄animatedtexture.h
│  │  │  ├─ 📄apngloader.cpp
│  │  │  ├─ 📄apngloader.h
│  │  │  ├─ 📄atlas.cpp
│  │  │  ├─ 📄atlas.h
│  │  │  ├─ 📄bitmapfont.cpp
│  │  │  ├─ 📄bitmapfont.h
│  │  │  ├─ 📄cachedtext.cpp
│  │  │  ├─ 📄cachedtext.h
│  │  │  ├─ 📄colorarray.h
│  │  │  ├─ 📄coordsbuffer.cpp
│  │  │  ├─ 📄coordsbuffer.h
│  │  │  ├─ 📄declarations.h
│  │  │  ├─ 📄deptharray.h
│  │  │  ├─ 📄drawcache.cpp
│  │  │  ├─ 📄drawcache.h
│  │  │  ├─ 📄drawqueue.cpp
│  │  │  ├─ 📄drawqueue.h
│  │  │  ├─ 📄fontmanager.cpp
│  │  │  ├─ 📄fontmanager.h
│  │  │  ├─ 📄framebuffer.cpp
│  │  │  ├─ 📄framebuffer.h
│  │  │  ├─ 📄framebuffermanager.cpp
│  │  │  ├─ 📄framebuffermanager.h
│  │  │  ├─ 📄glutil.h
│  │  │  ├─ 📄graph.cpp
│  │  │  ├─ 📄graph.h
│  │  │  ├─ 📄graphics.cpp
│  │  │  ├─ 📄graphics.h
│  │  │  ├─ 📄hardwarebuffer.cpp
│  │  │  ├─ 📄hardwarebuffer.h
│  │  │  ├─ 📄image.cpp
│  │  │  ├─ 📄image.h
│  │  │  ├─ 📄painter.cpp
│  │  │  ├─ 📄painter.h
│  │  │  ├─ 📄paintershaderprogram.cpp
│  │  │  ├─ 📄paintershaderprogram.h
│  │  │  ├─ 📄shader.cpp
│  │  │  ├─ 📄shader.h
│  │  │  ├─ 📄shadermanager.cpp
│  │  │  ├─ 📄shadermanager.h
│  │  │  ├─ 📄shaderprogram.cpp
│  │  │  ├─ 📄shaderprogram.h
│  │  │  ├─ 📄textrender.cpp
│  │  │  ├─ 📄textrender.h
│  │  │  ├─ 📄texture.cpp
│  │  │  ├─ 📄texture.h
│  │  │  ├─ 📄texturemanager.cpp
│  │  │  ├─ 📄texturemanager.h
│  │  │  └─ 📄vertexarray.h
│  │  ├─ 📁http
│  │  │  ├─ 📄http.cpp
│  │  │  ├─ 📄http.h
│  │  │  ├─ 📄result.h
│  │  │  ├─ 📄session.cpp
│  │  │  ├─ 📄session.h
│  │  │  ├─ 📄websocket.cpp
│  │  │  └─ 📄websocket.h
│  │  ├─ 📁input
│  │  │  ├─ 📄mouse.cpp
│  │  │  └─ 📄mouse.h
│  │  ├─ 📁luaengine
│  │  │  ├─ 📄declarations.h
│  │  │  ├─ 📄lbitlib.cpp
│  │  │  ├─ 📄lbitlib.h
│  │  │  ├─ 📄luabinder.h
│  │  │  ├─ 📄luaexception.cpp
│  │  │  ├─ 📄luaexception.h
│  │  │  ├─ 📄luainterface.cpp
│  │  │  ├─ 📄luainterface.h
│  │  │  ├─ 📄luaobject.cpp
│  │  │  ├─ 📄luaobject.h
│  │  │  ├─ 📄luavaluecasts.cpp
│  │  │  └─ 📄luavaluecasts.h
│  │  ├─ 📁net
│  │  │  ├─ 📄connection.cpp
│  │  │  ├─ 📄connection.h
│  │  │  ├─ 📄declarations.h
│  │  │  ├─ 📄inputmessage.cpp
│  │  │  ├─ 📄inputmessage.h
│  │  │  ├─ 📄outputmessage.cpp
│  │  │  ├─ 📄outputmessage.h
│  │  │  ├─ 📄packet_player.cpp
│  │  │  ├─ 📄packet_player.h
│  │  │  ├─ 📄packet_recorder.cpp
│  │  │  ├─ 📄packet_recorder.h
│  │  │  ├─ 📄protocol.cpp
│  │  │  ├─ 📄protocol.h
│  │  │  ├─ 📄server.cpp
│  │  │  └─ 📄server.h
│  │  ├─ 📁otml
│  │  │  ├─ 📄declarations.h
│  │  │  ├─ 📄otml.h
│  │  │  ├─ 📄otmldocument.cpp
│  │  │  ├─ 📄otmldocument.h
│  │  │  ├─ 📄otmlemitter.cpp
│  │  │  ├─ 📄otmlemitter.h
│  │  │  ├─ 📄otmlexception.cpp
│  │  │  ├─ 📄otmlexception.h
│  │  │  ├─ 📄otmlnode.cpp
│  │  │  ├─ 📄otmlnode.h
│  │  │  ├─ 📄otmlparser.cpp
│  │  │  └─ 📄otmlparser.h
│  │  ├─ 📁platform
│  │  │  ├─ 📄androidwindow.h
│  │  │  ├─ 📄crashhandler.h
│  │  │  ├─ 📄platform.cpp
│  │  │  ├─ 📄platform.h
│  │  │  ├─ 📄platformwindow.cpp
│  │  │  ├─ 📄platformwindow.h
│  │  │  ├─ 📄sdlwindow.cpp
│  │  │  ├─ 📄sdlwindow.h
│  │  │  ├─ 📄unixcrashhandler.cpp
│  │  │  ├─ 📄unixplatform.cpp
│  │  │  ├─ 📄win32crashhandler.cpp
│  │  │  ├─ 📄win32platform.cpp
│  │  │  ├─ 📄win32window.cpp
│  │  │  ├─ 📄win32window.h
│  │  │  ├─ 📄x11window.cpp
│  │  │  └─ 📄x11window.h
│  │  ├─ 📁proxy
│  │  │  ├─ 📄proxy.cpp
│  │  │  ├─ 📄proxy.h
│  │  │  ├─ 📄proxy_client.cpp
│  │  │  └─ 📄proxy_client.h
│  │  ├─ 📁sound
│  │  │  ├─ 📄combinedsoundsource.cpp
│  │  │  ├─ 📄combinedsoundsource.h
│  │  │  ├─ 📄declarations.h
│  │  │  ├─ 📄oggsoundfile.cpp
│  │  │  ├─ 📄oggsoundfile.h
│  │  │  ├─ 📄soundbuffer.cpp
│  │  │  ├─ 📄soundbuffer.h
│  │  │  ├─ 📄soundchannel.cpp
│  │  │  ├─ 📄soundchannel.h
│  │  │  ├─ 📄soundfile.cpp
│  │  │  ├─ 📄soundfile.h
│  │  │  ├─ 📄soundmanager.cpp
│  │  │  ├─ 📄soundmanager.h
│  │  │  ├─ 📄soundsource.cpp
│  │  │  ├─ 📄soundsource.h
│  │  │  ├─ 📄streamsoundsource.cpp
│  │  │  └─ 📄streamsoundsource.h
│  │  ├─ 📁stdext
│  │  │  ├─ 📄any.h
│  │  │  ├─ 📄boolean.h
│  │  │  ├─ 📄cast.h
│  │  │  ├─ 📄compiler.h
│  │  │  ├─ 📄demangle.cpp
│  │  │  ├─ 📄demangle.h
│  │  │  ├─ 📄dumper.h
│  │  │  ├─ 📄dynamic_storage.h
│  │  │  ├─ 📄exception.h
│  │  │  ├─ 📄fastrand.h
│  │  │  ├─ 📄format.h
│  │  │  ├─ 📄math.cpp
│  │  │  ├─ 📄math.h
│  │  │  ├─ 📄net.cpp
│  │  │  ├─ 📄net.h
│  │  │  ├─ 📄packed_any.h
│  │  │  ├─ 📄packed_storage.h
│  │  │  ├─ 📄stdext.h
│  │  │  ├─ 📄string.cpp
│  │  │  ├─ 📄string.h
│  │  │  ├─ 📄thread.h
│  │  │  ├─ 📄time.cpp
│  │  │  ├─ 📄time.h
│  │  │  ├─ 📄traits.h
│  │  │  ├─ 📄types.h
│  │  │  ├─ 📄uri.cpp
│  │  │  └─ 📄uri.h
│  │  ├─ 📁ui
│  │  │  ├─ 📄declarations.h
│  │  │  ├─ 📄ui.h
│  │  │  ├─ 📄uianchorlayout.cpp
│  │  │  ├─ 📄uianchorlayout.h
│  │  │  ├─ 📄uiboxlayout.cpp
│  │  │  ├─ 📄uiboxlayout.h
│  │  │  ├─ 📄uiflexbox.cpp
│  │  │  ├─ 📄uiflexbox.h
│  │  │  ├─ 📄uigridlayout.cpp
│  │  │  ├─ 📄uigridlayout.h
│  │  │  ├─ 📄uihorizontallayout.cpp
│  │  │  ├─ 📄uihorizontallayout.h
│  │  │  ├─ 📄uilayout.cpp
│  │  │  ├─ 📄uilayout.h
│  │  │  ├─ 📄uimanager.cpp
│  │  │  ├─ 📄uimanager.h
│  │  │  ├─ 📄uitextedit.cpp
│  │  │  ├─ 📄uitextedit.h
│  │  │  ├─ 📄uitranslator.cpp
│  │  │  ├─ 📄uitranslator.h
│  │  │  ├─ 📄uiverticallayout.cpp
│  │  │  ├─ 📄uiverticallayout.h
│  │  │  ├─ 📄uiwidget.cpp
│  │  │  ├─ 📄uiwidget.h
│  │  │  ├─ 📄uiwidgetbasestyle.cpp
│  │  │  ├─ 📄uiwidgetimage.cpp
│  │  │  └─ 📄uiwidgettext.cpp
│  │  ├─ 📁util
│  │  │  ├─ 📄color.cpp
│  │  │  ├─ 📄color.h
│  │  │  ├─ 📄crypt.cpp
│  │  │  ├─ 📄crypt.h
│  │  │  ├─ 📄databuffer.h
│  │  │  ├─ 📄extras.cpp
│  │  │  ├─ 📄extras.h
│  │  │  ├─ 📄framecounter.h
│  │  │  ├─ 📄matrix.h
│  │  │  ├─ 📄pngunpacker.cpp
│  │  │  ├─ 📄pngunpacker.h
│  │  │  ├─ 📄point.h
│  │  │  ├─ 📄qrcodegen.c
│  │  │  ├─ 📄qrcodegen.h
│  │  │  ├─ 📄rect.h
│  │  │  ├─ 📄size.h
│  │  │  ├─ 📄stats.cpp
│  │  │  └─ 📄stats.h
│  │  ├─ 📁xml
│  │  │  ├─ 📄tinystr.cpp
│  │  │  ├─ 📄tinystr.h
│  │  │  ├─ 📄tinyxml.cpp
│  │  │  ├─ 📄tinyxml.h
│  │  │  ├─ 📄tinyxmlerror.cpp
│  │  │  └─ 📄tinyxmlparser.cpp
│  │  ├─ 📄CMakeLists.txt
│  │  ├─ 📄const.h
│  │  ├─ 📄global.h
│  │  ├─ 📄luafunctions.cpp
│  │  └─ 📄pch.h
│  ├─ 📄main.cpp
│  ├─ 📄otcicon.ico
│  ├─ 📄otcicon.rc
│  ├─ 📄otclient.rc
│  └─ 📄resource.h
├─ 📄CMakeLists.txt
├─ 📄premake5.lua
└─ 📄vcpkg.json
```
