package com.elevenlabs

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = ElevenlabsModule.NAME)
class ElevenlabsModule(reactContext: ReactApplicationContext) :
  NativeElevenlabsSpec(reactContext) {

  override fun getName(): String {
    return NAME
  }

  override fun startConversation(agentId: String, promise: Promise) {
    try {
      // TODO: Implement actual logic to start conversation
      promise.resolve(null)
    } catch (e: Exception) {
      promise.reject("START_CONVERSATION_ERROR", e.message, e)
    }
  }

  override fun stopConversation() {
    // TODO: Implement actual logic to stop conversation
  }

  companion object {
    const val NAME = "Elevenlabs"
  }
}
