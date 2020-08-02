//
//  FYWalletVM.swift
//  QMM
//
//  Created by Yan on 2019/9/2.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit

class FYWalletVM: NSObject {
    
    var model = FYWalletModel()
    
    func requestWallet(complete: @escaping(Bool) -> Void) {
        FYRequest.request("getuserbalance", success: { ( response: FYBaseModel<FYWalletModel>) in
            if let m = response.data.first {
                self.model = m
            }
            complete(true)
        })
    }
    
    func requestChange(complete: @escaping(Bool) -> Void) {
        let params = ["balance":model.profit, "type":model.type]
        FYRequest.request("profitreturnbalance", params: params, success: { ( response: FYBaseModel<FYTempModel>) in
            complete(true)
        })
    }

    
}

