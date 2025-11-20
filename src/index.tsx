import NativeMarfeelTracker from './NativeMarfeelTracker';

export type InitializeOptions = {
  pageTechnology?: number;
};

export type TrackPageOptions = {
  recirculationSource?: string | null;
};

export type TrackScreenOptions = {
  recirculationSource?: string | null;
};

export type UserType =
  | 'anonymous'
  | 'logged'
  | 'paid'
  | {
      customId: number;
    };

const normalizeRecirculation = (
  recirculationSource?: string | null
): string | null => {
  return recirculationSource ?? null;
};

const warnPrefix = '[MarfeelTracker]';
let hasInitialized = false;

const ensureInitialized = (method: string): boolean => {
  if (hasInitialized) {
    return true;
  }
  console.warn(
    `${warnPrefix} initialize() must be called before invoking ${method}.`
  );
  return false;
};

export function initialize(accountId: string, options?: InitializeOptions) {
  NativeMarfeelTracker.initialize(accountId, options?.pageTechnology ?? null);
  hasInitialized = true;
}

export function trackPage(url: string, options?: TrackPageOptions): void {
  if (!ensureInitialized('trackPage')) {
    return;
  }
  NativeMarfeelTracker.trackNewPage(
    url,
    normalizeRecirculation(options?.recirculationSource)
  );
}

export function trackScreen(
  screen: string,
  options?: TrackScreenOptions
): void {
  if (!ensureInitialized('trackScreen')) {
    return;
  }
  NativeMarfeelTracker.trackScreen(
    screen,
    normalizeRecirculation(options?.recirculationSource)
  );
}

export function stopTracking(): void {
  if (!ensureInitialized('stopTracking')) {
    return;
  }
  NativeMarfeelTracker.stopTracking();
}

export function setLandingPage(landingPage: string): void {
  if (!ensureInitialized('setLandingPage')) {
    return;
  }
  NativeMarfeelTracker.setLandingPage(landingPage);
}

export function setSiteUserId(userId: string): void {
  if (!ensureInitialized('setSiteUserId')) {
    return;
  }
  NativeMarfeelTracker.setSiteUserId(userId);
}

export function getUserId(): string {
  if (!ensureInitialized('getUserId')) {
    return '';
  }

  try {
    return NativeMarfeelTracker.getUserId();
  } catch (error) {
    console.warn(`${warnPrefix} Failed to obtain user id`, error);
    return '';
  }
}

export function setUserType(userType: UserType): void {
  if (!ensureInitialized('setUserType')) {
    return;
  }

  if (typeof userType === 'string') {
    NativeMarfeelTracker.setUserType(userType, null);
    return;
  }

  NativeMarfeelTracker.setUserType('custom', userType.customId);
}

export function setConsent(consent: boolean): void {
  if (!ensureInitialized('setConsent')) {
    return;
  }
  NativeMarfeelTracker.setConsent(consent);
}

export function trackConversion(conversion: string): void {
  if (!ensureInitialized('trackConversion')) {
    return;
  }
  NativeMarfeelTracker.trackConversion(conversion);
}

export function trackClick(target: string): void {
  trackConversion(`click:${target}`);
}

export function setPageVar(name: string, value: string): void {
  if (!ensureInitialized('setPageVar')) {
    return;
  }
  NativeMarfeelTracker.setPageVar(name, value);
}

export function setSessionVar(name: string, value: string): void {
  if (!ensureInitialized('setSessionVar')) {
    return;
  }
  NativeMarfeelTracker.setSessionVar(name, value);
}

export function setUserVar(name: string, value: string): void {
  if (!ensureInitialized('setUserVar')) {
    return;
  }
  NativeMarfeelTracker.setUserVar(name, value);
}

export function addUserSegment(segment: string): void {
  if (!ensureInitialized('addUserSegment')) {
    return;
  }
  NativeMarfeelTracker.addUserSegment(segment);
}

export function setUserSegments(segments: string[]): void {
  if (!ensureInitialized('setUserSegments')) {
    return;
  }
  NativeMarfeelTracker.setUserSegments(segments);
}

export function removeUserSegment(segment: string): void {
  if (!ensureInitialized('removeUserSegment')) {
    return;
  }
  NativeMarfeelTracker.removeUserSegment(segment);
}

export function clearUserSegments(): void {
  if (!ensureInitialized('clearUserSegments')) {
    return;
  }
  NativeMarfeelTracker.clearUserSegments();
}

export function setPageMetric(name: string, value: number): void {
  if (!ensureInitialized('setPageMetric')) {
    return;
  }
  NativeMarfeelTracker.setPageMetric(name, Math.round(value));
}

const MarfeelTracker = {
  initialize,
  trackPage,
  trackScreen,
  stopTracking,
  setLandingPage,
  setSiteUserId,
  getUserId,
  setUserType,
  setConsent,
  trackConversion,
  trackClick,
  setPageVar,
  setSessionVar,
  setUserVar,
  addUserSegment,
  setUserSegments,
  removeUserSegment,
  clearUserSegments,
  setPageMetric,
};

export default MarfeelTracker;
