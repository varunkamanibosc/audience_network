//
//  FacebookAudienceNetworkRewardedAd.swift
//  facebook_audience_network
//
//  Created by Leonardo da Silva on 18/12/21.
//

import Foundation
import Flutter
import FBAudienceNetwork

class FacebookAudienceNetworkRewardedAdPlugin: NSObject, FBRewardedVideoAdDelegate {
    let channel: FlutterMethodChannel
    var rewardedVideoAd: FBRewardedVideoAd!
    
    init(_channel: FlutterMethodChannel) {
        print("FacebookAudienceNetworkRewardedAdPluginPlugin > init")
        
        channel = _channel
        
        super.init()
        
        channel.setMethodCallHandler { (call, result) in
            switch call.method {
            case "loadRewardedAd":
                print("FacebookAudienceNetworkRewardedAdPlugin > loadRewardedAd")
                result(self.loadAd(call))
            case "showRewardedAd":
                print("FacebookAudienceNetworkRewardedAdPlugin > showRewardedAd")
                result(self.showAd(call))
            case "destroyRewardedAd":
                print("FacebookAudienceNetworkRewardedAdPlugin> destroyRewardedAd")
                result(self.destroyAd())
            default: result(FlutterMethodNotImplemented)
            }
        }
        
        print("FacebookAudienceNetworkRewardedAdPluginPlugin > init > end")
    }
    
    func loadAd(_ call: FlutterMethodCall) -> Bool {
        if nil == self.rewardedVideoAd || !self.rewardedVideoAd.isAdValid {
            print("FacebookAudienceNetworkRewardedAdPlugin > loadAd > create")
            let args: NSDictionary = call.arguments as! NSDictionary
            let id: String = args["id"] as! String
            self.rewardedVideoAd = FBRewardedVideoAd.init(placementID: id)
            self.rewardedVideoAd.delegate = self
        }
        self.rewardedVideoAd.load()
        return true
    }
    
    func showAd(_ call: FlutterMethodCall) -> Bool {
        if !self.rewardedVideoAd.isAdValid {
            print("FacebookAudienceNetworkRewardedAdPlugin > showAd > not AdValid")
            return false
        }
        let args: NSDictionary = call.arguments as! NSDictionary
        let delay: Int = args["delay"] as! Int
        
        print("@@@ delay %d", delay)
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }
        
        func show() {
            rewardedVideoAd.show(fromRootViewController: rootViewController)
        }
        
        if 0 < delay {
            let time = DispatchTime.now() + .seconds(delay)
            DispatchQueue.main.asyncAfter(deadline: time, execute: show)
        } else {
            show()
        }
        return true
    }
    
    func destroyAd() -> Bool {
        if nil == self.rewardedVideoAd {
            return false
        } else {
            rewardedVideoAd.delegate = nil
            rewardedVideoAd = nil
        }
        return true
    }
    
    func rewardedVideoAd(_ rewardedVideoAd: FBRewardedVideoAd, didFailWithError error: Error) {
        print("RewardedAdView > rewardedAd failed")
        print(error.localizedDescription)
        
        let errorDetails = FacebookAdErrorDetails(fromSDKError: error)
        let placement_id: String = rewardedVideoAd.placementID
        let invalidated: Bool = rewardedVideoAd.isAdValid
        let arg: [String: Any] = [
            FANConstant.PLACEMENT_ID_ARG: placement_id,
            FANConstant.INVALIDATED_ARG: invalidated,
            FANConstant.ERROR_CODE_ARG: errorDetails?.code as Any,
            FANConstant.ERROR_MESSAGE_ARG: errorDetails?.message as Any,
        ]
        self.channel.invokeMethod(FANConstant.ERROR_METHOD, arguments: arg)
    }
    
    func rewardedVideoAdDidLoad(_ rewardedVideoAd: FBRewardedVideoAd) {
        print("RewardedAdView > rewardedAdDidLoad")
        
        let placement_id: String = rewardedVideoAd.placementID
        let invalidated: Bool = rewardedVideoAd.isAdValid
        let arg: [String: Any] = [
            FANConstant.PLACEMENT_ID_ARG: placement_id,
            FANConstant.INVALIDATED_ARG: invalidated,
        ]
        self.channel.invokeMethod(FANConstant.LOADED_METHOD, arguments: arg)
    }
    
    func rewardedVideoAdDidClick(_ rewardedVideoAd: FBRewardedVideoAd) {
        print("RewardedAdView > rewardedAdDidClick")
        
        let placement_id: String = rewardedVideoAd.placementID
        let invalidated: Bool = rewardedVideoAd.isAdValid
        let arg: [String: Any] = [
            FANConstant.PLACEMENT_ID_ARG: placement_id,
            FANConstant.INVALIDATED_ARG: invalidated,
        ]
        self.channel.invokeMethod(FANConstant.CLICKED_METHOD, arguments: arg)
    }
    
    func rewardedVideoAdWillLogImpression(_ rewardedVideoAd: FBRewardedVideoAd) {
        print("RewardedAdView > rewardedAdWillLogImpression")
        
        let placement_id: String = rewardedVideoAd.placementID
        let invalidated: Bool = rewardedVideoAd.isAdValid
        let arg: [String: Any] = [
            FANConstant.PLACEMENT_ID_ARG: placement_id,
            FANConstant.INVALIDATED_ARG: invalidated,
        ]
        self.channel.invokeMethod(FANConstant.LOGGING_IMPRESSION_METHOD, arguments: arg)
    }
    
    func rewardedVideoAdVideoComplete(_ rewardedVideoAd: FBRewardedVideoAd) {
        print("RewardedAdView > rewardedAdComplete")
        let placement_id: String = rewardedVideoAd.placementID
        let invalidated: Bool = rewardedVideoAd.isAdValid
        let arg: [String: Any] = [
            FANConstant.PLACEMENT_ID_ARG: placement_id,
            FANConstant.INVALIDATED_ARG: invalidated,
        ]
        self.channel.invokeMethod(FANConstant.REWARDED_VIDEO_COMPLETE_METHOD, arguments: arg)
    }
    
    func rewardedVideoAdDidClose(_ rewardedVideoAd: FBRewardedVideoAd) {
        print("RewardedAdView > rewardedAdDidClose")
        let placement_id: String = rewardedVideoAd.placementID
        let invalidated: Bool = rewardedVideoAd.isAdValid
        let arg: [String: Any] = [
            FANConstant.PLACEMENT_ID_ARG: placement_id,
            FANConstant.INVALIDATED_ARG: invalidated,
        ]
        self.channel.invokeMethod(FANConstant.REWARDED_VIDEO_CLOSED_METHOD, arguments: arg)
    }
    
    func rewardedVideoAdWillClose(_ rewardedVideoAd: FBRewardedVideoAd) {
        print("RewardedAdView > rewardedAdWillClose")
    }
    
    func rewardedVideoAdServerRewardDidFail(_ rewardedVideoAd: FBRewardedVideoAd) {
        print("RewardedAdView > rewardedAdServerDidFail")
    }
    
    func rewardedVideoAdServerRewardDidSucceed(_ rewardedVideoAd: FBRewardedVideoAd) {
        print("RewardedADView > rewardedADServerDidSucceed")
    }
}
