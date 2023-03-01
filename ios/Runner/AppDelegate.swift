import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    GeneratedPluginRegistrant.register(with: self)

    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GeneratedPluginRegistrant.register(with: self)
//    if #available(iOS 10.0, *) {
//  // For iOS 10 display notification (sent via APNS)
//  UNUserNotificationCenter.current().delegate = self
//  let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//  UNUserNotificationCenter.current().requestAuthorization(
//    options: authOptions,
//    completionHandler: { _, _ in }
//  )
//} else {
//  let settings: UIUserNotificationSettings =
//    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//  application.registerUserNotificationSettings(settings)
//}
//application.registerForRemoteNotifications()
//    //  if #available(iOS 10.0, *) {
//        // application.applicationIconBadgeNumber = 0 // For Clear Badge Counts
//        // let center = UNUserNotificationCenter.current()
//        // center.removeAllDeliveredNotifications() // To remove all delivered notifications
//        // center.removeAllPendingNotificationRequests()
//    // }
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}
