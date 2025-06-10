import Foundation
import ElevenLabsSDK

@objc(SwiftElevenlabs)
class SwiftElevenlabs: NSObject {
  private var currentAgentIndex = 0
  private var conversation: ElevenLabsSDK.Conversation?
  private var audioLevel: Float = 0.0
  private var mode: ElevenLabsSDK.Mode = .listening
  private var status: ElevenLabsSDK.Status = .disconnected
  
    @objc
    func multiply(a: Double, b: Double) -> NSNumber {
        return NSNumber(value: a * b)
    }
}
