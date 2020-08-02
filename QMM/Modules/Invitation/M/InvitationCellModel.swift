//
//  InvitationCellModel.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/12.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

enum InvitationCellType {
    case income
    case invitationInfo
    case tips
}


class InvitationCellModel: YSBaseModel {

    open var type: InvitationCellType
    open var value: Any?
    
    init(type: InvitationCellType, value: Any?) {
        self.type = type
        self.value = value
        
        super.init()
    }
}
