import 'dart:ffi';
import 'dart:io';

import 'native_template_bindings_generated.dart';

const String _libName = 'native_math';

/// The dynamic library in which the symbols for [NativeTemplateBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final NativeTemplateBindings _bindings = NativeTemplateBindings(_dylib);

int factorial(int n) {
  try {
    return _bindings.factorial(n);
  } catch (e) {
    print(e);
    return -1;
  }
}

int fibonacci(int n) {
  try {
    return _bindings.fibonacci(n);
  } catch (e) {
    print(e);
    return -1;
  }
}
