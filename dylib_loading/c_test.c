#include <dlfcn.h>
#include <stdint.h>
#include <stdio.h>
int main() {
  void* handle = dlopen("/home/dashie/gits/ReSet/ReSet-Doc/dylib_loading/testlib/target/debug/libtestlib.so", RTLD_NOW | RTLD_GLOBAL);
  void* func = dlsym(handle, "test_function2");
  void (*gg)(int32_t) = (void (*)(int32_t))func;
  int pass;
  scanf("%d", &pass);
  gg(pass);
  int blocker;
  scanf("%d", &blocker);
}
