package com.elevenlabs

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap

@ReactModule(name = ElevenlabsModule.NAME)
class ElevenlabsModule(reactContext: ReactApplicationContext) :
  NativeElevenlabsSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  override fun startConversation(agentId: String, dynamicVariables: ReadableMap?) {
    // TODO: Implement actual logic to start conversation
  }

  override fun stopConversation() {
    // TODO: Implement actual logic to stop conversation
  }

  companion object {
    const val NAME = "Elevenlabs"
  }
}
