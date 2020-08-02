//
//  RequestAdapter.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class RequestAdapter: NSObject {
    class func requestSignal(params: Dictionary<String, Any>, responseType: YSResponseType, responseClass: AnyClass?) -> RACSignal<AnyObject> {
        
        let url = YSRequestInfoConfig.share()?.baseURL
        let api =  params["code"] as? String ?? ""
        print("😀api:\(api)\nparams:\(params)")
        return (YSRequestAdapter.requestSignal(withURL: url,
                                               params: params,
                                               requestType: .POST,
                                               responseType: .original,
                                               responseClass: responseClass)?
            .map({ (value) -> Any? in
                let m = YSResponseModel()
                
                guard let value = value else {
                    return m
                }
                
                m.extra = value.extra ?? nil
                m.msg = value.msg ?? nil
                m.total = value.total ?? 0
                m.totalpage = value.totalpage ?? 0
                m.data = value.data ?? nil
                print("🐠api:\(api)\nresponse:\(String(describing: m.mj_JSONObject()))")
                switch responseType {
                case .original,
                     .message:
                    break
                    
                case .object:
                    guard m.data != nil else {
                        return m;
                    }
                    
                    let d = m.data as! Array<Any>
                    
                    m.data = responseClass?.mj_object(withKeyValues: d[0])
                    
                case .list:
                    guard m.data != nil else {
                        return m;
                    }
                    let d = m.data as! Array<Any>
                    
                    m.data = responseClass?.mj_objectArray(withKeyValuesArray: d)
                }
                
                return m
                
            }))!
        
        
    }
}
