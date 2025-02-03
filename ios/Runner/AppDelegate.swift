import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseMessaging
// import app_links


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDyM8Lfbquk6En-eI4FJs3df-tbjFfICos")
    GeneratedPluginRegistrant.register(with: self)
// Retrieve the link from parameters
//         if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
//           // We have a link, propagate it to your Flutter app or not
//           AppLinks.shared.handleLink(url: url)
//           return true // Returning true will stop the propagation to other packages
//         }
//     AppCenter.start(withAppSecret: "6e0c0431-d34d-4217-9a6b-64836aba6f84", services:[
//       Analytics.self,
//       Crashes.self
//     ])
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
