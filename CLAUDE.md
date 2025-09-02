# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a React Native library project for Marfeel Tracker, implementing a Turbo Module (New Architecture) for both iOS and Android platforms. The library uses Kotlin for Android and Objective-C++ for iOS.

## Architecture

### Module Structure
- **TypeScript Interface**: `src/NativeMarfeelTracker.ts` - Defines the TurboModule spec
- **Main Export**: `src/index.tsx` - Public API for the library
- **iOS Implementation**: `ios/MarfeelTracker.mm` - Objective-C++ implementation
- **Android Implementation**: `android/src/main/java/com/marfeeltracker/MarfeelTrackerModule.kt` - Kotlin implementation

### Build Configuration
- Uses `react-native-builder-bob` for building the library
- Configured for React Native's New Architecture (Turbo Modules + Fabric)
- Codegen configuration in `package.json` under `codegenConfig`

## Development Commands

### Library Development
```bash
# Install dependencies
yarn

# Type checking
yarn typecheck

# Linting
yarn lint
yarn lint --fix  # Auto-fix formatting

# Testing
yarn test

# Clean build artifacts
yarn clean

# Build the library
yarn prepare
```

### Example App Development

**Important**: This is a monorepo using `react-native-monorepo-config`. All example app commands must be run from the root directory, not from the example folder.

**Running the Example App**: You need to use two terminals:

**Terminal 1 - Start Metro bundler:**
```bash
yarn example start
```

**Terminal 2 - Run the app:**
```bash
# For iOS
yarn example ios

# For Android
yarn example android
```

**Build Commands:**
```bash
# Build iOS Debug mode (run from root)
yarn example build:ios

# Build Android (run from root)
yarn example build:android
```

## Testing

- Unit tests use Jest with React Native preset
- Test files located in `src/__tests__/`
- Run with `yarn test`

## Code Style

- TypeScript with strict mode enabled
- ESLint with React Native config
- Prettier for formatting (single quotes, 2 spaces, trailing comma ES5)
- Commit messages follow conventional commits specification

## Native Development

- **iOS**: Open `example/ios/MarfeelTrackerExample.xcworkspace` in Xcode
  - Source files at: `Pods > Development Pods > react-native-marfeel-tracker`
  
- **Android**: Open `example/android` in Android Studio
  - Source files at: `react-native-marfeel-tracker` module

## Release Process

Uses `release-it` for versioning and publishing:
```bash
yarn release
```