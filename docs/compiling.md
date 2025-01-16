# Compilation Instructions

## General Requirements
Before compiling on any platform, ensure the necessary tools like `git`, `powershell`, and `wget` are installed on your system. Each platform has specific commands to setup and build the project using Vcpkg and Premake.

## Windows

### Prerequisites
- Visual Studio 2022
- Git
- PowerShell

### Setup and Build
1. Open PowerShell as Administrator.
2. Clone and setup Vcpkg:
    ```sh
    git clone https://github.com/Microsoft/vcpkg.git
    cd vcpkg
    .\bootstrap-vcpkg.bat
    .\vcpkg.exe integrate install
    .\vcpkg.exe install --triplet x64-windows
    cd ..
    ```
3. Install dependencies:
    ```sh
    make setup-windows
    ```
4. Compile the project:
    ```sh
    make build-windows
    ```

### Additional Commands
- To clean the build:
    ```sh
    make clean-windows
    ```
- To rebuild the project:
    ```sh
    make rebuild-windows
    ```

## Linux

### Prerequisites
- GCC, G++, cmake, and other build essentials
- Git

### Setup and Build
1. Open Terminal.
2. Install required libraries:
    ```sh
    sudo apt update
    sudo apt install build-essential git cmake gcc g++ pkg-config autoconf libtool libglew-dev -y
    ```
3. Setup Vcpkg and install dependencies:
    ```sh
    make setup-linux
    ```
4. Compile the project:
    ```sh
    make build-linux
    ```

### Additional Commands
- To clean the build:
    ```sh
    make clean-linux
    ```
- To rebuild the project:
    ```sh
    make rebuild-linux
    ```

## macOS

### Prerequisites
- Xcode Command Line Tools
- Homebrew
- Git

### Setup and Build
1. Open Terminal.
2. Install required libraries using Homebrew:
    ```sh
    brew install cmake git
    ```
3. Setup Vcpkg and install dependencies:
    ```sh
    make setup-macos
    ```
4. Compile the project:
    ```sh
    make build-macos
    ```

### Additional Commands
- To clean the build:
    ```sh
    make clean-macos
    ```
- To rebuild the project:
    ```sh
    make rebuild-macos
    ```

## Common Make Commands
- **Setup**: Configures project dependencies.
- **Build**: Compiles the project.
- **Debug**: Builds the project in debug mode.
- **Release**: Builds the project in release mode.
- **Clean**: Removes build artifacts.
- **Rebuild**: Cleans and rebuilds the project.
- **Help**: Displays help message.
- **Update dependencies**: Updates VCPkg and Premake dependencies.

For more specific instructions or troubleshooting, refer to the output of the `make help` command relevant to your platform.
