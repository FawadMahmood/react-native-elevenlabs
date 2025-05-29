package com.margelo.nitro.elevenlabs
  
import com.facebook.proguard.annotations.DoNotStrip

@DoNotStrip
class Elevenlabs : HybridElevenlabsSpec() {
  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }
}
