import Foundation
import MarfeelSDK_iOS

@objcMembers
public final class MarfeelTrackerBridge: NSObject {
  public static let shared = MarfeelTrackerBridge()

  private var initialized = false
  private let lock = NSRecursiveLock()
  private var pendingActions: [(CompassTracker) -> Void] = []
  private let defaultPageTechnology = 3

  private override init() {
    super.init()
  }

  public func initialize(accountId: String, pageTechnology: NSNumber?) {
    runOnMainThreadSync {
      guard let parsedAccount = Self.parseAccountId(accountId) else {
        NSLog("[MarfeelTracker] Invalid account id received: %@", accountId)
        return
      }

      let technology = pageTechnology?.intValue ?? defaultPageTechnology
      CompassTracker.initialize(accountId: parsedAccount, pageTechnology: technology)
      initialized = true
      flushPending()
    }
  }

  public func trackPage(url: String, recirculationSource: String?) {
    enqueue { tracker in
      guard let parsedURL = URL(string: url) else {
        NSLog("[MarfeelTracker] trackPage received an invalid URL: %@", url)
        return
      }
      tracker.trackNewPage(url: parsedURL, rs: recirculationSource)
    }
  }

  public func trackScreen(name: String, recirculationSource: String?) {
    enqueue { tracker in
      tracker.trackScreen(name, rs: recirculationSource)
    }
  }

  public func stopTracking() {
    enqueue { tracker in
      tracker.stopTracking()
    }
  }

  public func setLandingPage(_ landingPage: String) {
    enqueue { tracker in
      tracker.setLandingPage(landingPage)
    }
  }

  public func setSiteUserId(_ userId: String) {
    enqueue { tracker in
      tracker.setSiteUserId(userId)
    }
  }

  public func userId() -> String {
    guard initialized else {
      return ""
    }
    return runOnMainThreadSyncResult {
      CompassTracker.shared.getUserId()
    }
  }

  public func setUserType(_ userType: String, customId: NSNumber?) {
    enqueue { tracker in
      guard let resolvedType = Self.userType(from: userType, customId: customId) else {
        NSLog("[MarfeelTracker] Unsupported user type received: %@", userType)
        return
      }
      tracker.setUserType(resolvedType)
    }
  }

  public func setConsent(_ consent: Bool) {
    enqueue { tracker in
      tracker.setConsent(consent)
    }
  }

  public func trackConversion(_ conversion: String) {
    enqueue { tracker in
      tracker.trackConversion(conversion: conversion)
    }
  }

  public func setPageVar(name: String, value: String) {
    enqueue { tracker in
      tracker.setPageVar(name: name, value: value)
    }
  }

  public func setSessionVar(name: String, value: String) {
    enqueue { tracker in
      tracker.setSessionVar(name: name, value: value)
    }
  }

  public func setUserVar(name: String, value: String) {
    enqueue { tracker in
      tracker.setUserVar(name: name, value: value)
    }
  }

  public func addUserSegment(_ segment: String) {
    enqueue { tracker in
      tracker.addUserSegment(segment)
    }
  }

  public func setUserSegments(_ segments: [String]) {
    enqueue { tracker in
      tracker.setUserSegments(segments)
    }
  }

  public func removeUserSegment(_ segment: String) {
    enqueue { tracker in
      tracker.removeUserSegment(segment)
    }
  }

  public func clearUserSegments() {
    enqueue { tracker in
      tracker.clearUserSegments()
    }
  }

  public func setPageMetric(name: String, value: Double) {
    enqueue { tracker in
      tracker.setPageMetric(name: name, value: Int(value.rounded()))
    }
  }

  private func enqueue(_ action: @escaping (CompassTracker) -> Void) {
    lock.lock()
    if initialized {
      lock.unlock()
      runOnMainThreadSync {
        action(CompassTracker.shared)
      }
      return
    }

    pendingActions.append(action)
    lock.unlock()
  }

  private func flushPending() {
    lock.lock()
    let actions = pendingActions
    pendingActions.removeAll()
    lock.unlock()

    guard !actions.isEmpty else {
      return
    }

    runOnMainThreadSync {
      let tracker = CompassTracker.shared
      actions.forEach { $0(tracker) }
    }
  }

  private func runOnMainThreadSync(_ block: () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      DispatchQueue.main.sync(execute: block)
    }
  }

  private func runOnMainThreadSyncResult<T>(_ block: () -> T) -> T {
    if Thread.isMainThread {
      return block()
    }

    var value: T!
    DispatchQueue.main.sync {
      value = block()
    }
    return value
  }

  private static func parseAccountId(_ value: String) -> Int? {
    let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
    return Int(trimmed)
  }

  private static func userType(from value: String, customId: NSNumber?) -> UserType? {
    switch value.lowercased() {
    case "anonymous":
      return .anonymous
    case "logged":
      return .logged
    case "paid":
      return .paid
    case "custom":
      guard let custom = customId?.intValue else {
        NSLog("[MarfeelTracker] Custom user type requires a numeric customId")
        return nil
      }
      return .custom(custom)
    case "unknown":
      return .unknown
    default:
      return nil
    }
  }
}

