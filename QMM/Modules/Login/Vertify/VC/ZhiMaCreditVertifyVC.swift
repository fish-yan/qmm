//
//  QMMCreditVertifyVC.swift
//  QMM
//
//  Created by Joseph Koh on 2018/10/29.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

import UIKit

class ZhiMaCreditVertifyVC: YSBaseViewController {
    @objc open var isFromLoginView = true
    
    private var bgImgV = UIImageView(image: UIImage(named: "login_bg"))
    private var contentView: UIView!
    private var introLabel: UILabel!
    private var vertifyBtn: UIButton!
    private var jumpLabel: UILabel!
    
    private var maskView: UIView?
    private var resultView: VertifyResultView?
    
    private let viewModel = ZhiMaCreditVertifyVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
        setupSubviews()
        setupSubviewsLayout()
        bind()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleCreditRstNotif(notif:)),
                                               name: NSNotification.Name(rawValue: ZHIMA_CER_RST_NOTIF_KEY),
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


extension ZhiMaCreditVertifyVC {
    private func bind() {
        self.viewModel.sendRstCmd.executing.skip(1).subscribeNext { (x) in
            if x?.boolValue == true {
                YSProgressHUD.show(in: self.view)
            }
        }
        
        self.viewModel.sendRstCmd.executionSignals.switchToLatest().subscribeNext { (x) in
            YSProgressHUD.hiddenHUD()
            self.popVertifySuccessView()
        }
        
        self.viewModel.sendRstCmd.errors.subscribeNext { (error) in
            YSProgressHUD.showTips(error?.localizedDescription)
        }
    }
    
    @objc private func handleCreditRstNotif(notif: Notification) {
        let rstDict = notif.object as? Dictionary<String, Any>
        
        if let biz_content = rstDict?["biz_content"] as? Dictionary<String, String> {
            viewModel.bizno = biz_content["biz_no"]
            viewModel.passed = biz_content["passed"]
            
            if viewModel.passed == "true" {
                viewModel.sendRstCmd.execute(nil)
                // 发送完成后显示成功
            }
            else {
                showVertifyFailureView()
            }
            
        }
    }
    
    override func popBack() {
        
        let vc = AlertViewController()
        vc.alertTitle = "确定退出芝麻认证吗?"
        vc.message = "完成芝麻认证，让自己被别人信任～"
        vc.leftButtonTitle = "确认返回"
        vc.rightButtonTitle = "继续认证"
        vc.rightBackgroundColor = UIColor(hexString: "#BDFED7")
        vc.cancelBlock = {
            self.navigationController?.popViewController(animated: true)
        }
        vc.sureBlock = {

        }
        
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    private func removeResultView() {
        if resultView == nil {
            return
        }
        
        maskView?.removeFromSuperview()
        maskView = nil
        
        resultView?.removeFromSuperview()
        resultView = nil
    }
    
    @objc private func go2nextStep() {
        QMMUIAssistant.shareInstance().setTabBarVCAsRootVCCommand.execute(nil)

//        switch QMMUserContext.share()?.userModel.iscomplete {
//        case .noCertifiedHadPay?:
//            QMMUIAssistant.shareInstance().setTabBarVCAsRootVCCommand.execute(nil)
//        case .noCertifiedNoPay?:
//            go2PayView()
//        default:
//            QMMUIAssistant.shareInstance().setTabBarVCAsRootVCCommand.execute(nil)
//        }
            
    }
    
//    @objc private func go2PayView() {
//        removeResultView()
//        
//        let vc = VertifyPayViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    
    func tryAliVertify() {
        guard let userModel = QMMUserContext.share().userModel  else {
            return
        }
        
        ZMCertHelper.share().doVerify(userModel.zhimaurl)
    }

    
    /// 认证失败
    func showVertifyFailureView() {
        hiddenContent()
        
        if resultView == nil {
            resultView = createRstView(result: false)
            view.addSubview(resultView!)
        }
        resultView!.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(30.0)
            make.height.equalTo(400.0)
        }
    }
    
