//
//  InvitationShareVM.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/14.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationShareVM: YSBaseViewModel {
    open var fetchCmd: RACCommand<AnyObject, AnyObject>!
    
    open var qrImgURL: URL?
    open var invitatURL: String?
    open var shareModel: InvitationShareInfoModel?
    
    required override init() {
        super.init()
        
        fetchCmd = RACCommand(signal: { [unowned self] input -> RACSignal<AnyObject> in
            return self.requestSignal()
                .doNext({ [unowned self] (x) in
                    guard let x = x as? InvitationShareInfoModel else {
                        self.shareModel = nil;
                        return
                    }
                    self.qrImgURL = URL.init(string: x.qrcodem ?? "")
                    self.invitatURL = x.referurl
                    self.shareModel = x;
                })
                .doError({ (error) in
                    print(error)
                })
        })
    }
}


extension InvitationShareVM {
    
    func requestSignal() -> RACSignal<AnyObject> {
        let params = NSMutableDictionary()
        
        return RequestAdapter.requestSignal(params: params.decode(withAPI: API_REFER_INFO) as! Dictionary<String, Any>,
                                            responseType: .object,
                                            responseClass: InvitationShareInfoModel.self)
            .map({ (x) -> Any? in
                guard let x = x as? YSResponseModel else {
                    return nil
                }
                
                return x.data
            })
    }
}
