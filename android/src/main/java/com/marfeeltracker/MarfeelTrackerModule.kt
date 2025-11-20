package com.marfeeltracker

import com.facebook.react.bridge.JSApplicationCausedNativeException
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.UiThreadUtil
import com.facebook.react.module.annotations.ReactModule
import com.marfeel.compass.core.model.compass.UserType
import com.marfeel.compass.tracker.CompassTracking
import java.util.Locale
import java.util.concurrent.CountDownLatch
import java.util.concurrent.atomic.AtomicReference

@ReactModule(name = MarfeelTrackerModule.NAME)
class MarfeelTrackerModule(reactContext: ReactApplicationContext) :
  NativeMarfeelTrackerSpec(reactContext) {

  private var initialized = false
  private val pendingActions = mutableListOf<(CompassTracking) -> Unit>()

  override fun getName(): String {
    return NAME
  }

  override fun initialize(accountId: String, pageTechnology: Double?) {
    val technology = pageTechnology?.toInt() ?: DEFAULT_PAGE_TECHNOLOGY
    runOnUiThreadSync {
      CompassTracking.Companion.initialize(
        reactApplicationContext,
        accountId,
        technology
      )
      initialized = true
      flushPending()
    }
  }

  override fun trackNewPage(url: String, recirculationSource: String?) {
    withTracker { tracker ->
      if (recirculationSource.isNullOrEmpty()) {
        tracker.trackNewPage(url)
      } else {
        tracker.trackNewPage(url, recirculationSource)
      }
    }
  }

  override fun trackScreen(screen: String, recirculationSource: String?) {
    withTracker { tracker ->
      if (recirculationSource.isNullOrEmpty()) {
        tracker.trackScreen(screen)
      } else {
        tracker.trackScreen(screen, recirculationSource)
      }
    }
  }

  override fun stopTracking() {
    withTracker { tracker ->
      tracker.stopTracking()
    }
  }

  override fun setLandingPage(landingPage: String) {
    withTracker { tracker ->
      tracker.setLandingPage(landingPage)
    }
  }

  override fun setSiteUserId(userId: String) {
    withTracker { tracker ->
      tracker.setSiteUserId(userId)
    }
  }

  override fun getUserId(): String {
    if (!initialized) {
      return ""
    }
    return runOnUiThreadSync {
      CompassTracking.Companion.getInstance().getUserId() ?: ""
    }
  }

  override fun setUserType(userType: String, customId: Double?) {
    val resolvedType = toUserType(userType, customId)
    withTracker { tracker ->
      tracker.setUserType(resolvedType)
    }
  }

  override fun setConsent(consent: Boolean) {
    withTracker { tracker ->
      tracker.setUserConsent(consent)
    }
  }

  override fun trackConversion(conversion: String) {
    withTracker { tracker ->
      tracker.trackConversion(conversion)
    }
  }

  override fun setPageVar(name: String, value: String) {
    withTracker { tracker ->
      tracker.setPageVar(name, value)
    }
  }

  override fun setSessionVar(name: String, value: String) {
    withTracker { tracker ->
      tracker.setSessionVar(name, value)
    }
  }

  override fun setUserVar(name: String, value: String) {
    withTracker { tracker ->
      tracker.setUserVar(name, value)
    }
  }

  override fun addUserSegment(segment: String) {
    withTracker { tracker ->
      tracker.addUserSegment(segment)
    }
  }

  override fun setUserSegments(segments: ReadableArray) {
    val list = segments.toStringList()
    withTracker { tracker ->
      tracker.setUserSegments(list)
    }
  }

  override fun removeUserSegment(segment: String) {
    withTracker { tracker ->
      tracker.removeUserSegment(segment)
    }
  }

  override fun clearUserSegments() {
    withTracker { tracker ->
      tracker.clearUserSegments()
    }
  }

  override fun setPageMetric(name: String, value: Double) {
    withTracker { tracker ->
      tracker.setPageMetric(name, value.toInt())
    }
  }

  private fun toUserType(userType: String, customId: Double?): UserType {
    return when (userType.lowercase(Locale.ROOT)) {
      "anonymous" -> UserType.Anonymous
      "logged" -> UserType.Logged
      "paid" -> UserType.Paid
      "custom" -> {
        val id = customId?.toInt() ?: throw JSApplicationCausedNativeException(
          "Custom user type requires a numeric customId"
        )
        UserType.Custom(id)
      }
      else -> throw JSApplicationCausedNativeException(
        "Unsupported user type: $userType"
      )
    }
  }

  private fun withTracker(action: (CompassTracking) -> Unit) {
    if (!initialized) {
      pendingActions.add(action)
      return
    }
    runOnUiThreadSync {
      action(CompassTracking.Companion.getInstance())
    }
  }

  private fun flushPending() {
    if (pendingActions.isEmpty()) {
      return
    }
    val tracker = CompassTracking.Companion.getInstance()
    pendingActions.forEach { pending ->
      pending(tracker)
    }
    pendingActions.clear()
  }

  private fun ReadableArray.toStringList(): List<String> {
    val result = mutableListOf<String>()
    for (i in 0 until size()) {
      val value = getString(i)
      if (value != null) {
        result.add(value)
      }
    }
    return result
  }

  companion object {
    const val NAME = "MarfeelTracker"
    private const val DEFAULT_PAGE_TECHNOLOGY = 4
  }

  private fun <T> runOnUiThreadSync(block: () -> T): T {
    if (UiThreadUtil.isOnUiThread()) {
      return block()
    }
    val latch = CountDownLatch(1)
    val result = AtomicReference<Any?>()
    val error = AtomicReference<Throwable?>()
    UiThreadUtil.runOnUiThread {
      try {
        result.set(block())
      } catch (t: Throwable) {
        error.set(t)
      } finally {
        latch.countDown()
      }
    }
    latch.await()
    error.get()?.let { throw it }
    @Suppress("UNCHECKED_CAST")
    return result.get() as T
  }
}
