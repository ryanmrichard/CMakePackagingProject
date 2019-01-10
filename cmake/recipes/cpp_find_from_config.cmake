################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(dependency/cpp_sanitize_version)
include(recipes/cpp_handle_found_var)

## Function that attempts to locate a dependency through config files.
#
# This function wraps CMake's ``find_package`` function in "config" mode. For
# sanity reasons we dramatically limit the places CMake can look. Specifically
# we limit CMake to paths provided by the ``CMAKE_PREFIX_PATH`` variable and any
# hint path provided to this function.
#
# :param found: Will be set to True if the package was found and false
#     otherwise.
# :param name: The name of the dependency we are attempting to locate.
# :param version: The minimum version of the dependency we are trying to find.
# :param comps: A list of the components the dependency must have.
# :param path: A hint for where ``find_package`` should look.
#
# :CMake Variables:
#
#     * *CMAKE_PREFIX_PATH* - Used to provide ``find_package`` a list of end-
#       user provided paths.
function(_cpp_find_from_config _cffc_found _cffc_name _cffc_version _cffc_comps
                               _cffc_path)
    #This only honors CMAKE_PREFIX_PATH and whatever paths were provided
    _cpp_sanitize_version(_cffc_temp "${_cffc_version}")
    _cpp_debug_print(
        "Attempting to find ${_cffc_name} version ${_cffc_temp} via config."
    )
    _cpp_debug_print("CMAKE_PREFIX_PATH is: ${CMAKE_PREFIX_PATH}")
    _cpp_debug_print("Additional search path: ${_cffc_path}")
    #CMake doesn't append the additional search path onto prefix path so
    #dependencies relying on prefix_path to find their dependencies won't find
    #them without this next line
    list(APPEND CMAKE_PREFIX_PATH ${_cffc_path})
    find_package(
        ${_cffc_name}
        ${_cffc_temp}
        ${_cffc_comps}
        CONFIG
        QUIET
        PATHS "${_cffc_path}"
        NO_PACKAGE_ROOT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
    )
    #CMake sets Name_DIR to Name_DIR-NOTFOUND if the config file wasn't found
    #this screws with thte call to special_find, so unset it
    set(_cffc_dir ${_cffc_name}_DIR)
    set(_cffc_value "${${_cffc_dir}}")
    _cpp_debug_print("After search: ${_cffc_dir} = ${_cffc_value}")
    if("${_cffc_value}" STREQUAL "${_cffc_dir}-NOTFOUND")
        unset(${_cffc_dir} CACHE)
    else()
        set(_cffc_helper_target _cpp_${_cffc_name}_External)
        _cpp_is_target(_cffc_is_target ${_cffc_helper_target})
        if(_cffc_is_target)
            set_target_properties(
                ${_cffc_helper_target}
                PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                "${_cffc_dir} ${_cffc_value}"
            )
        endif()
    endif()
    _cpp_handle_found_var(_cffc_was_found ${_cffc_name})
    set(${_cffc_found} ${_cffc_was_found} PARENT_SCOPE)
endfunction()
