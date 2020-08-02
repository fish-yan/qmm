//
//  CompleteInfoVM.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/16.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class CompleteInfoVM: YSBaseViewModel {
    
    public var avatar: String?
    
    public var nickName: String?
    public var isMale: Bool = true
    
    public var birthday: String?
    
    public var salary: NSNumber?
    public var salaryStr: String?
    
    public var workareaCode: NSNumber?
    public var workarea: String?
    
    public var constellationCode: NSNumber?
    public var constellation: String?
    
    public var height: String?
    
    public private(set) var savaInfoCmd: RACCommand<AnyObject, AnyObject>!
    
    override init() {
        super.init()
        
        
        savaInfoCmd = RACCommand.init(signal: {[unowned self] (input) -> RACSignal<AnyObject> in
            return self.saveSignal()
        })
        
        guard let userModel = QMMUserContext.share().userModel else {
            return
        }
        
        self.avatar = userModel.avatar
        self.nickName = userModel.name

        self.isMale = userModel.sex == "男" ? true : false
        if let year = userModel.birthyear, let month = userModel.birthmonth, let day = userModel.birthday {
            self.birthday = "\(year)-\(month)-\(day)"
        }

        self.salaryStr = salaryString(mid: userModel.salary)
        if let salary = userModel.salary, let i = Int(salary) {
            self.salary = NSNumber(value: i)
        }
        
        
        self.workareaCode = userModel.homedistrict
        if let p = userModel.provincestr, let c = userModel.citystr, let d = userModel.districtstr {
            self.workarea = "\(p)-\(c)-\(d)"
        }
        
        self.constellation =  constellationString(mid: userModel.constellation)
        if let c = userModel.constellation, let i = Int(c) {
            self.constellationCode = NSNumber(value: i)
        }
        
        
        
    }
    
    
    public var dataArray: [[CompleteInfoCellModel]] {
        get {
            return [
                [
                    CompleteInfoCellModel(cellType: .avatar,
                                          rectType: .middle,
                                          title: nil,
                                          placeHolder: nil,
                                          value: self.avatar)
                ],
                [
                    CompleteInfoCellModel(cellType: .input,
                                          rectType: .top,
                                          title: "填写昵称",
                                          placeHolder: "请填写昵称",
                                          value: self.nickName),
                    CompleteInfoCellModel(cellType: .gender,
                                          rectType: .middle,
                                          title: "选择性别",
                                          placeHolder: nil,
                                          value: self.isMale),
                    CompleteInfoCellModel(cellType: .selector,
                                          rectType: .middle,
                                          title: "出生日期",
                                          placeHolder: nil,
                                          value: self.birthday),
                    CompleteInfoCellModel(cellType: .selector,
                                          rectType: .middle,
                                          title: "工作地点",
                                          placeHolder: nil,
                                          value: self.workarea),
                    CompleteInfoCellModel(cellType: .selector,
                                          rectType: .middle,
                                          title: "身高",
                                          placeHolder: nil,
                                          value: self.height),
                    CompleteInfoCellModel(cellType: .selector,
                                          rectType: .middle,
                                          title: "星座",
                                          placeHolder: nil,
                                          value: self.constellation),
                    CompleteInfoCellModel(cellType: .selector,
                                          rectType: .bottom,
                                          title: "月收入",
                                          placeHolder: nil,
                                          value: self.salaryStr),
                ]
            ]
        }
    }

    
    private func salaryString(mid: String?) -> String? {
        guard let mid = mid, let datas = YSPickerViewData.share()?.salary else {
            return nil
        }
        
        let model = datas[Int(mid) ?? 0]
        return model.name
    }
    
    private func constellationString(mid: String?) -> String? {
        guard let mid = mid, let datas = YSPickerViewData.share()?.constellation else {
            return nil
        }
        
        let model = datas[Int(mid) ?? 0]
        return model.name
    }
    
    private func saveSignal() -> RACSignal<AnyObject> {
        let params = [
            "name": self.nickName ?? "",
            "sex": self.isMale ? "男" : "女",
            "birthday": self.birthday ?? "",
            "workarea": self.workareaCode ?? "",
            "height": self.height ?? "",
            "constellation": self.constellation ?? "",
            "salary": self.salary ?? "",
        ] as NSDictionary
        
        
        return RequestAdapter.requestSignal(params: params.decode(withAPI: API_SAVEPARTUSE_DATA) as! Dictionary<String, Any>,
                                            responseType: .message,
                                            responseClass: nil)
    }
}
