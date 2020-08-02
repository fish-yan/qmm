//
//  ZMXYHelper.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/14.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit


class ZMXYHelper: NSObject {
    static let share = ZMXYHelper()
    
    func doVerify(url: String) {
        let encodedUrl = urlEncodedString(url: url)
        let alipayUrl = "alipays://platformapi/startapp?appId=20000067&url=\(encodedUrl ?? "")"
        
    }
}

extension ZMXYHelper {
    func urlEncodedString(url: String) -> String? {
        let originalString = url as CFString
        let legalURL = "!'();:@&=+$,%#[]|" as CFString
        let ecaped = CFURLCreateStringByAddingPercentEscapes(nil,
                                                             originalString,
                                                             nil,
                                                             legalURL,
                                                             CFStringBuiltInEncodings.UTF8.rawValue)
        let encodedString = ecaped as String?
        return encodedString
    }
}
