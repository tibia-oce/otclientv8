# FindLibZip.cmake
include(FindPackageHandleStandardArgs)

if(WIN32)
    # For Windows with vcpkg
    find_path(LIBZIP_INCLUDE_DIR_ZIP zip.h
        PATHS
            ${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include
            ${VCPKG_ROOT}/installed/${VCPKG_TARGET_TRIPLET}/include
        PATH_SUFFIXES
            libzip
    )

    find_path(LIBZIP_INCLUDE_DIR_ZIPCONF zipconf.h
        PATHS
            ${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include
            ${VCPKG_ROOT}/installed/${VCPKG_TARGET_TRIPLET}/include
        PATH_SUFFIXES
            libzip
    )

    find_library(LIBZIP_LIBRARY
        NAMES zip libzip
        PATHS
            ${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib
            ${VCPKG_ROOT}/installed/${VCPKG_TARGET_TRIPLET}/lib
    )
else()
    # For Unix systems
    find_package(PkgConfig)
    pkg_check_modules(PC_LIBZIP QUIET libzip)
    
    find_path(LIBZIP_INCLUDE_DIR_ZIP zip.h
        HINTS ${PC_LIBZIP_INCLUDE_DIRS}
        PATH_SUFFIXES libzip)

    find_path(LIBZIP_INCLUDE_DIR_ZIPCONF zipconf.h
        HINTS ${PC_LIBZIP_INCLUDE_DIRS})

    find_library(LIBZIP_LIBRARY NAMES zip libzip
        HINTS ${PC_LIBZIP_LIBRARY_DIRS})
endif()

find_package_handle_standard_args(LibZip
    REQUIRED_VARS 
        LIBZIP_LIBRARY 
        LIBZIP_INCLUDE_DIR_ZIP 
        LIBZIP_INCLUDE_DIR_ZIPCONF)

mark_as_advanced(LIBZIP_INCLUDE_DIR_ZIP LIBZIP_INCLUDE_DIR_ZIPCONF LIBZIP_LIBRARY)