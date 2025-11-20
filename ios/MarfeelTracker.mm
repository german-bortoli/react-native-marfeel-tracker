#import "MarfeelTracker.h"

#import "MarfeelTracker-Swift.h"

@implementation MarfeelTracker
RCT_EXPORT_MODULE()

- (void)initialize:(NSString *)accountId pageTechnology:(NSNumber *)pageTechnology {
    [[MarfeelTrackerBridge shared] initializeWithAccountId:accountId pageTechnology:pageTechnology];
}

- (void)trackNewPage:(NSString *)url recirculationSource:(NSString *)recirculationSource {
    [[MarfeelTrackerBridge shared] trackPageWithUrl:url recirculationSource:recirculationSource];
}

- (void)trackScreen:(NSString *)screen recirculationSource:(NSString *)recirculationSource {
    [[MarfeelTrackerBridge shared] trackScreenWithName:screen recirculationSource:recirculationSource];
}

- (void)stopTracking {
    [[MarfeelTrackerBridge shared] stopTracking];
}

- (void)setLandingPage:(NSString *)landingPage {
    [[MarfeelTrackerBridge shared] setLandingPage:landingPage];
}

- (void)setSiteUserId:(NSString *)userId {
    [[MarfeelTrackerBridge shared] setSiteUserId:userId];
}

- (NSString *)getUserId {
    return [[MarfeelTrackerBridge shared] userId];
}

- (void)setUserType:(NSString *)userType customId:(NSNumber *)customId {
    [[MarfeelTrackerBridge shared] setUserType:userType customId:customId];
}

- (void)setConsent:(BOOL)consent {
    [[MarfeelTrackerBridge shared] setConsent:consent];
}

- (void)trackConversion:(NSString *)conversion {
    [[MarfeelTrackerBridge shared] trackConversion:conversion];
}

- (void)setPageVar:(NSString *)name value:(NSString *)value {
    [[MarfeelTrackerBridge shared] setPageVarWithName:name value:value];
}

- (void)setSessionVar:(NSString *)name value:(NSString *)value {
    [[MarfeelTrackerBridge shared] setSessionVarWithName:name value:value];
}

- (void)setUserVar:(NSString *)name value:(NSString *)value {
    [[MarfeelTrackerBridge shared] setUserVarWithName:name value:value];
}

- (void)addUserSegment:(NSString *)segment {
    [[MarfeelTrackerBridge shared] addUserSegment:segment];
}

- (void)setUserSegments:(NSArray<NSString *> *)segments {
    [[MarfeelTrackerBridge shared] setUserSegments:segments];
}

- (void)removeUserSegment:(NSString *)segment {
    [[MarfeelTrackerBridge shared] removeUserSegment:segment];
}

- (void)clearUserSegments {
    [[MarfeelTrackerBridge shared] clearUserSegments];
}

- (void)setPageMetric:(NSString *)name value:(double)value {
    [[MarfeelTrackerBridge shared] setPageMetricWithName:name value:value];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeMarfeelTrackerSpecJSI>(params);
}

@end
