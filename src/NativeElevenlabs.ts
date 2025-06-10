import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

import type { EventEmitter } from 'react-native/Libraries/Types/CodegenTypes';

export type ConversationalAIOnMessage = {
  role: string;
  message: string;
};

export type ConversationalAIOnConnect = {
  conversationId: string;
};

export type ConversationalAIOnDisconnect = {};

export type ConversationalAIOnError = {
  error: string;
  info: string;
};

export type ConversationalAIOnStatusChange = {
  status: 'connecting' | 'connected' | 'disconnected' | 'disconnecting';
};

export type ConversationalAIOnModeChange = {
  mode: 'speaking' | 'listening';
};

export type ConversationalAIOnVolumeUpdate = {
  volume: number;
};

export interface Spec extends TurboModule {
  startConversation(
    agentId: string,
    dynamicVariables?: { [key: string]: string | number | boolean }
  ): void;
  stopConversation(): void;

  readonly onMessage: EventEmitter<ConversationalAIOnMessage>;
  readonly onConnect: EventEmitter<ConversationalAIOnConnect>;
  readonly onDisconnect: EventEmitter<ConversationalAIOnDisconnect>;
  readonly onError: EventEmitter<ConversationalAIOnError>;
  readonly onStatusChange: EventEmitter<ConversationalAIOnStatusChange>;
  readonly onModeChange: EventEmitter<ConversationalAIOnModeChange>;
  readonly onVolumeUpdate: EventEmitter<ConversationalAIOnVolumeUpdate>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('Elevenlabs');
