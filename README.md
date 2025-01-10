# OTClientV8

> \[!NOTE]
>
>Based on [edubart/otclient](https://github.com/edubart/otclient).

OTClientV8 is highly optimized, cross-platform tile based 2d game engine built with c++17, lua, physfs, OpenGL ES 2.0 and OpenAL. It has been created as alternative client for game called Tibia. This client is designed specifically to work with the [Mythbound server](https://github.com/tibia-oce/server).

![rme](/docs/images/rme.png)

Supported platforms:
    - Mac Os (w/ https://www.xquartz.org/)
    - Windows (min. Windows 7)
    - Linux



## Getting started

Download the latest release [here](https://github.com/tibia-oce/otclientv8/releases/latest).  After compiling you need to provide the client a copy of the [https://github.com/tibia-oce/assets/tree/master/things/1098](assets) in `./data/things`

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
