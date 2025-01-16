# OTClientV8

OTClientV8 is highly optimized, cross-platform tile based 2d game engine built with c++17, lua, physfs, OpenGL ES 2.0 and OpenAL. It has been created as alternative client for OpenTibia. This client is designed specifically to work with the [Mythbound server](https://github.com/tibia-oce/server).

<div style="text-align: center;">
  <table>
    <tr>
      <td>
        <img src="https://github.com/tibia-oce/otclientv8/blob/master/docs/images/login-screen.png" width="200" alt="Login Screen" style="max-width:200px;">
      </td>
      <td>
        <img src="https://github.com/kokekanon/OTredemption-Picture-NODELETE/blob/main/Picture/Attached%20Effect/Creature/001_Bone.gif?raw=true" width="200" alt="Character Attachments" style="max-width:200px;">
        </td>
      <td>
        <img src="https://github.com/tibia-oce/otclientv8/blob/master/docs/images/client.png" width="200" alt="Game Interface" style="max-width:200px;">
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

You can download a pre-compiled version [here](https://github.com/tibia-oce/otclientv8/releases/latest), or [compile](https://github.com/tibia-oce/otclientv8/docs/compiling.readme)) the client yourself.

Afterward, you need to provide the client a copy of the [assets](https://github.com/tibia-oce/assets/tree/master/things/1098) in `./data/things`.

## Latest Builds

| Platform       | Build        | Notes        |
| :------------- | :----------: | :----------: |
| Linux        | [![Build & Release](https://github.com/tibia-oce/otclientv8/actions/workflows/build-ubuntu.yaml/badge.svg)](https://github.com/tibia-oce/otclientv8/actions/workflows/build-ubuntu.yaml) | |
| Windows        | [![Build & Release](https://github.com/tibia-oce/otclientv8/actions/workflows/build-windows.yaml/badge.svg)](https://github.com/tibia-oce/otclientv8/actions/workflows/build-windows.yaml) | Requires Windows 7+ |
| MacOS        | [![Build & Release](https://github.com/tibia-oce/otclientv8/actions/workflows/build-macos.yaml/badge.svg)](https://github.com/tibia-oce/otclientv8/actions/workflows/build-macos.yaml) | Requires [xquartz](https://www.xquartz.org/) |

## Compilation

The project can be built on MacOS, Windows and Linux (Ubuntu 20/22), by running the command `make`.

For more specific instructions or troubleshooting, refer to the output of the `make help` command relevant to your platform.
- **Setup**: Configures project dependencies.
- **Build**: Compiles the project.
- **Debug**: Builds the project in debug mode.
- **Release**: Builds the project in release mode.
- **Clean**: Removes build artifacts.
- **Rebuild**: Cleans and rebuilds the project.
- **Help**: Displays help message.
- **Update dependencies**: Updates VCPkg and Premake dependencies.
