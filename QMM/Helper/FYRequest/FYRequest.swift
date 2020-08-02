//
//  FYRequest.swift
//  QMM
//
//  Created by Yan on 2019/9/1.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

@objcMembers
class FYRequest: NSObject {
    
    public static func request<T>(_ api: String, params: [String: String] = [String: String](), success:@escaping (_ response: FYBaseModel<T>)->Void = {_ in }, failure:@escaping (_ error: FYError)->Void = {_ in }) {
        YSProgressHUD.showIndeterminate()
        let dict = NSMutableDictionary()
        for (key, value) in params {
            dict[key] = value
        }
        guard let par = dict.decode(withAPI: api) as? [String: Any] else {
            return;
        }
        let url = YSRequestInfoConfig.share()?.baseURL
        let a = YSRequestAdapter.requestSignal(withURL: url, params: par, requestType: .POST, responseType: .original, responseClass: nil)
            .map({ (objc) -> Any? in
                return objc
            })
            .doNext({ (response) in
                guard let resp = response?.mj_JSONObject() else {
                    let error = FYError("数据错误", errCode: -1)
                    YSProgressHUD.showTips(error.localizedDescription)
                    failure(error)
                    return
                }
                let json = JSON(resp)
                if let model = FYBaseModel<T>.deserialize(from: json.dictionaryObject) {
                    success(model)
                } else {
                    let error = FYError("数据解析错误", errCode: -1, errJson: json)
                    YSProgressHUD.showTips(error.localizedDescription)
                    failure(error)
                }
            })
            .doError { (error) in
                let err = error as NSError
                let e = FYError(err.localizedDescription, errCode: err.code, errJson: nil)
                YSProgressHUD.showTips(e.localizedDescription)
                if (err.code == 402002) {
                    NotificationCenter.default.post(name: Notification.Name(LOGOUT_NOTIF_KEY), object: nil)
                }
                failure(e)
            }
            .doCompleted {
                YSProgressHUD.hiddenHUD()
                print("complete")
        }
        let cmd: RACCommand<AnyObject, AnyObject> = RACCommand{ inp -> RACSignal<AnyObject> in
            return a
        }
        cmd.execute(nil)
        
    }
    
}


public struct FYError: Error {
    public var localizedDescription: String
    public var code = -1
    public var json: JSON!
    public init(_ description: String, errCode: Int = -1, errJson: JSON? = nil) {
        localizedDescription = description
        code = errCode
        json = errJson
    }
}
