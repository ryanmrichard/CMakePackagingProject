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
include(get_recipe/ctor_add_kwargs)

## Adds ``GetFromDisk``'s kwargs to a ``Kwargs`` instance
#
# :param kwargs: A handle to the ``Kwargs`` instance we are modifying.
function(_cpp_GetFromDisk_ctor_add_kwargs _cGcak_kwargs)
    _cpp_GetRecipe_ctor_add_kwargs(${_cGcak_kwargs})
endfunction()
