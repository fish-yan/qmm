//
//  RegisterAssistant.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/14.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class RegisterAssistant: NSObject {
    
    @objc static func registerVanders() {
        registerShareSDK()
        registerAmap()
    }
 
    private class func registerShareSDK() {
        
        UMConfigure.initWithAppkey("5c00eb8ef1f556691c000216", channel: "App Store")
        
        
        
        UMSocialManager.default()?.setPlaform(.wechatSession,
                                              appKey: WX_APP_ID,
                                              appSecret: WX_APP_SECRETE,
                                              redirectURL: "http://www.huayuanvip.com")
        WXApi.registerApp(WX_APP_ID)
        
    }
    
    private class func registerAmap() {
        AMapServices.shared().apiKey = "3a25b797fe414bcd650f7fa08409a106"
    }
}
