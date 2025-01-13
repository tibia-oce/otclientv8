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
BUILD_TYPE ?= Release
PREMAKE_VERSION ?= 5.0.0-beta2
VCPKG_REPO ?= https://github.com/Microsoft/vcpkg.git
MSBUILD_OPTIONS = /p:Configuration=Release \
                 /p:Platform=x64 \
                 /p:VcpkgEnabled=true \
                 /p:VcpkgEnableManifest=true \
                 /p:VcpkgManifestInstall=true \
                 /p:VcpkgConfiguration=Release
ifeq ($(PLATFORM),WINDOWS)
    DETECTED_MSBUILD := $(shell where MSBuild.exe 2>nul)
    MSBUILD := $(if $(DETECTED_MSBUILD),$(DETECTED_MSBUILD),"D:/Visual studio/2022 Community/MSBuild/Current/Bin/MSBuild.exe")
endif
NPROC := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
JOBS ?= $(NPROC)
MAKEFLAGS += -j$(JOBS)
ifeq ($(PLATFORM),WINDOWS)
    # Check if MSBUILD path exists
    MSBUILD_CHECK := $(wildcard $(subst ",,$(MSBUILD)))
    ifeq ($(MSBUILD_CHECK),)
        $(error MSBuild not found at $(MSBUILD). 
Please set the correct path to MSBuild.exe using: 
  make MSBUILD="/path/to/MSBuild.exe"
Or update the MSBUILD variable in the Makefile.
Typical locations:
  - "D:/Visual Studio/2022/Community/MSBuild/Current/Bin/MSBuild.exe"
  - "C:/Program Files/Microsoft Visual Studio/2022/Community/MSBuild/Current/Bin/MSBuild.exe"
)
    endif
endif

# ******************************************************************************
# Requirements validation
# ******************************************************************************
ifeq ($(OS),Windows_NT)
    PLATFORM := WINDOWS
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        PLATFORM := LINUX
    endif
    ifeq ($(UNAME_S),Darwin)
        PLATFORM := MACOS
    endif
endif

ifeq ($(PLATFORM),WINDOWS)
    REQUIRED_TOOLS := git powershell
else ifeq ($(PLATFORM),LINUX)
    REQUIRED_TOOLS := git wget tar
else ifeq ($(PLATFORM),MACOS)
    REQUIRED_TOOLS := git wget tar
else
    REQUIRED_TOOLS :=
endif

K := $(foreach exec,$(REQUIRED_TOOLS),\
    $(if $(shell which $(exec)),,$(error "Missing required tool for $(PLATFORM): $(exec)")))

# ******************************************************************************
# Default Targets
# ******************************************************************************
ifeq ($(PLATFORM),LINUX)
all: setup build

setup: vcpkg-linux premake-linux

vcpkg: vcpkg-linux

premake: premake-linux

build: build-linux

debug: debug-linux

release: release-linux

clean: clean-linux

rebuild: rebuild-linux

else ifeq ($(PLATFORM),WINDOWS)
all: setup build

setup: vcpkg-windows premake-windows

vcpkg: vcpkg-windows

premake: premake-windows

build: build-windows

debug: debug-windows

release: release-windows

clean: clean-windows

rebuild: rebuild-windows

else ifeq ($(PLATFORM),MACOS)
all: setup build

setup: vcpkg-macos premake-macos

vcpkg: vcpkg-macos

premake: premake-macos

build: build-macos

debug: debug-macos

release: release-macos

clean: clean-macos

rebuild: rebuild-macos

else
all:
	@echo "Unsupported platform. Only Windows, Linux, and macOS are supported."

setup vcpkg premake build debug release clean rebuild:
	@echo "Unsupported platform. Only Windows, Linux, and macOS are supported."
endif

# ******************************************************************************
# Windows Platform Targets
# ******************************************************************************
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

# ******************************************************************************
# Utility Targets
# ******************************************************************************
help:
	@echo ""
	@echo "======================="
	@echo "OTClientV8 Build System"
	@echo "======================="
	@echo ""
	@echo "Available targets:"
	@echo "  all             Setup and build the project (default)"
	@echo "  setup           Configure project dependencies"
	@echo "  build           Compile the project"
	@echo "  debug           Build in debug mode"
	@echo "  clean           Remove build artifacts"
	@echo "  rebuild         Clean and rebuild the project"
	@echo "  help            Show this help message"
	@echo "  update-deps     Update VCPkg and Premake"
	@echo ""
	@echo "Build Configuration:"
	@echo "  BUILD_TYPE      $(BUILD_TYPE)"
	@echo "  PLATFORM        $(PLATFORM)"
	@echo "  Parallel Jobs   $(JOBS)"
	@echo ""
	@echo "Platform-specific targets can be used directly"
	@echo "Supported platforms: Windows, Linux, macOS"
	@echo ""

update-deps:
	@echo "Updating VCPkg and Premake dependencies..."
	@cd vcpkg && git pull
