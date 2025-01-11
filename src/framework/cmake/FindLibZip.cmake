find_package(PkgConfig)
find_path(LIBZIP_INCLUDE_DIR
    NAMES zip.h
    PATHS
    ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include
    PATH_SUFFIXES libzip
)

find_library(LIBZIP_LIBRARY
    NAMES zip libzip
    PATHS
    ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibZip
    REQUIRED_VARS LIBZIP_LIBRARY LIBZIP_INCLUDE_DIR
)

if(LibZip_FOUND AND NOT TARGET LibZip::LibZip)
    add_library(LibZip::LibZip UNKNOWN IMPORTED)
    set_target_properties(LibZip::LibZip PROPERTIES
        IMPORTED_LOCATION "${LIBZIP_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${LIBZIP_INCLUDE_DIR}"
    )
endif()
