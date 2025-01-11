# FindLibZip.cmake
include(FindPackageHandleStandardArgs)

if(WIN32)
    find_path(LIBZIP_INCLUDE_DIR_ZIP
        NAMES zip.h
        PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include
        PATH_SUFFIXES libzip
    )
    
    find_path(LIBZIP_INCLUDE_DIR_ZIPCONF
        NAMES zipconf.h
        PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/include
    )
    
    find_library(LIBZIP_LIBRARY
        NAMES zip libzip
        PATHS ${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/lib
    )
else()
    find_path(LIBZIP_INCLUDE_DIR_ZIP
        NAMES zip.h
        PATH_SUFFIXES libzip
    )
    
    find_path(LIBZIP_INCLUDE_DIR_ZIPCONF
        NAMES zipconf.h
    )
    
    find_library(LIBZIP_LIBRARY
        NAMES zip libzip
    )
endif()

find_package_handle_standard_args(LibZip 
    REQUIRED_VARS LIBZIP_LIBRARY LIBZIP_INCLUDE_DIR_ZIP LIBZIP_INCLUDE_DIR_ZIPCONF
)

mark_as_advanced(LIBZIP_INCLUDE_DIR_ZIP LIBZIP_INCLUDE_DIR_ZIPCONF LIBZIP_LIBRARY)
