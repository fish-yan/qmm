//
//  FYWalletModel.swift
//  QMM
//
//  Created by Yan on 2019/9/2.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit
import HandyJSON

class FYWalletModel: NSObject, HandyJSON {
    
    var balance = "0"
    
    var profit = "0"
    
    var type = ""
    
    required override init() {
        
    }
}
