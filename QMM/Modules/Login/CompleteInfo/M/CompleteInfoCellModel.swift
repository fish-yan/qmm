//
//  CompleteInfoCellModel.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/16.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

enum CellRectType {
    case top
    case middle
    case bottom
}

enum InfoCellType: Int {
    case avatar
    case input
    case gender
    case selector
}

class CompleteInfoCellModel: YSBaseModel {


    
    var cellType = InfoCellType.selector
    var rectType = CellRectType.middle
    
    var title: String?
    var placeHolder: String?
    var value: Any?
    
    
    convenience init(cellType: InfoCellType = .selector,
                     rectType: CellRectType = .middle,
                     title: String?,
                     placeHolder: String?,
                     value: Any?) {
        self.init()

        self.cellType = cellType
        self.rectType = rectType
        self.title = title
        self.placeHolder = placeHolder
        self.value = value
        
    }
    
}
