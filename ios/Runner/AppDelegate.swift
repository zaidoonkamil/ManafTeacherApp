import Flutter
import UIKit
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "screen_capture_protection"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    methodChannel.setMethodCallHandler { (call, result) in
      if call.method == "enableProtection" {
        self.enableProtection()
        result(nil)
      } else if call.method == "disableProtection" {
        self.disableProtection()
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    OneSignal.initialize("86528530-6a6a-4c24-86f6-51bfd7e2099d", withLaunchOptions: launchOptions)
    OneSignal.Notifications.requestPermission({ accepted in
        print("User accepted notifications: \(accepted)")
    }, fallbackToSettings: true)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func enableProtection() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(screenCapturedChanged),
                                           name: UIScreen.capturedDidChangeNotification,
                                           object: nil)
    checkScreenCaptured()
  }

  func disableProtection() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIScreen.capturedDidChangeNotification,
                                              object: nil)
    window?.isHidden = false
  }

  @objc func screenCapturedChanged() {
    checkScreenCaptured()
  }

  func checkScreenCaptured() {
    if UIScreen.main.isCaptured {
      window?.isHidden = true
    } else {
      window?.isHidden = false
    }
  }
}
