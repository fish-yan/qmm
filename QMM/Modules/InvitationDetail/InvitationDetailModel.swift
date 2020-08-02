//
//  InvitationDetailModel.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

enum InvitationStatus: Int {
    case infoComplete = 0
    case waitZmxy = 1
//    case waitVertifyPay = 2
    case getReward = 3
    
}

@objcMembers
class InvitationDetailModel: YSBaseModel {
    
    var invitemobile: String?
    var inviteregdate2: String?
    var invitestatus2: String?
    
    var status: InvitationStatus
    
    override init() {
        status = .infoComplete
        super.init()
    }
}
