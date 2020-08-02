//
//  FYWithdrawViewController.swift
//  QMM
//
//  Created by Yan on 2019/9/2.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit

class FYWithdrawViewController: UIViewController {
    
    var type = ""
    
    @IBOutlet weak var alipayTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var moneyTF: UITextField!
    @IBOutlet weak var moneyLab: UILabel!
    
    private var model = FYWalletModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav(isColor: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestBalance()
    }
    

    @IBAction func allBtnAction(_ sender: UIButton) {
        moneyTF.text = model.profit
    }
    
    @IBAction func tixianAction(_ sender: UIButton) {
        view.endEditing(true)
        requestTixian()
    }
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FYWResult" {
            let vc = segue.destination as! FYWResultViewController
            vc.tel = self.alipayTF.text ?? ""
            vc.money = self.moneyTF.text ?? ""
            vc.residue = self.model.profit
        }

    }

    
    private func requestBalance(complete: @escaping ()->Void = {}) {
        let params = ["type":type]
        FYRequest.request("getavailincome", params: params, success: { (response: FYBaseModel<FYWalletModel>) in
            if let m = response.data.first {
                self.model = m
            }
            self.moneyLab.text = "可提现金额：￥\(self.model.profit)"
            complete()
        })
    }
    
    private func requestTixian() {
        if nameTF.text?.isEmpty ?? true {
            YSProgressHUD.showTips("姓名不能为空")
            return
        }
        if alipayTF.text?.isEmpty ?? true {
            YSProgressHUD.showTips("支付宝账号不能为空")
            return
        }
        if moneyTF.text?.isEmpty ?? true || moneyTF.text == "0" {
            YSProgressHUD.showTips("提现金额不能为空")
            return
        }
        let params = ["alipayrealname":nameTF.text!, "alipayaccount":alipayTF.text!, "extractamount":moneyTF.text!, "type":model.type]
        FYRequest.request("extractincome", params: params, success: { (response: FYBaseModel<FYTempModel>) in
            self.requestBalance(complete: {
                self.performSegue(withIdentifier: "FYWResult", sender: nil)
            })
        })
    }

}

