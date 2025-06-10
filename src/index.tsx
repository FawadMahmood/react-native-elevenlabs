import Elevenlabs from './NativeElevenlabs';

export function startConversation(
  agentId: string,
  onSuccess: () => void,
  onError: (error: string) => void
) {
  Elevenlabs.startConversation(agentId, onSuccess, onError);
}

export function stopConversation() {
  Elevenlabs.stopConversation();
}

export default Elevenlabs;
