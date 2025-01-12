.PHONY: all setup vcpkg premake build clean debug release rebuild

# Configure MSBuild path
MSBUILD = "D:/Visual studio/2022 Community/MSBuild/Current/Bin/MSBuild.exe"

# MSBuild options
MSBUILD_OPTIONS = /p:Configuration=Release \
				 /p:Platform=x64 \
				 /p:VcpkgEnabled=true \
				 /p:VcpkgEnableManifest=true \
				 /p:VcpkgManifestInstall=true \
				 /p:VcpkgConfiguration=Release

all: setup build

setup: vcpkg premake

premake:
	powershell -Command "if (-not (Test-Path 'tools')) { New-Item -ItemType Directory -Path 'tools' }"
	powershell -Command "if (-not (Test-Path 'tools/premake5.exe')) { \
		Invoke-WebRequest -Uri 'https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-windows.zip' -OutFile 'tools/premake.zip'; \
		Expand-Archive -Path 'tools/premake.zip' -DestinationPath 'tools'; \
		Remove-Item 'tools/premake.zip' \
	}"

vcpkg:
	powershell -Command "if (-not (Test-Path 'vcpkg')) { \
		git clone https://github.com/Microsoft/vcpkg.git; \
		cd vcpkg; \
		./bootstrap-vcpkg.bat \
	}"
	vcpkg/vcpkg.exe install --triplet x64-windows

build: release

debug:
	tools/premake5.exe vs2022
	$(MSBUILD) build/otclient.sln $(MSBUILD_OPTIONS) /p:Configuration=Debug

release:
	tools/premake5.exe vs2022
	$(MSBUILD) build/otclient.sln $(MSBUILD_OPTIONS)

rebuild: clean build

clean:
	powershell -Command "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue build,tools,vcpkg_installed"