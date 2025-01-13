# ******************************************************************************
# OTClientV8 Build System Makefile
# ******************************************************************************
.PHONY: all setup vcpkg premake build clean debug release rebuild \
        vcpkg-windows premake-windows build-windows \
        clean-windows debug-windows release-windows rebuild-windows \
        setup-windows \
        vcpkg-linux premake-linux build-linux \
        clean-linux debug-linux release-linux rebuild-linux \
        setup-linux \
        vcpkg-macos premake-macos build-macos \
        clean-macos debug-macos release-macos rebuild-macos \
        setup-macos

# ******************************************************************************
# Build Configuration
# ******************************************************************************
# Configure MSBuild path
MSBUILD = "D:/Visual studio/2022 Community/MSBuild/Current/Bin/MSBuild.exe"

# MSBuild options
MSBUILD_OPTIONS = /p:Configuration=Release \
                 /p:Platform=x64 \
                 /p:VcpkgEnabled=true \
                 /p:VcpkgEnableManifest=true \
                 /p:VcpkgManifestInstall=true \
                 /p:VcpkgConfiguration=Release


# ******************************************************************************
# Platform Detection
# ******************************************************************************
ifeq ($(OS),Windows_NT)
    PLATFORM := WINDOWS
else
    PLATFORM := $(shell uname -s | tr '[:lower:]' '[:upper:]')
endif

# ******************************************************************************
# Default Targets
# ******************************************************************************
all: setup build

setup: vcpkg premake

vcpkg:
	@echo "VCPkg setup not implemented for this platform"

premake:
	@echo "Premake setup not implemented for this platform"

build:
	@echo "Build not implemented for this platform"

debug:
	@echo "Debug build not implemented for this platform"

release:
	@echo "Release build not implemented for this platform"

clean:
	@echo "Clean not implemented for this platform"

rebuild: clean build

# ******************************************************************************
# Windows Platform Targets
# ******************************************************************************
ifeq ($(PLATFORM),WINDOWS)
setup: setup-windows
build: build-windows
debug: debug-windows
release: release-windows
rebuild: rebuild-windows
clean: clean-windows
endif

setup-windows: vcpkg-windows premake-windows

premake-windows:
	@echo Downloading Premake...
	@powershell -Command "& { \
		if (-not (Test-Path 'tools')) { \
			New-Item -ItemType Directory -Path 'tools' | Out-Null \
		} \
		if (-not (Test-Path 'tools/premake5.exe')) { \
			try { \
				Invoke-WebRequest -Uri 'https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-windows.zip' -OutFile 'tools/premake.zip' -ErrorAction Stop; \
				Expand-Archive -Path 'tools/premake.zip' -DestinationPath 'tools' -Force; \
				Remove-Item 'tools/premake.zip' -ErrorAction Stop; \
				Write-Host 'Premake downloaded successfully' \
			} catch { \
				Write-Host 'Failed to download Premake: $_'; \
				exit 1 \
			} \
		} else { \
			Write-Host 'Premake already exists' \
		} \
	}"

vcpkg-windows:
	@echo Configuring VCPkg...
	@powershell -Command "& { \
		if (-not (Test-Path 'vcpkg')) { \
			try { \
				git clone https://github.com/Microsoft/vcpkg.git; \
				Set-Location vcpkg; \
				./bootstrap-vcpkg.bat; \
				Write-Host 'VCPkg installed successfully' \
			} catch { \
				Write-Host 'Failed to install VCPkg: $_'; \
				exit 1 \
			} \
		} else { \
			Write-Host 'VCPkg already exists' \
		} \
	}"
	@vcpkg/vcpkg.exe install --triplet x64-windows

build-windows:
	@echo Generating project files...
	@tools/premake5.exe vs2022
	@echo Building project...
	@$(MSBUILD) build/otclient.sln $(MSBUILD_OPTIONS)

debug-windows:
	@echo Generating project files for Debug...
	@tools/premake5.exe vs2022
	@echo Building project in Debug mode...
	@$(MSBUILD) build/otclient.sln $(MSBUILD_OPTIONS) /p:Configuration=Debug

release-windows: build-windows

rebuild-windows: clean-windows build-windows

clean-windows:
	@powershell -Command "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue build,tools,vcpkg_installed"

# ******************************************************************************
# Linux Platform Targets
# ******************************************************************************
ifeq ($(PLATFORM),LINUX)
setup: setup-linux
build: build-linux
debug: debug-linux
release: release-linux
rebuild: rebuild-linux
clean: clean-linux
endif

setup-linux: vcpkg-linux premake-linux

vcpkg-linux:
	@echo "Configuring VCPkg for Linux (Not Implemented)"

premake-linux:
	@echo "Downloading Premake for Linux (Not Implemented)"

build-linux:
	@echo "Building for Linux (Not Implemented)"

debug-linux:
	@echo "Debug build for Linux (Not Implemented)"

release-linux:
	@echo "Release build for Linux (Not Implemented)"

clean-linux:
	@echo "Cleaning Linux build (Not Implemented)"

rebuild-linux:
	@echo "Rebuilding for Linux (Not Implemented)"

# ******************************************************************************
# macOS Platform Targets
# ******************************************************************************
ifeq ($(PLATFORM),DARWIN)
setup: setup-macos
build: build-macos
debug: debug-macos
release: release-macos
rebuild: rebuild-macos
clean: clean-macos
endif

setup-macos: vcpkg-macos premake-macos

vcpkg-macos:
	@echo "Configuring VCPkg for macOS (Not Implemented)"

premake-macos:
	@echo "Downloading Premake for macOS (Not Implemented)"

build-macos:
	@echo "Building for macOS (Not Implemented)"

debug-macos:
	@echo "Debug build for macOS (Not Implemented)"

release-macos:
	@echo "Release build for macOS (Not Implemented)"

clean-macos:
	@echo "Cleaning macOS build (Not Implemented)"

rebuild-macos:
	@echo "Rebuilding for macOS (Not Implemented)"
