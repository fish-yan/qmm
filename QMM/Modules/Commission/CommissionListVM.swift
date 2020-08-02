//
//  CommissionListVM.swift
//  QMM
//
//  Created by Joseph Koh on 2018/11/13.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class CommissionListVM: YSBaseViewModel {
    open var dataArray: [CommissionListVM] = Array()
    open var fetchCmd: RACCommand<AnyObject, AnyObject>!

    open var title: String?
    open var price: String?
    open var time: String?
    
    
    
    // 有返回self类型一定要有个 required 的构建方法
    // Constructing an object of class type 'Self' with a metatype value must use a 'required' initializer
    required override init() {
        super.init()
        
        fetchCmd = RACCommand(signal: { [unowned self] input -> RACSignal<AnyObject> in
            
            let flag = (input as? Int) ?? 1
            return self.requestSignal(flag: flag)
                .doNext({ [unowned self] (x) in
                    guard let x = x as? [CommissionModel] else {
                        self.dataArray = Array()
                        return
                    }
                    if flag == 1 {
                        self.dataArray = Array()
                    }
                    self.dataArray += self.recombine(dataArray: x)
                    
                })
                .doError({ (error) in
                    print(error)
                })
            })
    }
    
    func recombine(dataArray: [CommissionModel]) -> [CommissionListVM] {
        var arrM = Array<CommissionListVM>()
        for m in dataArray {
            arrM.append(.viewModel(withObj: m))
        }
        return arrM
    }
    
    override class func viewModel(withObj obj: Any!) -> Self {
        let vm = self.init()
        
        guard obj is CommissionModel else {
            return vm
        }
        
        let m = obj as! CommissionModel
        
        vm.title = m.incomemobile
        vm.price = m.incomeamount2
        vm.time = m.incomedate2
        
        return vm
    }
    
}



extension CommissionListVM {
    
    func requestSignal(flag: Int) -> RACSignal<AnyObject> {
        var page = flag

        let params = NSMutableDictionary()
        params.setValue(NSNumber(value: page), forKey: "page")
        params.setValue(NSNumber(value: 20), forKey: "count")
        
        return RequestAdapter.requestSignal(params: params.decode(withAPI: API_INCOME_LIST) as! Dictionary<String, Any>,
                                            responseType: .list,
                                            responseClass: CommissionModel.self)
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
