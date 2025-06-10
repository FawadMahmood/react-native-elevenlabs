import Elevenlabs from './NativeElevenlabs';

export function startConversation(
  agentId: string,
  dynamicVariables?: { [key: string]: string | number | boolean }
) {
  Elevenlabs.startConversation(agentId, dynamicVariables);
}

export function stopConversation() {
  Elevenlabs.stopConversation();
}

export default Elevenlabs;
