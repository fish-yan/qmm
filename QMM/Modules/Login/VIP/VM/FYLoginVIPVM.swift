//
//  FYLoginVIPVC.swift
//  QMM
//
//  Created by Yan on 2019/9/1.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit

class FYLoginVIPVM: NSObject {
    
    private let produceId = "qingtantan01"
    
    var orderId = ""
    
    var receipt = ""
    
    var dataArray = [FYLoginVIPModel]()
    
    func requestTheySay(complete:@escaping (Bool)->Void) {
        FYRequest.request("ondit", success: { (response: FYBaseModel<FYLoginVIPModel>) in
            self.dataArray = response.data
            complete(true)
        })
    }
    
    func requestPayment(complete:@escaping (Bool)->Void) {
        let iap = IAPHelper()
        YSProgressHUD.showIndeterminate()
        iap.fetchIAPProducts([produceId]) { (products, error) in
            print(products)
            iap.purchaseIdentrifier(self.produceId) { (receipt, error) in
                YSProgressHUD.hiddenHUD()
                if receipt.isEmpty {
                    YSProgressHUD.showTips(error.localizedDescription)
                    return
                }
                self.receipt = receipt
                self.requestCheckReceipt(complete: complete)
            }
        }
        
    }
    
    func requestOrderId(complete:@escaping (Bool)->Void) {
        let params = ["no":produceId]
        FYRequest.request(API_GETORDERID, params: params, success: { (response: FYBaseModel<FYTempModel>) in
            self.orderId = response.extra;
            complete(true)
        })
    }
    
    private func requestCheckReceipt(complete:@escaping (Bool)->Void) {
        let params = ["id":orderId,"receipt_data":receipt]
        FYRequest.request(API_CHECK_APPLE, params: params, success: { (response: FYBaseModel<FYTempModel>) in
            complete(true)
        })
    }
}
