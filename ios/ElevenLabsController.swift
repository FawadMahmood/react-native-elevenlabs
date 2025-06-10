import Foundation

@objc(ElevenLabsController)
public class ElevenLabsController: NSObject {
  private var currentAgentIndex = 0
  private var conversation: ElevenLabsSDK.Conversation?
  private var audioLevel: Float = 0.0
  private var mode: ElevenLabsSDK.Mode = .listening
  private var status: ElevenLabsSDK.Status = .disconnected
  private var eventEmitter: ((String, [String: Any]) -> Void)?

  // Helper to emit events on main thread
  private func emitEvent(_ name: String, _ payload: [String: Any]) {
    DispatchQueue.main.async { [weak self] in
      self?.eventEmitter?(name, payload)
    }
  }

  @objc public func setEventEmitter(_ emitter: @escaping (String, [String: Any]) -> Void) {
    self.eventEmitter = emitter
  }

  @objc public func stopConversation() {
    guard status == .connected else { return }
    conversation?.endSession()
    conversation = nil
    updateStatus(.disconnected)
    emitEvent(ElevenLabsEventEvents.onDisconnect, [:])
  }

  private func updateStatus(_ newStatus: ElevenLabsSDK.Status) {
    status = newStatus
    emitEvent(ElevenLabsEventEvents.onStatusChange, ["status": newStatus.rawValue])
  }

  private func handleEvent(_ event: String, _ payload: [String: Any]) {
    emitEvent(event, payload)
  }


  private func setupCallbacks() -> ElevenLabsSDK.Callbacks {
    var callbacks = ElevenLabsSDK.Callbacks()
    callbacks.onConnect = { [weak self] conversationId in
        self?.handleEvent(ElevenLabsEventEvents.onConnect, ["conversationId": conversationId])
        self?.updateStatus(.connected)
    }
    callbacks.onDisconnect = { [weak self] in
        self?.handleEvent(ElevenLabsEventEvents.onDisconnect, [:])
        self?.updateStatus(.disconnected)
    }
    callbacks.onMessage = { [weak self] message, role in
        self?.handleEvent(ElevenLabsEventEvents.onMessage, ["message": message, "role": role.rawValue])
    }
    callbacks.onError = { [weak self] errorMessage, info in
        self?.handleEvent(ElevenLabsEventEvents.onError, ["error": errorMessage, "info": info ?? ""])
    }
    callbacks.onStatusChange = { [weak self] newStatus in
        self?.updateStatus(newStatus)
    }
    callbacks.onModeChange = { [weak self] newMode in
        self?.handleEvent(ElevenLabsEventEvents.onModeChange, ["mode": newMode.rawValue])
    }
    callbacks.onVolumeUpdate = { [weak self] newVolume in
        self?.handleEvent(ElevenLabsEventEvents.onVolumeUpdate, ["volume": newVolume])
    }
    return callbacks
  }

  @objc public func startConversation(_ agentId: String) {
    if status == .connected {
      stopConversation()
    }

    let config = ElevenLabsSDK.SessionConfig(agentId: agentId)
    let callbacks = setupCallbacks()

    Task { [weak self] in
      guard let self = self else { return }
      let conversation = try? await ElevenLabsSDK.Conversation.startSession(config: config, callbacks: callbacks)
      self.conversation = conversation
    }
  }
}
