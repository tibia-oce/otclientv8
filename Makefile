# ******************************************************************************
# OTClientV8 Build System Makefile
# ******************************************************************************
.PHONY: all setup vcpkg premake build clean debug release rebuild help \
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
# Global Configuration
# ******************************************************************************
BUILD_TYPE ?= Release
PREMAKE_VERSION ?= 5.0.0-beta2
VCPKG_REPO ?= https://github.com/Microsoft/vcpkg.git
NPROC := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)
JOBS ?= $(NPROC)
MAKEFLAGS += -j$(JOBS)
REQUIRED_LIBS := libluajit-5.1-dev freeglut3-dev libasound2-dev libgl-dev libgl1-mesa-dev libglu1-mesa-dev libglew-dev libx11-dev libxi-dev libxmu-dev mesa-common-dev xorg-dev

# ******************************************************************************
# Platform Detection
# ******************************************************************************
ifeq ($(OS),Windows_NT)
    PLATFORM := WINDOWS
    SHELL = cmd.exe
else
    UNAME_S := $(shell uname -s)
    ifeq ($(UNAME_S),Linux)
        PLATFORM := LINUX
    endif
    ifeq ($(UNAME_S),Darwin)
        PLATFORM := MACOS
    endif
endif

# ******************************************************************************
# Windows-Specific Configuration
# ******************************************************************************
MSBUILD = "D:/Visual studio/2022 Community/MSBuild/Current/Bin/MSBuild.exe"
MSBUILD_OPTIONS = /p:Configuration=Release \
                 /p:Platform=x64 \
                 /p:VcpkgEnabled=true \
                 /p:VcpkgEnableManifest=true \
                 /p:VcpkgManifestInstall=true \
                 /p:VcpkgConfiguration=Release

# ******************************************************************************
# Required Tools Validation
# ******************************************************************************
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
ifeq ($(PLATFORM),WINDOWS)
all: setup build copy
setup: vcpkg-windows premake-windows
vcpkg: vcpkg-windows
premake: premake-windows
build: build-windows
debug: debug-windows
release: release-windows
clean: clean-windows
rebuild: rebuild-windows
copy: copy-windows-binaries

else ifeq ($(PLATFORM),LINUX)
all: setup build copy
setup: vcpkg-linux premake-linux
vcpkg: vcpkg-linux
premake: premake-linux
build: build-linux
debug: debug-linux
release: release-linux
clean: clean-linux
rebuild: rebuild-linux
copy: copy-linux-binaries

else ifeq ($(PLATFORM),MACOS)
all: setup build-macos
setup: vcpkg-macos premake-macos
vcpkg: vcpkg-macos
premake: premake-macos
build: build-macos
debug: debug-macos
release: release-macos
clean: clean-macos
rebuild: rebuild-macos

else
all: @echo "Unsupported platform. Only Windows, Linux, and macOS are supported."

setup vcpkg premake build debug release clean rebuild:
	@echo "Unsupported platform. Only Windows, Linux, and macOS are supported."
endif

# ******************************************************************************
# Windows Platform Targets
# ******************************************************************************
setup-windows: vcpkg-windows premake-windows

vcpkg-windows:
	@echo "Configuring VCPkg..."
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

premake-windows:
	@echo "Downloading Premake..."
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

build-windows: setup-windows
	@echo "Generating project files..."
	@tools/premake5.exe vs2022
	@echo "Building project..."
	@echo "Using MSBuild: $(MSBUILD)"
	@if not exist build/otclient.sln ( \
		echo "Solution file not found in build folder." && \
		exit 1 \
	)
	@$(MSBUILD) build/otclient.sln $(MSBUILD_OPTIONS) || ( \
		echo "Build failed" && \
		exit 1 \
	)

debug-windows: setup
	@echo "Generating project files for Debug..."
	@tools/premake5.exe vs2022
	@echo "Building project in Debug mode..."
	@$(MSBUILD) build/otclient.sln $(MSBUILD_OPTIONS) /p:Configuration=Debug

copy-windows-binaries: build-windows
	@echo "Moving built files to root directory..."
	@powershell -Command "Copy-Item 'build\bin\Release\*.dll','build\bin\Release\otclient.exe' -Destination '.' -Force -ErrorAction SilentlyContinue; exit 0"

release-windows: build-windows copy-windows-binaries

rebuild-windows: clean-windows release-windows

clean-windows:
	@powershell -Command "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue build,tools,vcpkg_installed; Remove-Item -Force -ErrorAction SilentlyContinue *.dll,otclient.exe; exit 0"

# ******************************************************************************
# Linux Platform Targets
# ******************************************************************************
setup-linux: linux-check-dependencies vcpkg-linux premake-linux

linux-check-dependencies:
ifeq ($(PLATFORM),LINUX)
	@echo "Checking required libraries..."
	@missing_libs=""
	@for lib in $(REQUIRED_LIBS); do \
		if ! dpkg-query -W -f='$${Status}' $$lib 2>/dev/null | grep -q "ok installed"; then \
			missing_libs="$$missing_libs $$lib"; \
		fi; \
	done
	@if [ ! -z "$$missing_libs" ]; then \
		echo "Warning: The following required libraries are missing:"; \
		echo "$$missing_libs"; \
		echo ""; \
		echo "You may need to install these libraries using the following command:"; \
		echo "sudo apt-get install$$missing_libs"; \
		echo ""; \
		echo "Continuing with the build process, but it may fail if dependencies are missing."; \
	else \
		echo "All required libraries are installed. Proceeding with the build..."; \
	fi
