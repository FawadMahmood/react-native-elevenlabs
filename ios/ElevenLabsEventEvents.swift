import Foundation

@objc public class ElevenLabsEventEvents: NSObject {
    @objc public static let onConnect = "ConversationalAIOnConnect"
    @objc public static let onDisconnect = "ConversationalAIOnDisconnect"
    @objc public static let onMessage = "ConversationalAIOnMessage"
    @objc public static let onError = "ConversationalAIOnError"
    @objc public static let onStatusChange = "ConversationalAIOnStatusChange"
    @objc public static let onModeChange = "ConversationalAIOnModeChange"
    @objc public static let onVolumeUpdate = "ConversationalAIOnVolumeUpdate"
}