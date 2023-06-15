# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(native_math_library VERSION 0.0.1 LANGUAGES C)

add_library(native_math SHARED
  "native_math.cpp"
)

set_target_properties(native_math PROPERTIES
  PUBLIC_HEADER native_tamplate.h
  OUTPUT_NAME "native_math"
)

target_compile_definitions(native_math PUBLIC DART_SHARED_LIB)