    // 认证成功
    func popVertifySuccessView() {
        if resultView != nil {
            return;
        }
        resultView = createRstView(result: true)
        
        if maskView == nil {
            let window = UIApplication.shared.keyWindow
            maskView = UIView(backgroundColor: UIColor(white: 0, alpha: 0.5), in: window!)
            maskView!.frame = window!.bounds
            maskView!.addSubview(self.resultView!)
        }
        
        
        resultView!.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(30.0)
            make.right.equalToSuperview().offset(-30.0)
            make.height.equalTo(320.0)
        }
    }
    
    func hiddenContent() -> Void {
        contentView.isHidden = true
        vertifyBtn.isHidden = true
        jumpLabel.isHidden = true
    }
    
    func createRstView(result isSuccess: Bool) -> VertifyResultView {
        let rstView = VertifyResultView()
        rstView.backgroundColor = UIColor.white
        rstView.isHidden = false
        rstView.layer.cornerRadius = 10.0
        rstView.layer.shadowColor = UIColor.black.cgColor
        rstView.layer.shadowOffset = CGSize.zero
        if isSuccess == true {
            rstView.type = .Success
            rstView.actionHandler = {[unowned self] (type) -> () in
                // 获取最新的用户状m态
                QMMUserContext.share()?.fetchLatestUserinfo(successHandle: { [unowned self] (m) in
                    YSProgressHUD.hiddenHUD()
                    self.go2nextStep()
                    
                    }, failureHandle: { [unowned self] (error) in
                        self.removeResultView()
                        QMMUIAssistant.shareInstance().setTabBarVCAsRootVCCommand.execute(nil)
                })
            }
        }
        else {
            rstView.type = .Failure
            rstView.actionHandler = { [unowned self] (type) -> () in                
                self.tryAliVertify()
            }
        }
        
        return rstView
    }
}


extension ZhiMaCreditVertifyVC {
    func initialization() {
        navigationItem.title = "信用认证(2/3)"
        view.backgroundColor = UIColor.init(hexString: "#FAFAFA")
        
        canBack = isFromLoginView
    }
    
    override func setupSubviews() {
        view.addSubview(bgImgV)
        bgImgV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // --
        contentView = UIView(backgroundColor: UIColor.white, in: view)
        contentView.layer.cornerRadius = 8.0
        contentView.layer.shadowOffset = CGSize.zero
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowColor = UIColor.init(hexString: "#808080", alpha: 0.5).cgColor
        
        // --
        introLabel = UILabel()
        introLabel.textAlignment = NSTextAlignment.left
        introLabel.numberOfLines = 0
        contentView.addSubview(introLabel)
        introLabel.attributedText = introAttributedString()
        
        // ---
        vertifyBtn = UIButton(title: "开启芝麻认证",
                              titleColor: UIColor(hexString: "#464646"),
                              font: UIFont.systemFont(ofSize: 18),
                              normalImgName: nil,
                              highlightedImageName: nil,
                              bgColor: UIColor(hexString: "#BDFED7"),
                              normalBgImageName: "",
                              highlightedBgImageName: nil,
                              in: view,
                              action: { [unowned self] (btn) in
                                self.tryAliVertify()
        })
        vertifyBtn.layer.cornerRadius = 25.0
        vertifyBtn.clipsToBounds = true
        
        
        // --
        jumpLabel = UILabel()
        jumpLabel.attributedText = jumpAttrString()
        jumpLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(go2nextStep))
        jumpLabel.addGestureRecognizer(tapGesture)
        view.addSubview(jumpLabel)
    }
    
    override func setupSubviewsLayout() {
        
        contentView.snp.makeConstraints { (make) in
            let topMarign = 25.0 + (IS_FULL_SCREEN_IPHONE ? 64.0 : 44.0)

            make.top.equalToSuperview().offset(topMarign)
            make.left.equalToSuperview().offset(25.0)
            make.right.equalToSuperview().offset(-25.0)
            make.height.equalTo(250.0)
        }
        
        introLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset((-30))
        }
        
        vertifyBtn.snp.makeConstraints { (make) in
            make.top.equalTo(contentView!.snp.bottom).offset(85)
            make.left.equalToSuperview().offset(38)
            make.right.equalToSuperview().offset(-38)
            make.height.equalTo(49)
        }
        
        jumpLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(vertifyBtn.snp.bottom).offset(40)
        }
    }
    
    func jumpAttrString() -> NSAttributedString {
        let attrM = NSMutableAttributedString(string: "暂时跳过 ",
                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#A5A5A5"),
                                                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        let attach = NSTextAttachment()
        attach.image = UIImage(named: "ic_arrow_right")
        attach.bounds = CGRect(x: 0, y: 0, width: 7.0, height: 12.5)
        
        attrM.append(NSAttributedString(attachment: attach))
        return attrM
    }
    
    func introAttributedString() -> NSAttributedString {
        let titleAttr: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#2E2E2E"),
                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let attrM = NSMutableAttributedString(string: "芝麻认证\n\n", attributes: titleAttr)
        
        let infoAttr: [NSAttributedString.Key : Any]  = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#868686"),
                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        attrM.append(NSAttributedString(string: "为了保障用户安全和隐私，APP需要实人认证，即让我们知道“您是您”。\n\n",
                                        attributes: infoAttr))
        
        
        let tipsAttr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FF8888"),
                                                       NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        attrM.append(NSAttributedString(string: "“快速认证”\n由阿里巴巴合作提供，保障您的隐私安全。",
                                        attributes: tipsAttr))
        return attrM
    }
}

