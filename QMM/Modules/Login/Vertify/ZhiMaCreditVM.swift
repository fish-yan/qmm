//
//  ZhiMaCreditVertifyVM.swift
//  QMM
//
//  Created by Joseph Koh on 2018/12/5.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class ZhiMaCreditVertifyVM: YSBaseViewModel {
    var bizno: String?
    var passed: String?
    
    var sendRstCmd: RACCommand<AnyObject, AnyObject>!
    
    override init() {
        super.init()
        
        self.sendRstCmd = RACCommand.init(signal: {[unowned self] (input) -> RACSignal<AnyObject> in
            return self.requestSignal().doNext({ (x) in
                //  更新完成后获取最新用户状态
                QMMUserContext.share()?.fetchLatestUserinfo(successHandle: nil, failureHandle: nil)
            })
        })
    }
    
    // 发送给服务端
    // 接口: zhimanotify
    // 入参: bizno, passed
    private func requestSignal() -> RACSignal<AnyObject> {
        let params = NSMutableDictionary()
        
        params.setObject(bizno ?? "", forKey: "bizno" as NSCopying)
        params.setObject(passed ?? "", forKey: "passed" as NSCopying)
        
        return RequestAdapter.requestSignal(params: params.decode(withAPI: "zhimanotify") as! Dictionary<String, Any>,
                                            responseType: .object,
                                            responseClass: nil)
    }
}
