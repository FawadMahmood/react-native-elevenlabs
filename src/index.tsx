import { NitroModules } from 'react-native-nitro-modules';
import type { Elevenlabs } from './Elevenlabs.nitro';

const ElevenlabsHybridObject =
  NitroModules.createHybridObject<Elevenlabs>('Elevenlabs');

export function multiply(a: number, b: number): number {
  return ElevenlabsHybridObject.multiply(a, b);
}
