import { TurboModuleRegistry, type TurboModule } from 'react-native';

export interface Spec extends TurboModule {
  initialize(accountId: string, pageTechnology?: number | null): void;
  trackNewPage(url: string, recirculationSource?: string | null): void;
  trackScreen(screen: string, recirculationSource?: string | null): void;
  stopTracking(): void;
  setLandingPage(landingPage: string): void;
  setSiteUserId(userId: string): void;
  getUserId(): string;
  setUserType(userType: string, customId?: number | null): void;
  setConsent(consent: boolean): void;
  trackConversion(conversion: string): void;
  setPageVar(name: string, value: string): void;
  setSessionVar(name: string, value: string): void;
  setUserVar(name: string, value: string): void;
  addUserSegment(segment: string): void;
  setUserSegments(segments: string[]): void;
  removeUserSegment(segment: string): void;
  clearUserSegments(): void;
  setPageMetric(name: string, value: number): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('MarfeelTracker');
