#
#   Copyright 2013 Pixar
#
#   Licensed under the Apache License, Version 2.0 (the "Apache License")
#   with the following modification; you may not use this file except in
#   compliance with the Apache License and the following modification to it:
#   Section 6. Trademarks. is deleted and replaced with:
#
#   6. Trademarks. This License does not grant permission to use the trade
#      names, trademarks, service marks, or product names of the Licensor
#      and its affiliates, except as required to comply with Section 4(c) of
#      the License and to reproduce the content of the NOTICE file.
#
#   You may obtain a copy of the Apache License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the Apache License with the above modification is
#   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
#   KIND, either express or implied. See the Apache License for the specific
#   language governing permissions and limitations under the Apache License.
#

# Try to find DirectX SDK.
# Once done this will define
#
# DXSDK_FOUND
# DXSDK_INCLUDE_DIR
# DXSDK_LIBRARY_DIR
# DXSDK_LIBRARIES
# DXSDK_LOCATION
#
# Also will define

if (WIN32)
    # Find the win10 SDK path.
    if ("$ENV{WIN10_SDK_PATH}$ENV{WIN10_SDK_VERSION}" STREQUAL "" )
      get_filename_component(WIN10_SDK_PATH "[HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0;InstallationFolder]" ABSOLUTE CACHE)
      get_filename_component(TEMP_WIN10_SDK_VERSION "[HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Microsoft\\Microsoft SDKs\\Windows\\v10.0;ProductVersion]" ABSOLUTE CACHE)
      get_filename_component(WIN10_SDK_VERSION ${TEMP_WIN10_SDK_VERSION} NAME)
    else()
      set (WIN10_SDK_PATH $ENV{WIN10_SDK_PATH})
      set (WIN10_SDK_VERSION $ENV{WIN10_SDK_VERSION})
    endif()
    if (IS_DIRECTORY "${WIN10_SDK_PATH}/Include/${WIN10_SDK_VERSION}.0")
      set(WIN10_SDK_VERSION "${WIN10_SDK_VERSION}.0")
    endif()

    find_path(DXSDK_INCLUDE_DIR
        NAMES
            D3D11.h D3Dcompiler.h
        PATHS
            "${WIN10_SDK_PATH}/Include/${WIN10_SDK_VERSION}"
    )

    foreach(DX_LIB d3d11 d3dcompiler)
        find_library(DXSDK_${DX_LIB}_LIBRARY
            NAMES 
                ${DX_LIB}.lib
            PATHS
                "${WIN10_SDK_PATH}/Lib/${WIN10_SDK_VERSION}/um/x64"
                "${WIN10_SDK_PATH}/Lib/${WIN10_SDK_VERSION}/um/x86"
        )
        if(NOT DXSDK_${DX_LIB}_LIBRARY)
            message(FATAL_ERROR "Could not find required library ${DX_LIB}")
        else()
            list(APPEND DXSDK_LIBRARIES ${DXSDK_${DX_LIB}_LIBRARY})
        endif()
    endforeach(DX_LIB)

    list(GET DXSDK_LIBRARIES 0 D3D11_LIBRARY)
    get_filename_component(DXSDK_LIBRARY_DIR ${D3D11_LIBRARY} DIRECTORY)
    message (STATUS "DX11 headers path:   ${DXSDK_INCLUDE_DIR}")
    message (STATUS "DX11 libraries path: ${DXSDK_LIBRARY_DIR}")
endif ()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(DXSDK DEFAULT_MSG
    DXSDK_INCLUDE_DIR
    DXSDK_LIBRARY_DIR
    DXSDK_LIBRARIES
)

mark_as_advanced(
    DXSDK_INCLUDE_DIR
    DXSDK_LIBRARY_DIR
    DXSDK_LIBRARIES
)
