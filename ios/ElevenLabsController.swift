import Foundation

@objc(ElevenLabsController)
public class ElevenLabsController: NSObject {
  private var currentAgentIndex = 0
  private var conversation: ElevenLabsSDK.Conversation?
  private var audioLevel: Float = 0.0
  private var mode: ElevenLabsSDK.Mode = .listening
  private var status: ElevenLabsSDK.Status = .disconnected
  private var eventEmitter: ((String, [String: Any]) -> Void)?

  
  @objc
  func multiply(a: Double, b: Double) -> NSNumber {
      return NSNumber(value: a * b)
  }
  
  @objc public func setEventEmitter(_ emitter: @escaping (String, [String: Any]) -> Void) {
      self.eventEmitter = emitter
  }
  
  
  @objc public func stopConversation() {
    if status == .connected {
      conversation?.endSession()
      conversation = nil
      status = .disconnected
//      sendEventToJS(name: "ConversationalAIOnDisconnect", body: [:])
    }
  }
  
  
  @objc public func startConversation(_ agentId: String) {
    if status == .connected {
          conversation?.endSession()
          conversation = nil
          status = .disconnected
        } else {
        let config = ElevenLabsSDK.SessionConfig(agentId: agentId)
        var callbacks = ElevenLabsSDK.Callbacks()

        callbacks.onConnect = { [weak self] conversationId in
          self?.status = .connected
          let eventName = ElevenLabsEventEvents.onConnect
          self?.eventEmitter?(eventName, ["conversationId": conversationId])
        }

        callbacks.onDisconnect = { [weak self] in
          self?.status = .disconnected
          let eventName = ElevenLabsEventEvents.onDisconnect as NSString as String
          self?.eventEmitter?(eventName,  [:])
        }

        callbacks.onMessage = { [weak self] message, role in
          let roleValue = role.rawValue
          DispatchQueue.main.async {
            let eventName = ElevenLabsEventEvents.onMessage
            self?.eventEmitter?(eventName, ["message": message, "role": roleValue])
          }
        }

        callbacks.onError = { [weak self] errorMessage, info in
          let eventName = ElevenLabsEventEvents.onError
          self?.eventEmitter?(eventName,  ["error": errorMessage, "info": info ?? ""])
        }

        callbacks.onStatusChange = { [weak self] newStatus in
          DispatchQueue.main.async {
            let eventName = ElevenLabsEventEvents.onStatusChange
            self?.eventEmitter?(eventName,  ["status": newStatus.rawValue])
          }
        }

        callbacks.onModeChange = { [weak self] newMode in
          DispatchQueue.main.async {
            let eventName = ElevenLabsEventEvents.onModeChange
            self?.eventEmitter?(eventName, ["mode": newMode.rawValue])
          }
        }

        callbacks.onVolumeUpdate = { [weak self] newVolume in
          DispatchQueue.main.async {
            let eventName = ElevenLabsEventEvents.onVolumeUpdate
            self?.eventEmitter?(eventName, ["volume": newVolume])
          }
        }

        Task { [weak self] in
          let conversation = try? await ElevenLabsSDK.Conversation.startSession(config: config, callbacks: callbacks)
          self?.conversation = conversation
        }
      }
  }
}
