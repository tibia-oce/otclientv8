find_package(PkgConfig)

# Try pkg-config first
pkg_check_modules(PC_LIBZIP QUIET libzip)

find_path(LIBZIP_INCLUDE_DIR
    NAMES zip.h
    PATHS
    ${PC_LIBZIP_INCLUDE_DIRS}
    ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include
    PATH_SUFFIXES libzip
)

if(WIN32)
    # On Windows, try both .lib and .dll
    find_library(LIBZIP_LIBRARY
        NAMES 
            zip libzip
            zip.lib libzip.lib
        PATHS
            ${PC_LIBZIP_LIBRARY_DIRS}
            ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib
            ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/bin
    )
else()
    find_library(LIBZIP_LIBRARY
        NAMES zip libzip
        PATHS
            ${PC_LIBZIP_LIBRARY_DIRS}
            ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib
    )
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibZip
    REQUIRED_VARS LIBZIP_LIBRARY LIBZIP_INCLUDE_DIR
    VERSION_VAR PC_LIBZIP_VERSION
)

if(LibZip_FOUND AND NOT TARGET LibZip::LibZip)
    add_library(LibZip::LibZip UNKNOWN IMPORTED)
    set_target_properties(LibZip::LibZip PROPERTIES
        IMPORTED_LOCATION "${LIBZIP_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${LIBZIP_INCLUDE_DIR}"
    )
    if(PC_LIBZIP_CFLAGS_OTHER)
        set_target_properties(LibZip::LibZip PROPERTIES
            INTERFACE_COMPILE_OPTIONS "${PC_LIBZIP_CFLAGS_OTHER}"
        )
    endif()
endif()

mark_as_advanced(LIBZIP_INCLUDE_DIR LIBZIP_LIBRARY)