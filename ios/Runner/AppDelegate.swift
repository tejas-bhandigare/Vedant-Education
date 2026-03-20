import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ─────────────────────────────────────────────
  //  Hide content when app goes to background
  //  (prevents PDF showing in app switcher)
  // ─────────────────────────────────────────────

  override func applicationWillResignActive(_ application: UIApplication) {
    guard let window = self.window else { return }

    // Add blur overlay to hide PDF content
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = window.bounds
    blurView.tag = 9999
    blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    window.addSubview(blurView)
  }

  // ─────────────────────────────────────────────
  //  Remove blur when app comes back to foreground
  // ─────────────────────────────────────────────

  override func applicationDidBecomeActive(_ application: UIApplication) {
    self.window?.viewWithTag(9999)?.removeFromSuperview()
  }
}





// import Flutter
// import UIKit
//
// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
