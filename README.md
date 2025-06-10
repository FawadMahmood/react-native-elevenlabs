# react-native-elevenlabs

A React Native TurboModule for integrating [ElevenLabsSwift](https://github.com/elevenlabs/ElevenLabsSwift) conversational AI features in your iOS app.

---

## Features

- Start and stop conversational AI sessions
- Receive real-time events: message, connect, disconnect, error, status change, mode change, volume update
- Written in Swift with TurboModule support

---

## Installation

### 1. Add the ElevenLabsSwift Swift Package

**Required:**  
Your app must add the [ElevenLabsSwift](https://github.com/elevenlabs/ElevenLabsSwift) Swift Package.

- In Xcode, go to **File > Add Packages...**
- Enter: `https://github.com/elevenlabs/ElevenLabsSwift`
- Add the package to your app target.

### 2. Install the React Native Module

```sh
npm install react-native-elevenlabs
# or
yarn add react-native-elevenlabs