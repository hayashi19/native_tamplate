# Dart FFI Application

### Description

This documentation is created to record the usage of Dart FFI in Flutter applications. This documentation was initially created for personal learning purposes, so there may be some inaccuracies in the approach.

The application to be built is a simple application for calculating Fibonacci and factorial values. The application will generate random numbers using the `Random()` function from Dart. The random value will be assigned to the `num` variable. The calculations for `fibonacci(n)` and `factorial(n)` will be performed using functions created with C++.

### 🖥️Platforms

- [x] Windows
- [x] Android
- [ ] Web

### 📚Dependencies

- ffi: ^2.0.1
- [ffigen: ^8.0.2](https://pub.dev/packages/ffigen)

### 📱Usage

1. Build the flutter project with template ffi

```
flutter create --platforms=android,ios,macos,windows,linux --template=plugin_ffi project_name
```

2. Modify the library

main c++ library file located in .\src

.\src\native_math.cpp

```c++
#include "native_math.h"

// Factorial function
int factorial(int n)
{
  if (n == 0)
  {
    return 1;
  }
  else
  {
    return n * factorial(n - 1);
  }
}

// Fibonacci function
int fibonacci(int n)
{
  if (n == 0)
  {
    return 0;
  }
  else if (n == 1)
  {
    return 1;
  }
  else
  {
    return fibonacci(n - 1) + fibonacci(n - 2);
  }
}
```

.\src\native_math.h
> do not forget to use extern c, if the library code using c++
```
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

#ifdef __cplusplus
extern "C"
{
#endif

    FFI_PLUGIN_EXPORT int factorial(int n);

    FFI_PLUGIN_EXPORT int fibonacci(int n);

#ifdef __cplusplus
}
#endif
```

3. CMake configuration for c++ library

.\src\CMakeLists.txt

```cmake
# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(
    native_math_library # -> library name
    VERSION 0.0.1       # -> library version
    LANGUAGES C
)

add_library(
    native_math         # -> shared name
    SHARED
    "native_math.cpp"   # -> main c++ library file
)


set_target_properties(
    native_math                         # -> shared name
    PROPERTIES
    PUBLIC_HEADER native_tamplate.h     # -> shared header name
    OUTPUT_NAME "native_math"           # -> shared name
)

target_compile_definitions(
    native_math         # -> shared name
    PUBLIC 
    DART_SHARED_LIB
)
```

4. CMake config for windows (in library)

.\windows\CMakeLists.txt

```cmake
# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "native_tamplate")     # -> project name (same as in pubspec.yaml)
project(${PROJECT_NAME} LANGUAGES CXX)

# Invoke the build for native code shared with the other target platforms.
# This can be changed to accommodate different builds.
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(
    native_tamplate_bundled_libraries   # -> {project name}_bundled_libraries
    # Defined in ../src/CMakeLists.txt.
    # This can be changed to accommodate different builds.
    $<TARGET_FILE:native_math>          # -> $<TARGET_FILE:{shared name}> (from .\src\CMakeLists.txt)
    PARENT_SCOPE
)
```

5. Config c++ lib gradle

.\android\build.gradle

```gradle
// The Android Gradle Plugin builds the native code with the Android NDK.

group 'com.example.native_tamplate'
version '1.0'

buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // The Android Gradle Plugin knows how to build native code with the NDK.
        classpath 'com.android.tools.build:gradle:7.3.0'
    }
}

rootProject.allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

apply plugin: 'com.android.library'

android {
    // Bumping the plugin compileSdkVersion requires all clients of this plugin
    // to bump the version in their app.
    compileSdkVersion 31

    // ADD THIS BLOCK
    // ====================================================================
    // Bumping the plugin ndkVersion requires all clients of this plugin to bump
    // the version in their app and to download a newer version of the NDK.
    ndkVersion "23.1.7779620"

    // Invoke the shared CMake build with the Android Gradle Plugin.
    externalNativeBuild {
        cmake {
            path "../src/CMakeLists.txt"

            // The default CMake version for the Android Gradle Plugin is 3.10.2.
            // https://developer.android.com/studio/projects/install-ndk#vanilla_cmake
            //
            // The Flutter tooling requires that developers have CMake 3.10 or later
            // installed. You should not increase this version, as doing so will cause
            // the plugin to fail to compile for some customers of the plugin.
            // version "3.10.2"
        }
    }
    // ====================================================================

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
        minSdkVersion 16
    }
}
```

for add other platfrom use
```
flutter create --platforms {platform_name} .
```