# react-native-marfeel-tracker

React Native bindings for [Marfeel CompassTracking SDK](https://community.marfeel.com/t/native-android-sdk-instrumentation/8489) that let you record pageviews, clicks and user metadata from JavaScript while delegating the heavy lifting to the native Android implementation. iOS support will be added in a following iteration; the iOS module currently logs a warning for every method call.

## Installation

```sh
yarn add react-native-marfeel-tracker
```

No extra Gradle setup is required—the library already ships with the Marfeel Maven repository and Compass dependency.

## Quick start

```ts
import MarfeelTracker from 'react-native-marfeel-tracker';

MarfeelTracker.initialize('ACCOUNT_ID_FROM_MARFEEL');
MarfeelTracker.trackPage('https://example.com/home');

MarfeelTracker.setSiteUserId('user-123');
MarfeelTracker.setUserType('logged');

// Track UI interactions as conversions/clicks
MarfeelTracker.trackClick('cta.primary'); // Same as trackConversion('click:cta.primary')
```

## API

- `initialize(accountId: string, options?: { pageTechnology?: number })`
- `trackPage(url: string, options?: { recirculationSource?: string })`
- `trackScreen(screen: string, options?: { recirculationSource?: string })`
- `stopTracking()`
- `setLandingPage(landingPage: string)`
- `setSiteUserId(userId: string)`
- `getUserId(): string`
- `setUserType('anonymous' | 'logged' | 'paid' | { customId: number })`
- `setConsent(consent: boolean)`
- `trackConversion(conversion: string)` and `trackClick(target: string)`
- `setPageVar / setSessionVar / setUserVar`
- `addUserSegment`, `setUserSegments`, `removeUserSegment`, `clearUserSegments`
- `setPageMetric(name: string, value: number)`

Under the hood these functions call the corresponding CompassTracking APIs documented by Marfeel, so the same behaviors and constraints apply (e.g. metrics accept integers only, custom user types require IDs above 100) [^docs].

[^docs]: Implementation reference: [Marfeel Native Android SDK instrumentation guide](https://community.marfeel.com/t/native-android-sdk-instrumentation/8489).

## Contributing

- [Development workflow](CONTRIBUTING.md#development-workflow)
- [Sending a pull request](CONTRIBUTING.md#sending-a-pull-request)
- [Code of conduct](CODE_OF_CONDUCT.md)

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
