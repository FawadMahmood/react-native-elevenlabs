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

  @objc public func startConversation(_ agentId: String) {
    if status == .connected {
      stopConversation()
    }

    let config = ElevenLabsSDK.SessionConfig(agentId: agentId)
    var callbacks = ElevenLabsSDK.Callbacks()

    callbacks.onConnect = { [weak self] conversationId in
      guard let self = self else { return }
      self.updateStatus(.connected)
      self.emitEvent(ElevenLabsEventEvents.onConnect, ["conversationId": conversationId])
    }

    callbacks.onDisconnect = { [weak self] in
      guard let self = self else { return }
      self.updateStatus(.disconnected)
      self.emitEvent(ElevenLabsEventEvents.onDisconnect, [:])
    }

    callbacks.onMessage = { [weak self] message, role in
      guard let self = self else { return }
      self.emitEvent(ElevenLabsEventEvents.onMessage, ["message": message, "role": role.rawValue])
    }

    callbacks.onError = { [weak self] errorMessage, info in
      guard let self = self else { return }
      self.emitEvent(ElevenLabsEventEvents.onError, ["error": errorMessage, "info": info ?? ""])
    }

    callbacks.onStatusChange = { [weak self] newStatus in
      guard let self = self else { return }
      self.updateStatus(newStatus)
    }

    callbacks.onModeChange = { [weak self] newMode in
      guard let self = self else { return }
      self.emitEvent(ElevenLabsEventEvents.onModeChange, ["mode": newMode.rawValue])
    }

    callbacks.onVolumeUpdate = { [weak self] newVolume in
      guard let self = self else { return }
      self.emitEvent(ElevenLabsEventEvents.onVolumeUpdate, ["volume": newVolume])
    }

    Task { [weak self] in
      guard let self = self else { return }
      let conversation = try? await ElevenLabsSDK.Conversation.startSession(config: config, callbacks: callbacks)
      self.conversation = conversation
    }
  }
}
