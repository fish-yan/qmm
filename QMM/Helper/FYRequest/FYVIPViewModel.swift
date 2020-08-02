//
//  FYVIPViewModel.swift
//  QMM
//
//  Created by Yan on 2019/9/16.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit
import HandyJSON

class FYVIPViewModel: NSObject {
    
    @objc static func request(_ type: String, complete: @escaping ([FYProduct])->Void) {
        FYRequest.request("getmemberproduct", params: ["type":type], success: { (response: FYBaseModel<FYProduct>) in
            complete(response.data)
        })
    }
}

@objcMembers
class FYProduct: NSObject, HandyJSON {
    
    var productIdentifier = ""
    
    var localizedTitle = ""
    
    var price = ""
    
    var localizedDescription = ""
    
    required override init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
        self.localizedTitle <-- ["name"]
        mapper <<<
        self.productIdentifier <-- ["no"]
        mapper <<<
        self.price <-- ["price2"]
    }
}
