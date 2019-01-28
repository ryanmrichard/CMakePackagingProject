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
include(object/object)

## Constructor for the GetRecipe  baseclass
#
# Get recipes are responsible for being able to get a tarball of a dependency's
# source code. There are a variety of mechanisms for doing this and each one of
# those mechanisms is implemented as class derived from the ``GetRecipe`` class.
#
# Members:
#
# * version - The version of the dependency this recipe is for.
#
# :param handle: The identifier that will hold the newly created object
# :param version: The version of the dependency this recipe is for. If blank the
#                 version will be set to "latest"
function(_cpp_GetRecipe_ctor _cGc_handle _cGc_version)
    _cpp_Object_ctor(_cGc_temp)
    _cpp_Object_set_type(${_cGc_temp} GetRecipe)
    _cpp_Object_add_members(${_cGc_temp} version)
    cpp_option(_cGc_version "latest")
    _cpp_Object_set_value(${_cGc_temp} version ${_cGc_version})
    _cpp_set_return(${_cGc_handle} ${_cGc_temp})
endfunction()
