//
//  InvitationDetailListVM.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationDetailListVM: YSBaseViewModel {
    open var type: DetailListType!
    open var dataArray = Array<InvitationDetailModel>()
    open var fetchCmd: RACCommand<AnyObject, AnyObject>!
    
    
    override init() {
        super.init()
        
        dataArray = [InvitationDetailModel]()
        fetchCmd = RACCommand(signal: { [unowned self] input -> RACSignal<AnyObject> in
          
            let flag = (input as? Int) ?? 1
            return self.requestSignal(flag: flag)
                .doNext({ [unowned self] (x) in
                    guard let x = x as? Array<InvitationDetailModel> else {
                        self.dataArray = Array<InvitationDetailModel>()
                        return
                    }
                    if flag == 1 {
                        self.dataArray = Array<InvitationDetailModel>()
                    }
                    
                    self.dataArray += x
                })
                .doError({ (error) in
                    print(error)
                })
        })
    }
}

extension InvitationDetailListVM {
    
    func requestSignal(flag: Int) -> RACSignal<AnyObject> {
        var page = flag
        
        let params = NSMutableDictionary()
        params.setValue(NSNumber(value: page), forKey: "page")
        params.setValue(NSNumber(value: 20), forKey: "count")
        params.setValue(NSNumber(value: self.type!.rawValue), forKey: "payverifystatus")
        
        return RequestAdapter.requestSignal(params: params.decode(withAPI: API_INVITE_LIST) as! Dictionary<String, Any>,
                                            responseType: .list,
                                            responseClass: InvitationDetailModel.self)
            .map({ (x) -> Any? in
                guard let x = x as? YSResponseModel else {
                    return nil
                }
                
                if self.flag.intValue == x.totalpage || x.totalpage == 0 {
                    self.hasMore = false
                }
                else {
                    self.hasMore = true
                    page += 1
                    self.flag = NSNumber(value: page)
                }
                
                return x.data
            })
    }
}
