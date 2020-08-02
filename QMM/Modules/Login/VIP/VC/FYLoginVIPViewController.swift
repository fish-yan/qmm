//
//  FYLoginVIPViewController.swift
//  QMM
//
//  Created by Yan on 2019/9/1.
//  Copyright © 2019 Joseph Koh. All rights reserved.
//

import UIKit

class FYLoginVIPViewController: UIViewController {
    
    @IBOutlet weak var bannerIV: UIImageView!
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var nameLab1: UILabel!
    @IBOutlet weak var ageLab1: UILabel!
    @IBOutlet weak var desLab1: UILabel!
    
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var nameLab2: UILabel!
    @IBOutlet weak var ageLab2: UILabel!
    @IBOutlet weak var desLab2: UILabel!
    
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var nameLab3: UILabel!
    @IBOutlet weak var ageLab3: UILabel!
    @IBOutlet weak var desLab3: UILabel!
    
    @IBOutlet weak var priceDesLab: UILabel!
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var agreeBtn: UIButton!
    var viewModel = FYLoginVIPVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestTheySay { [weak self] (success) in
            self?.configView()
        }
        viewModel.requestOrderId { (success) in }
    }
    
    func configView() {
        var appNm = ""
        if let dict = Bundle.main.infoDictionary,
            let name = dict["CFBundleDisplayName"] as? String {
            appNm = name
        }
        let model1 = viewModel.dataArray[0]
        let model2 = viewModel.dataArray[1]
        let model3 = viewModel.dataArray[2]
        img1.sd_setImage(with: URL(string: model1.photo), completed: nil)
        nameLab1.text = model1.name
        ageLab1.text = model1.age + "岁"
        desLab1.text = model1.sentence.replacingOccurrences(of: "%s", with: appNm)
        
        img2.sd_setImage(with: URL(string: model2.photo), completed: nil)
        nameLab2.text = model2.name
        ageLab2.text = model2.age + "岁"
        desLab2.text = model2.sentence.replacingOccurrences(of: "%s", with: appNm)
        
        img3.sd_setImage(with: URL(string: model3.photo), completed: nil)
        nameLab3.text = model3.name
        ageLab3.text = model3.age + "岁"
        desLab3.text = model3.sentence.replacingOccurrences(of: "%s", with: appNm)
        
        if let userModel = QMMUserContext.share()?.userModel,
            let price = userModel.payverify.price {
            priceDesLab.text = "首次购买本产品的用户，\(price)元服务费将退回至APP“我的账户”内，可按规则提现到支付宝账户，详见提现页面。"
            priceLab.text = "仅\(price)元/3个月"
            let imgNm = userModel.sex == "女" ? "bg_login_vip_banner_women.png" : "bg_login_vip_banner_man.png"
            bannerIV.image = UIImage(named: imgNm)
        }
        
        
    }
    
    @IBAction func agreeAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func protocolAction(_ sender: UIButton) {
        YSMediator.openURL("http://www.huayuanvip.com/service/fuwuxieyi_30001.html")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func payAction(_ sender: UIButton) {
        if !agreeBtn.isSelected {
            YSProgressHUD.showTips("请阅读并同意《脱单计划服务协议》")
            return
        }
//        let assistant = QMMUIAssistant.shareInstance()
//        assistant.setTabBarVCAsRootVCCommand.execute(nil)
        viewModel.requestPayment { (success) in
            let assistant = QMMUIAssistant.shareInstance()
            assistant.setTabBarVCAsRootVCCommand.execute(nil)
        }
    }
    
}
