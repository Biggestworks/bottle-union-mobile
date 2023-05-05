import UIKit
import Flutter
import GoogleMaps
import Firebase
import Xendit


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
      Xendit.publishableKey = "xnd_public_production_B99eGILsUL9tW8iYaJ7GNu0Mhec12HA6QYtJJv6Yj3oefkwnDYJ7u0Q3WSvKholc"

      // Xendit.publishableKey = "xnd_public_development_uMa8E5AsTVGa8GjnVHK8pcfEK6W5D6BCDk4cU1fDLHwpDvKU0vMFuuxrKmaWKNP"

      // Xendit.publishableKey = "xnd_public_development_O4iFfuQhgLOsl8M9eeEYGzeWYNH3otV5w3Dh/BFj/mHW+72nCQR/"
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let uiController : FlutterViewController
    let xenditChannel = FlutterMethodChannel(name: "bottle.union/xendit", binaryMessenger: controller.binaryMessenger)

    xenditChannel.setMethodCallHandler({
       (call: FlutterMethodCall,result:@escaping FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      if (call.method == "xenditCreateToken")
      {
          if let args = call.arguments as? Dictionary<String, Any>,
            let cardNumber = args["card_number"] as? String,
            let expMonth = args["exp_month"] as? String,
            let expYear = args["exp_year"] as? String,
            let cvn = args["cvn"] as? String {
             let cardData = CardData()
        
        cardData.cardNumber = cardNumber
        cardData.cardExpMonth = expMonth
        cardData.cardExpYear = expYear
        cardData.cardCvn = cvn
        cardData.isMultipleUse = false

        Xendit.createToken(fromViewController: controller, cardData: cardData) { (token, error) in
          if (error != nil){
              result(FlutterError(code: error!.errorCode,
                            message: error!.message,
                            details: nil))
                            return
          }

            DispatchQueue.main.async() {
              result(token!.id)
            }
           

        } 
          } else {
            result(FlutterError.init(code: "bad args", message: nil, details: nil))
          }

      } else if(call.method == "xenditCreateAuthentication")
      {
          if let args = call.arguments as? Dictionary<String, Any>,
            let amount = args["amount"] as? Int,
            let tokenId = args["token_id"] as? String {
        
            let amountNumber = NSNumber(value: amount)
            Xendit.createAuthentication(fromViewController: controller, tokenId: tokenId, amount: amountNumber) { (authentication, error) in
            if (error != nil) {
                result(FlutterError(code: error!.errorCode,
                            message: error!.message,
                            details: nil))
                            return
            }

             DispatchQueue.main.async() {
              result(authentication!.id)
            }
        }
    
          } else {
            result(FlutterError.init(code: "bad args", message: nil, details: nil))
          }
      }
       else {
        result(FlutterMethodNotImplemented)
        return
      }
     
    })

    GMSServices.provideAPIKey("AIzaSyCuLLX57qWxuKkqQaoG1L3uXdF2xRXQMVs")
    GeneratedPluginRegistrant.register(with: self)
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }



  private func receiveBatteryLevel(result: FlutterResult) {
      let device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
      if device.batteryState == UIDevice.BatteryState.unknown {
        result(FlutterError(code: "UNAVAILABLE",
                            message: "Battery level not available.",
                            details: nil))
      } else {
        result(Int(device.batteryLevel * 100))
      }
    }
}


