#import "MarfeelTracker.h"
#import <React/RCTLog.h>

@implementation MarfeelTracker
RCT_EXPORT_MODULE()

- (void)initialize:(NSString *)accountId pageTechnology:(NSNumber * _Nullable)pageTechnology {
    RCTLogWarn(@"MarfeelTracker.initialize is not implemented for iOS yet. accountId=%@", accountId);
}

- (void)trackNewPage:(NSString *)url recirculationSource:(NSString * _Nullable)recirculationSource {
    RCTLogWarn(@"MarfeelTracker.trackNewPage is not implemented for iOS yet. url=%@", url);
}

- (void)trackScreen:(NSString *)screen recirculationSource:(NSString * _Nullable)recirculationSource {
    RCTLogWarn(@"MarfeelTracker.trackScreen is not implemented for iOS yet. screen=%@", screen);
}

- (void)stopTracking {
    RCTLogWarn(@"MarfeelTracker.stopTracking is not implemented for iOS yet.");
}

- (void)setLandingPage:(NSString *)landingPage {
    RCTLogWarn(@"MarfeelTracker.setLandingPage is not implemented for iOS yet. landingPage=%@", landingPage);
}

- (void)setSiteUserId:(NSString *)userId {
    RCTLogWarn(@"MarfeelTracker.setSiteUserId is not implemented for iOS yet. userId=%@", userId);
}

- (NSString *)getUserId {
    RCTLogWarn(@"MarfeelTracker.getUserId is not implemented for iOS yet.");
    return @"";
}

- (void)setUserType:(NSString *)userType customId:(NSNumber * _Nullable)customId {
    RCTLogWarn(@"MarfeelTracker.setUserType is not implemented for iOS yet. userType=%@", userType);
}

- (void)setConsent:(BOOL)consent {
    RCTLogWarn(@"MarfeelTracker.setConsent is not implemented for iOS yet. consent=%@", consent ? @"true" : @"false");
}

- (void)trackConversion:(NSString *)conversion {
    RCTLogWarn(@"MarfeelTracker.trackConversion is not implemented for iOS yet. conversion=%@", conversion);
}

- (void)setPageVar:(NSString *)name value:(NSString *)value {
    RCTLogWarn(@"MarfeelTracker.setPageVar is not implemented for iOS yet. name=%@", name);
}

- (void)setSessionVar:(NSString *)name value:(NSString *)value {
    RCTLogWarn(@"MarfeelTracker.setSessionVar is not implemented for iOS yet. name=%@", name);
}

- (void)setUserVar:(NSString *)name value:(NSString *)value {
    RCTLogWarn(@"MarfeelTracker.setUserVar is not implemented for iOS yet. name=%@", name);
}

- (void)addUserSegment:(NSString *)segment {
    RCTLogWarn(@"MarfeelTracker.addUserSegment is not implemented for iOS yet. segment=%@", segment);
}

- (void)setUserSegments:(NSArray<NSString *> *)segments {
    RCTLogWarn(@"MarfeelTracker.setUserSegments is not implemented for iOS yet. count=%@", @(segments.count));
}

- (void)removeUserSegment:(NSString *)segment {
    RCTLogWarn(@"MarfeelTracker.removeUserSegment is not implemented for iOS yet. segment=%@", segment);
}

- (void)clearUserSegments {
    RCTLogWarn(@"MarfeelTracker.clearUserSegments is not implemented for iOS yet.");
}

- (void)setPageMetric:(NSString *)name value:(double)value {
    RCTLogWarn(@"MarfeelTracker.setPageMetric is not implemented for iOS yet. name=%@", name);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeMarfeelTrackerSpecJSI>(params);
}

@end
