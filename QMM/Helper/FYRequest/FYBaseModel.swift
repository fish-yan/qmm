//
//  FYBaseModel.swift
//  QMM
//
//  Created by Yan on 2019/9/2.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit
import HandyJSON

class FYBaseModel<T>: NSObject, HandyJSON {
    var code = -1
    var msg = ""
    var totalpage = 0
    var total = 0
    var extra = ""
    var data = [T]()
    required override init() {}
}
