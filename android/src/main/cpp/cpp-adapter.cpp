#include <jni.h>
#include "elevenlabsOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {
  return margelo::nitro::elevenlabs::initialize(vm);
}