endif

vcpkg-linux:
	@echo "Configuring VCPkg for Linux..."
	@if [ ! -d vcpkg ]; then \
		git clone $(VCPKG_REPO); \
		cd vcpkg; \
		./bootstrap-vcpkg.sh; \
	fi
	@vcpkg/vcpkg install --triplet x64-linux

premake-linux: linux-check-dependencies
	@echo "Downloading Premake for Linux..."
	@mkdir -p tools
	@if [ ! -f tools/premake5 ]; then \
		wget --no-netrc -q --show-progress \
			-O tools/premake.tar.gz \
			"https://github.com/premake/premake-core/releases/download/v$(PREMAKE_VERSION)/premake-$(PREMAKE_VERSION)-linux.tar.gz" && \
		cd tools && \
		tar -xzf premake.tar.gz && \
		rm premake.tar.gz && \
		chmod +x premake5; \
	fi

build-linux: premake-linux
	@echo "Generating project files..."
	@./tools/premake5 gmake2
	@echo "Building project..."
	@$(MAKE) -C build config=release

debug-linux:
	@echo "Generating project files for Debug..."
	@tools/premake5 gmake2
	@echo "Building project in Debug mode..."
	@$(MAKE) -C build config=debug

copy-linux-binaries: setup-linux
	@echo "Moving built files to root directory..."
	@cp -f build/bin/Release/otclient ./otclient
	@chmod +x ./otclient
	@cp -f build/bin/Release/*.so ./ 2>/dev/null || true

release-linux: build-linux

rebuild-linux: clean-linux build-linux

clean-linux:
	@rm -rf build tools vcpkg_installed otclient otclientv8.log packet.log crash_report.log

# ******************************************************************************
# macOS Platform Targets
# ******************************************************************************
setup-macos: vcpkg-macos premake-macos

vcpkg-macos:
	@echo "Configuring VCPkg for macOS..."
	@if [ ! -d vcpkg ]; then \
		git clone $(VCPKG_REPO); \
		cd vcpkg; \
		./bootstrap-vcpkg.sh; \
	fi
	@vcpkg/vcpkg install --triplet x64-macos

premake-macos:
	@echo "Downloading Premake for macOS..."
	@mkdir -p tools
	@if [ ! -f tools/premake5 ]; then \
		wget -O tools/premake.tar.gz "https://github.com/premake/premake-core/releases/download/v$(PREMAKE_VERSION)/premake-$(PREMAKE_VERSION)-macos.tar.gz"; \
		tar -xzvf tools/premake.tar.gz -C tools; \
		rm tools/premake.tar.gz; \
		chmod +x tools/premake5; \
	fi

build-macos:
	@echo "Generating project files..."
	@tools/premake5 gmake2
	@echo "Building project..."
	@$(MAKE) -C build config=release

debug-macos:
	@echo "Generating project files for Debug..."
	@tools/premake5 gmake2
	@echo "Building project in Debug mode..."
	@$(MAKE) -C build config=debug

release-macos: build-macos

rebuild-macos: clean-macos build-macos

clean-macos:
	@rm -rf build tools vcpkg_installed

# ******************************************************************************
# Utility Targets
# ******************************************************************************
update-deps:
	@echo "Updating VCPkg and Premake dependencies..."
	@cd vcpkg && git pull

ifeq ($(PLATFORM),WINDOWS)
help:
	@echo.
	@echo =======================
	@echo OTClientV8 Build System
	@echo =======================
	@echo.
	@echo Available targets:
	@echo   all             Setup and build the project (default)
	@echo   setup           Configure project dependencies
	@echo   build           Compile the project
	@echo   debug           Build in debug mode
	@echo   clean           Remove build artifacts
	@echo   rebuild         Clean and rebuild the project
	@echo   help            Show this help message
	@echo   update-deps     Update VCPkg and Premake
	@echo.
	@echo Build Configuration:
	@echo   BUILD_TYPE      $(BUILD_TYPE)
	@echo   PLATFORM        $(PLATFORM)
	@echo   Parallel Jobs   $(JOBS)
	@echo.
	@echo Platform-specific targets can be used directly
	@echo Supported platforms: Windows, Linux, macOS
	@echo.
else
help:
	@echo
	@echo =======================
	@echo OTClientV8 Build System
	@echo =======================
	@echo
	@echo Available targets:
	@echo   all             Setup and build the project
	@echo   setup           Configure project dependencies
	@echo   build           Compile the project
	@echo   debug           Build in debug mode
	@echo   clean           Remove build artifacts
	@echo   rebuild         Clean and rebuild the project
	@echo   help            Show this help message
	@echo   update-deps     Update VCPkg and Premake
	@echo
	@echo Build Configuration:
	@echo   BUILD_TYPE      $(BUILD_TYPE)
	@echo   PLATFORM        $(PLATFORM)
	@echo   Parallel Jobs   $(JOBS)
	@echo
	@echo Platform-specific targets can be used directly
	@echo Supported platforms: Windows, Linux, macOS
	@echo
endif
