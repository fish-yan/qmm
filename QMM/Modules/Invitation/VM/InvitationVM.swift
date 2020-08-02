//
//  InvitationVM.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/10.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class InvitationVM: YSBaseViewModel {

    open var dataArray: Array<InvitationCellModel>!
    open var fetchCmd: RACCommand<AnyObject, AnyObject>!
    
    
    override init() {
        super.init()
        
        fetchCmd = RACCommand.init(signal: {[unowned self] input -> RACSignal<AnyObject> in
            
            return self.requestSignal()
                .doNext({ (x) in
                    
                    if let data = x as? YSResponseModel, let rst = data.data as? InvitationInfoModel {
                        self.dataArray = [
                            InvitationCellModel(type: .income, value: rst.incomebalance),
                            InvitationCellModel(type: .invitationInfo, value: [rst.inviteoknum, rst.invitewipnum]),
                            InvitationCellModel(type: .tips, value: rst.inviteokincome)
                        ]
                    }
                    
                })
                .doError({ (error) in
                    print(error)
                })
        })
        
        dataArray = [
            InvitationCellModel(type: .income, value: nil),
            InvitationCellModel(type: .invitationInfo, value: nil),
            InvitationCellModel(type: .tips, value: nil)
        ]
        
    }
    
}

extension InvitationVM {
    func requestSignal() -> RACSignal<AnyObject> {
        let params = NSDictionary().decode(withAPI: API_INCOME_OVERVIEW)
        
        let signal = RequestAdapter.requestSignal(params: params as! Dictionary<String, Any>,
                                                  responseType: .object,
                                                  responseClass: InvitationInfoModel.self)
        return signal
    }
}
