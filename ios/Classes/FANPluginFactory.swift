import Foundation
import Flutter
import FBAudienceNetwork

class FANPluginFactory: NSObject {
    let channel: FlutterMethodChannel
    
    init(_channel: FlutterMethodChannel) {
        print("FANPluginFactory > init")
        
        channel = _channel
        
        super.init()
        
        channel.setMethodCallHandler { (_ call : FlutterMethodCall, result : @escaping FlutterResult) in
            switch call.method{
            case "init":
                FBAudienceNetworkAds.initialize(with: nil) { results in
                    if !results.isSuccess {
                        print("FANPluginFactory > init > failed")
                        result(false)
                        return
                    }
                    
                    let args = call.arguments as! Dictionary<String,AnyObject>
                    if let testingId = args["testingId"] as? String {
                        FBAdSettings.addTestDevice(testingId)
                    } else {
                        print("test hash: \(FBAdSettings.testDeviceHash())")
                    }
                    
                    if #available(iOS 14.0, *) {
                        let iOSAdvertiserTrackingEnabled = (args["iOSAdvertiserTrackingEnabled"] as! NSString).boolValue
                        print("FANPluginFactory > iOSAdvertiserTrackingEnabled: " + String(iOSAdvertiserTrackingEnabled))
                        FBAdSettings.setAdvertiserTrackingEnabled(iOSAdvertiserTrackingEnabled)
                    }
                    
                    print("FANPluginFactory > init")
                    result(true)
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        print("FacebookAudienceNetworkInterstitialAdPlugin > init > end")
    }
}
