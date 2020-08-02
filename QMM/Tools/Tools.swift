//
//  Tools.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/2.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import Foundation

// MARK: - UI
let KEY_WINDOW = UIApplication.shared.keyWindow

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
let SCREEN_MIN_LENGTH = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)


// MARK: - Device
// pod 'DeviceGuru'
let IS_FULL_SCREEN_IPHONE = (UIDevice.current.userInterfaceIdiom == .phone
    && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.height) >= 812.0)

struct DeviceType {
    static let IS_IPHONE = (UIDevice.current.userInterfaceIdiom == .phone)
    static let IS_IPAD = (UIDevice.current.userInterfaceIdiom == .pad)
    
    static let IS_IPHONE_5 = (UIDevice.current.userInterfaceIdiom == .phone
        && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 568.0)
    static let IS_IPHONE_6_7_8 = (UIDevice.current.userInterfaceIdiom == .phone
        && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 667.0)
    static let IS_IPHONE_PLUS = (UIDevice.current.userInterfaceIdiom == .phone
        && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 736.0)
    static let IS_IPHONE_X_XS = (UIDevice.current.userInterfaceIdiom == .phone
        && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 812.0)
    static let IS_IPHONE_XR = (UIDevice.current.userInterfaceIdiom == .phone
        && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 896.0)
    static let IS_IPHONE_XS_MAX = (UIDevice.current.userInterfaceIdiom == .phone
        && max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) == 896.0)
}




